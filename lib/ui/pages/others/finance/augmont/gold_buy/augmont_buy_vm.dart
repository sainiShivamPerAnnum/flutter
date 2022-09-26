import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/aug_gold_rates_model.dart';
import 'package:felloapp/core/model/coupon_card_model.dart';
import 'package:felloapp/core/model/eligible_coupon_model.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/repository/coupons_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/cache_manager.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/augmont_transaction_service.dart';
import 'package:felloapp/core/service/payments/paytm_service.dart';
import 'package:felloapp/core/service/payments/razorpay_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/dialogs/negative_dialog.dart';
import 'package:felloapp/ui/modals_sheets/augmont_register_modal_sheet.dart';
import 'package:felloapp/ui/modals_sheets/coupon_modal_sheet.dart';
import 'package:felloapp/ui/pages/others/finance/amount_chip.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:upi_pay/upi_pay.dart';

class GoldBuyViewModel extends BaseViewModel {
  static const int STATUS_UNAVAILABLE = 0;
  static const int STATUS_REGISTER = 1;
  static const int STATUS_OPEN = 2;

  final _logger = locator<CustomLogger>();
  final BaseUtil _baseUtil = locator<BaseUtil>();
  final DBModel _dbModel = locator<DBModel>();
  final AugmontService _augmontModel = locator<AugmontService>();
  final UserService _userService = locator<UserService>();
  final _razorpayService = locator<RazorpayService>();
  final AugmontTransactionService _augTxnService =
      locator<AugmontTransactionService>();

  final _analyticsService = locator<AnalyticsService>();
  final _couponRepo = locator<CouponRepository>();
  final _paytmService = locator<PaytmService>();
  double incomingAmount;
  List<ApplicationMeta> appMetaList = [];
  UpiApplication upiApplication;
  String selectedUpiApplicationName;
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
  set goldBuyAmount(double value) {
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
  List<int> chipAmountList = [101, 201, 501, 1001];
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
    // resetBuyOptions();
    setState(ViewState.Busy);
    skipMl = isSkipMilestone;
    incomingAmount = amount?.toDouble() ?? 0;
    goldBuyAmount = amount.toDouble() ?? chipAmountList[1];
    goldAmountController = TextEditingController(
        text: amount.toString() ?? chipAmountList[1].toInt().toString());
    fieldWidth =
        (SizeConfig.padding40 * goldAmountController.text.length.toDouble());
    fetchGoldRates();
    await fetchNotices();
    status = checkAugmontStatus();
    _paytmService.getActiveSubscriptionDetails();
    getAvailableCoupons();
    userAugmontState = await CacheManager.readCache(key: "UserAugmontState");
    _onboardUserAutomatically(userAugmontState);
    await _userService.fetchUserAugmontDetail();
    delayedAugmontCall();
    checkIfDepositIsLocked();
    setState(ViewState.Idle);
  }

  //INIT CHECKS
  checkIfDepositIsLocked() {
    if (_userService.userAugmontDetails != null &&
        _userService.userAugmontDetails.depNotice != null &&
        _userService.userAugmontDetails.depNotice.isNotEmpty)
      buyNotice = _userService.userAugmontDetails.depNotice;
  }

  delayedAugmontCall() async {
    if (_userService.userAugmontDetails == null && !_augmontSecondFetchDone) {
      await Future.delayed(Duration(seconds: 2));
      await _userService.fetchUserAugmontDetail();
      _augmontSecondFetchDone = true;
      notifyListeners();
    }
  }

  fetchNotices() async {
    buyNotice = await _dbModel.showAugmontBuyNotice();
  }

  resetBuyOptions() {
    goldBuyAmount = chipAmountList[1].toDouble();
    goldAmountController.text = chipAmountList[1].toInt().toString();
    appliedCoupon = null;
    lastTappedChipIndex = 1;
    notifyListeners();
  }

