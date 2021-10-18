import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/fcm/fcm_listener_service.dart';
import 'package:felloapp/core/service/transaction_service.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/dialogs/augmont_disabled_dialog.dart';
import 'package:felloapp/ui/dialogs/success-dialog.dart';
import 'package:felloapp/ui/modals_sheets/augmont_deposit_modal_sheet.dart';
import 'package:felloapp/ui/modals_sheets/augmont_register_modal_sheet.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/fcm_topics.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/material.dart';

class BuyGoldBtnVM extends BaseModel {
  static const int STATUS_UNAVAILABLE = 0;
  static const int STATUS_REGISTER = 1;
  static const int STATUS_OPEN = 2;
  final Log log = new Log("AugmontService");
  GlobalKey<AugmontDepositModalSheetState> _modalKey2 = GlobalKey();
  BuildContext augContext;
  BaseUtil _baseUtil = locator<BaseUtil>();
  DBModel _dbModel = locator<DBModel>();
  AugmontModel _augmontModel = locator<AugmontModel>();
  FcmListener _fcmListener = locator<FcmListener>();
  UserService _userService = locator<UserService>();
  TransactionService _txnService = locator<TransactionService>();
  String getActionButtonText() {
    int _status = checkAugmontStatus();
    if (_status == STATUS_UNAVAILABLE)
      return 'UNAVAILABLE';
    else if (_status == STATUS_REGISTER)
      return 'REGISTER';
    else
      return 'SAVE';
  }

  buyButtonAction() async {
    if (await BaseUtil.showNoInternetAlert()) return;
    Haptic.vibrate();
    _baseUtil.isAugDepositRouteLogicInProgress = true;
    _onDepositClicked().then((value) {});
  }

  int checkAugmontStatus() {
    //check who is allowed to deposit
    String _perm = BaseRemoteConfig.remoteConfig
        .getString(BaseRemoteConfig.AUGMONT_DEPOSIT_PERMISSION);
    int _isGeneralUserAllowed = 1;
    bool _isAllowed = false;
    if (_perm != null && _perm.isNotEmpty) {
      try {
        _isGeneralUserAllowed = int.parse(_perm);
      } catch (e) {
        _isGeneralUserAllowed = 1;
      }
    }
    if (_isGeneralUserAllowed == 0) {
      //General permission is denied. Check if specific user permission granted
      if (_baseUtil.myUser.isAugmontEnabled != null &&
          _baseUtil.myUser.isAugmontEnabled) {
        //this specific user is allowed to use Augmont
        _isAllowed = true;
      } else {
        _isAllowed = false;
      }
    } else {
      _isAllowed = true;
    }

    if (!_isAllowed)
      return STATUS_UNAVAILABLE;
    else if (_baseUtil.myUser.isAugmontOnboarded == null ||
        _baseUtil.myUser.isAugmontOnboarded == false)
      return STATUS_REGISTER;
    else
      return STATUS_OPEN;
  }

