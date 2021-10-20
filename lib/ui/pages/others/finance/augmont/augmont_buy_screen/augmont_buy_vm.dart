import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/aug_gold_rates_model.dart';
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
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/ui/widgets/fello_dialog/fello_dialog.dart';
import 'package:felloapp/ui/widgets/fello_dialog/fello_info_dialog.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/fcm_topics.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class AugmontGoldBuyViewModel extends BaseModel {
  static const int STATUS_UNAVAILABLE = 0;
  static const int STATUS_REGISTER = 1;
  static const int STATUS_OPEN = 2;
  final Log log = new Log("AugmontBuy");
  BaseUtil _baseUtil = locator<BaseUtil>();
  DBModel _dbModel = locator<DBModel>();
  AugmontModel _augmontModel = locator<AugmontModel>();
  FcmListener _fcmListener = locator<FcmListener>();
  UserService _userService = locator<UserService>();
  TransactionService _txnService = locator<TransactionService>();
  bool isGoldRateFetching = false;
  AugmontRates goldRates;
  bool isGoldBuyInProgress = false;
  double goldBuyAmount = 0;
  double goldAmountInGrams = 0.0;
  TextEditingController goldAmountController;
  List<double> chipAmountList = [100, 500, 1000, 5000];

  double get goldBuyPrice => goldRates != null ? goldRates.goldBuyPrice : 0.0;

  init() {
    goldAmountController = TextEditingController();
    fetchGoldRates();
  }

  Widget amoutChip(double amt) {
    return GestureDetector(
      onTap: () {
        goldBuyAmount += amt;
        goldAmountController.text = goldBuyAmount.toString();
        updateGoldAmount();
        notifyListeners();
      },
      child: Container(
        width: SizeConfig.screenWidth * 0.229,
        height: SizeConfig.screenWidth * 0.103,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SizeConfig.roundness12),
          color: amt.toInt() == 1000
              ? UiConstants.tertiarySolid
              : UiConstants.tertiaryLight,
        ),
        alignment: Alignment.center,
        child: Text(
          "+ ₹ ${amt.toInt()}",
          style: TextStyles.body3.bold.colour(
            amt.toInt() == 1000 ? Colors.white : UiConstants.tertiarySolid,
          ),
        ),
      ),
    );
  }

  updateGoldAmount() {
    if (goldBuyPrice != 0.0)
      goldAmountInGrams =
          double.tryParse(goldAmountController.text) / goldBuyPrice;
    else
      goldAmountInGrams = 0.0;
    refresh();
  }

  fetchGoldRates() async {
    isGoldRateFetching = true;
    refresh();
    goldRates = await _augmontModel.getRates();
    if (goldRates == null)
      BaseUtil.showNegativeAlert(
        'Portal unavailable',
        'The current rates couldn\'t be loaded. Please try again',
      );
    isGoldRateFetching = false;

    refresh();
  }

  initiateBuy() async {
    // if (await BaseUtil.showNoInternetAlert()) return;
    // if (checkAugmontStatus() == STATUS_OPEN) {
    //   if (goldAmountController.text.trim().isEmpty)
    //     return BaseUtil.showNegativeAlert(
    //         "No Amount Entered", "Please enter some amount");
    // }

    // isGoldBuyInProgress = true;
    // notifyListeners();
    // Haptic.vibrate();
    // _onDepositClicked();
    showSuccessGoldBuyDialog();
  }

  String getActionButtonText() {
    int _status = checkAugmontStatus();
    if (_status == STATUS_UNAVAILABLE)
      return 'UNAVAILABLE';
    else if (_status == STATUS_REGISTER)
      return 'REGISTER';
    else
      return 'BUY';
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
      BaseUtil.openDialog(
          content: AugmontDisabled(),
          addToScreenStack: true,
          isBarrierDismissable: true);

      return true;
    } else if (_status == STATUS_REGISTER) {
      BaseUtil.openModalBottomSheet(
          addToScreenStack: true,
          content: AugmontRegisterModalSheet(),
          isBarrierDismissable: false);
      isGoldBuyInProgress = false;
      notifyListeners();

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
        await _augmontModel.initiateGoldPurchase(_baseUtil.augmontGoldRates,
            double.tryParse(goldAmountController.text));

        await _augmontModel
            .setAugmontTxnProcessListener(_onDepositTransactionComplete);
        // BaseUtil.openModalBottomSheet(
        //     isBarrierDismissable: false,
        //     content: AugmontDepositModalSheet(
        //       key: _modalKey2,
        //       onDepositConfirmed: (double amount) {
        //         _augmontModel.initiateGoldPurchase(
        //             _baseUtil.augmontGoldRates, amount);
        //         _augmontModel.setAugmontTxnProcessListener(
        //             _onDepositTransactionComplete);
        //       },
        //       currentRates: _baseUtil.augmontGoldRates,
        //     ),
        //     addToScreenStack: true);
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
        onDepositComplete(true);
        _augmontModel.completeTransaction();
        _baseUtil.refreshAugmontBalance();
        return true;
      }
    } else if (txn.tranStatus == UserTransaction.TRAN_STATUS_CANCELLED) {
      //razorpay payment failed
      log.debug('Payment cancelled');
      if (_baseUtil.currentAugmontTxn != null) {
        onDepositComplete(false);
        _augmontModel.completeTransaction();
      }
    } else if (txn.tranStatus == UserTransaction.TRAN_STATUS_PENDING) {
      //razorpay completed but augmont purchase didnt go through
      log.debug('Payment pending');
      if (_baseUtil.currentAugmontTxn != null) {
        onDepositComplete(false);
        _augmontModel.completeTransaction();
      }
    }
  }

  onDepositComplete(bool flag) {
    // _isDepositInProgress = false;
    // setState(() {});
    isGoldBuyInProgress = false;
    notifyListeners();
    if (flag) {
      // BaseUtil.showPositiveAlert(
      //     'SUCCESS', 'You gold deposit was confirmed!', context);
      Haptic.vibrate();

      BaseUtil.openDialog(
          addToScreenStack: true,
          content: SuccessDialog(),
          isBarrierDismissable: false);
    } else {
      AppState.backButtonDispatcher.didPopRoute();
      BaseUtil.showNegativeAlert('Failed',
          'Your gold deposit failed. Please try again or contact us if you are facing issues',
          seconds: 5);
    }
  }

  showSuccessGoldBuyDialog() {
    BaseUtil.openDialog(
      addToScreenStack: true,
      hapticVibrate: true,
      isBarrierDismissable: false,
      content: FelloInfoDialog(
        asset: Assets.goldenTicket,
        title: "Congratulations",
        subtitle:
            "You have successfully saved Rs.100 and earned 10 tickets! here is a golden ticket!",
        action: Container(
          width: SizeConfig.screenWidth,
          child: FelloButtonLg(
            child: Text(
              "Next",
              style: TextStyles.body3.colour(Colors.white),
            ),
            color: UiConstants.primaryColor,
            onPressed: AppState.backButtonDispatcher.didPopRoute,
          ),
        ),
      ),
    );
  }
}
