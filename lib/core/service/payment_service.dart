import 'dart:async';
import 'dart:isolate';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/icici_ops.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/icici_api_util.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PaymentService extends ChangeNotifier {
  static Log log = new Log('PaymentService');
  ValueChanged<int> _onProcessComplete;

  PaymentService();

  BaseUtil baseProvider = locator<BaseUtil>();
  DBModel dbProvider = locator<DBModel>();
  ICICIModel iProvider = locator<ICICIModel>();
  Isolate isolate;
  static const int CHECK_COUNT = 3;
  static const int CHECK_INTERVAL = 12;
  static const int TRANSACTION_PENDING = 0;
  static const int TRANSACTION_COMPLETE = 1;
  static const int TRANSACTION_REJECTED = 2;
  static const int TRANSACTION_CHECK_TIMEOUT = 3;
  String errResponses = '';
  String localVpa;

  Future<bool> _init() async {
    if (baseProvider == null ||
        iProvider == null ||
        dbProvider == null ||
        baseProvider.myUser == null) return false;

    if (baseProvider.iciciDetail == null)
      baseProvider.iciciDetail =
          await dbProvider.getUserIciciDetails(baseProvider.myUser.uid);
    if (!iProvider.isInit()) await iProvider.init();

    return (baseProvider.iciciDetail != null && iProvider.isInit());
  }

  Future<Map<String, dynamic>> verifyPaymentsIfAny() async {
    if (baseProvider.myUser.pendingTxnId != null) {
      //currently pending payment found
      verifyPayment();
    }
  }

  Future<Map<String, dynamic>> initiateTransaction(
      String amount, String vpa) async {
    bool initFlag = await _init();
    if (!initFlag)
      return {
        'flag': false,
        'reason': 'App restart required'
      }; //should never happen

    if (!baseProvider.iciciDetail.firstInvMade ||
        baseProvider.iciciDetail.firstInvMade == null)
      return _initiateTransactionForNewInvestor(amount, vpa);
    else
      return _initiateTransactionForExistingInvestor(amount, vpa);
  }

  Future<Map<String, dynamic>> _initiateTransactionForNewInvestor(
      String amount, String vpa) async {
    if (amount == null || amount.isEmpty || vpa == null || vpa.isEmpty)
      return {
        'flag': false,
        'reason': 'App restart required'
      }; //should never happen
    if (baseProvider.iciciDetail == null ||
        baseProvider.iciciDetail.appId == null ||
        baseProvider.iciciDetail.email == null ||
        baseProvider.iciciDetail.folioNo == null ||
        baseProvider.iciciDetail.bankCode == null ||
        baseProvider.iciciDetail.panNumber == null)
      return {
        'flag': false,
        'reason':
            'There are insufficient details to initiate a transaction. Please contact us'
      }; //should never happen
    double amtDouble = 0;
    try {
      amtDouble = double.parse(amount);
    } catch (e) {
      return {
        'flag': false,
        'reason': 'App restart required'
      }; //should never happen
    }
    var pRes = await iProvider.initiateUPIPurchaseForNewInvestor(
        baseProvider.iciciDetail.appId,
        baseProvider.iciciDetail.email,
        baseProvider.iciciDetail.bankCode,
        baseProvider.iciciDetail.panNumber,
        baseProvider.iciciDetail.folioNo,
        baseProvider.iciciDetail.appMode ?? '0',
        amount,
        vpa);
    if (pRes == null || pRes[QUERY_SUCCESS_FLAG] == QUERY_FAILED) {
      String errReason = (pRes[QUERY_FAIL_REASON] != null)
          ? pRes[QUERY_FAIL_REASON]
          : 'Unknown';
      Map<String, dynamic> failData = {'failReason': errReason};
      bool failureLogged = await dbProvider.logFailure(baseProvider.myUser.uid,
          FailType.UserTransactionInitiateFailed, failData);
      log.debug('Failure logged correctly: $failureLogged');
      return {
        'flag': false,
        'reason': (pRes[QUERY_FAIL_REASON] != null)
            ? pRes[QUERY_FAIL_REASON]
            : 'Encountered an unknown error. Please try again in a while'
      };
    } else {
      if (pRes[SubmitUpiNewInvestor.resTrnId] == null ||
          pRes[SubmitUpiExistingInvestor.resTrnId] == '') {
        //Submit transaction not successful
        //send error response to modal
        String errReason = (pRes[SubmitUpiNewInvestor.resMsg] != null)
            ? pRes[SubmitUpiNewInvestor.resMsg]
            : 'The transaction could not be initiated. Please try again in a while';
        var failData = {'failReason': errReason};
        bool failureLogged = await dbProvider.logFailure(
            baseProvider.myUser.uid,
            FailType.UserTransactionInitiateFailed,
            failData);
        log.debug('Failure logged correctly: $failureLogged');
        return {
          'flag': false,
          'reason': (pRes[SubmitUpiNewInvestor.resMsg] != null)
              ? pRes[SubmitUpiNewInvestor.resMsg]
              : 'The transaction could not be initiated. Please try again in a while'
        };
      } else {
        //create transaction
        //add current live txn dockey to user obj
        String pTranId = pRes[SubmitUpiNewInvestor.resTrnId];
        String pMultipleId = pRes[SubmitUpiNewInvestor.resMultipleId];
        String pUpiDateTime = pRes[SubmitUpiNewInvestor.resUpiTime];
        localVpa = vpa;
        baseProvider.currentICICITxn = UserTransaction.mfDeposit(pTranId,
            pMultipleId, pUpiDateTime, amtDouble, baseProvider.myUser.uid);
        String userTxnKey = await dbProvider.addUserTransaction(
            baseProvider.myUser.uid, baseProvider.currentICICITxn);
        bool nFlag = (userTxnKey != null);
        bool upFlag = false;
        if (nFlag) {
          baseProvider.currentICICITxn.docKey = userTxnKey;
          baseProvider.myUser.pendingTxnId = userTxnKey;
          upFlag = await dbProvider.updateUser(baseProvider.myUser);
          log.debug('User pending txn id updated: $upFlag');
        }
        if (nFlag && upFlag) {
          log.debug('Transaction initiated and details stored successfully');
          return {'flag': true};
        } else {
          //transaction initiated, however the details were not stored with Firebase correctly
          var failData = {
            'tranid': baseProvider
                .currentICICITxn.icici[UserTransaction.subFldIciciTranId],
            'failReason':
                'Txn updated: ${nFlag.toString()} and user updated: ${upFlag.toString()}'
          };
          bool failureLogged = await dbProvider.logFailure(
              baseProvider.myUser.uid,
              FailType.UserTransactionDetailSaveFailed,
              failData);
          log.debug('Failure logged correctly: $failureLogged');
          return {
            'flag': false,
            'reason':
                'The transaction could not be processed correctly. We will verify your transaction from our end!'
          };
        }
      }
    }
  }

  Future<Map<String, dynamic>> _initiateTransactionForExistingInvestor(
      String amount, String vpa) async {
    if (amount == null || amount.isEmpty || vpa == null || vpa.isEmpty)
      return {
        'flag': false,
        'reason': 'App restart required'
      }; //should never happen
    if (baseProvider.iciciDetail == null ||
        baseProvider.iciciDetail.folioNo == null ||
        baseProvider.iciciDetail.bankCode == null ||
        baseProvider.iciciDetail.bankCode == null ||
        baseProvider.iciciDetail.bankAccNo == null ||
        baseProvider.iciciDetail.panNumber == null)
      return {
        'flag': false,
        'reason':
            'There are insufficient details to initiate a transaction. Please contact us'
      }; //should never happen
    double amtDouble = 0;
    try {
      amtDouble = double.parse(amount);
    } catch (e) {
      return {
        'flag': false,
        'reason': 'App restart required'
      }; //should never happen
    }
    var pRes = await iProvider.initiateUPIPurchaseForExistingInvestor(
        baseProvider.iciciDetail.folioNo,
        baseProvider.iciciDetail.chkDigit ?? '',
        amount,
        baseProvider.iciciDetail.bankCode,
        baseProvider.iciciDetail.bankAccNo,
        baseProvider.iciciDetail.panNumber,
        vpa);
    if (pRes == null || pRes[QUERY_SUCCESS_FLAG] == QUERY_FAILED) {
      String errReason = (pRes[QUERY_FAIL_REASON] != null)
          ? pRes[QUERY_FAIL_REASON]
          : 'Unknown';
      Map<String, dynamic> failData = {
        'folioNumber': baseProvider.iciciDetail.folioNo,
        'failReason': errReason
      };
      bool failureLogged = await dbProvider.logFailure(baseProvider.myUser.uid,
          FailType.UserTransactionInitiateFailed, failData);
      log.debug('Failure logged correctly: $failureLogged');
      return {
        'flag': false,
        'reason': (pRes[QUERY_FAIL_REASON] != null)
            ? pRes[QUERY_FAIL_REASON]
            : 'Encountered an unknown error. Please try again in a while'
      };
    } else {
      if (pRes[SubmitUpiExistingInvestor.resTrnId] == null ||
          pRes[SubmitUpiExistingInvestor.resTrnId] == '') {
        //Submit transaction not successful
        //send error response to modal
        String errReason = (pRes[SubmitUpiExistingInvestor.resMsg] != null)
            ? pRes[SubmitUpiExistingInvestor.resMsg]
            : 'The transaction could not be initiated. Please try again in a while';
        var failData = {'failReason': errReason};
        bool failureLogged = await dbProvider.logFailure(
            baseProvider.myUser.uid,
            FailType.UserTransactionInitiateFailed,
            failData);
        log.debug('Failure logged correctly: $failureLogged');
        return {
          'flag': false,
          'reason': (pRes[SubmitUpiExistingInvestor.resMsg] != null)
              ? pRes[SubmitUpiExistingInvestor.resMsg]
              : 'The transaction could not be initiated. Please try again in a while'
        };
      } else {
        //create transaction
        //add current live txn dockey to user obj
        String pTranId = pRes[SubmitUpiExistingInvestor.resTrnId];
        String pMultipleId = pRes[SubmitUpiExistingInvestor.resMultipleId];
        String pUpiDateTime = pRes[SubmitUpiExistingInvestor.resUpiTime];
        localVpa = vpa;
        baseProvider.currentICICITxn = UserTransaction.mfDeposit(pTranId,
            pMultipleId, pUpiDateTime, amtDouble, baseProvider.myUser.uid);
        String userTxnKey = await dbProvider.addUserTransaction(
            baseProvider.myUser.uid, baseProvider.currentICICITxn);
        bool nFlag = (userTxnKey != null);
        bool upFlag = false;
        if (nFlag) {
          baseProvider.currentICICITxn.docKey = userTxnKey;
          baseProvider.myUser.pendingTxnId = userTxnKey;
          upFlag = await dbProvider.updateUser(baseProvider.myUser);
          log.debug('User pending txn id updated: $upFlag');
        }
        if (nFlag && upFlag) {
          log.debug('Transaction initiated and details stored successfully');
          return {'flag': true};
        } else {
          //transaction initiated, however the details were not stored with Firebase correctly
          var failData = {
            'tranid': baseProvider
                .currentICICITxn.icici[UserTransaction.subFldIciciTranId],
            'failReason':
                'Txn updated: ${nFlag.toString()} and user updated: ${upFlag.toString()}'
          };
          bool failureLogged = await dbProvider.logFailure(
              baseProvider.myUser.uid,
              FailType.UserTransactionDetailSaveFailed,
              failData);
          log.debug('Failure logged correctly: $failureLogged');
          return {
            'flag': false,
            'reason':
                'The transaction could not be processed correctly. We will verify your transaction from our end!'
          };
        }
      }
    }
  }

  void verifyPayment() async {
    bool initFlag = await _init();
    baseProvider.currentICICITxn = (baseProvider.currentICICITxn == null)
        ? await dbProvider.getUserTransaction(
            baseProvider.myUser.uid, baseProvider.myUser.pendingTxnId)
        : baseProvider.currentICICITxn;
    if (baseProvider.currentICICITxn != null &&
        baseProvider.currentICICITxn.isExpired()) {
      //Transaction expired
      //run one final check then close transaction
      _getTransactionStatus(
              baseProvider
                  .currentICICITxn.icici[UserTransaction.subFldIciciTranId],
              baseProvider.iciciDetail.panNumber)
          .then((resMap) {
        if (resMap != null && resMap['isComplete'] && resMap['isPaid']) {
          //transaction successful
          _onTransactionCompleted().then((flag) {
            if (_onProcessComplete != null)
              _onProcessComplete(TRANSACTION_COMPLETE);
          });
        } else {
          _onTransactionRejected().then((flag) {
            if (_onProcessComplete != null)
              _onProcessComplete(TRANSACTION_REJECTED);
          });
        }
      });
      return;
    }

    ReceivePort receivePort =
        ReceivePort(); //port for this main isolate to receive messages.
    isolate = await Isolate.spawn(startTimer, receivePort.sendPort);
    int counter = CHECK_COUNT;
    receivePort.listen((data) {
      counter--;
      _getTransactionStatus(
              baseProvider
                  .currentICICITxn.icici[UserTransaction.subFldIciciTranId],
              baseProvider.iciciDetail.panNumber)
          .then((resMap) {
        if (resMap != null) {
          if (!resMap['isComplete']) {
            if (resMap['reason'] != null)
              errResponses = errResponses + resMap['reason'];
          } else {
            if (resMap['isPaid']) {
              //transaction successful
              _onTransactionCompleted().then((flag) {
                if (flag) stopVerification();
                if (_onProcessComplete != null)
                  _onProcessComplete(TRANSACTION_COMPLETE);
              });
            } else {
              //transaction rejected
              _onTransactionRejected().then((flag) {
                if (flag) stopVerification();
                if (_onProcessComplete != null)
                  _onProcessComplete(TRANSACTION_REJECTED);
              });
            }
          }
        }
      });
      if (counter <= 0) {
        stopVerification();
        _onTransactionProcessingFailed().then((flag) {
          if (_onProcessComplete != null)
            _onProcessComplete(TRANSACTION_CHECK_TIMEOUT);
        });
      }
    });
  }

  static void startTimer(SendPort sendPort) {
    int counter = 0;
    Timer.periodic(new Duration(seconds: CHECK_INTERVAL), (Timer t) {
      counter++;
      String msg = 'notification ' + counter.toString();
      log.debug('SEND: ' + msg + ' - ');
      sendPort.send(msg);
    });
  }

  void stopVerification() {
    if (isolate != null) {
      log.debug('killing isolate');
      isolate.kill(priority: Isolate.immediate);
      isolate = null;
    }
  }

  Future<Map<String, dynamic>> _getTransactionStatus(
      String tranId, String panNumber) async {
    if (tranId == null ||
        tranId.isEmpty ||
        panNumber == null ||
        panNumber.isEmpty) {
      return {
        'isPaid': false,
        'isComplete': false,
        'errReason': 'Invalid fields'
      };
    } else {
      return iProvider.getPaidStatus(tranId, panNumber).then((resObj) {
        if (resObj == null || resObj['flag'] == false) {
          return {
            'isPaid': false,
            'isComplete': false,
            'errReason': 'Request failed. Please try again'
          };
        } else {
          if (resObj[GetPaidStatus.resStatus] == null) {
            return {
              'isPaid': false,
              'isComplete': false,
              'errReason': resObj[GetPaidStatus.resErrorDesc] ??
                  'Request could not be processed. Please try again'
            };
          } else {
            if (resObj[GetPaidStatus.resStatus] ==
                GetPaidStatus.STATUS_SUCCESS) {
              return {
                'isPaid': true,
                'isComplete': true,
              };
            } else if (resObj[GetPaidStatus.resStatus] ==
                GetPaidStatus.STATUS_REJECTED) {
              return {
                'isPaid': false,
                'isComplete': true,
                'errReason': 'The transaction was cancelled'
              };
            } else if (resObj[GetPaidStatus.resStatus] ==
                GetPaidStatus.STATUS_INCOMPLETE) {
              return {
                'isPaid': false,
                'isComplete': false,
                'errReason': 'The transaction has not been completed yet'
              };
            } else {
              return {
                'isPaid': false,
                'isComplete': false,
                'errReason': 'Unknown response received'
              };
            }
          }
        }
      }).catchError((err) {
        return {
          'isPaid': false,
          'isComplete': false,
          'errReason': 'Transaction Process Failed'
        };
      });
    }
  }

  Future<bool> _onTransactionCompleted() async {
    //update base user object
    //update transaction
    //update first investment flag in icicidetail
    //update user balance
    //update user ticket count
    if (baseProvider.myUser.pendingTxnId == null) {
      //rare cases where transaction has already completed but schedular is still running
      return true;
    }
    baseProvider.currentICICITxn = (baseProvider.currentICICITxn == null)
        ? await dbProvider.getUserTransaction(
            baseProvider.myUser.uid, baseProvider.myUser.pendingTxnId)
        : baseProvider.currentICICITxn;

    //baseProvider.iciciDetail = baseProvider.iciciDetail??(await dbProvider.getUserIciciDetails(baseProvider.myUser.uid));
    baseProvider.currentICICITxn.tranStatus =
        UserTransaction.TRAN_STATUS_COMPLETE;

    double amt = baseProvider.currentICICITxn.amount;
    int ticketCount = (amt / Constants.INVESTMENT_AMOUNT_FOR_TICKET).floor();

    double totalBal = baseProvider.userFundWallet.getEstTotalWealth() ?? 0.0;

    //update transaction object
    baseProvider.currentICICITxn.ticketUpCount = ticketCount;
    baseProvider.currentICICITxn.closingBalance = totalBal + amt;

    //update user object
    baseProvider.myUser.pendingTxnId = null;
    bool usFlag = await dbProvider.updateUser(baseProvider.myUser);

    //update fund wallet
    double _f = baseProvider.userFundWallet.iciciPrinciple;
    baseProvider.userFundWallet = await dbProvider.updateUserIciciBalance(
        baseProvider.myUser.uid, baseProvider.userFundWallet, amt);
    bool isFundWalletUpdated =
        (_f != baseProvider.userFundWallet.iciciPrinciple);

    //update ticket count
    int _t = baseProvider.userTicketWallet.icici1565Tck;
    baseProvider.userTicketWallet = await dbProvider.updateICICIUserTicketCount(
        baseProvider.myUser.uid, baseProvider.userTicketWallet, ticketCount);
    bool isTckWalletUpdated =
        (_t != baseProvider.userTicketWallet.icici1565Tck);

    //update user transaction
    bool txnFlag = await dbProvider.updateUserTransaction(
        baseProvider.myUser.uid, baseProvider.currentICICITxn);

    bool icFlag = true;
    //check if the user vpa needs to be added
    bool vpaUpdateFlag =
        ((baseProvider.iciciDetail.vpa == null && localVpa != null) ||
            baseProvider.iciciDetail.vpa != null &&
                localVpa != null &&
                baseProvider.iciciDetail.vpa != localVpa);
    //check if its the user's first investment
    if (!baseProvider.iciciDetail.firstInvMade || vpaUpdateFlag) {
      if (!baseProvider.iciciDetail.firstInvMade)
        baseProvider.iciciDetail.firstInvMade = true;
      if (vpaUpdateFlag) baseProvider.iciciDetail.vpa = localVpa;
      icFlag = await dbProvider.updateUserIciciDetails(
          baseProvider.myUser.uid, baseProvider.iciciDetail);
    }

    baseProvider.currentICICITxn = null;
    log.debug(
        'Updated all flags:: $icFlag\t$usFlag\t$txnFlag\t$isFundWalletUpdated\t$isTckWalletUpdated');
    return (icFlag &&
        usFlag &&
        txnFlag &&
        isFundWalletUpdated &&
        isTckWalletUpdated);
  }

  Future<bool> _onTransactionRejected() async {
    //update base user object
    //update transaction
    if (baseProvider.myUser.pendingTxnId == null) {
      //rare cases where transaction has already completed but schedular is still running
      return true;
    }
    baseProvider.currentICICITxn = (baseProvider.currentICICITxn == null)
        ? await dbProvider.getUserTransaction(
            baseProvider.myUser.uid, baseProvider.myUser.pendingTxnId)
        : baseProvider.currentICICITxn;

    //update transaction fields
    baseProvider.currentICICITxn.tranStatus =
        UserTransaction.TRAN_STATUS_CANCELLED;
    baseProvider.currentICICITxn.closingBalance =
        baseProvider.userFundWallet.getEstTotalWealth() ?? 0.0;

    //update user field
    baseProvider.myUser.pendingTxnId = null;

    bool usFlag = await dbProvider.updateUser(baseProvider.myUser);
    bool txnFlag = await dbProvider.updateUserTransaction(
        baseProvider.myUser.uid, baseProvider.currentICICITxn);
    baseProvider.currentICICITxn = null;
    log.debug('Updated all flags:: $usFlag\t$txnFlag');

    return (usFlag && txnFlag);
  }

  Future<bool> _onTransactionProcessingFailed() async {
    //log failure
    //dont close transaction,let it still process in the future as well
    Map<String, dynamic> failData = {
      'tranid':
          baseProvider.currentICICITxn.icici[UserTransaction.subFldIciciTranId],
      'userTxnId': baseProvider.currentICICITxn.docKey
    };
    bool failureLogged = await dbProvider.logFailure(baseProvider.myUser.uid,
        FailType.UserTransactionVerifyTimeoutFailed, failData);
    log.debug('Failure logged correctly: $failureLogged');

    return failureLogged;
  }

  Future<bool> _onWithdrawalCompleted(
      UserTransaction txn, bool isInstantTxn) async {
    //add withdrawal transaction
    //update user balance
    //update user ticket count
    double amt = txn.amount;
    int ticketCount = (amt / Constants.INVESTMENT_AMOUNT_FOR_TICKET).floor();

    double totalBal = baseProvider.userFundWallet.getEstTotalWealth() ?? 0.0;

    //update transaction object
    txn.ticketUpCount = ticketCount;
    txn.closingBalance = totalBal - amt;

    //update user funds
    double _f = baseProvider.userFundWallet.iciciPrinciple;
    baseProvider.userFundWallet = await dbProvider.updateUserIciciBalance(
        baseProvider.myUser.uid, baseProvider.userFundWallet, amt * -1);
    bool isFundWalletUpdated =
        (_f != baseProvider.userFundWallet.iciciPrinciple);

    int _t = baseProvider.userTicketWallet.icici1565Tck;
    baseProvider.userTicketWallet = await dbProvider.updateICICIUserTicketCount(
        baseProvider.myUser.uid,
        baseProvider.userTicketWallet,
        ticketCount * -1);
    bool isTckWalletUpdated =
        (_t != baseProvider.userTicketWallet.icici1565Tck);

    baseProvider.userMiniTxnList = null; //so transactions get refreshed
    if (isInstantTxn) {
      String txnDocId =
          await dbProvider.addUserTransaction(baseProvider.myUser.uid, txn);
      log.debug('Updated all flags:: ${txnDocId != null}');

      return (isFundWalletUpdated && isTckWalletUpdated && txnDocId != null);
    } else {
      bool tFlag =
          await dbProvider.updateUserTransaction(baseProvider.myUser.uid, txn);

      return (isFundWalletUpdated && isTckWalletUpdated && tFlag);
    }
  }

  ///returns OTP ID
  Future<String> _onNonInstantSendOtp(UserTransaction txn) async {
    final redemptionMap = await iProvider.sendRedemptionOtp(
      baseProvider.iciciDetail.folioNo,
      txn.icici[UserTransaction.subFldIciciTranId],
    );

    if (redemptionMap == null ||
        redemptionMap[QUERY_SUCCESS_FLAG] == QUERY_FAILED) {
      String errReason = (redemptionMap[QUERY_FAIL_REASON] != null)
          ? redemptionMap[QUERY_FAIL_REASON]
          : 'Unknown';
      Map<String, dynamic> failData = {
        'folioNumber': baseProvider.iciciDetail.folioNo,
        'failReason': errReason
      };
      bool failureLogged = await dbProvider.logFailure(baseProvider.myUser.uid,
          FailType.UserRedemptionOTPSendFailed, failData);
      log.debug('Failure logged correctly: $failureLogged');
      return null;
    } else {
      String otpId = redemptionMap[SendRedemptionOtp.resOtpId];
      if (otpId == null || otpId.isEmpty)
        return null;
      else
        return otpId;
    }
  }

  addPaymentStatusListener(ValueChanged<int> listener) {
    _onProcessComplete = listener;
  }

  ///run checkIMPS to get instant balance, total balance, and imps allowed
  Future<Map<String, dynamic>> getWithdrawalDetails() async {
    bool initFlag = await _init();
    if (!initFlag)
      return {
        'flag': false,
        'reason': 'App restart required'
      }; //should never happen

    if (baseProvider.iciciDetail.folioNo == null)
      return {
        'flag': false,
        'reason': 'Insufficient details'
      }; //should never happen

    final impsFlag = await iProvider.checkIMPSEligible(
        baseProvider.iciciDetail.folioNo, '1');
    if (impsFlag == null || impsFlag[QUERY_SUCCESS_FLAG] == QUERY_FAILED) {
      String errReason = (impsFlag[QUERY_FAIL_REASON] != null)
          ? impsFlag[QUERY_FAIL_REASON]
          : 'Unknown';
      Map<String, dynamic> failData = {
        'folioNumber': baseProvider.iciciDetail.folioNo,
        'failReason': errReason
      };
      bool failureLogged = await dbProvider.logFailure(baseProvider.myUser.uid,
          FailType.UserWithdrawalCheckIMPSFailed, failData);
      log.debug('Failure logged correctly: $failureLogged');
      return {
        'flag': false,
        'reason': (impsFlag[QUERY_FAIL_REASON] != null)
            ? impsFlag[QUERY_FAIL_REASON]
            : 'Encountered an unknown error. Please try again in a while'
      };
    } else {
      double instantBalance = impsFlag[CheckIMPSStatus.resInstantBalance];
      double totalBalance = impsFlag[CheckIMPSStatus.resTotalBalance];
      String impsFlagStr = impsFlag[CheckIMPSStatus.resAllowIMPSFlag];
      String returnCodeStr = impsFlag[CheckIMPSStatus.resReturnCode];
      String returnMsgStr = impsFlag[CheckIMPSStatus.resReturnMsg];

      if (impsFlagStr != 'Y' ||
          returnCodeStr != CheckIMPSStatus.STATUS_ALLOWED) {
        Map<String, dynamic> failData = {
          'folioNumber': baseProvider.iciciDetail.folioNo,
          'IMPSReturnCode': returnCodeStr,
          'AllowRedeem': impsFlagStr
        };
        bool failureLogged = await dbProvider.logFailure(
            baseProvider.myUser.uid,
            FailType.UserWithdrawalCheckIMPSFailed,
            failData);
        log.debug('Failure logged correctly: $failureLogged');
        return {
          'flag': true,
          'is_imps_allowed': false,
          'instant_balance': instantBalance,
          'total_balance': totalBalance,
          'reason':
              'Instant Withdrawal not available. Please contact us for more information'
        };
      } else {
        return {
          'flag': true,
          'is_imps_allowed': true,
          'instant_balance': instantBalance,
          'total_balance': totalBalance
        };
      }
    }
  }

  ///check if less than 90%
  ///run get redeem details
  ///run submit withdrawal
  ///add firebase transaction
  Future<Map<String, dynamic>> preProcessWithdrawal(String amount) async {
    bool initFlag = await _init();
    if (!initFlag)
      return {
        'flag': false,
        'reason': 'App restart required'
      }; //should never happen

    Map<String, dynamic> _bankDetails = await _getBankDetails();
    if (!_bankDetails['flag'])
      return _bankDetails;
    else
      _bankDetails[SubmitRedemption.fldAmount] = amount;
    //TODO exit load status
    // Map<String, dynamic> _exitLoadDetails = await _getExitLoadDetails(amount);
    //
    // if (_exitLoadDetails['flag']) {
    //   _bankDetails[GetExitLoad.resPopUpFlag] =
    //       _exitLoadDetails[GetExitLoad.resPopUpFlag];
    //   _bankDetails[GetExitLoad.resApproxLoadAmt] =
    //       _exitLoadDetails[GetExitLoad.resApproxLoadAmt];
    // }

    return _bankDetails;
  }

  Future<Map<String, dynamic>> processWithdrawal(
      Map<String, dynamic> withdrawalMap,
      double instantAmount,
      double nonInstantAmount) async {
    bool initFlag = await _init();
    if (!initFlag)
      return {
        'flag': false,
        'reason': 'App restart required'
      }; //should never happen

    log.debug('$instantAmount, $nonInstantAmount');

    bool netFlag = true;
    Map<String, dynamic> resMap = {};
    Map<String, dynamic> instantWithdrawalResult, nonInstantWithdrawalResult;
    // if (instantAmount != null && instantAmount > 0) {
    //   ///first process the instant withdrawal
    //   instantWithdrawalResult =
    //       await _processInstantWithdrawal(withdrawalMap, instantAmount);
    //   if (instantWithdrawalResult != null &&
    //       instantWithdrawalResult['flag'] != null) {
    //     resMap['instant_flag'] = instantWithdrawalResult['flag'];
    //     if (!instantWithdrawalResult['flag']) {
    //       netFlag = false;
    //       resMap['instant_fail_reason'] = instantWithdrawalResult['reason'];
    //     }
    //   }
    // }
    /////////////////
    //DUMMY
    resMap['instant_flag'] = true;
    /////////////////
    if (netFlag && nonInstantAmount != null && nonInstantAmount > 0) {
      ///next process the non instant withdrawal
      nonInstantWithdrawalResult =
          await _processNonInstantWithdrawal(withdrawalMap, nonInstantAmount);
      if (nonInstantWithdrawalResult != null &&
          nonInstantWithdrawalResult['flag'] != null) {
        resMap['non_instant_flag'] = nonInstantWithdrawalResult['flag'];
        if (!nonInstantWithdrawalResult['flag']) {
          netFlag = false;
          resMap['non_instant_fail_reason'] =
              nonInstantWithdrawalResult['reason'];
        }
      }
    }

    log.debug('');
    return resMap;
  }

  ///the withdrawalMap fields should have
  ///all bank details
  ///amount
  ///exit load details if required
  Future<Map<String, dynamic>> _processInstantWithdrawal(
      Map<String, dynamic> withdrawalMap, double amount) async {
    final redemptionMap = await iProvider.submitInstantWithdrawal(
        baseProvider.iciciDetail.folioNo,
        amount.toString(),
        withdrawalMap['bankCode'],
        '91${baseProvider.myUser.mobile}',
        withdrawalMap['bankName'],
        withdrawalMap['accountNumber'],
        withdrawalMap['accountType'],
        withdrawalMap['bankBranch'],
        withdrawalMap['bankCity'],
        withdrawalMap['redeemMode'],
        withdrawalMap['ifsc'],
        withdrawalMap['exitLoadTick'],
        withdrawalMap['approxLoadAmount']);

    if (redemptionMap == null ||
        redemptionMap[QUERY_SUCCESS_FLAG] == QUERY_FAILED) {
      String errReason = (redemptionMap[QUERY_FAIL_REASON] != null)
          ? redemptionMap[QUERY_FAIL_REASON]
          : 'Unknown';
      Map<String, dynamic> failData = {
        'folioNumber': baseProvider.iciciDetail.folioNo,
        'failReason': errReason
      };
      bool failureLogged = await dbProvider.logFailure(baseProvider.myUser.uid,
          FailType.UserWithdrawalSubmitFailed, failData);
      log.debug('Failure logged correctly: $failureLogged');
      return {
        'flag': false,
        'reason': (redemptionMap[QUERY_FAIL_REASON] != null)
            ? redemptionMap[QUERY_FAIL_REASON]
            : 'Encountered an unknown error. Please try again in a while'
      };
    } else {
      if (redemptionMap[SubmitRedemption.resTranId] == null ||
          redemptionMap[SubmitRedemption.resTranId].toString().isEmpty) {
        //Transaction ID not created. Withdrawal failed
        Map<String, dynamic> failData = {
          'folioNumber': baseProvider.iciciDetail.folioNo,
          'failReason': 'Tran ID not generated'
        };
        bool failureLogged = await dbProvider.logFailure(
            baseProvider.myUser.uid,
            FailType.UserWithdrawalSubmitFailed,
            failData);
        log.debug('Failure logged correctly: $failureLogged');
        return {
          'flag': false,
          'reason':
              'Withdrawal failed. Please try again in sometime. We will verify the transaction from our end as well!'
        };
      } else {
        //Transaction ID generated. Now check for IMPS Code
        if (redemptionMap[SubmitRedemption.resIMPSCode] == null ||
            redemptionMap[SubmitRedemption.resIMPSCode] !=
                SubmitRedemption.IMPS_TRANSACTION_SUCCESS) {
          Map<String, dynamic> failData = {
            'folioNumber': baseProvider.iciciDetail.folioNo,
            'failReason': 'Tran ID generated but IMPS status not 0'
          };
          bool failureLogged = await dbProvider.logFailure(
              baseProvider.myUser.uid,
              FailType.UserWithdrawalSubmitFailed,
              failData);
          log.debug('Failure logged correctly: $failureLogged');
          return {
            'flag': false,
            'reason': redemptionMap[SubmitRedemption.resIMPSStatus] ??
                'Withdrawal failed. Please try again in sometime. We will verify the transaction from our end as well!'
          };
        } else {
          double amt = 0;
          try {
            amt = double.parse(withdrawalMap['amount']);
          } catch (e) {}
          //Transaction ID generated and IMPS code is success
          UserTransaction withTxn = UserTransaction.mfWithdrawal(
              redemptionMap[SubmitRedemption.resTranId],
              redemptionMap[SubmitRedemption.resBankRnn],
              redemptionMap[SubmitRedemption.resIMPSStatus] ?? 'NA',
              redemptionMap[SubmitRedemption.resTrnTime],
              amt,
              baseProvider.myUser.uid);
          bool fFlag = await _onWithdrawalCompleted(withTxn, true);
          return {'flag': fFlag};
        }
      }
    }
  }

  Future<Map<String, dynamic>> _processNonInstantWithdrawal(
      Map<String, dynamic> withdrawalMap, double amount) async {
    final redemptionMap = await iProvider.submitNonInstantWithdrawal(
        baseProvider.iciciDetail.folioNo,
        baseProvider.userRegdPan,
        amount.toString(),
        withdrawalMap['bankCode'],
        withdrawalMap['bankName'],
        withdrawalMap['accountNumber'],
        withdrawalMap['accountType'],
        withdrawalMap['bankBranch'],
        withdrawalMap['bankCity'],
        withdrawalMap['redeemMode'],
        withdrawalMap['ifsc']);

    if (redemptionMap == null ||
        redemptionMap[QUERY_SUCCESS_FLAG] == QUERY_FAILED) {
      String errReason = (redemptionMap[QUERY_FAIL_REASON] != null)
          ? redemptionMap[QUERY_FAIL_REASON]
          : 'Unknown';
      Map<String, dynamic> failData = {
        'folioNumber': baseProvider.iciciDetail.folioNo,
        'failReason': errReason
      };
      bool failureLogged = await dbProvider.logFailure(baseProvider.myUser.uid,
          FailType.UserWithdrawalSubmitFailed, failData);
      log.debug('Failure logged correctly: $failureLogged');
      return {
        'flag': false,
        'reason': (redemptionMap[QUERY_FAIL_REASON] != null)
            ? redemptionMap[QUERY_FAIL_REASON]
            : 'Encountered an unknown error. Please try again in a while'
      };
    } else {
      if (redemptionMap[SubmitRedemptionNonInstant.resTranId] == null ||
          redemptionMap[SubmitRedemptionNonInstant.resTranId]
              .toString()
              .isEmpty) {
        //Transaction ID not created. Withdrawal failed
        Map<String, dynamic> failData = {
          'folioNumber': baseProvider.iciciDetail.folioNo,
          'type': 'NONINSTANTWITHDRAWAL',
          'failReason': 'Tran ID not generated'
        };
        bool failureLogged = await dbProvider.logFailure(
            baseProvider.myUser.uid,
            FailType.UserWithdrawalSubmitFailed,
            failData);
        log.debug('Failure logged correctly: $failureLogged');
        return {
          'flag': false,
          'reason':
              'Withdrawal failed. Please try again in sometime. We will verify the transaction from our end as well!'
        };
      } else {
        //Transaction ID generated. Now check for IMPS Code
        double amt = 0;
        try {
          amt = double.parse(withdrawalMap['amount']);
        } catch (e) {}
        //Transaction ID generated and IMPS code is success
        UserTransaction withTxn = UserTransaction.mfNonInstantWithdrawal(
            redemptionMap[SubmitRedemptionNonInstant.resTranId],
            redemptionMap[SubmitRedemptionNonInstant.resIMPSStatus] ?? 'NA',
            redemptionMap[SubmitRedemptionNonInstant.resTrnTime],
            amount,
            baseProvider.myUser.uid);
        baseProvider.currentICICINonInstantWthrlTxn = withTxn;
        String otpId;
        try {
          otpId = await _onNonInstantSendOtp(
              baseProvider.currentICICINonInstantWthrlTxn);
        } catch (e) {
          log.error('Failed to push transaction otp api');
        }

        ///update the otp id to the txn
        if (otpId != null) {
          baseProvider.currentICICINonInstantWthrlTxn
              .icici[UserTransaction.subFldIciciTxnOtpId] = otpId;
          baseProvider.currentICICINonInstantWthrlTxn
              .icici[UserTransaction.subFldIciciTxnOtpVerified] = false;
        } else {
          //failed
          baseProvider.currentICICINonInstantWthrlTxn.tranStatus =
              UserTransaction.TRAN_STATUS_CANCELLED;
        }

        ///add the txn to db
        await dbProvider.addUserTransaction(baseProvider.myUser.uid,
            baseProvider.currentICICINonInstantWthrlTxn);

        ///clean global field if txn failed
        if (baseProvider.currentICICINonInstantWthrlTxn.tranStatus ==
            UserTransaction.TRAN_STATUS_CANCELLED) {
          baseProvider.currentICICINonInstantWthrlTxn = null;
          baseProvider.userMiniTxnList = null; //so transactions get refreshed
        }

        return (otpId != null)
            ? {'flag': true, 'otpid': otpId}
            : {'flag': false, 'reason': 'Failed to send a transaction otp'};
      }
    }
  }

  Future<bool> verifyWithdrawalOtp(String otp) async {
    if (!iProvider.isInit()) await iProvider.init();
    if (otp == null || otp.isEmpty) return false;

    Map<String, dynamic> _resMap = await iProvider.verifyRedemptionOtp(
        baseProvider.iciciDetail.folioNo,
        baseProvider.currentICICINonInstantWthrlTxn
            .icici[UserTransaction.subFldIciciTranId],
        baseProvider.currentICICINonInstantWthrlTxn
            .icici[UserTransaction.subFldIciciTxnOtpId],
        otp);

    if (_resMap != null &&
        _resMap[QUERY_SUCCESS_FLAG] == QUERY_PASSED &&
        _resMap[VerifyRedemptionOtp.resStatus] == '1') {
      ///withdrawal txn otp successfully verified
      baseProvider.currentICICINonInstantWthrlTxn
          .icici[UserTransaction.subFldIciciTxnOtpVerified] = true;
      baseProvider.currentICICINonInstantWthrlTxn.tranStatus =
          UserTransaction.TRAN_STATUS_COMPLETE;
      return await _onWithdrawalCompleted(
          baseProvider.currentICICINonInstantWthrlTxn, false);
    } else {
      return false;
    }
  }

  Future<Map<String, dynamic>> _getBankDetails() async {
    if (baseProvider.iciciDetail.folioNo == null)
      return {
        'flag': false,
        'reason': 'Insufficient details'
      }; //should never happen
    final getRedeemMap =
        await iProvider.getBankRedeemDetails(baseProvider.iciciDetail.folioNo);
    if (getRedeemMap == null ||
        getRedeemMap[QUERY_SUCCESS_FLAG] == QUERY_FAILED) {
      String errReason = (getRedeemMap[QUERY_FAIL_REASON] != null)
          ? getRedeemMap[QUERY_FAIL_REASON]
          : 'Unknown';
      Map<String, dynamic> failData = {
        'folioNumber': baseProvider.iciciDetail.folioNo,
        'failReason': errReason
      };
      bool failureLogged = await dbProvider.logFailure(baseProvider.myUser.uid,
          FailType.UserWithdrawalGetRedeemFailed, failData);
      log.debug('Failure logged correctly: $failureLogged');
      return {
        'flag': false,
        'reason': (getRedeemMap[QUERY_FAIL_REASON] != null)
            ? getRedeemMap[QUERY_FAIL_REASON]
            : 'Encountered an unknown error. Please try again in a while'
      };
    } else {
      String bankName = getRedeemMap[GetBankRedemptionDetail.resBankName];
      String bankDetailsCombined =
          getRedeemMap[GetBankRedemptionDetail.resCombinedBankDetails];
      String accountDetailsCombined =
          getRedeemMap[GetBankRedemptionDetail.resCombinedAccountDetails];
      String accountNumber,
          ifsc,
          bankCode,
          accountType,
          bankBranch,
          bankCity,
          redeemMode;
      try {
        accountNumber =
            GetBankRedemptionDetail.getBankAccNo(accountDetailsCombined);
        ifsc = GetBankRedemptionDetail.getBankIfsc(accountDetailsCombined);
        bankCode = GetBankRedemptionDetail.getBankCode(accountDetailsCombined);
      } catch (e) {}

      try {
        accountType =
            GetBankRedemptionDetail.getBankAccType(bankDetailsCombined);
        bankBranch = GetBankRedemptionDetail.getBankBranch(bankDetailsCombined);
        bankCity = GetBankRedemptionDetail.getBankCity(bankDetailsCombined);
        redeemMode = GetBankRedemptionDetail.getRedeemMode(bankDetailsCombined);
      } catch (e) {}

      if (bankName == null ||
          accountNumber == null ||
          bankCode == null ||
          ifsc == null)
        return {
          'flag': false,
          'reason': 'Your associated bank details could not be fetched'
        };
      else
        return {
          'flag': true,
          'accountNumber': accountNumber,
          'bankName': bankName,
          'bankBranch': bankBranch ?? '',
          'bankCity': bankCity ?? '',
          'ifsc': ifsc,
          'bankCode': bankCode,
          'accountType': accountType ?? 'SB',
          'redeemMode': redeemMode ?? 'NEFT'
        };
    }
  }

  Future<Map<String, dynamic>> _getExitLoadDetails(String amount) async {
    if (baseProvider.iciciDetail.folioNo == null)
      return {
        'flag': false,
        'reason': 'Insufficient details'
      }; //should never happen
    final elMap = await iProvider.getExitLoadStatus(
        baseProvider.iciciDetail.folioNo, amount);
    if (elMap == null || elMap[QUERY_SUCCESS_FLAG] == QUERY_FAILED) {
      String errReason = (elMap[QUERY_FAIL_REASON] != null)
          ? elMap[QUERY_FAIL_REASON]
          : 'Unknown';
      Map<String, dynamic> failData = {
        'folioNumber': baseProvider.iciciDetail.folioNo,
        'failReason': errReason
      };
      bool failureLogged = await dbProvider.logFailure(baseProvider.myUser.uid,
          FailType.UserWithdrawalExitLoadFailed, failData);
      log.debug('Failure logged correctly: $failureLogged');
      return {
        'flag': false,
        'reason': (elMap[QUERY_FAIL_REASON] != null)
            ? elMap[QUERY_FAIL_REASON]
            : 'Encountered an unknown error. Please try again in a while'
      };
    } else {
      return elMap;
    }
  }
}
