import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:app_install_date/utils.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/enums/transaction_state_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/aug_gold_rates_model.dart';
import 'package:felloapp/core/model/coupon_card_model.dart';
import 'package:felloapp/core/model/eligible_coupon_model.dart';
import 'package:felloapp/core/model/paytm_models/deposit_fcm_response_model.dart';
import 'package:felloapp/core/model/paytm_models/txn_result_model.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/razorpay_ops.dart';
import 'package:felloapp/core/repository/coupons_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/cache_manager.dart';
import 'package:felloapp/core/service/notifier_services/golden_ticket_service.dart';
import 'package:felloapp/core/service/notifier_services/internal_ops_service.dart';
import 'package:felloapp/core/service/notifier_services/paytm_service.dart';
import 'package:felloapp/core/service/notifier_services/transaction_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/dialogs/confirm_action_dialog.dart';
import 'package:felloapp/ui/dialogs/default_dialog.dart';
import 'package:felloapp/ui/dialogs/negative_dialog.dart';
import 'package:felloapp/ui/modals_sheets/augmont_register_modal_sheet.dart';
import 'package:felloapp/ui/modals_sheets/coupon_modal_sheet.dart';
import 'package:felloapp/ui/modals_sheets/recharge_modal_sheet.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_buy_screen/augmont_buy_view.dart';
import 'package:felloapp/ui/pages/others/finance/augmont/augmont_buy_screen/upi_intent_view.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_scratch_dialog/gt_instant_view.dart';
import 'package:felloapp/ui/pages/static/txn_completed_ui/txn_completed_view.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/ui/widgets/fello_dialog/fello_confirm_dialog.dart';
import 'package:felloapp/ui/widgets/fello_dialog/fello_info_dialog.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:upi_pay/upi_pay.dart';
import 'package:url_launcher/url_launcher.dart';

class AugmontGoldBuyViewModel extends BaseModel {
  static const int STATUS_UNAVAILABLE = 0;
  static const int STATUS_REGISTER = 1;
  static const int STATUS_OPEN = 2;

  final _logger = locator<CustomLogger>();
  final BaseUtil _baseUtil = locator<BaseUtil>();
  final DBModel _dbModel = locator<DBModel>();
  final AugmontModel _augmontModel = locator<AugmontModel>();
  final UserService _userService = locator<UserService>();
  final _razorpayOpsModel = locator<RazorpayModel>();
  final TransactionService _txnService = locator<TransactionService>();

  final _analyticsService = locator<AnalyticsService>();
  final _couponRepo = locator<CouponRepository>();
  final _paytmService = locator<PaytmService>();
  double incomingAmount;
  List<ApplicationMeta> appMetaList = [];
  UpiApplication _upiApplication;

  int _status = 0;
  int lastTappedChipIndex = 1;
  CouponModel _focusCoupon;
  EligibleCouponResponseModel _appliedCoupon;
  bool _showMaxCapText = false;
  bool _showMinCapText = false;
  bool _isGoldRateFetching = false;
  bool _isGoldBuyInProgress = false;
  bool _skipMl = false;
  double _fieldWidth = 0.0;

  get fieldWidth => this._fieldWidth;

  set fieldWidth(value) {
    this._fieldWidth = value;
    notifyListeners();
  }

  // bool _isSubscriptionInProgress = false;
  bool _couponApplyInProgress = false;
  bool _showCoupons = false;
  bool _augmontSecondFetchDone = false;

  AugmontRates goldRates;
  String userAugmontState;
  FocusNode buyFieldNode = FocusNode();
  bool _augOnbRegInProgress = false;
  bool _augRegFailed = false;
  String buyNotice;

  double _goldBuyAmount = 0;
  double _goldAmountInGrams = 0.0;
  get goldBuyAmount => this._goldBuyAmount;

  set goldBuyAmount(value) {
    this._goldBuyAmount = value;
    notifyListeners();
  }

