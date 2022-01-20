import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/aug_gold_rates_model.dart';
import 'package:felloapp/core/model/golden_ticket_model.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/cache_manager.dart';
import 'package:felloapp/core/service/fcm/fcm_listener_service.dart';
import 'package:felloapp/core/service/golden_ticket_service.dart';
import 'package:felloapp/core/service/transaction_service.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/dialogs/augmont_disabled_dialog.dart';
import 'package:felloapp/ui/modals_sheets/augmont_register_modal_sheet.dart';
import 'package:felloapp/ui/widgets/fello_dialog/fello_confirm_dialog.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/fcm_topics.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class AugmontGoldBuyViewModel extends BaseModel {
  static const int STATUS_UNAVAILABLE = 0;
  static const int STATUS_REGISTER = 1;
  static const int STATUS_OPEN = 2;
  final _logger = locator<CustomLogger>();
  BaseUtil _baseUtil = locator<BaseUtil>();
  DBModel _dbModel = locator<DBModel>();
  AugmontModel _augmontModel = locator<AugmontModel>();
  FcmListener _fcmListener = locator<FcmListener>();
  UserService _userService = locator<UserService>();
  TransactionService _txnService = locator<TransactionService>();
  GoldenTicketService _gtService = GoldenTicketService();

  int _status = 0;

  bool _showMaxCapText = false;
  bool isGoldRateFetching = false;
  AugmontRates goldRates;
  bool _isGoldBuyInProgress = false;
  String userAugmontState;
  FocusNode buyFieldNode = FocusNode();
  bool _augOnbRegInProgress = false;
  bool _augRegFailed = false;
  String buyNotice;

  double goldBuyAmount = 0;
  double goldAmountInGrams = 0.0;
  TextEditingController goldAmountController;
  List<double> chipAmountList = [100, 500, 1000, 5000];

  double get goldBuyPrice => goldRates != null ? goldRates.goldBuyPrice : 0.0;

  get isGoldBuyInProgress => this._isGoldBuyInProgress;

  set isGoldBuyInProgress(value) {
    this._isGoldBuyInProgress = value;
    notifyListeners();
  }

  get augOnbRegInProgress => this._augOnbRegInProgress;

  set augOnbRegInProgress(value) {
    this._augOnbRegInProgress = value;
    notifyListeners();
  }

  get augRegFailed => this._augRegFailed;

  set augRegFailed(value) {
    this._augRegFailed = value;
    notifyListeners();
  }

  get status => this._status;

  set status(value) {
    this._status = value;
    notifyListeners();
  }

  get showMaxCapText => this._showMaxCapText;

  set showMaxCapText(value) {
    this._showMaxCapText = value;
    notifyListeners();
  }

  init() async {
    setState(ViewState.Busy);
    goldAmountController = TextEditingController();
    fetchGoldRates();
    await fetchNotices();
    status = checkAugmontStatus();

    //Check if user is registered on augmont
    if (status == STATUS_REGISTER) {
      _onboardUser();
    }
    if (_baseUtil.augmontDetail == null) {
      _baseUtil.augmontDetail =
          await _dbModel.getUserAugmontDetails(_baseUtil.myUser.uid);
    }
    // Check if deposit is locked the this particular user
    if (_baseUtil.augmontDetail != null &&
        _baseUtil.augmontDetail.depNotice != null &&
        _baseUtil.augmontDetail.depNotice.isNotEmpty)
      buyNotice = _baseUtil.augmontDetail.depNotice;

    setState(ViewState.Idle);
  }

  fetchNotices() async {
    buyNotice = await _dbModel.showAugmontBuyNotice();
  }

