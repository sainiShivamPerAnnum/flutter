// ignore_for_file: empty_catches, avoid_setters_without_getters

import 'dart:async';
import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/model/asset_options_model.dart';
import 'package:felloapp/core/model/coupon_card_model.dart';
import 'package:felloapp/core/model/eligible_coupon_model.dart';
import 'package:felloapp/core/model/happy_hour_campign.dart';
import 'package:felloapp/core/model/timestamp_model.dart';
import 'package:felloapp/core/repository/coupons_repo.dart';
import 'package:felloapp/core/service/analytics/analyticsProperties.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/marketing_event_handler_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/lendbox_transaction_service.dart';
import 'package:felloapp/core/service/power_play_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/finance/lendbox/deposit/widget/flo_coupon_modal_sheet.dart';
import 'package:felloapp/ui/pages/finance/lendbox/deposit/widget/prompt.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/installed_upi_apps_finder.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:upi_pay/upi_pay.dart';

import '../../../../../core/repository/getters_repo.dart';

enum FloPrograms { lendBox8, lendBox10, lendBox12 }

class LendboxBuyViewModel extends BaseViewModel {
  final LendboxTransactionService _txnService =
      locator<LendboxTransactionService>();
  final AnalyticsService analyticsService = locator<AnalyticsService>();
  final CouponRepository _couponRepo = locator<CouponRepository>();
  final CustomLogger _logger = locator<CustomLogger>();

  S locale = locator<S>();

  double? incomingAmount;

  int lastTappedChipIndex = 1;
  bool _skipMl = false;

  FocusNode buyFieldNode = FocusNode();
  String? buyNotice;

  bool _isBuyInProgress = false;

  TextEditingController? amountController;
  AnimationController? animationController;

  // TextEditingController? vpaController;

  num minAmount = 100;
  num maxAmount = 50000;
  AssetOptionsModel? assetOptionsModel;
  List<CouponModel>? _couponList;
  int? numberOfTambolaTickets;
  int tambolaMultiplier = 1;

  int? totalTickets;
  int? happyHourTickets;

  CouponModel? _focusCoupon;
  EligibleCouponResponseModel? _appliedCoupon;
  bool _couponApplyInProgress = false;
  bool _showCoupons = false;

  int? _buyAmount = 0;
  bool isLendboxOldUser = false;
  late String floAssetType;
  double _fieldWidth = 0.0;
  bool _forcedBuy = false;
  String maturityPref = "NA";
  bool _showMaxCapText = false;
  bool _showMinCapText = false;
  String? couponCode;
  bool isSpecialCoupon = true;
  bool showCouponAppliedText = false;
  bool _addSpecialCoupon = false;
  int _selectedOption = -1;
  bool isIntentFlow = true;
  List<ApplicationMeta> appMetaList = [];
  UpiApplication? upiApplication;
  ApplicationMeta? selectedUpiApplication;

  ///  ---------- getter and setter ------------

  int? get buyAmount => _buyAmount;

  bool get isBuyInProgress => _isBuyInProgress;

  set buyAmount(int? value) {
    _buyAmount = value;
    notifyListeners();
  }

  bool get skipMl => _skipMl;

  set skipMl(bool value) {
    _skipMl = value;
  }

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

  bool get showCoupons => _showCoupons;

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

  set showCoupons(bool val) {
    _showCoupons = val;
    notifyListeners();
  }

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

  double get fieldWidth => _fieldWidth;

  set fieldWidth(value) {
    _fieldWidth = value;
    notifyListeners();
  }

  bool get forcedBuy => _forcedBuy;

