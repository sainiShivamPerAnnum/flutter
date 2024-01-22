// ignore_for_file: empty_catches

import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/model/asset_options_model.dart';
import 'package:felloapp/core/model/aug_gold_rates_model.dart';
import 'package:felloapp/core/model/coupon_card_model.dart';
import 'package:felloapp/core/model/eligible_coupon_model.dart';
import 'package:felloapp/core/model/happy_hour_campign.dart';
import 'package:felloapp/core/model/timestamp_model.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/repository/coupons_repo.dart';
import 'package:felloapp/core/repository/getters_repo.dart';
import 'package:felloapp/core/service/analytics/analyticsProperties.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/cache_manager.dart';
import 'package:felloapp/core/service/notifier_services/marketing_event_handler_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/augmont_transaction_service.dart';
import 'package:felloapp/core/service/payments/bank_and_pan_service.dart';
import 'package:felloapp/core/service/power_play_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/back_button_actions.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/dialogs/negative_dialog.dart';
import 'package:felloapp/ui/modalsheets/coupon_modal_sheet.dart';
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

import '../../../../../util/styles/ui_constants.dart';

mixin NetbankingValidationMixin on BaseViewModel {
  BankAndPanService get bankingService;

  Future<void> getAccDetailsWithNetbankingInfo() async {
    await bankingService.checkForUserBankAccountDetails(
      forceRefetch: true,
      withNetBankingValidation: true,
    );
  }
}