  //BUY FLOW
  //1
  initiateBuy() async {
    _augTxnService.isGoldBuyInProgress = true;
    if (!await initChecks()) {
      _augTxnService.isGoldBuyInProgress = false;
      return;
    }
    await _augTxnService.initateAugmontTransaction(
      details: GoldPurchaseDetails(
        goldBuyAmount: goldBuyAmount,
        goldRates: goldRates,
        couponCode: appliedCoupon?.code ?? '',
        skipMl: skipMl ?? false,
        goldInGrams: goldAmountInGrams,
      ),
    );
  }

  //2 Basic Checks
  Future<bool> initChecks() async {
    if (status == STATUS_UNAVAILABLE) return false;
    if (status == STATUS_REGISTER) {
      _onboardUserManually();
      return true;
    }

    if (goldRates == null) {
      BaseUtil.showNegativeAlert(
          'Gold Rates Unavailable', 'Please try again in sometime');
      return false;
    }
    if (goldBuyAmount == null) {
      BaseUtil.showNegativeAlert('No amount entered', 'Please enter an amount');
      return false;
    }
    if (goldBuyAmount < 10) {
      showMinCapText = true;
      return false;
    }

    if (_userService.userAugmontDetails == null) {
      BaseUtil.showNegativeAlert(
        'Deposit Failed',
        'Please try again in sometime or contact us',
      );
      return false;
    }

    if (_userService.userAugmontDetails.isDepLocked) {
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

// UI ESSENTIALS

  Widget amountChip(int index) {
    int amt = chipAmountList[index];
    return AmountChip(
      isActive: lastTappedChipIndex == index,
      amt: amt,
      isBest: index == 1,
      onClick: (int amt) {
        if (couponApplyInProgress || isGoldBuyInProgress) return;
        showMaxCapText = false;
        showMinCapText = false;
        Haptic.vibrate();
        lastTappedChipIndex = index;
        buyFieldNode.unfocus();
        goldBuyAmount = amt.toDouble();
        goldAmountController.text = goldBuyAmount.toInt().toString();
        updateGoldAmount();
        //checkIfCouponIsStillApplicable();
        appliedCoupon = null;
        notifyListeners();
      },
    );
  }

  updateGoldAmount() {
    if (goldAmountController.text == null ||
        goldAmountController.text.isEmpty ||
        double.tryParse(goldAmountController.text) == null) {
      goldAmountInGrams = 0.0;
    } else {
      double netTax = goldRates?.cgstPercent ?? 0 + goldRates?.sgstPercent ?? 0;
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

  onBuyValueChanged(String val) {
    _logger.d("Value: $val");
    if (showMaxCapText) showMaxCapText = false;
    if (showMinCapText) showMinCapText = false;
    if (val != null && val.isNotEmpty) {
      if (double.tryParse(val.trim()) > 50000.0) {
        goldBuyAmount = 50000;
        goldAmountController.text = goldBuyAmount.toInt().toString();
        updateGoldAmount();
        showMaxCapText = true;
        buyFieldNode.unfocus();
      } else {
        goldBuyAmount = double.tryParse(val);
        if (goldBuyAmount < 10.0) showMinCapText = true;
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
    if (status == STATUS_REGISTER && userAugmontState != null) {
      augOnbRegInProgress = true;
      _logger.d("Augmont Onboarding started automagically");
      _userService.setUserAugmontDetails(await _augmontModel.createSimpleUser(
          _userService.baseUser.mobile, userAugmontState));
      if (_userService.userAugmontDetails == null) {
        augOnbRegInProgress = false;
        augRegFailed = true;
        return;
      } else {
        augOnbRegInProgress = false;
        status = checkAugmontStatus();
        augRegFailed = false;
      }
      _logger.d("Augmont Onboarding Completed");
      isGoldBuyInProgress = false;
      setState(ViewState.Idle);
      return true;
    }
  }

  Future _onboardUserManually() async {
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

  void showOfferModal(GoldBuyViewModel model) {
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
      BaseUtil.showNegativeAlert("Coupon not applied",
          response?.errorMessage ?? "Please try another coupon");
    } else {
      BaseUtil.showNegativeAlert(
          "Coupon not applied", "Please try another coupon");
    }
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
