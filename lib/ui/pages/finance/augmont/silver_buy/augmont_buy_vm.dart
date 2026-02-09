// ignore_for_file: empty_catches

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/model/asset_options_model.dart';
import 'package:felloapp/core/model/aug_silver_rates_model.dart';
import 'package:felloapp/core/model/coupon_card_model.dart';
import 'package:felloapp/core/model/eligible_coupon_model.dart';
import 'package:felloapp/core/model/timestamp_model.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/core/repository/coupons_repo.dart';
import 'package:felloapp/core/repository/getters_repo.dart';
import 'package:felloapp/core/service/analytics/analyticsProperties.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/cache_manager.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/bank_and_pan_service.dart';
import 'package:felloapp/core/service/payments/silver_transaction_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/back_button_actions.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/dialogs/negative_dialog.dart';
import 'package:felloapp/ui/pages/finance/augmont/silver_buy/silver_coupon_widget.dart';
import 'package:felloapp/ui/pages/finance/preffered_upi_option_mixin.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

mixin NetBankingValidationMixin on BaseViewModel {
  BankAndPanService get bankingService;

  Future<void> getAccDetailsWithNetbankingInfo() async {
    await bankingService.checkForUserBankAccountDetails(
      forceRefetch: true,
      withNetBankingValidation: true,
    );
  }
}

