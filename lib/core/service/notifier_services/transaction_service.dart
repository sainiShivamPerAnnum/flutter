import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/enums/transaction_service_enum.dart';
import 'package:felloapp/core/model/paytm_models/deposit_fcm_response_model.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/service/notifier_services/golden_ticket_service.dart';
import 'package:felloapp/core/service/notifier_services/internal_ops_service.dart';
import 'package:felloapp/core/service/notifier_services/user_coin_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_scratch_dialog/gt_instant_view.dart';
import 'package:felloapp/ui/pages/static/txn_completed_ui/txn_completed_view.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class TransactionService
    extends PropertyChangeNotifier<TransactionServiceProperties> {
  final _dBModel = locator<DBModel>();
  final _baseUtil = locator<BaseUtil>();
  final _userService = locator<UserService>();
  final _logger = locator<CustomLogger>();
  final _gtService = GoldenTicketService();
  final _internalOpsService = locator<InternalOpsService>();
  final _userCoinService = locator<UserCoinService>();

  final _baseUrl = FlavorConfig.isDevelopment()
      ? "https://wd7bvvu7le.execute-api.ap-south-1.amazonaws.com/dev"
      : "https://yg58g0feo0.execute-api.ap-south-1.amazonaws.com/prod";
  List<UserTransaction> _txnList;
  String lastTxnDocId,
      lastPrizeTxnDocId,
      lastDepositTxnDocId,
      lastWithdrawalTxnDocId,
      lastRefundedTxnDocId;
  bool hasMoreTxns = true,
      hasMorePrizeTxns = true,
      hasMoreDepositTxns = true,
      hasMoreWithdrawalTxns = true,
      hasMoreRefundedTxns = true;

  List<UserTransaction> get txnList => _txnList;

  set txnList(List<UserTransaction> list) {
    _txnList = list;
    notifyListeners(TransactionServiceProperties.transactionList);
  }

  appendTxns(List<UserTransaction> list) {
    list.forEach((txn) {
      UserTransaction duplicate = _txnList
          .firstWhere((t) => t.timestamp == txn.timestamp, orElse: () => null);
      if (duplicate == null) _txnList.add(txn);
    });
    _txnList.sort((a, b) => b.timestamp.seconds.compareTo(a.timestamp.seconds));
    notifyListeners(TransactionServiceProperties.transactionList);
  }

  fetchTransactions({
    String status,
    String type,
    String subtype,
  }) async {
    if (_dBModel != null && _userService != null) {
      //fetch filtered transactions
      final response = await getUserTransactionsfromApi(
        type: type,
        subtype: subtype,
        status: status,
        start: getLastTxnDocType(status: status, type: type),
      );

      // if transaction list is empty
      if (_txnList == null || _txnList.length == 0) {
        txnList = response.model.transactions;
      } else {
        // if transaction list already have some items
        appendTxns(response.model.transactions);
      }
      _logger.d("Current Transaction List length: ${_txnList.length}");
      // set proper lastDocument snapshot for further fetches
      if (response.model.transactions.isNotEmpty)
        setLastTxnDocType(
            status: status,
            type: type,
            lastDocId: response.model.transactions.last.docKey);
      // check and set which category has no more items to fetch
      if (response.model.isLastPage)
        setHasMoreTxnsValue(type: type, status: status);
    }
  }

  String getLastTxnDocType({String status, String type}) {
    if (status == null && type == null) return lastTxnDocId;
    if (status != null) return lastRefundedTxnDocId;
    if (type != null) {
      if (type == UserTransaction.TRAN_TYPE_DEPOSIT) return lastDepositTxnDocId;
      if (type == UserTransaction.TRAN_TYPE_PRIZE) return lastPrizeTxnDocId;
      if (type == UserTransaction.TRAN_TYPE_WITHDRAW)
        return lastWithdrawalTxnDocId;
    }
    return lastTxnDocId;
  }

  setLastTxnDocType({String status, String type, String lastDocId}) {
    if (status == null && type == null) {
      lastTxnDocId = lastDocId;
      lastRefundedTxnDocId = lastDocId;
      lastDepositTxnDocId = lastDocId;
      lastWithdrawalTxnDocId = lastDocId;
      lastPrizeTxnDocId = lastDocId;
    } else if (status != null)
      lastRefundedTxnDocId = lastDocId;
    else if (type != null) {
      if (type == UserTransaction.TRAN_TYPE_DEPOSIT)
        lastDepositTxnDocId = lastDocId;
      if (type == UserTransaction.TRAN_TYPE_PRIZE)
        lastPrizeTxnDocId = lastDocId;
      if (type == UserTransaction.TRAN_TYPE_WITHDRAW)
        lastWithdrawalTxnDocId = lastDocId;
    }
  }

  setHasMoreTxnsValue({String status, String type}) {
    if (status == null && type == null) {
      hasMoreTxns = false;
      hasMorePrizeTxns = false;
      hasMoreDepositTxns = false;
      hasMoreRefundedTxns = false;
      hasMoreWithdrawalTxns = false;
      findFirstAugmontTransaction();
      _logger.d("Transaction fetch complete, no more operations from here on");
    } else if (status != null) {
      hasMoreRefundedTxns = false;
    } else if (type != null) {
      if (type == UserTransaction.TRAN_TYPE_DEPOSIT)
        hasMoreDepositTxns = false;
      else if (type == UserTransaction.TRAN_TYPE_WITHDRAW)
        hasMoreWithdrawalTxns = false;
      else if (type == UserTransaction.TRAN_TYPE_PRIZE)
        hasMorePrizeTxns = false;
    }
  }

  findFirstAugmontTransaction() {
    try {
      List<UserTransaction> reversedList = txnList.reversed.toList();
      _baseUtil.firstAugmontTransaction = reversedList.firstWhere((element) =>
          element.type == UserTransaction.TRAN_TYPE_DEPOSIT &&
          element.tranStatus == UserTransaction.TRAN_STATUS_COMPLETE &&
          element.subType == UserTransaction.TRAN_SUBTYPE_AUGMONT_GOLD);
    } catch (e) {
      _logger.i("No transaction found");
    }
  }

  updateTransactions() async {
    lastTxnDocId = null;
    hasMoreTxns = true;
    hasMorePrizeTxns = true;
    hasMoreDepositTxns = true;
    hasMoreWithdrawalTxns = true;
    hasMoreRefundedTxns = true;
    txnList?.clear();
    await fetchTransactions();
    _logger.i("Transactions got updated");
  }

// helpers

  String getFormattedTxnAmount(double amount) {
    if (amount > 0)
      return "₹ ${amount.abs().toStringAsFixed(2)}";
    else
      return "- ₹ ${amount.abs().toStringAsFixed(2)}";
  }

  String getFormattedTime(Timestamp tTime) {
    DateTime now =
        DateTime.fromMillisecondsSinceEpoch(tTime.millisecondsSinceEpoch);
    return DateFormat('yyyy-MM-dd – hh:mm a').format(now);
  }

  Widget getTileLead(String type) {
    IconData icon;
    Color iconColor;
    if (type == UserTransaction.TRAN_STATUS_COMPLETE) {
      icon = Icons.check_circle;
      iconColor = UiConstants.primaryColor;
    } else if (type == UserTransaction.TRAN_STATUS_CANCELLED ||
        type == UserTransaction.TRAN_STATUS_FAILED) {
      icon = Icons.cancel;
      iconColor = Colors.red;
    } else if (type == UserTransaction.TRAN_STATUS_PENDING ||
        type == UserTransaction.TRAN_STATUS_PROCESSING) {
      icon = Icons.access_time_filled;
      iconColor = UiConstants.tertiarySolid;
    } else if (type == UserTransaction.TRAN_STATUS_REFUNDED) {
      icon = Icons.remove_circle;
      iconColor = Colors.blue;
    }
    if (icon != null) return Icon(icon, color: iconColor);

    return Image.asset("images/fello_logo.png", fit: BoxFit.contain);
  }

  String getTileTitle(String type) {
    if (type == UserTransaction.TRAN_SUBTYPE_ICICI) {
      return "ICICI Prudential Fund";
    } else if (type == UserTransaction.TRAN_SUBTYPE_AUGMONT_GOLD) {
      return "Digital Gold";
    } else if (type == UserTransaction.TRAN_SUBTYPE_TAMBOLA_WIN) {
      return "Tambola Win";
    } else if (type == UserTransaction.TRAN_SUBTYPE_REF_BONUS) {
      return "Referral Bonus";
    } else if (type == UserTransaction.TRAN_SUBTYPE_REWARD_REDEEM) {
      return "Rewards Redeemed";
    } else if (type == UserTransaction.TRAN_SUBTYPE_GLDN_TCK)
      return "Golden Ticket";
    return "Fello Rewards";
  }

  String getTileSubtitle(String type) {
    if (type == UserTransaction.TRAN_TYPE_DEPOSIT) {
      return "Deposit";
    } else if (type == UserTransaction.TRAN_TYPE_PRIZE) {
      return "Prize";
    } else if (type == UserTransaction.TRAN_TYPE_WITHDRAW) {
      return "Withdrawal";
    }
    return "";
  }

  Color getTileColor(String type) {
    if (type == UserTransaction.TRAN_STATUS_CANCELLED ||
        type == UserTransaction.TRAN_STATUS_FAILED) {
      return Colors.redAccent;
    } else if (type == UserTransaction.TRAN_STATUS_COMPLETE) {
      return UiConstants.primaryColor;
    } else if (type == UserTransaction.TRAN_STATUS_PENDING) {
      return Colors.amber;
    } else if (type == UserTransaction.TRAN_STATUS_PROCESSING) {
      return Colors.amber;
    } else if (type == UserTransaction.TRAN_STATUS_REFUNDED) {
      return Colors.blue;
    }
    return Colors.black54;
  }

  // BEER FEST SPECIFIC CODE

  bool isOfferStillValid(Timestamp time) {
    String _timeoutMins = BaseRemoteConfig.remoteConfig
        .getString(BaseRemoteConfig.OCT_FEST_OFFER_TIMEOUT);
    if (_timeoutMins == null || _timeoutMins.isEmpty) _timeoutMins = '10';
    int _timeout = int.tryParse(_timeoutMins);

    DateTime tTime =
        DateTime.fromMillisecondsSinceEpoch(time.millisecondsSinceEpoch);
    Duration difference = DateTime.now().difference(tTime);
    if (difference.inSeconds <= _timeout * 60) {
      return true;
    }
    return false;
  }

  bool getBeerTicketStatus(UserTransaction transaction) {
    double minBeerDeposit = double.tryParse(BaseRemoteConfig.remoteConfig
            .getString(BaseRemoteConfig.OCT_FEST_MIN_DEPOSIT) ??
        '150.0');
    _logger.d(_baseUtil.firstAugmontTransaction);
    if (_baseUtil.firstAugmontTransaction != null &&
        _baseUtil.firstAugmontTransaction == transaction &&
        transaction.amount >= minBeerDeposit &&
        isOfferStillValid(transaction.timestamp)) return true;
    return false;
  }

  getAmount(double amount) {
    if (amount > amount.toInt())
      return amount;
    else
      return amount.toInt();
  }

  showTxnSuccessScreen(double amount, String title,
      {bool showAutoSavePrompt = false}) {
    AppState.screenStack.add(ScreenItem.dialog);
    Navigator.of(AppState.delegate.navigatorKey.currentContext).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) =>
            TxnCompletedConfirmationScreenView(
          amount: amount ?? 0,
          title: title ?? "Hurray, we saved ₹NA",
          showAutoSavePrompt: showAutoSavePrompt,
        ),
      ),
    );
  }

  fcmTransactionResponseUpdate(fcmDataPayload) async {
    //Stop loader if loading.
    _logger.i("Updating response value. $fcmDataPayload");
    // AppState.delegate.appState.txnFunction.timeout(Duration(seconds: 1));
    AppState.delegate.appState.txnTimer.cancel();
    _logger.d("timer cancelled");

    try {
      final DepositFcmResponseModel depositFcmResponseModel =
          DepositFcmResponseModel.fromJson(json.decode(fcmDataPayload));

      //Handle failed condition here.
      if (!depositFcmResponseModel.status) {
        AppState.delegate.appState.isTxnLoaderInView = false;
        BaseUtil.showNegativeAlert("Transaction failed",
            "Your gold purchase did not complete successfully");
        return;
      }
      //handle multiple fcm command for same transaction
      if (depositFcmResponseModel.gtId != null) {
        print(
            "Hey a new fcm recived with gtId: ${depositFcmResponseModel.gtId}");
        if (GoldenTicketService.lastGoldenTicketId != null) {
          if (GoldenTicketService.lastGoldenTicketId ==
              depositFcmResponseModel.gtId) {
            return;
          } else {
            GoldenTicketService.lastGoldenTicketId =
                depositFcmResponseModel.gtId;
          }
        } else {
          GoldenTicketService.lastGoldenTicketId = depositFcmResponseModel.gtId;
        }
      }

      double newAugPrinciple = depositFcmResponseModel.augmontPrinciple;
      if (newAugPrinciple != null && newAugPrinciple > 0) {
        _userService.augGoldPrinciple = newAugPrinciple;
      }
      double newAugQuantity = depositFcmResponseModel.augmontGoldQty;
      if (newAugQuantity != null && newAugQuantity > 0) {
        _userService.augGoldQuantity = newAugQuantity;
      }
      //add this to augmontBuyVM
      int newFlcBalance = depositFcmResponseModel?.flcBalance ?? 0;
      if (newFlcBalance > 0) {
        _userCoinService.setFlcBalance(newFlcBalance);
      }
      if (AppState.delegate.appState.isTxnLoaderInView == true) {
        if (depositFcmResponseModel.gtId != null) {
          GoldenTicketService.goldenTicketId = depositFcmResponseModel.gtId;
          if (await _gtService.fetchAndVerifyGoldenTicketByID()) {
            Future.delayed(Duration(milliseconds: 220), () {
              AppState.delegate.appState.isTxnLoaderInView = false;
            });
            _gtService.showInstantGoldenTicketView(
                amount: depositFcmResponseModel.amount,
                title:
                    "You have successfully saved ₹${getAmount(depositFcmResponseModel.amount)}",
                source: GTSOURCE.deposit,
                showAutoSavePrompt: depositFcmResponseModel.autosavePrompt);
          } else {
            AppState.delegate.appState.isTxnLoaderInView = false;
            showTxnSuccessScreen(depositFcmResponseModel.amount,
                "You have successfully saved ₹${getAmount(depositFcmResponseModel.amount)}",
                showAutoSavePrompt: depositFcmResponseModel.autosavePrompt);
          }
        } else {
          AppState.delegate.appState.isTxnLoaderInView = false;
          showTxnSuccessScreen(depositFcmResponseModel.amount,
              "You have successfully saved ₹${getAmount(depositFcmResponseModel.amount)}",
              showAutoSavePrompt: depositFcmResponseModel.autosavePrompt);
        }
      }
      updateTransactions();
    } catch (e) {
      _logger.e(e);
      _internalOpsService.logFailure(
          _userService.baseUser.uid, FailType.DepositPayloadError, e);
    }
  }

  transactionResponseUpdate({String gtId, double amount}) async {
    try {
      if (gtId != null) {
        print("Hey a new fcm recived with gtId: $gtId");
        if (GoldenTicketService.lastGoldenTicketId != null) {
          if (GoldenTicketService.lastGoldenTicketId == gtId) {
            return;
          } else {
            GoldenTicketService.lastGoldenTicketId = gtId;
          }
        } else {
          GoldenTicketService.lastGoldenTicketId = gtId;
        }
      }

      //add this to augmontBuyVM
      double newFlcBalance = amount ?? 0;
      if (newFlcBalance > 0) {
        _userCoinService.setFlcBalance(newFlcBalance.toInt());
      }
      if (AppState.delegate.appState.isTxnLoaderInView == true) {
        if (gtId != null) {
          GoldenTicketService.goldenTicketId = gtId;
          if (await _gtService.fetchAndVerifyGoldenTicketByID()) {
            Future.delayed(Duration(milliseconds: 220), () {
              AppState.delegate.appState.isTxnLoaderInView = false;
            });
            _gtService.showInstantGoldenTicketView(
                amount: amount,
                title: "You have successfully saved ₹${getAmount(amount)}",
                source: GTSOURCE.deposit,
                showAutoSavePrompt: true);
          } else {
            AppState.delegate.appState.isTxnLoaderInView = false;
            showTxnSuccessScreen(
                amount, "You have successfully saved ₹${getAmount(amount)}",
                showAutoSavePrompt: true);
          }
        } else {
          AppState.delegate.appState.isTxnLoaderInView = false;
          showTxnSuccessScreen(
              amount, "You have successfully saved ₹${getAmount(amount)}",
              showAutoSavePrompt: true);
        }
      }
      updateTransactions();
    } catch (e) {
      _logger.e(e);
      _internalOpsService.logFailure(
          _userService.baseUser.uid, FailType.DepositPayloadError, e);
    }
  }