  set forcedBuy(bool value) {
    _forcedBuy = value;
    log("forcedBuy $value");
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

  bool get addSpecialCoupon => _addSpecialCoupon;

  set addSpecialCoupon(value) {
    _addSpecialCoupon = value;
    notifyListeners();
  }

  int get selectedOption => _selectedOption;

  set selectedOption(int value) {
    _selectedOption = value;
    notifyListeners();
  }

  Future<void> init(
    int? amount,
    bool isSkipMilestone,
    TickerProvider vsync, {
    required String assetTypeFlow,
    String? initialCouponCode,
    String? entryPoint,
    bool quickCheckout = false,
  }) async {
    setState(ViewState.Busy);
    floAssetType = assetTypeFlow;
    _txnService.floAssetType = floAssetType;
    showHappyHour = locator<MarketingEventHandlerService>().showHappyHourBanner;
    animationController = AnimationController(
        vsync: vsync, duration: const Duration(milliseconds: 500));
    animationController?.addListener(listener);
    isLendboxOldUser =
        locator<UserService>().userSegments.contains(Constants.US_FLO_OLD);
    appMetaList = await UpiUtils.getUpiApps();
    await getAssetOptionsModel(entryPoint: entryPoint);
    isIntentFlow = assetOptionsModel!.data.intent;
    log("isLendboxOldUser $isLendboxOldUser");
    skipMl = isSkipMilestone;

    int? data = assetOptionsModel?.data.userOptions
        .firstWhere((element) => element.best,
            orElse: () => assetOptionsModel!.data.userOptions[1])
        .value;

    amountController = TextEditingController(
      text: amount?.toString() ?? data.toString(),
    );
    buyAmount = amount ?? data;

    lastTappedChipIndex = assetOptionsModel?.data.userOptions
            .indexWhere((element) => element.best) ??
        1;

    setState(ViewState.Idle);

    await getAvailableCoupons();

    await _applyInitialCoupon(
      initialCouponCode,
    );

    if (quickCheckout) {
      await initiateBuy();
    }
  }

  void listener() {
    if (animationController?.status == AnimationStatus.completed) {
      animationController?.reset();
    }
  }

  Future<void> getAssetOptionsModel({String? entryPoint}) async {
    final isNewUser = locator<UserService>().userSegments.contains(
          Constants.NEW_USER,
        );
    final res = await locator<GetterRepository>().getAssetOptions(
      'weekly',
      'flo',
      subType: floAssetType,
      isOldLendboxUser: isLendboxOldUser,
      isNewUser: isNewUser,
      entryPoint: entryPoint,
    );
    final model = res.model;
    if (res.code == 200 && model != null) {
      assetOptionsModel = model;
      minAmount = model.data.minAmount;
      maxAmount = model.data.maxAmount;
    }
    log(res.model?.message ?? '');
  }

  Future<void> initiateBuy() async {
    log("amountController ${amountController?.text}");
    if (couponApplyInProgress || _isBuyInProgress) return;

    _isBuyInProgress = true;
    notifyListeners();
    final amount = await initChecks();
    if (amount == 0) {
      _isBuyInProgress = false;
      forcedBuy = false;
      BaseUtil.showNegativeAlert(locale.noAmountEntered, locale.enterAmount);
      notifyListeners();
      return;
    }

    if (amount < minAmount) {
      _isBuyInProgress = false;
      forcedBuy = false;
      BaseUtil.showNegativeAlert(
          "Invalid Amount", "Please Enter Amount Greater than $minAmount");
      notifyListeners();
      return;
    }

    log(amount.toString());
    _isBuyInProgress = true;
    notifyListeners();
    trackCheckOut(amount.toDouble());
    await _txnService.initiateTransaction(
      FloPurchaseDetails(
        floAssetType: floAssetType,
        maturityPref: maturityPref,
        couponCode: appliedCoupon?.code ?? '',
        txnAmount: amount.toDouble(),
        skipMl: skipMl,
        upiChoice: selectedUpiApplication,
      ),
    );

    _isBuyInProgress = false;
    forcedBuy = false;
    notifyListeners();

    if (selectedUpiApplication != null) {
      analyticsService
          .track(eventName: AnalyticsEvents.intentUpiAppSelected, properties: {
        "floAssetType": floAssetType,
        "maturityPref": maturityPref,
        "couponCode": appliedCoupon?.code ?? '',
        "txnAmount": amount.toDouble(),
        "skipMl": skipMl,
        "upiChoice": selectedUpiApplication!.packageName,
        "abTesting": AppConfig.getValue(AppConfigKey.payment_brief_view)
            ? "with payment summary"
            : "without payment summary"
      });
    }
  }

  bool readOnly = true;

  showKeyBoard() {
    if (readOnly) {
      readOnly = false;
      notifyListeners();
    }
  }

  trackCheckOut(double? amount) {
    _txnService.currentTransactionAnalyticsDetails = {
      "Asset": "Flo",
      "Amount Entered": amount ?? 0,
      "Error message": "",
    };
    analyticsService.track(
      eventName: AnalyticsEvents.saveCheckout,
      properties: AnalyticsProperties.getDefaultPropertiesMap(
        extraValuesMap: {
          "Asset": floAssetType,
          "Amount Entered": amount ?? 0,
        },
      ),
    );
  }

  //2 Basic Checks
  Future<int> initChecks() async {
    buyAmount = int.tryParse(amountController?.text ?? "0") ?? 0;

    log("buyAmount $buyAmount && minAmount $minAmount && maxAmount $maxAmount");
    if (buyAmount == 0) {
      BaseUtil.showNegativeAlert(locale.noAmountEntered, locale.enterAmount);
      return 0;
    }

    if (buyAmount! < minAmount) {
      BaseUtil.showNegativeAlert(
        '${locale.minAmountIs}$minAmount',
        '${locale.enterAmountGreaterThan}$minAmount',
      );
      return 0;
    }

    if (buyAmount! > maxAmount) {
      BaseUtil.showNegativeAlert(
        '${locale.maxAmountIs}$maxAmount',
        '${locale.enterAmountLowerThan}$maxAmount',
      );
      return 0;
    }

    analyticsService.track(
        eventName: AnalyticsEvents.saveCheckout,
        properties:
            AnalyticsProperties.getDefaultPropertiesMap(extraValuesMap: {
          "iplPrediction": PowerPlayService.powerPlayDepositFlow,
          "Asset": floAssetType,
          "Amount Entered": amountController?.text,
          "Best flag": assetOptionsModel?.data.userOptions
              .firstWhere(
                  (element) =>
                      element.value.toString() == amountController!.text,
                  orElse: () => UserOption(order: 0, value: 0, best: false))
              .value,
          "Lock-in": getLockin(),
          "Maturity Decision": getMaturityTitle(),
          "coupon name": appliedCoupon?.code
        }));
    return buyAmount!;
  }

  String getLockin() {
    if (floAssetType == Constants.ASSET_TYPE_FLO_FELXI && isLendboxOldUser) {
      return "1 month";
    }

    if (floAssetType == Constants.ASSET_TYPE_FLO_FELXI && !isLendboxOldUser) {
      return "1 week";
    }
    if (floAssetType == Constants.ASSET_TYPE_FLO_FIXED_3) {
      return "3 month";
    }
    if (floAssetType == Constants.ASSET_TYPE_FLO_FIXED_6) {
      return "6 month";
    }
    return "";
  }

  String getMaturityTitle() {
    if (selectedOption == 0) {
      return "ReInvest in ${floAssetType == Constants.ASSET_TYPE_FLO_FIXED_6 ? 12 : 10}%";
    }
    if (selectedOption == 1) {
      return "Move to ${floAssetType == Constants.ASSET_TYPE_FLO_FIXED_6 ? 10 : 8}%";
    }
    if (selectedOption == 2) {
      return "Withdraw to bank";
    }
    return "NA";
    // if(selectedOption == -2){
    //   return "Decide Later";
    // }
  }

  void navigateToKycScreen() {
    analyticsService
        .track(eventName: AnalyticsEvents.completeKYCTapped, properties: {
      "location": "Fello Felo Invest",
      "Total invested amount": AnalyticsProperties.getGoldInvestedAmount() +
          AnalyticsProperties.getFelloFloAmount(),
      "Amount invested in gold": AnalyticsProperties.getGoldInvestedAmount(),
      "Grams of gold owned": AnalyticsProperties.getGoldQuantityInGrams(),
      "Amount invested in Flo": AnalyticsProperties.getFelloFloAmount(),
    });
    AppState.delegate!.appState.currentAction = PageAction(
      state: PageState.addPage,
      page: KycDetailsPageConfig,
    );
  }

  Future<void> getAvailableCoupons() async {
    final ApiResponse<List<CouponModel>> couponsRes =
        await _couponRepo.getCoupons(assetType: floAssetType);
    if (couponsRes.code == 200 &&
        couponsRes.model != null &&
        (couponsRes.model?.length ?? 0) >= 1) {
      couponList = couponsRes.model;
      if (couponList?[0].priority == 1) focusCoupon = couponList?[0];
      showCoupons = true;
    }
  }

  int getAmount(int amount) {
    if (amount > amount.toInt()) {
      return amount;
    } else {
      return amount.toInt();
    }
  }

  String showHappyHourSubtitle() {
    final int parsedFloAmount =
        int.tryParse(amountController?.text ?? '0') ?? 0;

    if (parsedFloAmount < this.minAmount) {
      showInfoIcon = false;
      return "";
    }

    final int tambolaCost = AppConfig.getValue(AppConfigKey.tambola_cost);
    final HappyHourCampign? happyHourModel =
        locator.isRegistered<HappyHourCampign>()
            ? locator<HappyHourCampign>()
            : null;

    final num minAmount =
        num.tryParse(happyHourModel?.data?.minAmount.toString() ?? '0') ?? 0;

    if (parsedFloAmount < tambolaCost) {
      totalTickets = 0;
      showInfoIcon = false;
      return '';
    }

    numberOfTambolaTickets = parsedFloAmount ~/ tambolaCost;
    totalTickets = numberOfTambolaTickets! * tambolaMultiplier;

    happyHourTickets =
        showHappyHour && happyHourModel?.data?.rewards?[0].type == 'tt'
            ? happyHourModel!.data!.rewards![0].value
            : null;

    if (parsedFloAmount >= minAmount && happyHourTickets != null) {
      totalTickets =
          (numberOfTambolaTickets! * tambolaMultiplier) + happyHourTickets!;
      showInfoIcon = true;
    } else {
      showInfoIcon = false;
    }

    return '+$totalTickets Tickets';
  }

  void onChipClick(int index) {
    log("_isBuyInProgress $_isBuyInProgress");
    if (couponApplyInProgress || _isBuyInProgress || forcedBuy) return;
    Haptic.vibrate();
    lastTappedChipIndex = index;
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    buyAmount = assetOptionsModel?.data.userOptions[index].value.toInt();
    amountController!.text = buyAmount!.toString();

    appliedCoupon = null;

    analyticsService
        .track(eventName: AnalyticsEvents.suggestedAmountTapped, properties: {
      'order': index,
      'Asset': floAssetType,
      'Amount': assetOptionsModel?.data.userOptions[index].value,
      'Best flag': assetOptionsModel?.data.userOptions
          .firstWhere((element) => element.best,
              orElse: () => UserOption(order: 0, value: 0, best: false))
          .value
    });

    updateFieldWidth();
    notifyListeners();
  }

  onValueChanged(String val) {
    if (showMaxCapText) showMaxCapText = false;
    if (showMinCapText) showMinCapText = false;
    if (val.isNotEmpty) {
      if (int.tryParse(val.trim())! > maxAmount) {
        buyAmount = maxAmount.toInt();
        showMaxCapText = true;
        amountController!.text = buyAmount!.toInt().toString();
      } else {
        buyAmount = int.tryParse(val);
        if ((buyAmount ?? 0.0) < minAmount) showMinCapText = true;
        for (int i = 0; i < assetOptionsModel!.data.userOptions.length; i++) {
          if (buyAmount == assetOptionsModel!.data.userOptions[i].value) {
            lastTappedChipIndex = i;
            break;
          }
        }
      }
    } else {
      buyAmount = 0;
    }

    AppState.amt = (buyAmount ?? 0) * 1.0;

    updateFieldWidth();

    appliedCoupon = null;
  }

  String calculateAmountAfterMaturity(String amount) {
    int interest = floAssetType == Constants.ASSET_TYPE_FLO_FIXED_6 ? 12 : 10;

    double principal = double.tryParse(amount) ?? 0.0;
    double rateOfInterest = interest / 100.0;
    int timeInMonths = floAssetType == Constants.ASSET_TYPE_FLO_FIXED_6 ? 2 : 4;

    // 0.12 / 365 * amt * (365 / 2)
    //0.10 / 365 * amt * (365 / 4)

    double amountAfterMonths =
        rateOfInterest / 365 * principal * (365 / timeInMonths);

    return (principal + amountAfterMonths).toStringAsFixed(2);
  }

  void openReinvestBottomSheet() {
    BaseUtil.openModalBottomSheet(
      isBarrierDismissible: true,
      addToScreenStack: true,
      backgroundColor: const Color(0xff1B262C),
      content: ReInvestPrompt(
        amount: amountController?.text ?? '0',
        assetType: floAssetType,
        model: this,
      ),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(SizeConfig.roundness24),
        topRight: Radius.circular(SizeConfig.roundness24),
      ),
      hapticVibrate: true,
      isScrollControlled: true,
    );
  }