  get goldAmountInGrams => this._goldAmountInGrams;

  set goldAmountInGrams(value) {
    this._goldAmountInGrams = value;
    notifyListeners();
  }

  TextEditingController goldAmountController;
  TextEditingController vpaController;
  List<double> chipAmountList = [101, 201, 501, 1001];
  List<CouponModel> _couponList;

  bool get couponApplyInProgress => _couponApplyInProgress;

  set couponApplyInProgress(bool val) {
    _couponApplyInProgress = val;
    notifyListeners();
  }

  List<CouponModel> get couponList => _couponList;

  set couponList(List<CouponModel> list) {
    _couponList = list;
    notifyListeners();
  }

  double get goldBuyPrice => goldRates != null ? goldRates.goldBuyPrice : 0.0;

  get isGoldBuyInProgress => this._isGoldBuyInProgress;
  get augmontObjectSecondFetchDone => _augmontSecondFetchDone;

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

  set upiApplication(UpiApplication value) {
    this._upiApplication = value;
    notifyListeners();
  }

  get showMaxCapText => this._showMaxCapText;

  set showMaxCapText(value) {
    this._showMaxCapText = value;
    notifyListeners();
  }

  get showMinCapText => this._showMinCapText;

  set showMinCapText(value) {
    this._showMinCapText = value;
    notifyListeners();
  }

  get isGoldRateFetching => this._isGoldRateFetching;

  set isGoldRateFetching(value) {
    this._isGoldRateFetching = value;
    notifyListeners();
  }

  EligibleCouponResponseModel get appliedCoupon => this._appliedCoupon;