class SilverBuyViewModel extends BaseViewModel
    with PaymentIntentMixin, NetBankingValidationMixin {
  static const int STATUS_UNAVAILABLE = 0;
  static const int STATUS_OPEN = 2;

  @override
  final bankingService = locator<BankAndPanService>();
  final CustomLogger _logger = locator<CustomLogger>();
  final AugmontService _augmontModel = locator<AugmontService>();
  final UserService _userService = locator<UserService>();
  final AugmontSilverTransactionService _augTxnService =
      locator<AugmontSilverTransactionService>();

  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  final CouponRepository _couponRepo = locator<CouponRepository>();

  // final PaytmService? _paytmService = locator<PaytmService>();
  S locale = locator<S>();
  AssetOptionsModel? assetOptionsModel;
  double? incomingAmount;

  int _status = 0;
  int lastTappedChipIndex = 1;
  CouponModel? _focusCoupon;
  EligibleCouponResponseModel? _appliedCoupon;
  bool _showMaxCapText = false;
  bool _showMinCapText = false;
  bool _isSilverRateFetching = false;
  bool _isSilverBuyInProgress = false;
  bool _addSpecialCoupon = false;
  bool isSpecialCoupon = true;
  bool showCouponAppliedText = false;
  bool isIntentFlow = true;
  bool _isBuyInProgess = false;

  bool _skipMl = false;
  double _fieldWidth = 0.0;
  num minAmount = 100;
  num maxAmount = 100;
  AnimationController? animationController;

  double get fieldWidth => _fieldWidth;

  set fieldWidth(value) {
    _fieldWidth = value;
    notifyListeners();
  }

  String? couponCode;

  // bool _isSubscriptionInProgress = false;
  bool _couponApplyInProgress = false;
  bool _showCoupons = false;
  final bool _augmontSecondFetchDone = false;

  AugmontSilverRates? silverRates;
  String? userAugmontState;
  FocusNode buyFieldNode = FocusNode();
  String? buyNotice;

  num? _silverBuyAmount = 0;
  num _silverAmountInGrams = 0.0;

  num? get silverBuyAmount => _silverBuyAmount;

  set silverBuyAmount(num? value) {
    _silverBuyAmount = value;
    notifyListeners();
  }

  bool get isBuyInProgess => _isBuyInProgess;

  set isBuyInProgess(bool value) {
    _isBuyInProgess = value;
    notifyListeners();
  }

  Future<void> getAssetOptionsModel({String? entryPoint}) async {
    final isNewUser = locator<UserService>().userSegments.contains(
          Constants.NEW_USER,
        );
    final res = await locator<GetterRepository>().getAssetOptions(
      'weekly',
      'gold',
      isNewUser: isNewUser,
      entryPoint: entryPoint,
    );
    final model = res.model;
    if (res.code == 200 && model != null) {
      assetOptionsModel = model;
      minAmount = model.data.minAmount;
      maxAmount = model.data.maxAmount;
    }
  }

  num get silverAmountInGrams => _silverAmountInGrams;

  set silverAmountInGrams(value) {
    _silverAmountInGrams = value;
    notifyListeners();
  }

  TextEditingController? silverAmountController;
  TextEditingController? vpaController;
  List<CouponModel>? _couponList;

  bool get couponApplyInProgress => _couponApplyInProgress;

  set couponApplyInProgress(bool val) {
    _couponApplyInProgress = val;
    notifyListeners();
  }

  List<CouponModel>? get couponList => _couponList;

  set couponList(List<CouponModel>? list) {
    _couponList = list;
    notifyListeners();
  }

  double? get silverBuyPrice => silverRates != null ?
    silverRates!.silverBuyPrice : 0.0;

  bool get isSilverBuyInProgress => _isSilverBuyInProgress;

  bool get augmontObjectSecondFetchDone => _augmontSecondFetchDone;

  set isSilverBuyInProgress(value) {
    _isSilverBuyInProgress = value;
    notifyListeners();
  }

  int get status => _status;

  set status(value) {
    _status = value;
    notifyListeners();
  }

  bool get showMaxCapText => _showMaxCapText;

  set showMaxCapText(value) {
    _showMaxCapText = value;
    notifyListeners();
  }

  bool get showMinCapText => _showMinCapText;

  set showMinCapText(value) {
    _showMinCapText = value;
    notifyListeners();
  }

  bool get isSilverRateFetching => _isSilverRateFetching;

  set isSilverRateFetching(value) {
    _isSilverRateFetching = value;
    notifyListeners();
  }

  EligibleCouponResponseModel? get appliedCoupon => _appliedCoupon;

  set appliedCoupon(EligibleCouponResponseModel? value) {
    _appliedCoupon = value;
    notifyListeners();
  }

  CouponModel? get focusCoupon => _focusCoupon;

  set focusCoupon(CouponModel? coupon) {
    _focusCoupon = coupon;
    notifyListeners();
  }

  bool get showCoupons => _showCoupons;

  set showCoupons(bool val) {
    _showCoupons = val;
    notifyListeners();
  }

  bool get skipMl => _skipMl;

  set skipMl(bool value) {
    _skipMl = value;
  }

  bool get addSpecialCoupon => _addSpecialCoupon;

  set addSpecialCoupon(value) {
    _addSpecialCoupon = value;
    notifyListeners();
  }

  int? numberOfTambolaTickets;

  int? totalTickets;
  int? happyHourTickets;

  late bool _showHappyHour;

  bool _showInfoIcon = false;

  bool get showInfoIcon => _showInfoIcon;

  set showInfoIcon(bool value) {
    _showInfoIcon = value;
  }

  bool get showHappyHour => _showHappyHour;

  set showHappyHour(bool value) {
    _showHappyHour = value;
    notifyListeners();
  }

  bool readOnly = true;

  Future<void> init(
    int? amount,
    bool isSkipMilestone,
    TickerProvider vsync,
    double? gms, {
    String? initialCouponCode,
    String? entryPoint,
    bool quickCheckout = false,
  }) async {
    setState(ViewState.Busy);
    await initAndSetPreferredPaymentOption();
    isBuyInProgess = _augTxnService.isSilverBuyInProgress;
    animationController = AnimationController(
        vsync: vsync, duration: const Duration(milliseconds: 500));

    await getAssetOptionsModel(entryPoint: entryPoint);
    isIntentFlow = assetOptionsModel!.data.intent;
    animationController?.addListener(listnear);
    skipMl = isSkipMilestone;
    incomingAmount = amount?.toDouble() ?? 0;
    silverBuyAmount = amount?.toDouble() ??
        assetOptionsModel?.data.userOptions[1].value.toDouble();
    silverAmountController = TextEditingController(
        text: amount?.toString() ??
            assetOptionsModel!.data.userOptions[1].value.toString());
    fieldWidth =
        SizeConfig.padding30 * silverAmountController!.text.length.toDouble();
    if (silverBuyAmount != assetOptionsModel?.data.userOptions[1].value) {
      lastTappedChipIndex = -1;
    }

    final silverRateFuture = fetchSilverRates().then((value) {
      if (gms != null) {
        double netTax =
            (silverRates?.cgstPercent ?? 0) + (silverRates?.sgstPercent ?? 0);
        silverBuyAmount = convertToNearestCeilMultipleOf100(
            ((silverBuyPrice! * gms) + (netTax * silverBuyPrice! * gms) / 100) + 4);

        silverAmountController!.text = silverBuyAmount!.toInt().toString();
        fieldWidth =
            SizeConfig.padding30 * silverAmountController!.text.length.toDouble();
        updateSilverAmount();
        silverAmountController!.selection = TextSelection.fromPosition(
            TextPosition(offset: silverAmountController!.text.length));

        FocusScope.of(AppState.delegate!.navigatorKey.currentContext!)
            .unfocus();
      }
    });

    // await fetchNotices();
    status = checkAugmontStatus();
    // _paytmService!.getActiveSubscriptionDetails();
    setState(ViewState.Idle);

    await getAvailableCoupons();

    await _applyInitialCoupon(
      initialCouponCode,
    );

    userAugmontState = await CacheManager.readCache(key: "UserAugmontState");
    // setBackButtonActions();

    if (quickCheckout) {
      await silverRateFuture;
      await initiateBuy();
    }
  }

  bool hideKeyboard = false;

  void showKeyBoard() {
    if (readOnly) {
      readOnly = false;
      notifyListeners();
    }
  }

  void listnear() {
    if (animationController?.status == AnimationStatus.completed) {
      animationController?.reset();
    }
  }

  double convertToNearestCeilMultipleOf100(double number) {
    // Round up the number to the nearest multiple of 100
    int roundedNumber = ((number / 100).ceil() * 100).toInt();

    // Convert back to double and return the result
    return roundedNumber.toDouble();
  }

  resetBuyOptions() {
    silverBuyAmount = assetOptionsModel?.data.userOptions[1].value.toDouble();
    silverAmountController!.text =
        assetOptionsModel?.data.userOptions[1].value.toInt().toString() ?? '';
    appliedCoupon = null;
    lastTappedChipIndex = 1;
    notifyListeners();
  }

  //BUY FLOW
  //1
  Future<void> initiateBuy() async {
    locator<BackButtonActions>().isTransactionCancelled = false;
    if (_augTxnService.isSilverSellInProgress || couponApplyInProgress) return;
    _augTxnService.isSilverBuyInProgress = true;
    isBuyInProgess = true;
    if (!await initChecks()) {
      _augTxnService.isSilverBuyInProgress = false;
      isBuyInProgess = false;
      return;
    }
    await _augTxnService.initiateAugmontSilverTransaction(
      details: SilverPurchaseDetails(
        silverBuyAmount: silverBuyAmount?.toDouble(),
        silverRates: silverRates,
        couponCode: appliedCoupon?.code ?? '',
        skipMl: skipMl,
        silverInGrams: silverAmountInGrams.toDouble(),
        upiChoice: selectedUpiApplication,
        isIntentFlow: assetOptionsModel!.data.intent,
      ),
    );
    if (selectedUpiApplication != null) {
      _analyticsService
          .track(eventName: AnalyticsEvents.intentUpiAppSelected, properties: {
        "silverBuyAmount": silverBuyAmount,
        "couponCode": appliedCoupon?.code ?? '',
        "skipMl": skipMl,
        "silverInGrams": silverAmountInGrams,
        "upiChoice": selectedUpiApplication!.packageName,
        "abTesting": AppConfig.getValue(AppConfigKey.payment_brief_view)
            ? "with payment summary"
            : "without payment summary"
      });
    }
  }

  //2 Basic Checks
  Future<bool> initChecks() async {
    if (status == STATUS_UNAVAILABLE) {
      trackCheckOutEvent("Status was unavilable");
      return false;
    }

    if (silverRates == null) {
      BaseUtil.showNegativeAlert(
          locale.loadingSilverRates, locale.loadingSilverRates1,);

      return false;
    }
    if (silverBuyAmount == null) {
      BaseUtil.showNegativeAlert(locale.noAmountEntered, locale.enterAmount);
      return false;
    }

    if (silverBuyAmount! < minAmount) {
      showMinCapText = true;
      BaseUtil.showNegativeAlert(
        "Invalid Amount",
        "Please Enter Amount Greater than ₹$minAmount",
      );
      return false;
    }

    trackCheckOutEvent();
    return true;
  }

  void trackCheckOutEvent([String errorMessage = '']) {
    _augTxnService.currentTransactionAnalyticsDetails = {
      "iplPrediction": false,
      "Asset": "Silver",
      "Coupon Code":
          appliedCoupon != null ? appliedCoupon?.code : "Not Applied",
      "Amount Entered": silverAmountController!.text,
      "Silver Weight": silverAmountInGrams,
      "Per gram rate": silverRates?.silverBuyPrice,
      "Best flag": silverAmountController!.text ==
              assetOptionsModel?.data.userOptions[2].value.toString(),
      "Error message": errorMessage,
    };
    _analyticsService.track(
        eventName: AnalyticsEvents.saveCheckout,
        properties:
            AnalyticsProperties.getDefaultPropertiesMap(extraValuesMap: {
          "Asset": "Silver",
          "Coupon Code":
              appliedCoupon != null ? appliedCoupon!.code : "Not Applied",
          "Amount Entered": silverAmountController!.text,
          "Silver Weight": silverAmountInGrams,
          "Per gram rate": silverRates?.silverBuyPrice,
          "Best flag": assetOptionsModel?.data.userOptions
              .firstWhere(
                (element) =>
                    element.value.toString() == silverAmountController!.text,
                orElse: () => const UserOption(order: 0, value: 0, best: false),
              )
              .best,
          "Error message": errorMessage,
        }));
  }

  void onChipClick(int index) {
    if (couponApplyInProgress ||
        isSilverBuyInProgress ||
        _augTxnService.isSilverBuyInProgress) return;
    showMaxCapText = false;
    showMinCapText = false;
    addSpecialCoupon = false;
    Haptic.vibrate();
    lastTappedChipIndex = index;
    // buyFieldNode.unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    silverBuyAmount = assetOptionsModel?.data.userOptions[index].value.toDouble();
    silverAmountController!.text = silverBuyAmount!.toInt().toString();
    updateSilverAmount();
    silverAmountController!.selection = TextSelection.fromPosition(
        TextPosition(offset: silverAmountController!.text.length));
    //checkIfCouponIsStillApplicable();
    focusCoupon = couponList!.firstWhereOrNull((element) =>
        element.minPurchase! <= int.parse(silverAmountController!.text));
    appliedCoupon = null;
    _analyticsService
        .track(eventName: AnalyticsEvents.suggestedAmountTapped, properties: {
      'order': index,
      'Amount': assetOptionsModel?.data.userOptions[index].value,
      'Best flag': assetOptionsModel?.data.userOptions
          .firstWhere((element) => element.best,
              orElse: () => const UserOption(order: 0, value: 0, best: false))
          .value
    });
    notifyListeners();
  }

  void updateSilverAmount() { //todo changes
    if ((silverAmountController?.text.isEmpty ?? false) ||
        double.tryParse(silverAmountController?.text ?? "0.0") == null) {
      silverAmountInGrams = 0.0;
    } else {
      double? netTax =
          (silverRates?.cgstPercent ?? 0) + (silverRates?.sgstPercent ?? 0);
      double enteredAmount =
          double.tryParse(silverAmountController?.text ?? "0") ?? 0;
      double postTaxAmount = BaseUtil.digitPrecision(
          enteredAmount - getTaxOnAmount(enteredAmount, netTax),);

      if (silverBuyPrice != null && silverBuyPrice != 0.0) {
        silverAmountInGrams =
            BaseUtil.digitPrecision(postTaxAmount / silverBuyPrice!, 4, false);
      } else {
        silverAmountInGrams = 0.0;
      }
    }
    fieldWidth = SizeConfig.padding30 *
        ((silverAmountController?.text != null &&
                (silverAmountController?.text.isNotEmpty ?? false))
            ? (silverAmountController?.text ?? "0").length.toDouble()
            : 0.5);
    AppState.amt = silverBuyAmount?.toDouble();
    refresh();
  }

  double getTaxOnAmount(double amount, double taxRate) {
    return BaseUtil.digitPrecision((amount * taxRate) / (100 + taxRate));
  }

  Future<void> fetchSilverRates() async {
    isSilverRateFetching = true;
    silverRates = await _augmontModel.getSilverRates();
    updateSilverAmount();
    if (silverRates == null) {
      BaseUtil.showNegativeAlert(
        locale.portalUnavailable,
        locale.currentRatesNotLoadedText1,
      );
    }
    isSilverRateFetching = false;
  }

  onBuyValueChanged(String val) {
    _logger.d("Value: $val");
    if (showMaxCapText) showMaxCapText = false;
    if (showMinCapText) showMinCapText = false;
    addSpecialCoupon = false;
    if (val.isNotEmpty) {
      if (double.tryParse(val.trim())! > maxAmount) {
        silverBuyAmount = maxAmount;
        silverAmountController!.text = silverBuyAmount!.toInt().toString();
        updateSilverAmount();
        showMaxCapText = true;
        silverAmountController!.selection = TextSelection.fromPosition(
            TextPosition(offset: silverAmountController!.text.length));
      } else {
        silverBuyAmount = double.tryParse(val);
        if ((silverBuyAmount ?? 0.0) < minAmount) showMinCapText = true;
        for (int i = 0; i < assetOptionsModel!.data.userOptions.length; i++) {
          if (silverBuyAmount == assetOptionsModel!.data.userOptions[i].value) {
            lastTappedChipIndex = i;
            break;
          }
        }

        updateSilverAmount();
      }
    } else {
      silverBuyAmount = 0;

      updateSilverAmount();
    }

    focusCoupon = couponList!.firstWhereOrNull((element) =>
        element.minPurchase! <= int.parse(silverAmountController!.text));
    appliedCoupon = null;
  }

  int checkAugmontStatus() {
    //check who is allowed to deposit
    String perm =
        AppConfig.getValue(AppConfigKey.augmont_deposit_permission).toString();

    int isGeneralUserAllowed = 1;
    bool isAllowed = false;
    if (perm.isNotEmpty) {
      try {
        isGeneralUserAllowed = int.parse(perm);
      } catch (e) {
        isGeneralUserAllowed = 1;
      }
    }
    if (isGeneralUserAllowed == 0) {
      //General permission is denied. Check if specific user permission granted
      if (_userService.baseUser!.isAugmontEnabled != null &&
          _userService.baseUser!.isAugmontEnabled!) {
        //this specific user is allowed to use Augmont
        isAllowed = true;
      } else {
        isAllowed = false;
      }
    } else {
      isAllowed = true;
    }

    if (!isAllowed) {
      return STATUS_UNAVAILABLE;
    } else {
      return STATUS_OPEN;
    }
  }

   void showOfferModal(SilverBuyViewModel? model) {
    AppState.delegate!.appState.currentAction = PageAction(
      page: SilverCouponViewConfig,
      state: PageState.addWidget,
      widget: SilverCouponPage(
        model: model,
      ),
    );
  }

  num getAmount(double amount) {
    if (amount > amount.toInt()) {
      return amount;
    } else {
      return amount.toInt();
    }
  }

//----------------------------------------------- COUPON LOGIC -------------------------------

  Future<void> getAvailableCoupons() async {
    final ApiResponse<List<CouponModel>> couponsRes =
        await _couponRepo.getCoupons(assetType: "AUGSILVER");

    if (couponsRes.code == 200 &&
        couponsRes.model != null &&
        (couponsRes.model?.isNotEmpty ?? false)) {
      couponList = couponsRes.model;
      if (couponList![0].priority == 1) focusCoupon = couponList![0];
      if (couponList!.length > 1) {
        couponList!.sort(
          (a, b) => b.maxRewardAmount!.compareTo(a.maxRewardAmount!),
        );
      }
      focusCoupon = couponList!.firstWhere((element) =>
          element.minPurchase! <= int.parse(silverAmountController!.text));
      showCoupons = true;
    }
  }

  Future<void> _applyInitialCoupon(String? coupon) async {
    if (coupon == null) return;
    try {
      await applyCoupon(coupon, false);
    } catch (e, stack) {
      _logger.e('Failed to apply initial coupon', e, stack);
    }
  }

  Future<void> applyCoupon(String? couponCode, bool isManuallyTyped) async {
    if (couponCode == null ||
        couponApplyInProgress ||
        isSilverBuyInProgress ||
        _augTxnService.isSilverBuyInProgress) return;

    int order = -1;
    int? minTransaction = -1;
    int counter = 0;
    isSpecialCoupon = true;
    for (final CouponModel c in couponList ?? []) {
      if (c.code == couponCode) {
        order = counter;
        isSpecialCoupon = false;
        minTransaction = c.minPurchase;
        break;
      }
      counter++;
    }

    buyFieldNode.unfocus();
    this.couponCode = couponCode;
    couponApplyInProgress = true;

    ApiResponse<EligibleCouponResponseModel> response =
        await _couponRepo.getEligibleCoupon(
      uid: _userService.baseUser!.uid,
      amount: silverBuyAmount!.toInt(),
      couponcode: couponCode,
      assetType: "AUGSILVER",
    );

    couponApplyInProgress = false;
    this.couponCode = null;
    if (response.code == 200) {
      if (response.model!.flag == true) {
        if (response.model!.minAmountRequired != null &&
            response.model!.minAmountRequired.toString().isNotEmpty &&
            response.model!.minAmountRequired != 0 &&
            (silverBuyAmount ?? 0) < response.model!.minAmountRequired!) {
          silverAmountController!.text =
              response.model!.minAmountRequired!.toInt().toString();
          silverBuyAmount = response.model!.minAmountRequired;
          updateSilverAmount();
          showMaxCapText = false;
          showMinCapText = false;
          await AppState.backButtonDispatcher!.didPopRoute();
          await animationController?.forward();
        }
        checkForSpecialCoupon(response.model!);

        appliedCoupon = response.model;

        focusCoupon = couponList?.firstWhereOrNull(
            (element) => element.code! == response.model!.code);

        BaseUtil.showPositiveAlert(
            locale.couponAppliedSucc, response.model?.message);
      } else {
        BaseUtil.showNegativeAlert(
            locale.couponCannotBeApplied, response.model?.message);
      }
    } else if (response.code == 400) {
      BaseUtil.showNegativeAlert(locale.couponNotApplied,
          response.errorMessage ?? locale.anotherCoupon);
    } else {
      BaseUtil.showNegativeAlert(locale.couponNotApplied, locale.anotherCoupon);
    }
    _analyticsService
        .track(eventName: AnalyticsEvents.saveBuyCoupon, properties: {
      "Manual Code entry": isManuallyTyped,
      "Order of coupon in list": order == -1 ? "Not in list" : order.toString(),
      "Coupon Name": couponCode,
      "Error message": response.code == 400 ? response.model?.message : "",
      "Asset": "Silver",
      "Min transaction": minTransaction == -1 ? "Not fetched" : minTransaction,
    });
  }

  void checkForSpecialCoupon(EligibleCouponResponseModel model) {
    // Check if coupon already exists in the list
    bool couponExists =
        couponList?.any((coupon) => coupon.code == model.code) ?? false;

    if (!couponExists) {
      // Initialize couponList if it's null
      couponList ??= [];

      showCoupons = false;
      couponList!.insert(
        0,
        CouponModel(
          code: model.code,
          createdOn: TimestampModel.currentTimeStamp(),
          description: model.desc,
          expiresOn: TimestampModel.currentTimeStamp(),
          highlight: '',
          maxUse: 0,
          minPurchase: model.minAmountRequired?.toInt(),
          priority: 0,
          id: '',
        ),
      );
      addSpecialCoupon = true;
      showCoupons = true;
      notifyListeners(); // Add this to update UI
    }
  }
}

class PendingDialog extends StatelessWidget {
  final String title, subtitle, duration;

  const PendingDialog(
      {required this.title,
      required this.subtitle,
      required this.duration,
      super.key});

  @override
  Widget build(BuildContext context) {
    S locale = locator<S>();
    return AppNegativeDialog(
      btnAction: () {},
      btnText: locale.btnOk.toUpperCase(),
      title: locale.processing,
      subtitle: subtitle + duration,
    );
  }
}

//Remove
//Leaderboard and Prices