  void showOfferModal(LendboxBuyViewModel? model) {
    BaseUtil.openModalBottomSheet(
      content: FloCouponModalSheet(model: model),
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

  Widget showReinvestSubTitle() {
    final maturityAmount =
        calculateAmountAfterMaturity(amountController?.text ?? "0");

    String getText() {
      if (selectedOption == -1) {
        return "What will happen at maturity?";
      }
      if (selectedOption == 3) {
        return "Withdrawing to your bank account after maturity";
      }
      if (selectedOption == 1) {
        return "Re-investing ₹$maturityAmount in ${floAssetType == Constants.ASSET_TYPE_FLO_FIXED_6 ? "12" : "10"}% Flo";
      }
      if (selectedOption == 2) {
        return "Investing ₹$maturityAmount in ${floAssetType == Constants.ASSET_TYPE_FLO_FIXED_6 ? "12" : "10"}% Flo after maturity";
      }

      if (selectedOption == -2) {
        return "We will contact you before the maturity to help you decide";
      }
      return 'What will happen at maturity?';
    }

    return Flexible(
      child: Text(
        getText(),
        style: TextStyles.sourceSans.body3.colour(Colors.white),
        textAlign: TextAlign.left,
        maxLines: 2,
      ),
    );
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
    if (couponCode == null || couponApplyInProgress || isBuyInProgress) return;

    int order = -1;
    int? minTransaction = -1;
    int counter = 0;
    isSpecialCoupon = true;
    String description = '';
    for (final c in couponList!) {
      if (c.code == couponCode) {
        order = counter;
        isSpecialCoupon = false;
        description = c.description ?? '';
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
      uid: locator<UserService>().baseUser!.uid,
      amount: buyAmount!.toInt(),
      couponcode: couponCode,
      assetType: floAssetType,
    );

    couponApplyInProgress = false;
    this.couponCode = null;
    if (response.code == 200) {
      if (response.model!.flag == true) {
        if (response.model!.minAmountRequired != null &&
            response.model!.minAmountRequired.toString().isNotEmpty &&
            response.model!.minAmountRequired != 0 &&
            (buyAmount ?? 0) < response.model!.minAmountRequired!) {
          amountController!.text =
              response.model!.minAmountRequired!.toInt().toString();
          buyAmount = response.model!.minAmountRequired?.toInt();
          // updateGoldAmount();
          showMaxCapText = false;
          showMinCapText = false;
          await animationController?.forward();
          updateFieldWidth();
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
    analyticsService
        .track(eventName: AnalyticsEvents.saveBuyCoupon, properties: {
      "Asset": floAssetType,
      "Manual Code entry": isManuallyTyped,
      "Order of coupon in list": order == -1 ? "Not in list" : order.toString(),
      "Coupon Name": couponCode,
      "description": description,
      "Error message": response.code == 400 ? response.model?.message : "",
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
              description: model.message,
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

  void updateFieldWidth() {
    int n = amountController!.text.length;
    if (n == 0) n++;
    _fieldWidth = SizeConfig.padding40 * n.toDouble();
    amountController!.selection = TextSelection.fromPosition(
        TextPosition(offset: amountController!.text.length));
  }
}