  Future<bool> _onDepositClicked() async {
    setState(ViewState.Busy);
    _baseUtil.augmontDetail = (_baseUtil.augmontDetail == null)
        ? (await _dbModel.getUserAugmontDetails(_baseUtil.myUser.uid))
        : _baseUtil.augmontDetail;
    int _status = checkAugmontStatus();
    if (_status == STATUS_UNAVAILABLE) {
      _baseUtil.isAugDepositRouteLogicInProgress = false;
      setState(ViewState.Idle);
      AppState.screenStack.add(ScreenItem.dialog);
      showDialog(
          context: augContext,
          builder: (BuildContext context) => AugmontDisabled());
      return true;
    } else if (_status == STATUS_REGISTER) {
      BaseUtil.openModalBottomSheet(
          addToScreenStack: true,
          content: AugmontRegisterModalSheet(),
          isBarrierDismissable: false);
      // showModalBottomSheet(
      //     isDismissible: false,
      //     // backgroundColor: Colors.transparent,
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(16),
      //     ),
      //     context: augContext,
      //     isScrollControlled: true,
      //     builder: (context) {
      //       return AugmontRegisterModalSheet();
      //     });

      _baseUtil.isAugDepositRouteLogicInProgress = false;
      setState(ViewState.Idle);

      return true;
    } else {
      _baseUtil.augmontGoldRates =
          await _augmontModel.getRates(); //refresh rates
      _baseUtil.isAugDepositRouteLogicInProgress = false;
      setState(ViewState.Idle);

      if (_baseUtil.augmontGoldRates == null) {
        BaseUtil.showNegativeAlert(
          'Portal unavailable',
          'The current rates couldn\'t be loaded. Please try again',
        );
        return false;
      } else {
        BaseUtil.openModalBottomSheet(
            isBarrierDismissable: false,
            content: AugmontDepositModalSheet(
              key: _modalKey2,
              onDepositConfirmed: (double amount) {
                _augmontModel.initiateGoldPurchase(
                    _baseUtil.augmontGoldRates, amount);
                _augmontModel.setAugmontTxnProcessListener(
                    _onDepositTransactionComplete);
              },
              currentRates: _baseUtil.augmontGoldRates,
            ),
            addToScreenStack: true);
        // showModalBottomSheet(
        //     isDismissible: false,
        //     // backgroundColor: Colors.transparent,
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(16),
        //     ),
        //     context: augContext,
        //     isScrollControlled: true,
        //     builder: (context) {
        //       return;
        //     });
      }
    }
    return true;
  }

