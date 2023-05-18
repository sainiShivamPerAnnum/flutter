import 'dart:core';
import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
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
import 'package:felloapp/core/service/payments/lendbox_transaction_service.dart';
import 'package:felloapp/core/service/power_play_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/dialogs/negative_dialog.dart';
import 'package:felloapp/ui/modalsheets/coupon_modal_sheet.dart';
import 'package:felloapp/ui/pages/buy_flow/buy_modal_sheet.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:upi_pay/upi_pay.dart';

//TODO : add location for save checkout [ journey, save, asset details, challenges,promos]

enum Asset { gold, flo }

class BuyViewModel extends BaseViewModel {
  static const int STATUS_UNAVAILABLE = 0;
  static const int STATUS_OPEN = 2;

  final CustomLogger _logger = locator<CustomLogger>();
  final DBModel _dbModel = locator<DBModel>();
  final AugmontService _augmontModel = locator<AugmontService>();
  final UserService _userService = locator<UserService>();
  final AugmontTransactionService augTxnService =
      locator<AugmontTransactionService>();
  final LendboxTransactionService _lendBoxTxnService =
      locator<LendboxTransactionService>();

  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  final CouponRepository _couponRepo = locator<CouponRepository>();

  // final PaytmService? _paytmService = locator<PaytmService>();
  S locale = locator<S>();
  AssetOptionsModel? assetOptionsModel;
  double? incomingAmount;
  List<ApplicationMeta> appMetaList = [];
  UpiApplication? upiApplication;
  String? selectedUpiApplicationName;
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
  Asset? _selectedAsset;
  bool _isBuyInProgress = false;

  bool get isBuyInProgress => _isBuyInProgress;

  bool _skipMl = false;
  double _fieldWidth = 0.0;
  AnimationController? animationController;

  Asset? get selectedAsset => _selectedAsset;

  set selectedAsset(Asset? value) {
    _selectedAsset = value;
    // notifyListeners();
  }

  get fieldWidth => _fieldWidth;

  set fieldWidth(value) {
    _fieldWidth = value;
    notifyListeners();
  }

  String? couponCode;

  // bool _isSubscriptionInProgress = false;
  bool _couponApplyInProgress = false;
  bool _showCoupons = false;
  bool _augmontSecondFetchDone = false;

  AugmontRates? goldRates;
  String? userAugmontState;
  FocusNode buyFieldNode = FocusNode();
  String? buyNotice;

  double? _goldBuyAmount = 0;
  double _goldAmountInGrams = 0.0;

  double? get goldBuyAmount => _goldBuyAmount;

  double _floBuyAmount = 0;

  double get floBuyAmount => _floBuyAmount;

  final double minAmount = 100;
  final double maxAmount = 50000;

  set floBuyAmount(double value) {
    _floBuyAmount = value;
    notifyListeners();
  }

  int? numberOfTambolaTickets;

  int? totalTickets;
  int? happyHourTickets;
  double? initialAmount;

  set goldBuyAmount(double? value) {
    _goldBuyAmount = value;
    notifyListeners();
  }

  get goldAmountInGrams => _goldAmountInGrams;

  set goldAmountInGrams(value) {
    _goldAmountInGrams = value;
    notifyListeners();
  }

  TextEditingController? amountController;
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

  get isGoldBuyInProgress => augTxnService.isGoldBuyInProgress;

  get augmontObjectSecondFetchDone => _augmontSecondFetchDone;

  set isGoldBuyInProgress(value) {
    _isGoldBuyInProgress = value;
    notifyListeners();
  }

  get status => _status;

  set status(value) {
    _status = value;
    notifyListeners();
  }

  get showMaxCapText => _showMaxCapText;

  set showMaxCapText(value) {
    _showMaxCapText = value;
    notifyListeners();
  }

  get showMinCapText => _showMinCapText;

  set showMinCapText(value) {
    _showMinCapText = value;
    notifyListeners();
  }

  get isGoldRateFetching => _isGoldRateFetching;

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

  get addSpecialCoupon => _addSpecialCoupon;

  set addSpecialCoupon(value) {
    _addSpecialCoupon = value;
    notifyListeners();
  }

  bool _showInfoIcon = false;

  bool get showInfoIcon => _showInfoIcon;

  set showInfoIcon(bool value) {
    _showInfoIcon = value;
  }

  late bool showHappyHour;

  bool readOnly = true;