// Clear transactions
  signOut() {
    lastTxnDocId = null;
    hasMoreTxns = true;
    hasMorePrizeTxns = true;
    hasMoreDepositTxns = true;
    hasMoreWithdrawalTxns = true;
    hasMoreRefundedTxns = true;
    if (txnList != null) txnList.clear();
  }

  Future<ApiResponse<TransactionResponse>> getUserTransactionsfromApi({
    String start,
    String type,
    String subtype,
    String status,
  }) async {
    List<UserTransaction> events = [];
    try {
      final String _uid = _userService.baseUser.uid;
      final _token = await _getBearerToken();
      final _queryParams = {
        "type": type,
        "subtype": subtype,
        "start": start,
        "status": status
      };
      final response = await APIService.instance.getData(
        ApiPath.kSingleTransactions(_uid),
        token: _token,
        queryParams: _queryParams,
        cBaseUrl: _baseUrl,
      );

      final responseData = response["data"];
      responseData["transactions"].forEach((e) {
        events.add(UserTransaction.fromMap(e, e["id"]));
      });

      final bool isLastPage = responseData["isLastPage"] ?? false;
      final TransactionResponse txnResponse =
          TransactionResponse(isLastPage: isLastPage, transactions: events);

      return ApiResponse<TransactionResponse>(model: txnResponse, code: 200);
    } catch (e) {
      _logger.e(e.toString());
      return ApiResponse.withError("Unable to fetch transactions", 400);
    }
  }

  Future<String> _getBearerToken() async {
    String token = await _userService.firebaseUser.getIdToken();
    _logger.d(token);
    return token;
  }
}

class TransactionResponse {
  final List<UserTransaction> transactions;
  final bool isLastPage;

  TransactionResponse({this.isLastPage, this.transactions});
}