  set appliedCoupon(EligibleCouponResponseModel value) {
    this._appliedCoupon = value;
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

  bool get skipMl => this._skipMl;

  set skipMl(bool value) {
    this._skipMl = value;
  }

  init(int amount, bool isSkipMilestone) async {
    setState(ViewState.Busy);
    // buyFieldNode = _userService.buyFieldFocusNode;
    skipMl = isSkipMilestone;
    incomingAmount = amount?.toDouble() ?? 0;
    goldBuyAmount = amount.toDouble() ?? chipAmountList[1];
    goldAmountController = TextEditingController(
        text: amount.toString() ?? chipAmountList[1].toInt().toString());
    fieldWidth =
        (SizeConfig.padding40 * goldAmountController.text.length.toDouble());
    await getUPIApps();
    fetchGoldRates();
    await fetchNotices();
    status = checkAugmontStatus();
    _paytmService.getActiveSubscriptionDetails();
    //Fetch available coupons
    getAvailableCoupons();
    //Check if user can be registered automagically
    userAugmontState = await CacheManager.readCache(key: "UserAugmontState");
    if (status == STATUS_REGISTER && userAugmontState != null) {
      _onboardUserAutomatically(userAugmontState);
    }

    //NOTE: NEED TO DISCUSS WITH ARAB
    // if (!_userService.showOnboardingTutorial) {
    //   _augmontSecondFetchDone = true;
    // }

    if (_baseUtil.augmontDetail == null) {
      await _baseUtil.fetchUserAugmontDetail();
    }

    if (_baseUtil.augmontDetail == null && !_augmontSecondFetchDone)
      delayedAugmontCall();

    // Check if deposit is locked the this particular user
    if (_baseUtil.augmontDetail != null &&
        _baseUtil.augmontDetail.depNotice != null &&
        _baseUtil.augmontDetail.depNotice.isNotEmpty)
      buyNotice = _baseUtil.augmontDetail.depNotice;

    setState(ViewState.Idle);
  }

  initiateBuy(AugmontGoldBuyViewModel model) async {
    if (Platform.isAndroid) {
      //Android - RazorpayPG
      if (BaseRemoteConfig.remoteConfig
              .getString(BaseRemoteConfig.ACTIVE_PG_ANDROID) ==
          'RZP-PG') {
        initiateRzpGatewayTxn();
      }
      //Android - PaytmPG
      if (BaseRemoteConfig.remoteConfig
              .getString(BaseRemoteConfig.ACTIVE_PG_ANDROID) ==
          'PAYTM-PG') {
        initiatePaytmPgTxn();
      }
      //Android - Paytm(UPI Intent)
      if (BaseRemoteConfig.remoteConfig
              .getString(BaseRemoteConfig.ACTIVE_PG_ANDROID) ==
          'PAYTM') {
        bool isAllowed = await initChecks();
        if (isAllowed) {
          BaseUtil.openModalBottomSheet(
              addToScreenStack: true,
              backgroundColor: Colors.transparent,
              isBarrierDismissable: false,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(SizeConfig.roundness12),
                  topRight: Radius.circular(SizeConfig.roundness12)),
              content: UPIAppsBottomSheet(
                model: model,
              ));
        }
      }
    } else if (Platform.isIOS) {
      //iOS - RazorpayPG
      if (BaseRemoteConfig.remoteConfig
              .getString(BaseRemoteConfig.ACTIVE_PG_IOS) ==
          'RZP-PG') {
        initiateRzpGatewayTxn();
      }
      //iOS - PaytmPG
      if (BaseRemoteConfig.remoteConfig
              .getString(BaseRemoteConfig.ACTIVE_PG_IOS) ==
          'PAYTM-PG') {
        initiatePaytmPgTxn();
      }
      //iOS - Paytm(UPI Intent)
      if (BaseRemoteConfig.remoteConfig
              .getString(BaseRemoteConfig.ACTIVE_PG_IOS) ==
          'PAYTM') {
        bool isAllowed = await initChecks();
        if (isAllowed) {
          BaseUtil.openModalBottomSheet(
              addToScreenStack: true,
              backgroundColor: Colors.transparent,
              isBarrierDismissable: false,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(SizeConfig.roundness12),
                  topRight: Radius.circular(SizeConfig.roundness12)),
              content: UPIAppsBottomSheet(
                model: model,
              ));
        }
      }
    }
  }

  getUPIApps() async {
    List<ApplicationMeta> allUpiApps = await UpiPay.getInstalledUpiApplications(
        statusType: UpiApplicationDiscoveryAppStatusType.all);
    allUpiApps.forEach((element) {
      if (element.upiApplication.appName == "Paytm" &&
          BaseRemoteConfig.remoteConfig
              .getString(BaseRemoteConfig.ENABLED_PSP_APPS)
              .contains('P')) {
        appMetaList.add(element);
      }
      if (element.upiApplication.appName == "PhonePe" &&
          BaseRemoteConfig.remoteConfig
              .getString(BaseRemoteConfig.ENABLED_PSP_APPS)
              .contains('E')) {
        appMetaList.add(element);
      }
      if (element.upiApplication.appName == "Google Pay" &&
          BaseRemoteConfig.remoteConfig
              .getString(BaseRemoteConfig.ENABLED_PSP_APPS)
              .contains('G')) {
        appMetaList.add(element);
      }
    });
  }

  delayedAugmontCall() async {
    await Future.delayed(Duration(seconds: 2));
    await _baseUtil.fetchUserAugmontDetail();
    _augmontSecondFetchDone = true;
    notifyListeners();
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
        if (couponApplyInProgress || isGoldBuyInProgress) return;
        showMaxCapText = false;
        showMinCapText = false;
        Haptic.vibrate();
        lastTappedChipIndex = index;
        buyFieldNode.unfocus();
        goldBuyAmount = amt;
        goldAmountController.text = goldBuyAmount.toInt().toString();
        updateGoldAmount();
        //checkIfCouponIsStillApplicable();
        appliedCoupon = null;
        notifyListeners();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: SizeConfig.padding8, horizontal: SizeConfig.padding12),
        margin: EdgeInsets.symmetric(horizontal: SizeConfig.padding6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SizeConfig.roundness5),
          border: Border.all(
            color: lastTappedChipIndex == index
                ? Color(0xFFFEF5DC)
                : Color(0xFFFEF5DC).withOpacity(0.2),
            width: SizeConfig.border0,
          ),
          // color: lastTappedChipIndex == index
          //     ? UiConstants.primaryColor
          //     : UiConstants.primaryLight.withOpacity(0.5),
        ),
        alignment: Alignment.center,
        child: Text(
          "₹ ${amt.toInt()}",
          style: TextStyles.sourceSansL.body2.colour(
              // lastTappedChipIndex == index
              Colors.white
              // : UiConstants.primaryColor,
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
      double netTax = goldRates?.cgstPercent ?? 0 + goldRates.sgstPercent;
      double enteredAmount = double.tryParse(goldAmountController.text);
      double postTaxAmount = BaseUtil.digitPrecision(
          enteredAmount - getTaxOnAmount(enteredAmount, netTax));

      if (goldBuyPrice != null && goldBuyPrice != 0.0)
        goldAmountInGrams =
            BaseUtil.digitPrecision(postTaxAmount / goldBuyPrice, 4, false);
      else
        goldAmountInGrams = 0.0;
    }
    fieldWidth =
        (SizeConfig.padding40 * goldAmountController.text.length.toDouble());
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

  initiateBuyFromModal() {
    return BaseUtil.openModalBottomSheet(
      addToScreenStack: true,
      enableDrag: false,
      hapticVibrate: true,
      isBarrierDismissable: false,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      content: RechargeModalSheet(),
    );
  }

  processTransaction(String pspApp) async {
    setState(ViewState.Idle);
    isGoldBuyInProgress = true;
    double buyAmount = double.tryParse(goldAmountController.text);
    bool _disabled = await _dbModel.isAugmontBuyDisabled();
    if (_disabled != null && _disabled) {
      isGoldBuyInProgress = false;
      BaseUtil.showNegativeAlert(
        'Purchase Failed',
        'Gold buying is currently on hold. Please try again after sometime.',
      );
      return;
    }
    _analyticsService.track(eventName: AnalyticsEvents.buyGold);

    try {
      await _paytmService.processTransaction(
          buyAmount,
          PlatformUtils.isAndroid ? 'android' : 'ios',
          pspApp,
          'UPI_INTENT',
          goldRates,
          appliedCoupon?.code ?? "",
          _upiApplication, () async {
        ApiResponse<TxnResultModel> _txnResult =
            await _paytmService.validateTxnResult(_paytmService.orderId);
        print(_txnResult.model.data.gt);
        if (_txnResult.code == 200) {
          // transactionResponseUpdate(
          //     amount: buyAmount, gtId: _paytmService.orderId);
        }
      });

      resetBuyOptions();
      if (AppState.screenStack.last == ScreenItem.loader) {
        AppState.screenStack.removeLast();
      }
      AppState.backButtonDispatcher.didPopRoute();
      AppState.backButtonDispatcher.didPopRoute();
      setState(ViewState.Idle);
    } catch (e) {
      print(e);
    }
    isGoldBuyInProgress = false;
  }

  Future<bool> initChecks() async {
    if (status == STATUS_UNAVAILABLE) return false;
    if (status == STATUS_REGISTER) {
      _onboardUserManually();
      return true;
    }
    if (couponApplyInProgress) return false;
    double buyAmount = double.tryParse(goldAmountController.text);
    // checkIfCouponIsStillApplicable();
    if (goldRates == null) {
      BaseUtil.showNegativeAlert(
        'Gold Rates Unavailable',
        'Please try again in sometime',
      );
      return false;
    }
    if (buyAmount == null) {
      BaseUtil.showNegativeAlert(
        'No amount entered',
        'Please enter an amount',
      );
      return false;
    }
    if (buyAmount < 10) {
      showMinCapText = true;
      return false;
    }

    if (_baseUtil.augmontDetail == null) {
      BaseUtil.showNegativeAlert(
        'Deposit Failed',
        'Please try again in sometime or contact us',
      );
      return false;
    }

    if (_baseUtil.augmontDetail.isDepLocked) {
      BaseUtil.showNegativeAlert(
        'Purchase Failed',
        "${buyNotice ?? 'Gold buying is currently on hold. Please try again after sometime.'}",
      );
      return false;
    }

    bool _disabled = await _dbModel.isAugmontBuyDisabled();
    if (_disabled != null && _disabled) {
      isGoldBuyInProgress = false;
      BaseUtil.showNegativeAlert(
        'Purchase Failed',
        'Gold buying is currently on hold. Please try again after sometime.',
      );
      return false;
    }
    _analyticsService.track(eventName: AnalyticsEvents.buyGold);
    return true;
  }

  initiateRzpGatewayTxn() async {
    if (status == STATUS_UNAVAILABLE) return;
    if (status == STATUS_REGISTER) {
      _onboardUserManually();
      return;
    }
    if (couponApplyInProgress) return;
    double buyAmount = double.tryParse(goldAmountController.text);
    // checkIfCouponIsStillApplicable();
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
      showMinCapText = true;
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
    isGoldBuyInProgress = true;

    bool _disabled = await _dbModel.isAugmontBuyDisabled();
    if (_disabled != null && _disabled) {
      isGoldBuyInProgress = false;
      BaseUtil.showNegativeAlert(
        'Purchase Failed',
        'Gold buying is currently on hold. Please try again after sometime.',
      );
      return;
    }
    _analyticsService.track(eventName: AnalyticsEvents.buyGold);

    await _razorpayOpsModel.initiateRazorpayTxn(
        amount: buyAmount,
        augmontRates: goldRates,
        couponCode: appliedCoupon?.code ?? "",
        email: _userService.baseUser.email,
        mobile: _userService.baseUser.mobile);

    isGoldBuyInProgress = false;
    resetBuyOptions();
  }

  initiatePaytmPgTxn() async {
    if (status == STATUS_UNAVAILABLE) return;
    if (status == STATUS_REGISTER) {
      _onboardUserManually();
      return;
    }
    if (couponApplyInProgress) return;
    double buyAmount = double.tryParse(goldAmountController.text);
    // checkIfCouponIsStillApplicable();
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
      showMinCapText = true;
      return;
    }

    if (_baseUtil.augmontDetail == null) {
      BaseUtil.showNegativeAlert(
        'Deposit Failed',
        'Please try again in sometime or contact us',
      );
      return;
    }

    if (skipMl && buyAmount < incomingAmount) {
      return BaseUtil.openDialog(
          addToScreenStack: true,
          content: ConfirmationDialog(
            title: "Alert!",
            description:
                "Buy amount is less than skip cost. You can still buy gold but milestone won't be skipped",
            asset: Icon(Icons.warning_rounded,
                color: Colors.amber, size: SizeConfig.padding54),
            buttonText: "Continue",
            cancelAction: () => AppState.backButtonDispatcher.didPopRoute(),
            confirmAction: () => AppState.backButtonDispatcher.didPopRoute(),
            cancelBtnText: "Cancle",
          ),
          isBarrierDismissable: false,
          hapticVibrate: true);
    }

    if (_baseUtil.augmontDetail.isDepLocked) {
      BaseUtil.showNegativeAlert(
        'Purchase Failed',
        "${buyNotice ?? 'Gold buying is currently on hold. Please try again after sometime.'}",
      );
      return;
    }
    isGoldBuyInProgress = true;
    // NOTE: We can enable using make model size full screen and put some padding from top.

    // AppState.screenStack.add(ScreenItem.loader);
    bool _disabled = await _dbModel.isAugmontBuyDisabled();
    if (_disabled != null && _disabled) {
      isGoldBuyInProgress = false;
      // AppState.screenStack.removeLast();
      BaseUtil.showNegativeAlert(
        'Purchase Failed',
        'Gold buying is currently on hold. Please try again after sometime.',
      );
      return;
    }
    _analyticsService.track(eventName: AnalyticsEvents.buyGold);

    final bool restrictPaytmAppInvoke = (FlavorConfig.isDevelopment() ||
            BaseRemoteConfig.remoteConfig
                    .getString(BaseRemoteConfig.RESTRICT_PAYTM_APP_INVOKE) ==
                "true")
        ? true
        : false;

    bool _status;

    _status = await _paytmService.initiatePaytmPGTransaction(
        amount: buyAmount,
        augmontRates: goldRates,
        couponCode: appliedCoupon?.code ?? "",
        restrictAppInvoke: restrictPaytmAppInvoke);

    isGoldBuyInProgress = false;
    resetBuyOptions();
    if (_status) {
      // AppState.delegate.appState.isTxnLoaderInView = true;
      _txnService.currentTransactionState = TransactionState.ongoingTransaction;
      AppState.screenStack.add(ScreenItem.loader);
      _logger.d("Txn Timer Function reinitialised and set with 30 secs delay");
      _paytmService.handleTransactionPolling();
      // AppState.delegate.appState.txnTimer = Timer(
      //   Duration(seconds: 30),
      //   () async {
      //     AppState.pollingPeriodicTimer?.cancel();
      //     if (AppState.delegate.appState.isTxnLoaderInView) {
      //       AppState.delegate.appState.isTxnLoaderInView = false;
      //       _txnService.showTransactionPendingDialog();
      //     }
      //     // AppState.delegate.appState.txnTimer.cancel();
      //   },
      // );
    } else {
      // if (AppState.delegate.appState.isTxnLoaderInView == true) {
      //   AppState.delegate.appState.isTxnLoaderInView = false;
      // }
      if (_txnService.currentTransactionState ==
          TransactionState.ongoingTransaction) {
        _txnService.currentTransactionState = TransactionState.idleTrasantion;
      }
      AppState.unblockNavigation();
      BaseUtil.showNegativeAlert(
        'Transaction failed',
        'Your transaction was unsuccessful. Please try again',
      );
    }

    isGoldBuyInProgress = false;
    resetBuyOptions();
  }

  onBuyValueChanged(String val) {
    _logger.d("Value: $val");
    if (showMaxCapText) showMaxCapText = false;
    if (showMinCapText) showMinCapText = false;
    if (val != null && val.isNotEmpty) {
      if (val.length > 2 && val[0] == '0' && val[1] != '.')
        val = val.substring(1);
      if (double.tryParse(val.trim()) != null &&
          double.tryParse(val.trim()) > 50000) {
        goldBuyAmount = 50000;
        goldAmountController.text = goldBuyAmount.toInt().toString();
        updateGoldAmount();
        showMaxCapText = true;
        buyFieldNode.unfocus();
      } else {
        goldBuyAmount = double.tryParse(val);
        for (int i = 0; i < chipAmountList.length; i++) {
          if (goldBuyAmount == chipAmountList[i]) {
            lastTappedChipIndex = i;
            break;
          }
        }

        updateGoldAmount();
      }
    } else {
      goldBuyAmount = 0;
      goldAmountController.text = '0';
      buyFieldNode.unfocus();
      updateGoldAmount();
    }

    // checkIfCouponIsStillApplicable();
    appliedCoupon = null;
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
      if (_userService.baseUser.isAugmontEnabled != null &&
          _userService.baseUser.isAugmontEnabled) {
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
    else if (_userService.baseUser.isAugmontOnboarded == null ||
        _userService.baseUser.isAugmontOnboarded == false)
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
    // BaseUtil.openModalBottomSheet(
    //   addToScreenStack: true,
    //   backgroundColor: Colors.white,
    //   borderRadius: BorderRadius.only(
    //     topLeft: Radius.circular(SizeConfig.padding16),
    //     topRight: Radius.circular(SizeConfig.padding16),
    //   ),
    //   hapticVibrate: true,
    //   isBarrierDismissable: false,
    //   isScrollControlled: true,
    // content: AugmontCouponsModalSheet(model: model),
    // );

    BaseUtil.openModalBottomSheet(
      content: CouponModalSheet(model: model),
      addToScreenStack: true,
      backgroundColor: UiConstants.kSecondaryBackgroundColor,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(SizeConfig.roundness12),
        topRight: Radius.circular(SizeConfig.roundness12),
      ),
      boxContraints: BoxConstraints(
        maxHeight: SizeConfig.screenHeight * 0.75,
        minHeight: SizeConfig.screenHeight * 0.75,
      ),
      isBarrierDismissable: false,
      isScrollControlled: true,
    );
  }

  getAmount(double amount) {
    if (amount > amount.toInt())
      return amount;
    else
      return amount.toInt();
  }

  showSuccessGoldBuyDialog(double amount, {String subtitle}) {
    BaseUtil.openDialog(
      addToScreenStack: true,
      hapticVibrate: true,
      isBarrierDismissable: false,
      content: FelloConfirmationDialog(
        asset: Assets.goldenTicket,
        title: "Congratulations",
        subtitle: subtitle ??
            "You have successfully saved ₹ ${getAmount(amount)} and earned ${amount.ceil()} tokens!",
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
          _analyticsService.track(eventName: AnalyticsEvents.buyGoldInvestMore);
          AppState.backButtonDispatcher.didPopRoute();
        },
      ),
    );
  }