  Future<void> init(int? amount, bool isSkipMilestone, TickerProvider vsync,
      {InvestmentType? investmentType}) async {
    // resetBuyOptions();

    setState(ViewState.Busy);

    initialAmount = amount?.toDouble() ?? 0;
    showHappyHour = locator<MarketingEventHandlerService>().showHappyHourBanner;

    animationController = AnimationController(
        vsync: vsync, duration: const Duration(milliseconds: 500));
    await getAssetOptionsModel(investmentType);
    animationController?.addListener(listnear);
    skipMl = isSkipMilestone;
    incomingAmount = amount?.toDouble() ?? 0;

    amountController = TextEditingController(
        text: amount?.toString() ??
            assetOptionsModel!.data.userOptions[1].value.toString());
    fieldWidth =
        SizeConfig.padding40 * amountController!.text.length.toDouble();

    if (investmentAsset == InvestmentType.AUGGOLD99) {
      goldBuyAmount = amount?.toDouble() ??
          assetOptionsModel!.data.userOptions[1].value.toDouble();
      if (goldBuyAmount != assetOptionsModel?.data.userOptions[1].value) {
        lastTappedChipIndex = -1;
      }
      fetchGoldRates();
      status = checkAugmontStatus();
    }
    getAvailableCoupons();

    if (investmentType == InvestmentType.AUGGOLD99) {
      userAugmontState = await CacheManager.readCache(key: "UserAugmontState");
    }

    setState(ViewState.Idle);
  }