class GoldBuyViewModel extends BaseViewModel
    with PaymentIntentMixin, NetbankingValidationMixin {
  static const int STATUS_UNAVAILABLE = 0;
  static const int STATUS_OPEN = 2;

  @override
  final bankingService = locator<BankAndPanService>();
  final CustomLogger _logger = locator<CustomLogger>();
  final DBModel _dbModel = locator<DBModel>();
  final AugmontService _augmontModel = locator<AugmontService>();
  final UserService _userService = locator<UserService>();
  final AugmontTransactionService _augTxnService =
      locator<AugmontTransactionService>();

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
  bool _isGoldRateFetching = false;
  bool _isGoldBuyInProgress = false;
  bool _addSpecialCoupon = false;
  bool isSpecialCoupon = true;
  bool showCouponAppliedText = false;
  bool isIntentFlow = true;

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

  AugmontRates? goldRates;
  String? userAugmontState;
  FocusNode buyFieldNode = FocusNode();
  String? buyNotice;

  num? _goldBuyAmount = 0;
  num _goldAmountInGrams = 0.0;

  num? get goldBuyAmount => _goldBuyAmount;

  set goldBuyAmount(num? value) {
    _goldBuyAmount = value;
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

  num get goldAmountInGrams => _goldAmountInGrams;

  set goldAmountInGrams(value) {
    _goldAmountInGrams = value;
    notifyListeners();
  }

  TextEditingController? goldAmountController;
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

  double? get goldBuyPrice => goldRates != null ? goldRates!.goldBuyPrice : 0.0;

  bool get isGoldBuyInProgress => _isGoldBuyInProgress;

  bool get augmontObjectSecondFetchDone => _augmontSecondFetchDone;

  set isGoldBuyInProgress(value) {
    _isGoldBuyInProgress = value;
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

  bool get isGoldRateFetching => _isGoldRateFetching;

  set isGoldRateFetching(value) {
    _isGoldRateFetching = value;
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

    showHappyHour = locator<MarketingEventHandlerService>().showHappyHourBanner;
    animationController = AnimationController(
        vsync: vsync, duration: const Duration(milliseconds: 500));
    await getAssetOptionsModel(entryPoint: entryPoint);
    isIntentFlow = assetOptionsModel!.data.intent;
    animationController?.addListener(listnear);
    skipMl = isSkipMilestone;
    incomingAmount = amount?.toDouble() ?? 0;
    goldBuyAmount = amount?.toDouble() ??
        assetOptionsModel?.data.userOptions[1].value.toDouble();
    goldAmountController = TextEditingController(
        text: amount?.toString() ??
            assetOptionsModel!.data.userOptions[1].value.toString());
    fieldWidth =
        SizeConfig.padding40 * goldAmountController!.text.length.toDouble();
    if (goldBuyAmount != assetOptionsModel?.data.userOptions[1].value) {
      lastTappedChipIndex = -1;
    }
    final goldRateFuture = fetchGoldRates().then((value) {
      if (gms != null) {
        double netTax =
            (goldRates?.cgstPercent ?? 0) + (goldRates?.sgstPercent ?? 0);
        goldBuyAmount = convertToNearestCeilMultipleOf100(
            ((goldBuyPrice! * gms) + (netTax * goldBuyPrice! * gms) / 100) + 4);

        goldAmountController!.text = goldBuyAmount!.toInt().toString();
        fieldWidth =
            SizeConfig.padding32 * goldAmountController!.text.length.toDouble();
        updateGoldAmount();
        goldAmountController!.selection = TextSelection.fromPosition(
            TextPosition(offset: goldAmountController!.text.length));

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
      await goldRateFuture;
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
    goldBuyAmount = assetOptionsModel?.data.userOptions[1].value.toDouble();
    goldAmountController!.text =
        assetOptionsModel?.data.userOptions[1].value.toInt().toString() ?? '';
    appliedCoupon = null;
    lastTappedChipIndex = 1;
    notifyListeners();
  }

  //BUY FLOW
  //1
  Future<void> initiateBuy() async {
    locator<BackButtonActions>().isTransactionCancelled = false;
    if (_augTxnService.isGoldSellInProgress || couponApplyInProgress) return;
    _augTxnService.isGoldBuyInProgress = true;
    if (!await initChecks()) {
      _augTxnService.isGoldBuyInProgress = false;
      return;
    }
    await _augTxnService.initiateAugmontTransaction(
      details: GoldPurchaseDetails(
        goldBuyAmount: goldBuyAmount?.toDouble(),
        goldRates: goldRates,
        couponCode: appliedCoupon?.code ?? '',
        skipMl: skipMl,
        goldInGrams: goldAmountInGrams.toDouble(),
        upiChoice: selectedUpiApplication,
        isIntentFlow: assetOptionsModel!.data.intent,
      ),
    );
    if (selectedUpiApplication != null) {
      _analyticsService
          .track(eventName: AnalyticsEvents.intentUpiAppSelected, properties: {
        "goldBuyAmount": goldBuyAmount,
        "couponCode": appliedCoupon?.code ?? '',
        "skipMl": skipMl,
        "goldInGrams": goldAmountInGrams,
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

    if (goldRates == null) {
      BaseUtil.showNegativeAlert(
          locale.loadingGoldRates, locale.loadingGoldRates1);

      return false;
    }
    if (goldBuyAmount == null) {
      BaseUtil.showNegativeAlert(locale.noAmountEntered, locale.enterAmount);
      return false;
    }

    if (goldBuyAmount! < minAmount) {
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
      "iplPrediction": PowerPlayService.powerPlayDepositFlow,
      "Asset": "Gold",
      "Coupon Code":
          appliedCoupon != null ? appliedCoupon?.code : "Not Applied",
      "Amount Entered": goldAmountController!.text,
      "Gold Weight": goldAmountInGrams,
      "Per gram rate": goldRates?.goldBuyPrice,
      "Best flag": goldAmountController!.text ==
              assetOptionsModel?.data.userOptions[2].value.toString()
          ? true
          : false,
      "Error message": errorMessage,
    };
    _analyticsService.track(
        eventName: AnalyticsEvents.saveCheckout,
        properties:
            AnalyticsProperties.getDefaultPropertiesMap(extraValuesMap: {
          "Asset": "Gold",
          "Coupon Code":
              appliedCoupon != null ? appliedCoupon!.code : "Not Applied",
          "Amount Entered": goldAmountController!.text,
          "Gold Weight": goldAmountInGrams,
          "Per gram rate": goldRates?.goldBuyPrice,
          "Best flag": assetOptionsModel?.data.userOptions
              .firstWhere(
                (element) =>
                    element.value.toString() == goldAmountController!.text,
                orElse: () => const UserOption(order: 0, value: 0, best: false),
              )
              .best,
          "Error message": errorMessage,
        }));
  }

  void onChipClick(int index) {
    if (couponApplyInProgress ||
        isGoldBuyInProgress ||
        _augTxnService.isGoldBuyInProgress) return;
    showMaxCapText = false;
    showMinCapText = false;
    addSpecialCoupon = false;
    Haptic.vibrate();
    lastTappedChipIndex = index;
    // buyFieldNode.unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    goldBuyAmount = assetOptionsModel?.data.userOptions[index].value.toDouble();
    goldAmountController!.text = goldBuyAmount!.toInt().toString();
    updateGoldAmount();
    goldAmountController!.selection = TextSelection.fromPosition(
        TextPosition(offset: goldAmountController!.text.length));
    //checkIfCouponIsStillApplicable();
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

  void updateGoldAmount() {
    if ((goldAmountController?.text.isEmpty ?? false) ||
        double.tryParse(goldAmountController?.text ?? "0.0") == null) {
      goldAmountInGrams = 0.0;
    } else {
      double? netTax =
          (goldRates?.cgstPercent ?? 0) + (goldRates?.sgstPercent ?? 0);
      double enteredAmount =
          double.tryParse(goldAmountController?.text ?? "0") ?? 0;
      double postTaxAmount = BaseUtil.digitPrecision(
          enteredAmount - getTaxOnAmount(enteredAmount, netTax));

      if (goldBuyPrice != null && goldBuyPrice != 0.0) {
        goldAmountInGrams =
            BaseUtil.digitPrecision(postTaxAmount / goldBuyPrice!, 4, false);
      } else {
        goldAmountInGrams = 0.0;
      }
    }
    fieldWidth = SizeConfig.padding40 *
        ((goldAmountController?.text != null &&
                (goldAmountController?.text.isNotEmpty ?? false))
            ? (goldAmountController?.text ?? "0").length.toDouble()
            : 0.5);
    AppState.amt = goldBuyAmount?.toDouble();
    refresh();
  }

  double getTaxOnAmount(double amount, double taxRate) {
    return BaseUtil.digitPrecision((amount * taxRate) / (100 + taxRate));
  }

  Future<void> fetchGoldRates() async {
    isGoldRateFetching = true;
    goldRates = await _augmontModel.getRates();
    updateGoldAmount();
    if (goldRates == null) {
      BaseUtil.showNegativeAlert(
        locale.portalUnavailable,
        locale.currentRatesNotLoadedText1,
      );
    }
    isGoldRateFetching = false;
  }

  onBuyValueChanged(String val) {
    _logger.d("Value: $val");
    if (showMaxCapText) showMaxCapText = false;
    if (showMinCapText) showMinCapText = false;
    addSpecialCoupon = false;
    if (val.isNotEmpty) {
      if (double.tryParse(val.trim())! > maxAmount) {
        goldBuyAmount = maxAmount;
        goldAmountController!.text = goldBuyAmount!.toInt().toString();
        updateGoldAmount();
        showMaxCapText = true;
        goldAmountController!.selection = TextSelection.fromPosition(
            TextPosition(offset: goldAmountController!.text.length));
      } else {
        goldBuyAmount = double.tryParse(val);
        if ((goldBuyAmount ?? 0.0) < minAmount) showMinCapText = true;
        for (int i = 0; i < assetOptionsModel!.data.userOptions.length; i++) {
          if (goldBuyAmount == assetOptionsModel!.data.userOptions[i].value) {
            lastTappedChipIndex = i;
            break;
          }
        }

        updateGoldAmount();
      }
    } else {
      goldBuyAmount = 0;

      updateGoldAmount();
    }
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

  void showOfferModal(GoldBuyViewModel? model) {
    BaseUtil.openModalBottomSheet(
      content: CouponModalSheet(model: model),
      addToScreenStack: true,
      backgroundColor: UiConstants.kSecondaryBackgroundColor,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(SizeConfig.roundness12),
        topRight: Radius.circular(SizeConfig.roundness12),
      ),
      boxContraints: BoxConstraints(
        maxHeight: SizeConfig.screenHeight! * 0.75,
        minHeight: SizeConfig.screenHeight! * 0.75,
      ),
      isBarrierDismissible: false,
      isScrollControlled: true,
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
        await _couponRepo.getCoupons(assetType: "AUGGOLD");

    if (couponsRes.code == 200 &&
        couponsRes.model != null &&
        (couponsRes.model?.length ?? 0) > 1) {
      couponList = couponsRes.model;
      if (couponList![0].priority == 1) focusCoupon = couponList![0];
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
        isGoldBuyInProgress ||
        _augTxnService.isGoldBuyInProgress) return;

    int order = -1;
    int? minTransaction = -1;
    int counter = 0;
    isSpecialCoupon = true;
    for (final CouponModel c in couponList!) {
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
      amount: goldBuyAmount!.toInt(),
      couponcode: couponCode,
      assetType: "AUGGOLD",
    );

    couponApplyInProgress = false;
    this.couponCode = null;
    if (response.code == 200) {
      if (response.model!.flag == true) {
        if (response.model!.minAmountRequired != null &&
            response.model!.minAmountRequired.toString().isNotEmpty &&
            response.model!.minAmountRequired != 0 &&
            (goldBuyAmount ?? 0) < response.model!.minAmountRequired!) {
          goldAmountController!.text =
              response.model!.minAmountRequired!.toInt().toString();
          goldBuyAmount = response.model!.minAmountRequired;
          updateGoldAmount();
          showMaxCapText = false;
          showMinCapText = false;
          await animationController?.forward();
        }
        checkForSpecialCoupon(response.model!);

        appliedCoupon = response.model;

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
      "Asset": "Gold",
      "Min transaction": minTransaction == -1 ? "Not fetched" : minTransaction,
    });
  }

  void checkForSpecialCoupon(EligibleCouponResponseModel model) {
    if (couponList!.firstWhere((coupon) => coupon.code == model.code,
            orElse: CouponModel.none) ==
        CouponModel.none()) {
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
              id: ''));
      addSpecialCoupon = true;
      showCoupons = true;
    }
  }

  String showHappyHourSubtitle() {
    final int tambolaCost = AppConfig.getValue(AppConfigKey.tambola_cost);
    final HappyHourCampign? happyHourModel =
        locator.isRegistered<HappyHourCampign>()
            ? locator<HappyHourCampign>()
            : null;

    final int parsedGoldAmount =
        int.tryParse(goldAmountController?.text ?? '0') ?? 0;
    final num minAmount =
        num.tryParse(happyHourModel?.data?.minAmount.toString() ?? "0") ?? 0;

    if (parsedGoldAmount < tambolaCost) {
      totalTickets = 0;
      showInfoIcon = false;
      return "";
    }

    numberOfTambolaTickets = parsedGoldAmount ~/ tambolaCost;
    totalTickets = numberOfTambolaTickets;

    showHappyHour
        ? happyHourTickets = (happyHourModel?.data != null &&
                happyHourModel?.data?.rewards?[0].type == 'tt')
            ? happyHourModel?.data!.rewards![0].value
            : null
        : happyHourTickets = null;

    if (parsedGoldAmount >= minAmount && happyHourTickets != null) {
      totalTickets = numberOfTambolaTickets! + happyHourTickets!;
      showInfoIcon = true;
    } else {
      showInfoIcon = false;
    }

    return "+$totalTickets Tickets";
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
