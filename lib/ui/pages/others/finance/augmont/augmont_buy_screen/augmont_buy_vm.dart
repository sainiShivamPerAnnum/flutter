import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/aug_gold_rates_model.dart';
import 'package:felloapp/core/model/coupon_card_model.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/analytics/analytics_events.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/cache_manager.dart';
import 'package:felloapp/core/service/fcm/fcm_listener_service.dart';
import 'package:felloapp/core/service/golden_ticket_service.dart';
import 'package:felloapp/core/service/transaction_service.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/modals_sheets/augmont_coupons_modal.dart';
import 'package:felloapp/ui/modals_sheets/augmont_register_modal_sheet.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_scratch_dialog/gt_instant_view.dart';
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
import 'package:url_launcher/url_launcher.dart';

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
  final _analyticsService = locator<AnalyticsService>();

  int _status = 0;
  int lastTappedChipIndex = 1;
  CouponModel _appliedCoupon, _focusCoupon;

  bool _showMaxCapText = false;
  bool _isGoldRateFetching = false;
  bool _isGoldBuyInProgress = false;
  bool _showCoupons = false;
  AugmontRates goldRates;
  String userAugmontState;
  FocusNode buyFieldNode;
  bool _augOnbRegInProgress = false;
  bool _augRegFailed = false;
  String buyNotice;

  double goldBuyAmount = 0;
  double goldAmountInGrams = 0.0;
  TextEditingController goldAmountController;
  List<double> chipAmountList = [101, 201, 501, 1001];
  List<CouponModel> _couponList;

  List<CouponModel> get couponList => _couponList;

  set couponList(List<CouponModel> list) {
    _couponList = list;
    notifyListeners();
  }

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

  get isGoldRateFetching => this._isGoldRateFetching;

  set isGoldRateFetching(value) {
    this._isGoldRateFetching = value;

    notifyListeners();
  }

  CouponModel get appliedCoupon => this._appliedCoupon;

  set appliedCoupon(CouponModel value) {
    this._appliedCoupon = value;
    _logger.d(_appliedCoupon.toString());
    notifyListeners();
  }

  CouponModel get focusCoupon => this._focusCoupon;

  set focusCoupon(CouponModel coupon) {
    _focusCoupon = coupon;
    notifyListeners();
  }

  bool get showCoupons => _showCoupons;

  set showCoupons(bool val) {
    _showCoupons = val;
    notifyListeners();
  }

  init() async {
    setState(ViewState.Busy);
    buyFieldNode = _userService.buyFieldFocusNode;
    goldBuyAmount = chipAmountList[1];
    goldAmountController =
        TextEditingController(text: chipAmountList[1].toInt().toString());
    fetchGoldRates();
    await fetchNotices();
    status = checkAugmontStatus();
    //Fetch available coupons
    getAvailableCoupons();
    //Check if user can be registered automagically
    userAugmontState = await CacheManager.readCache(key: "UserAugmontState");
    if (status == STATUS_REGISTER && userAugmontState != null) {
      _onboardUserAutomatically(userAugmontState);
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

  resetBuyOptions() {
    goldBuyAmount = chipAmountList[1];
    goldAmountController.text = chipAmountList[1].toInt().toString();
    appliedCoupon = null;
    lastTappedChipIndex = 1;
    notifyListeners();
  }

// UI ESSENTIALS

  Widget amoutChip(int index) {
    double amt = chipAmountList[index];
    return GestureDetector(
      onTap: () {
        Haptic.vibrate();
        lastTappedChipIndex = index;
        buyFieldNode.unfocus();
        //if (goldBuyAmount == null)
        goldBuyAmount = amt;
        // else {
        //   if (goldBuyAmount + amt <= 50000)
        //     goldBuyAmount += amt;
        //   else
        //     goldBuyAmount = 50000;
        // }
        checkIfCouponIsStillApplicable();
        goldAmountController.text = goldBuyAmount.toInt().toString();
        updateGoldAmount();
        notifyListeners();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: SizeConfig.padding8, horizontal: SizeConfig.padding12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SizeConfig.roundness12),
          color: lastTappedChipIndex == index
              ? UiConstants.primaryColor
              : UiConstants.primaryLight.withOpacity(0.5),
        ),
        alignment: Alignment.center,
        child: Text(
          " ₹ ${amt.toInt()} ",
          style: TextStyles.body3.bold.colour(
            lastTappedChipIndex == index
                ? Colors.white
                : UiConstants.primaryColor,
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
    goldRates = await _augmontModel.getRates();
    updateGoldAmount();
    if (goldRates == null)
      BaseUtil.showNegativeAlert(
        'Portal unavailable',
        'The current rates couldn\'t be loaded. Please try again',
      );
    isGoldRateFetching = false;
  }

  // BUY LOGIC

  initiateBuy() async {
    //Check if user is registered on augmont
    if (status == STATUS_UNAVAILABLE) return;
    if (status == STATUS_REGISTER) {
      _onboardUserManually();
      return;
    }
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
    _analyticsService.track(eventName: AnalyticsEvents.buyGold);
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
        goldAmountController.text = goldBuyAmount.toInt().toString();
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
    checkIfCouponIsStillApplicable();
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

  Future _onboardUserAutomatically(String state) async {
    augOnbRegInProgress = true;
    _logger.d("Augmont Onboarding started automagically");
    _baseUtil.augmontDetail = await _augmontModel.createSimpleUser(
        _userService.baseUser.mobile, userAugmontState);
    if (_baseUtil.augmontDetail == null) {
      // BaseUtil.showNegativeAlert('Registration Failed',
      //     'Failed to register for digital gold. Please check your connection and try after some time.');
      augOnbRegInProgress = false;
      augRegFailed = true;
      return;
    } else {
      augOnbRegInProgress = false;
      status = checkAugmontStatus();
      augRegFailed = false;
      // BaseUtil.showPositiveAlert('Registration Successful',
      //     'You are successfully onboarded to Augmont Digital Gold');
    }
    _logger.d("Augmont Onboarding Completed");
    isGoldBuyInProgress = false;
    setState(ViewState.Idle);
    return true;
  }

  Future _onboardUserManually() async {
    // userAugmontState = await CacheManager.readCache(key: "UserAugmontState");
    // if (userAugmontState == null) {
    return Future.delayed(Duration.zero, () {
      BaseUtil.openModalBottomSheet(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(SizeConfig.roundness24),
            topRight: Radius.circular(SizeConfig.roundness24),
          ),
          addToScreenStack: true,
          content: AugmontRegisterModalSheet(
            onAugRegInit: (val) {
              augOnbRegInProgress = val;
            },
            onSuccessfulAugReg: (val) {
              if (val) {
                augOnbRegInProgress = false;
                status = checkAugmontStatus();
                isGoldBuyInProgress = false;
                augRegFailed = false;
                setState(ViewState.Idle);
              }
            },
          ),
          isBarrierDismissable: false);
    });
  }

  onboardUser() async {
    userAugmontState = await CacheManager.readCache(key: "UserAugmontState");
    if (userAugmontState != null)
      _onboardUserAutomatically(userAugmontState);
    else
      _onboardUserManually();
  }

  void showOfferModal(AugmontGoldBuyViewModel model) {
    BaseUtil.openModalBottomSheet(
      addToScreenStack: true,
      backgroundColor: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(SizeConfig.padding16),
        topRight: Radius.circular(SizeConfig.padding16),
      ),
      hapticVibrate: true,
      isBarrierDismissable: false,
      isScrollControlled: true,
      content: AugmontCouponsModalSheet(model: model),
    );
  }

  Future<void> _onDepositTransactionComplete(UserTransaction txn) async {
    resetBuyOptions();
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
        onDepositComplete(true, txn);
        _augmontModel.completeTransaction();
        return true;
      }
    } else if (txn.tranStatus == UserTransaction.TRAN_STATUS_CANCELLED) {
      //razorpay payment failed
      _logger.d('Payment cancelled');
      if (_baseUtil.currentAugmontTxn != null) {
        onDepositComplete(false, txn);
        _augmontModel.completeTransaction();
      }
    } else if (txn.tranStatus == UserTransaction.TRAN_STATUS_PENDING) {
      //razorpay completed but augmont purchase didnt go through
      _logger.d('Payment pending');
      if (_baseUtil.currentAugmontTxn != null) {
        onDepositComplete(false, txn);
        _augmontModel.completeTransaction();
      }
    }
  }

  onDepositComplete(bool flag, UserTransaction txn) async {
    bool gtFlag = await _gtService.fetchAndVerifyGoldenTicketByID();
    isGoldBuyInProgress = false;
    if (flag) {
      if (gtFlag)
        _gtService.showInstantGoldenTicketView(
            title: '₹${txn.amount.toStringAsFixed(0)} saved!',
            source: GTSOURCE.deposit);
      else
        showSuccessGoldBuyDialog(txn);
    }
  }

  getAmount(double amount) {
    if (amount > amount.toInt())
      return amount;
    else
      return amount.toInt();
  }

  showSuccessGoldBuyDialog(UserTransaction txn) {
    BaseUtil.openDialog(
      addToScreenStack: true,
      hapticVibrate: true,
      isBarrierDismissable: false,
      content: FelloConfirmationDialog(
        asset: Assets.goldenTicket,
        title: "Congratulations",
        subtitle:
            "You have successfully saved ₹ ${getAmount(txn.amount)} and earned ${txn.amount.ceil()} tokens!",
        result: (res) {
          // if (res) ;
        },
        accept: "Invest more",
        reject: "Start Playing",
        acceptColor: UiConstants.primaryColor,
        rejectColor: UiConstants.tertiarySolid,
        onReject: () {
          AppState.backButtonDispatcher.didPopRoute();
          AppState.delegate.appState.setCurrentTabIndex = 1;
        },
        onAccept: () {
          AppState.backButtonDispatcher.didPopRoute();
        },
      ),
    );
  }

// ----------------------------------------NAVIGATION--------------------------------------//

  navigateToGoldBalanceDetailsScreen() {
    AppState.delegate.appState.currentAction = PageAction(
        state: PageState.addPage, page: GoldBalanceDetailsViewPageConfig);
  }

  navigateToAboutGold() {
    AppState.delegate.appState.currentAction = PageAction(
        state: PageState.addPage, page: AugmontGoldDetailsPageConfig);
  }

  openAugmontWebUri() async {
    const url = "https://www.augmont.com/about-us";
    if (await canLaunch(url))
      await launch(url);
    else
      BaseUtil.showNegativeAlert(
          'Failed to launch URL', 'Please try again in sometime');
  }

//----------------------------------------------- COUPON LOGIC -------------------------------

  getAvailableCoupons() async {
    couponList = await _dbModel.getCoupons();
    if (couponList[0].priority == 1) focusCoupon = couponList[0];
    showCoupons = true;
  }

  applyCoupon(CouponModel coupon) {
    buyFieldNode.unfocus();
    if (goldBuyAmount < coupon.minPurchase.toDouble())
      goldBuyAmount = coupon.minPurchase.toDouble();

    goldAmountController.text = goldBuyAmount.toInt().toString();
    updateGoldAmount();
    notifyListeners();
    appliedCoupon = coupon;
    BaseUtil.showPositiveAlert("Coupon Applied Successfully",
        "You 3% gold will be credited to your wallet");
  }

  checkIfCouponIsStillApplicable() {
    if (appliedCoupon != null && goldBuyAmount < appliedCoupon.minPurchase)
      appliedCoupon = null;
  }
}