  Future<void> getAssetOptionsModel(InvestmentType? investmentType) async {
    var _asset;
    if (investmentType == null) {
      _asset = 'gold';
    } else {
      _asset = investmentType == InvestmentType.AUGGOLD99 ? 'gold' : 'flo';
    }

    final res =
        await locator<GetterRepository>().getAssetOptions('weekly', _asset);
    if (res.code == 200) assetOptionsModel = res.model;
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

  //INIT CHECKS
  // checkIfDepositIsLocked() {
  //   if (_userService.userAugmontDetails != null &&
  //       _userService.userAugmontDetails.depNotice != null &&
  //       _userService.userAugmontDetails.depNotice.isNotEmpty)
  //     buyNotice = _userService.userAugmontDetails.depNotice;
  // }dis

  // delayedAugmontCall() async {
  //   if (_userService.userAugmontDetails == null && !_augmontSecondFetchDone) {
  //     await Future.delayed(Duration(seconds: 2));
  //     // await _userService.fetchUserAugmontDetail();
  //     _augmontSecondFetchDone = true;
  //     notifyListeners();
  //   }
  // }

  // fetchNotices() async {
  //   buyNotice = await _dbModel!.showAugmontBuyNotice();
  // }

  resetBuyOptions() async {
    if (selectedAsset == Asset.gold) {
      goldBuyAmount = assetOptionsModel?.data.userOptions[1].value.toDouble();
    } else {
      floBuyAmount =
          assetOptionsModel?.data.userOptions[1].value.toDouble() ?? 0;
    }

    amountController!.text =
        assetOptionsModel?.data.userOptions[1].value.toInt().toString() ?? '';
    appliedCoupon = null;
    lastTappedChipIndex = 1;
    notifyListeners();

    await getAssetOptionsModel(investmentAsset);

    if (investmentAsset == InvestmentType.AUGGOLD99) {
      if (goldBuyAmount != assetOptionsModel?.data.userOptions[1].value) {
        lastTappedChipIndex = -1;
      }
      fetchGoldRates();
      status = checkAugmontStatus();
    }
  }

  //BUY FLOW
  //1
  initiateBuy() async {
    _isBuyInProgress = true;
    if (augTxnService.isGoldSellInProgress || couponApplyInProgress) return;
    augTxnService.isGoldBuyInProgress = true;
    if (!await initChecks()) {
      augTxnService.isGoldBuyInProgress = false;
      return;
    }
    _isBuyInProgress = true;
    await augTxnService!.initiateAugmontTransaction(
      details: GoldPurchaseDetails(
        goldBuyAmount: goldBuyAmount,
        goldRates: goldRates,
        couponCode: appliedCoupon?.code ?? '',
        skipMl: skipMl ?? false,
        goldInGrams: goldAmountInGrams,
      ),
    );
    _isBuyInProgress = false;
    notifyListeners();
  }

  initiateFloBuy() async {
    _isBuyInProgress = true;
    notifyListeners();
    final amount = await initFloChecks();
    if (amount == 0) {
      _isBuyInProgress = false;
      notifyListeners();
      return;
    }

    log(amount.toString());
    _isBuyInProgress = true;
    notifyListeners();
    trackFloCheckOut(amount.toDouble());
    await _lendBoxTxnService.initiateTransaction(amount.toDouble(), skipMl);
    _isBuyInProgress = false;
    notifyListeners();
  }

  //2 Basic Checks
  Future<bool> initChecks() async {
    _isBuyInProgress = false;
    if (status == STATUS_UNAVAILABLE) {
      trackCheckOOutEvent("Status was unavilable");
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
    if (goldBuyAmount! < 10) {
      showMinCapText = true;
      return false;
    }

    // if (_userService.userAugmontDetails.isDepLocked) {
    //   BaseUtil.showNegativeAlert(
    //     'Purchase Failed',
    //     "${buyNotice ?? 'Gold buying is currently on hold. Please try again after sometime.'}",
    //   );
    //   trackCheckOOutEvent(
    //       "Purchase Failed,'Gold buying is currently on hold. Please try again after sometime.");

    //   return false;
    // }

    bool _disabled = await _dbModel!.isAugmontBuyDisabled();
    if (_disabled != null && _disabled) {
      isGoldBuyInProgress = false;
      BaseUtil.showNegativeAlert(
        locale.purchaseFailed,
        locale.goldBuyHold,
      );
      trackCheckOOutEvent(
          "Purchase Failed,'Gold buying is currently on hold. Please try again after sometime.");
      return false;
    }

    trackCheckOOutEvent("");
    return true;
  }

  Future<int> initFloChecks() async {
    final buyAmount = int.tryParse(amountController!.text) ?? 0;

    if (buyAmount == 0) {
      BaseUtil.showNegativeAlert(locale.noAmountEntered, locale.enterAmount);
      return 0;
    }

    if (buyAmount < minAmount) {
      BaseUtil.showNegativeAlert(
        '${locale.minAmountIs}$minAmount',
        '${locale.enterAmountGreaterThan}$minAmount',
      );
      return 0;
    }

    if (buyAmount > maxAmount) {
      BaseUtil.showNegativeAlert(
        '${locale.maxAmountIs}$maxAmount',
        '${locale.enterAmountLowerThan}$maxAmount',
      );
      return 0;
    }

    _analyticsService!.track(
        eventName: AnalyticsEvents.saveCheckout,
        properties:
            AnalyticsProperties.getDefaultPropertiesMap(extraValuesMap: {
          "iplPrediction": PowerPlayService.powerPlayDepositFlow,
          "Asset": "Flo",
          "Amount Entered": amountController?.text,
          "Best flag": assetOptionsModel?.data.userOptions
              .firstWhere(
                  (element) =>
                      element.value.toString() == amountController!.text,
                  orElse: () => UserOption(order: 0, value: 0, best: false))
              .value
        }));
    return buyAmount;
  }

  trackCheckOOutEvent(String errorMessage) {
    augTxnService.currentTransactionAnalyticsDetails = {
      //   "Asset": "Flo",
      // "Amount Entered": lboxAmount!.text,
      // "Best flag": goldAmountController!.text ==
      //         assetOptionsModel?.data.userOptions[2].value.toString()
      //     ? true
      //     : false,
      // "Error message": errorMessage,
      "iplPrediction": PowerPlayService.powerPlayDepositFlow,
      "Asset": "Gold",
      "Coupon Code":
          appliedCoupon != null ? appliedCoupon?.code : "Not Applied",
      "Amount Entered": amountController!.text,
      "Gold Weight": goldAmountInGrams,
      "Per gram rate": goldRates?.goldBuyPrice,
      "Best flag": amountController!.text ==
              assetOptionsModel?.data.userOptions[2].value.toString()
          ? true
          : false,
      "Error message": errorMessage,
    };
    _analyticsService!.track(
        eventName: AnalyticsEvents.saveCheckout,
        properties:
            AnalyticsProperties.getDefaultPropertiesMap(extraValuesMap: {
          "Asset": "Gold",
          "Coupon Code":
              appliedCoupon != null ? appliedCoupon!.code : "Not Applied",
          "Amount Entered": amountController!.text,
          "Gold Weight": goldAmountInGrams,
          "Per gram rate": goldRates?.goldBuyPrice,
          "Best flag": assetOptionsModel?.data.userOptions
              .firstWhere(
                (element) => element.value.toString() == amountController!.text,
                orElse: () => UserOption(order: 0, value: 0, best: false),
              )
              .best,
          "Error message": errorMessage,
        }));
  }

  onChipClick(int index) {
    if (couponApplyInProgress ||
        isGoldBuyInProgress ||
        augTxnService.isGoldBuyInProgress) return;
    showMaxCapText = false;
    showMinCapText = false;
    addSpecialCoupon = false;
    Haptic.vibrate();
    lastTappedChipIndex = index;
    // buyFieldNode.unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    goldBuyAmount = assetOptionsModel?.data.userOptions[index].value.toDouble();
    amountController!.text = goldBuyAmount!.toInt().toString();
    updateGoldAmount();
    amountController!.selection = TextSelection.fromPosition(
        TextPosition(offset: amountController!.text.length));
    //checkIfCouponIsStillApplicable();
    appliedCoupon = null;
    _analyticsService
        .track(eventName: AnalyticsEvents.suggestedAmountTapped, properties: {
      'order': index,
      'Amount': assetOptionsModel?.data.userOptions[index].value,
      'Best flag': assetOptionsModel?.data.userOptions
          .firstWhere((element) => element.best,
              orElse: () => UserOption(order: 0, value: 0, best: false))
          .value
    });
    notifyListeners();
  }

  String showHappyHourSubtitle() {
    final int tambolaCost = AppConfig.getValue(AppConfigKey.tambola_cost);
    final HappyHourCampign? happyHourModel =
        locator.isRegistered<HappyHourCampign>()
            ? locator<HappyHourCampign>()
            : null;

    final int parsedGoldAmount =
        int.tryParse(amountController?.text ?? '0') ?? 0;
    final num minAmount =
        num.tryParse(happyHourModel?.data?.minAmount.toString() ?? "0") ?? 0;

    if (parsedGoldAmount < tambolaCost) {
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

    return "+$totalTickets Tambola Tickets";
  }

  // UI ESSENTIALS

  // Widget amountChip(int index) {

  //   return AmountChip(
  //     isActive: lastTappedChipIndex == index,
  //     amt: amt,
  //     isBest: index == 2,
  //     onClick: (int amount) async {
  //       if (couponApplyInProgress ||
  //           isGoldBuyInProgress ||
  //           _augTxnService.isGoldBuyInProgress) return;
  //       showMaxCapText = false;
  //       showMinCapText = false;
  //       Haptic.vibrate();
  //       lastTappedChipIndex = index;
  //       // buyFieldNode.unfocus();
  //       SystemChannels.textInput.invokeMethod('TextInput.hide');
  //       goldBuyAmount = chipAmountList[index].toDouble();
  //       goldAmountController.text = goldBuyAmount.toInt().toString();
  //       updateGoldAmount();
  //       //checkIfCouponIsStillApplicable();
  //       appliedCoupon = null;
  //       _analyticsService.track(
  //           eventName: AnalyticsEvents.suggestedAmountTapped,
  //           properties: {
  //             'order': index,
  //             'Amount': amt,
  //             'Best flag': index == 2
  //           });
  //       notifyListeners();
  //     },
  //   );
  // }

  updateGoldAmount() {
    if (amountController!.text.isEmpty ||
        double.tryParse(amountController!.text) == null) {
      goldAmountInGrams = 0.0;
    } else {
      double? netTax =
          (goldRates?.cgstPercent ?? 0) + (goldRates?.sgstPercent ?? 0);
      double enteredAmount = double.tryParse(amountController!.text)!;
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
        ((amountController!.text != null && amountController!.text.isNotEmpty)
            ? amountController!.text.length.toDouble()
            : 0.5);
    refresh();
  }

  double getTaxOnAmount(double amount, double taxRate) {
    return BaseUtil.digitPrecision((amount * taxRate) / (100 + taxRate));
  }

  fetchGoldRates() async {
    isGoldRateFetching = true;
    goldRates = await _augmontModel!.getRates();
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
    _logger!.d("Value: $val");
    if (showMaxCapText) showMaxCapText = false;
    if (showMinCapText) showMinCapText = false;
    addSpecialCoupon = false;

    if (selectedAsset == Asset.gold) {
      if (val != null && val.isNotEmpty) {
        if (double.tryParse(val.trim())! > 50000.0) {
          goldBuyAmount = 50000;
          amountController!.text = goldBuyAmount!.toInt().toString();
          updateGoldAmount();
          showMaxCapText = true;
          amountController!.selection = TextSelection.fromPosition(
              TextPosition(offset: amountController!.text.length));
        } else {
          goldBuyAmount = double.tryParse(val);
          if ((goldBuyAmount ?? 0.0) < 10.0) showMinCapText = true;
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
    }

    if (selectedAsset == Asset.flo) {
      if (val != null && val.isNotEmpty) {
        if (double.tryParse(val.trim())! > 50000.0) {
          floBuyAmount = 50000;
          amountController!.text = floBuyAmount.toInt().toString();
          showMaxCapText = true;
          amountController!.selection = TextSelection.fromPosition(
              TextPosition(offset: amountController!.text.length));
        } else {
          floBuyAmount = double.tryParse(val) ?? 0;
          if (floBuyAmount < 10.0) showMinCapText = true;
        }
      } else {
        floBuyAmount = 0;
      }
    }

    appliedCoupon = null;
  }

  int checkAugmontStatus() {
    //check who is allowed to deposit
    String _perm =
        AppConfig.getValue(AppConfigKey.augmont_deposit_permission).toString();

    log("Augmont permission: $_perm");

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
      log("Checking specific user permission => ${_userService!.baseUser!.isAugmontEnabled}");

      if (_userService!.baseUser!.isAugmontEnabled != null &&
          _userService!.baseUser!.isAugmontEnabled!) {
        //this specific user is allowed to use Augmont
        _isAllowed = true;
      } else {
        _isAllowed = false;
      }
    } else {
      _isAllowed = true;
    }

    log("Augmont status: $_isAllowed");

    if (!_isAllowed) {
      return STATUS_UNAVAILABLE;
    } else {
      return STATUS_OPEN;
    }
  }

  void showOfferModal(BuyViewModel? model) {
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

  getAmount(double amount) {
    if (amount > amount.toInt()) {
      return amount;
    } else {
      return amount.toInt();
    }
  }

  void navigateToKycScreen() {
    _analyticsService!
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

//----------------------------------------------- COUPON LOGIC -------------------------------

  getAvailableCoupons() async {
    final ApiResponse<List<CouponModel>> couponsRes =
        await _couponRepo!.getCoupons();
    if (couponsRes.code == 200) {
      couponList = couponsRes.model;
      if (couponList![0].priority == 1) focusCoupon = couponList![0];
      showCoupons = true;
    }
  }

  Future applyCoupon(String? couponCode, bool isManuallyTyped) async {
    if (couponApplyInProgress ||
        isGoldBuyInProgress ||
        augTxnService.isGoldBuyInProgress) return;

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
        await _couponRepo!.getEligibleCoupon(
      uid: _userService!.baseUser!.uid,
      amount: goldBuyAmount!.toInt(),
      couponcode: couponCode,
    );

    couponApplyInProgress = false;
    this.couponCode = null;
    if (response.code == 200) {
      if (response.model!.flag == true) {
        if (response.model!.minAmountRequired != null &&
            response.model!.minAmountRequired.toString().isNotEmpty &&
            response.model!.minAmountRequired != 0) {
          amountController!.text =
              response.model!.minAmountRequired!.toInt().toString();
          goldBuyAmount = response.model!.minAmountRequired;
          updateGoldAmount();
          showMaxCapText = false;
          showMinCapText = false;
          animationController?.forward();
        }
        checkForSpecialCoupon(response.model!);

        appliedCoupon = response.model;

        BaseUtil.showPositiveAlert(
            locale.couponAppliedSucc, response?.model?.message);
      } else {
        BaseUtil.showNegativeAlert(
            locale.couponCannotBeApplied, response?.model?.message);
      }
    } else if (response.code == 400) {
      BaseUtil.showNegativeAlert(locale.couponNotApplied,
          response?.errorMessage ?? locale.anotherCoupon);
    } else {
      BaseUtil.showNegativeAlert(locale.couponNotApplied, locale.anotherCoupon);
    }
    _analyticsService!
        .track(eventName: AnalyticsEvents.saveBuyCoupon, properties: {
      "Manual Code entry": isManuallyTyped,
      "Order of coupon in list": order == -1 ? "Not in list" : order.toString(),
      "Coupon Name": couponCode,
      "Error message": response.code == 400 ? response?.model?.message : "",
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

  void trackFloCheckOut(double? amount) {
    _lendBoxTxnService.currentTransactionAnalyticsDetails = {
      "Asset": "Flo",
      "Amount Entered": amount ?? 0,
      "Error message": "",
    };
    _analyticsService!.track(
      eventName: AnalyticsEvents.saveCheckout,
      properties: AnalyticsProperties.getDefaultPropertiesMap(
        extraValuesMap: {
          "Asset": "Flo",
          "Amount Entered": amount ?? 0,
        },
      ),
    );
  }
}

class PendingDialog extends StatelessWidget {
  final String title, subtitle, duration;

  const PendingDialog(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.duration});

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