// ----------------------------------------NAVIGATION--------------------------------------//

  navigateToGoldBalanceDetailsScreen() {
    AppState.delegate.appState.currentAction = PageAction(
      state: PageState.addPage,
      page: GoldBalanceDetailsViewPageConfig,
    );

    _analyticsService.track(
      eventName: AnalyticsEvents.saveBalance,
      properties: {'balance': _userService?.userFundWallet?.augGoldQuantity},
    );
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
    final ApiResponse<List<CouponModel>> couponsRes =
        await _couponRepo.getCoupons();
    if (couponsRes.code == 200) {
      couponList = couponsRes.model;
      if (couponList[0].priority == 1) focusCoupon = couponList[0];
      showCoupons = true;
    }
  }

  Future applyCoupon(String couponCode) async {
    if (couponApplyInProgress || isGoldBuyInProgress) return;

    _analyticsService.track(eventName: AnalyticsEvents.saveBuyCoupon);

    buyFieldNode.unfocus();

    couponApplyInProgress = true;

    ApiResponse<EligibleCouponResponseModel> response =
        await _couponRepo.getEligibleCoupon(
      uid: _userService.baseUser.uid,
      amount: goldBuyAmount.toInt(),
      couponcode: couponCode,
    );

    couponApplyInProgress = false;

    if (response.code == 200) {
      if (response.model.flag == true) {
        appliedCoupon = response.model;
        BaseUtil.showPositiveAlert(
            "Coupon Applied Successfully", response?.model?.message);
      } else {
        BaseUtil.showNegativeAlert(
            "Coupon cannot be applied", response?.model?.message);
      }
    } else if (response.code == 400) {
      BaseUtil.showNegativeAlert("Coupon not applied", response?.errorMessage);
    } else {
      BaseUtil.showNegativeAlert(
          "Coupon not applied", "Please try another coupon");
    }
  }

  //------------------------------- TEST -------------------------------- //

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
}

class PendingDialog extends StatelessWidget {
  final String title, subtitle, duration;

  PendingDialog(
      {@required this.title, @required this.subtitle, @required this.duration});

  @override
  Widget build(BuildContext context) {
    return AppNegativeDialog(
      btnAction: () {},
      btnText: "OK",
      title: "We're still Processing",
      subtitle: subtitle + duration,
    );
  }
}