  Future<void> _onDepositTransactionComplete(UserTransaction txn) async {
    if (txn.tranStatus == UserTransaction.TRAN_STATUS_COMPLETE) {
      if (_baseUtil.currentAugmontTxn != null) {
        ///update user wallet object account balance
        double _tempCurrentBalance = _baseUtil.userFundWallet.augGoldBalance;
        //baseutil side [TO BE DELETED]
        _baseUtil.userFundWallet = await _dbModel.updateUserAugmontGoldBalance(
            _baseUtil.myUser.uid,
            _baseUtil.userFundWallet,
            _baseUtil.augmontGoldRates.goldSellPrice,
            _baseUtil
                .currentAugmontTxn.augmnt[UserTransaction.subFldAugTotalGoldGm],
            _baseUtil.currentAugmontTxn.amount);
        //userService side
        _userService.userFundWallet =
            await _dbModel.updateUserAugmontGoldBalance(
                _baseUtil.myUser.uid,
                _baseUtil.userFundWallet,
                _baseUtil.augmontGoldRates.goldSellPrice,
                _baseUtil.currentAugmontTxn
                    .augmnt[UserTransaction.subFldAugTotalGoldGm],
                _baseUtil.currentAugmontTxn.amount);

        ///check if balance updated correctly
        if (_baseUtil.userFundWallet.augGoldBalance == _tempCurrentBalance) {
          //wallet balance was not updated. Transaction update failed
          Map<String, dynamic> _data = {
            'txn_id': _baseUtil.currentAugmontTxn.docKey,
            'aug_tran_id': _baseUtil
                .currentAugmontTxn.augmnt[UserTransaction.subFldAugTranId],
            'note':
                'Transaction completed, but found inconsistency while updating balance'
          };
          await _dbModel.logFailure(_baseUtil.myUser.uid,
              FailType.UserAugmontDepositUpdateDiscrepancy, _data);
        }

        ///update user ticket count
        ///tickets will be updated based on total amount spent
        int _ticketUpdateCount = _baseUtil
            .getTicketCountForTransaction(_baseUtil.currentAugmontTxn.amount);
        if (_ticketUpdateCount > 0) {
          int _tempCurrentCount = _baseUtil.userTicketWallet.augGold99Tck;
          //baseutil side [TO BE DELETED]
          _baseUtil.userTicketWallet =
              await _dbModel.updateAugmontGoldUserTicketCount(
                  _baseUtil.myUser.uid,
                  _baseUtil.userTicketWallet,
                  _ticketUpdateCount);
          //userService side
          // _userService.userTicketWallet =
          //     await _dbModel.updateAugmontGoldUserTicketCount(
          //         _baseUtil.myUser.uid,
          //         _baseUtil.userTicketWallet,
          //         _ticketUpdateCount);

          ///check if ticket count updated correctly
          if (_baseUtil.userTicketWallet.augGold99Tck == _tempCurrentCount) {
            //ticket count did not update
            Map<String, dynamic> _data = {
              'txn_id': _baseUtil.currentAugmontTxn.docKey,
              'aug_tran_id': _baseUtil
                  .currentAugmontTxn.augmnt[UserTransaction.subFldAugTranId],
              'note':
                  'Transaction completed, but found inconsistency while updating tickets'
            };
            await _dbModel.logFailure(_baseUtil.myUser.uid,
                FailType.UserAugmontDepositUpdateDiscrepancy, _data);
          }
        }

        ///update user transaction
        ///update augmont transaction closing balance and ticketupcount
        ///closing balance will be based on taxed amount
        _baseUtil.currentAugmontTxn.ticketUpCount = _ticketUpdateCount;
        _baseUtil.currentAugmontTxn.closingBalance =
            _baseUtil.getCurrentTotalClosingBalance();
        await _dbModel.updateUserTransaction(
            _baseUtil.myUser.uid, _baseUtil.currentAugmontTxn);

        ///if this was the user's first investment
        ///- update AugmontDetail obj
        ///- add notification subscription
        if (!_baseUtil.augmontDetail.firstInvMade) {
          _baseUtil.augmontDetail.firstInvMade = true;
          bool _aflag = await _dbModel.updateUserAugmontDetails(
              _baseUtil.myUser.uid, _baseUtil.augmontDetail);
          if (_aflag) {
            _fcmListener.removeSubscription(FcmTopic.MISSEDCONNECTION);
            _fcmListener.addSubscription(FcmTopic.GOLDINVESTOR);
          }
        }

        ///check if referral bonuses need to be unlocked
        if (_baseUtil.userFundWallet.augGoldPrinciple >=
            BaseRemoteConfig.UNLOCK_REFERRAL_AMT) {
          bool _isUnlocked =
              await _dbModel.unlockReferralTickets(_baseUtil.myUser.uid);
          if (_isUnlocked) {
            //give it a few seconds before showing congratulatory message
            Timer(const Duration(seconds: 4), () {
              BaseUtil.showPositiveAlert(
                'Congratulations are in order!',
                'Your referral bonus has been unlocked 🎉',
              );
            });
          }
        }

        ///update UI
        _modalKey2.currentState.onDepositComplete(true);
        _augmontModel.completeTransaction();
        _baseUtil.refreshAugmontBalance();
        return true;
      }
    } else if (txn.tranStatus == UserTransaction.TRAN_STATUS_CANCELLED) {
      //razorpay payment failed
      log.debug('Payment cancelled');
      if (_baseUtil.currentAugmontTxn != null) {
        _modalKey2.currentState.onDepositComplete(false);
        _augmontModel.completeTransaction();
      }
    } else if (txn.tranStatus == UserTransaction.TRAN_STATUS_PENDING) {
      //razorpay completed but augmont purchase didnt go through
      log.debug('Payment pending');
      if (_baseUtil.currentAugmontTxn != null) {
        _modalKey2.currentState.onDepositComplete(false);
        _augmontModel.completeTransaction();
      }
    }
  }

  onDepositComplete(bool flag) {
    // _isDepositInProgress = false;
    // setState(() {});

    if (flag) {
      // BaseUtil.showPositiveAlert(
      //     'SUCCESS', 'You gold deposit was confirmed!', context);
      AppState.screenStack.add(ScreenItem.dialog);
      Haptic.vibrate();
      showDialog(
        context: augContext,
        barrierDismissible: false,
        builder: (BuildContext context) => SuccessDialog(),
      );
    } else {
      AppState.backButtonDispatcher.didPopRoute();
      BaseUtil.showNegativeAlert('Failed',
          'Your gold deposit failed. Please try again or contact us if you are facing issues',
          seconds: 5);
    }
  }
}