// UI ESSENTIALS

  Widget amoutChip(double amt) {
    return GestureDetector(
      onTap: () {
        buyFieldNode.unfocus();
        if (goldBuyAmount == null)
          goldBuyAmount = amt;
        else {
          if (goldBuyAmount + amt <= 50000)
            goldBuyAmount += amt;
          else
            goldBuyAmount = 50000;
        }

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
    if (goldAmountController.text == null ||
        goldAmountController.text.isEmpty ||
        double.tryParse(goldAmountController.text) == null) {
      goldAmountInGrams = 0.0;
    } else {
      double netTax = goldRates.cgstPercent + goldRates.sgstPercent;
      double enteredAmount = double.tryParse(goldAmountController.text);
      double postTaxAmount = BaseUtil.digitPrecision(
          enteredAmount - getTaxOnAmount(enteredAmount, netTax));

      if (goldBuyPrice != null && goldBuyPrice != 0.0)
        goldAmountInGrams =
            BaseUtil.digitPrecision(postTaxAmount / goldBuyPrice, 4, false);
      else
        goldAmountInGrams = 0.0;
    }
    refresh();
  }

  double getTaxOnAmount(double amount, double taxRate) {
    return BaseUtil.digitPrecision((amount * taxRate) / (100 + taxRate));
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

  // BUY LOGIC

  initiateBuy() async {
    // if (_status == 1) {
    //   bool res = await _onboardUser();
    //   if (!res) await _checkRegistrationStatus();
    //   status = checkAugmontStatus();
    //   return;
    // }
    double buyAmount = double.tryParse(goldAmountController.text);
    if (goldRates == null) {
      BaseUtil.showNegativeAlert(
        'Gold Rates Unavailable',
        'Please try again in sometime',
      );
      return;
    }
    if (buyAmount == null) {
      BaseUtil.showNegativeAlert(
        'No amount entered',
        'Please enter an amount',
      );
      return;
    }
    if (buyAmount < 10) {
      BaseUtil.showNegativeAlert(
        'Minimum amount should be ₹ 10',
        'Please enter a minimum purchase amount of ₹ 10',
      );
      return;
    }

    if (_baseUtil.augmontDetail == null) {
      BaseUtil.showNegativeAlert(
        'Deposit Failed',
        'Please try again in sometime or contact us',
      );
      return;
    }

    if (_baseUtil.augmontDetail.isDepLocked) {
      BaseUtil.showNegativeAlert(
        'Purchase Failed',
        "${buyNotice ?? 'Gold buying is currently on hold. Please try again after sometime.'}",
      );
      return;
    }

    bool _disabled = await _dbModel.isAugmontBuyDisabled();
    if (_disabled != null && _disabled) {
      BaseUtil.showNegativeAlert(
        'Purchase Failed',
        'Gold buying is currently on hold. Please try again after sometime.',
      );
      return;
    }
    isGoldBuyInProgress = true;
    _augmontModel.initiateGoldPurchase(goldRates, buyAmount).then((txn) {
      if (txn == null) {
        isGoldBuyInProgress = false;
        BaseUtil.showNegativeAlert(
          'Transaction failed',
          'Please try again in sometime or contact us for further assistance.',
        );
      }
    });
    _augmontModel.setAugmontTxnProcessListener(_onDepositTransactionComplete);
  }

  onBuyValueChanged(String val) {
    _logger.d("Value: $val");
    if (showMaxCapText) showMaxCapText = false;
    if (val != null && val.isNotEmpty) {
      if (double.tryParse(val.trim()) != null &&
          double.tryParse(val.trim()) > 50000) {
        goldBuyAmount = 50000;
        goldAmountController.text = goldBuyAmount.toString();
        updateGoldAmount();
        showMaxCapText = true;
        buyFieldNode.unfocus();
      } else {
        goldBuyAmount = double.tryParse(val);
        updateGoldAmount();
      }
    } else {
      goldBuyAmount = 0;
      updateGoldAmount();
    }
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

  Future _onboardUser() async {
    augOnbRegInProgress = true;
    userAugmontState = await CacheManager.readCache(key: "UserAugmontState");
    if (userAugmontState == null) {
      return Future.delayed(Duration.zero, () {
        BaseUtil.openModalBottomSheet(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(SizeConfig.roundness24),
              topRight: Radius.circular(SizeConfig.roundness24),
            ),
            addToScreenStack: false,
            content: AugmontRegisterModalSheet(
              onSuccessfulAugReg: (val) {
                if (val) {
                  augOnbRegInProgress = false;
                  status = checkAugmontStatus();
                }
              },
            ),
            isBarrierDismissable: false);
      });
    } else {
      _baseUtil.augmontDetail = await _augmontModel.createSimpleUser(
          _userService.baseUser.mobile, userAugmontState);
      if (_baseUtil.augmontDetail == null) {
        BaseUtil.showNegativeAlert('Registration Failed',
            'Failed to register for digital gold. Please check your connection and reopen.');
        augOnbRegInProgress = false;
        augRegFailed = true;
        return;
      } else {
        augOnbRegInProgress = false;
        status = checkAugmontStatus();
        // BaseUtil.showPositiveAlert('Registration Successful',
        //     'You are successfully onboarded to Augmont Digital Gold');
      }
    }
    isGoldBuyInProgress = false;
    setState(ViewState.Idle);
    return true;
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
      }
    }
    return true;
  }

  Future<void> _onDepositTransactionComplete(UserTransaction txn) async {
    if (txn.tranStatus == UserTransaction.TRAN_STATUS_COMPLETE) {
      if (_baseUtil.currentAugmontTxn != null) {
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
        // if (_userService.userFundWallet.augGoldPrinciple >=
        //     BaseUtil.toInt(BaseRemoteConfig.remoteConfig
        //         .getString(BaseRemoteConfig.UNLOCK_REFERRAL_AMT))) {
        //   bool _isUnlocked =
        //       await _dbModel.unlockReferralTickets(_baseUtil.myUser.uid);
        //   // if (_isUnlocked) {
        // }

        ///update UI
        onDepositComplete(true);
        _augmontModel.completeTransaction();
        return true;
      }
    } else if (txn.tranStatus == UserTransaction.TRAN_STATUS_CANCELLED) {
      //razorpay payment failed
      _logger.d('Payment cancelled');
      if (_baseUtil.currentAugmontTxn != null) {
        onDepositComplete(false);
        _augmontModel.completeTransaction();
      }
    } else if (txn.tranStatus == UserTransaction.TRAN_STATUS_PENDING) {
      //razorpay completed but augmont purchase didnt go through
      _logger.d('Payment pending');
      if (_baseUtil.currentAugmontTxn != null) {
        onDepositComplete(false);
        _augmontModel.completeTransaction();
      }
    }
  }

  onDepositComplete(bool flag) async {
    bool gtFlag = await _gtService.fetchAndVerifyGoldenTicketByID();
    isGoldBuyInProgress = false;
    if (flag) {
      if (gtFlag)
        _gtService.showInstantGoldenTicketView();
      else
        showSuccessGoldBuyDialog();
    } else {
      AppState.backButtonDispatcher.didPopRoute();
    }
  }

  getAmount(double amount) {
    if (amount > amount.toInt())
      return amount;
    else
      return amount.toInt();
  }

  showSuccessGoldBuyDialog() {
    BaseUtil.openDialog(
      addToScreenStack: true,
      hapticVibrate: true,
      isBarrierDismissable: false,
      content: FelloConfirmationDialog(
        asset: Assets.goldenTicket,
        title: "Congratulations",
        subtitle:
            "You have successfully saved ₹ ${getAmount(_baseUtil.currentAugmontTxn.amount)} and earned ${_baseUtil.currentAugmontTxn.amount.ceil()} tokens!",
        result: (res) {
          // if (res) ;
        },
        accept: "Invest more",
        reject: "Start Playing",
        acceptColor: UiConstants.primaryColor,
        rejectColor: UiConstants.tertiarySolid,
        onReject: () {
          AppState.backButtonDispatcher.didPopRoute();
          AppState.backButtonDispatcher.didPopRoute();
          AppState.delegate.appState.setCurrentTabIndex = 1;
          // _gtService.showGoldenTicketAvailableDialog();
        },
        onAccept: () {
          AppState.backButtonDispatcher.didPopRoute();
          // _gtService.showGoldenTicketAvailableDialog();
        },
      ),
    );
  }
}
