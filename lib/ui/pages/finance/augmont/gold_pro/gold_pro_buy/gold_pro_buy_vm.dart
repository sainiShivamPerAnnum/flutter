import 'dart:async';
import 'dart:math';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/transaction_state_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/model/asset_options_model.dart';
import 'package:felloapp/core/model/aug_gold_rates_model.dart';
import 'package:felloapp/core/model/gold_pro_models/gold_pro_investment_reponse_model.dart';
import 'package:felloapp/core/ops/augmont_ops.dart';
import 'package:felloapp/core/repository/getters_repo.dart';
import 'package:felloapp/core/repository/payment_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/transaction_history_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/augmont_transaction_service.dart';
import 'package:felloapp/core/service/payments/bank_and_pan_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_buy/augmont_buy_vm.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_pro/gold_pro_buy/gold_pro_buy_components/gold_pro_choice_chips.dart';
import 'package:felloapp/ui/pages/finance/preffered_upi_option_mixin.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';

class GoldProBuyViewModel extends BaseViewModel
    with PaymentIntentMixin, NetbankingValidationMixin {
  @override
  BankAndPanService get bankingService => _bankAndPanService;

  final AugmontTransactionService _txnService =
      locator<AugmontTransactionService>();
  final UserService userService = locator<UserService>();
  final AugmontService _augmontModel = locator<AugmontService>();
  final CustomLogger _logger = locator<CustomLogger>();
  final BankAndPanService _bankAndPanService = locator<BankAndPanService>();
  final PaymentRepository _paymentRepo = locator<PaymentRepository>();
  final TxnHistoryService _txnHistoryService = locator<TxnHistoryService>();
  S locale = locator<S>();
  TextEditingController goldFieldController = TextEditingController(
      text: AppConfig.getValue(AppConfigKey.goldProInvestmentChips)[1]
          .toDouble()
          .toString());

  bool get isGoldBuyInProgress => _txnService.isGoldBuyInProgress;

  double minimumGrams =
      AppConfig.getValue(AppConfigKey.goldProInvestmentChips)[0].toDouble();
  double maximumGrams =
      AppConfig.getValue(AppConfigKey.goldProInvestmentChips)[4].toDouble();

  double edgeDifference =
      AppConfig.getValue(AppConfigKey.goldProInvestmentChips)[4].toDouble() -
          AppConfig.getValue(AppConfigKey.goldProInvestmentChips)[0].toDouble();
  double consecutiveDifference =
      AppConfig.getValue(AppConfigKey.goldProInvestmentChips)[1].toDouble() -
          AppConfig.getValue(AppConfigKey.goldProInvestmentChips)[0].toDouble();

  bool _isDescriptionView = false;
  double _totalGoldBalance = 0.0;
  double _currentGoldBalance = 0.0;
  double _additionalGoldBalance = 0;
  double _expectedGoldReturns = 0.0;
  double _totalGoldAmount = 0;
  bool _isGoldRateFetching = true;
  bool _isChecked = false;
  bool _isAutoLeaseChecked = true;
  AugmontRates? goldRates;

  List<GoldProChoiceChipsModel> chipsList = [
    GoldProChoiceChipsModel(
      isBest: false,
      isSelected: false,
      value:
          AppConfig.getValue(AppConfigKey.goldProInvestmentChips)[0].toDouble(),
    ),
    GoldProChoiceChipsModel(
      isBest: false,
      isSelected: true,
      value:
          AppConfig.getValue(AppConfigKey.goldProInvestmentChips)[1].toDouble(),
    ),
    GoldProChoiceChipsModel(
      isBest: true,
      isSelected: false,
      value:
          AppConfig.getValue(AppConfigKey.goldProInvestmentChips)[2].toDouble(),
    ),
    GoldProChoiceChipsModel(
      isBest: false,
      isSelected: false,
      value:
          AppConfig.getValue(AppConfigKey.goldProInvestmentChips)[3].toDouble(),
    ),
    GoldProChoiceChipsModel(
      isBest: false,
      isSelected: false,
      value:
          AppConfig.getValue(AppConfigKey.goldProInvestmentChips)[4].toDouble(),
    ),
  ];

  AssetOptionsModel? assetOptionsModel;
  bool isIntentFlow = true;
  String _unavailabilityText = "";

  String get unavailabilityText => _unavailabilityText;

  set unavailabilityText(String value) {
    _unavailabilityText = value;
    notifyListeners();
  }

  double get totalGoldAmount => _totalGoldAmount;

  set totalGoldAmount(double value) {
    _totalGoldAmount = value;
    _logger.d("Total Gold Amount: $_totalGoldAmount");
    notifyListeners();
  }

  double get totalGoldBalance => _totalGoldBalance;

  set totalGoldBalance(double value) {
    _totalGoldBalance = value;

    _additionalGoldBalance = BaseUtil.digitPrecision(
        max(totalGoldBalance - currentGoldBalance, 0), 4, false);
    print(
        "Total: $totalGoldBalance && Current: $currentGoldBalance && additional: $additionalGoldBalance");
    updateSliderValueFromGoldBalance();
    postUpdateChips();
    updateAmount();
    notifyListeners();
  }

  double get expectedGoldReturns => _expectedGoldReturns;

  set expectedGoldReturns(double value) {
    _expectedGoldReturns = value;
    notifyListeners();
  }

  double get currentGoldBalance => _currentGoldBalance;

  set currentGoldBalance(double value) {
    _currentGoldBalance = value;
    notifyListeners();
  }

  double get additionalGoldBalance => _additionalGoldBalance;

  set additionalGoldBalance(double value) {
    _additionalGoldBalance = value;
    notifyListeners();
  }

  bool get hasEnoughGoldBalanceForLease => additionalGoldBalance == 0;

  bool get isDescriptionView => _isDescriptionView;

  set isDescriptionView(value) {
    _isDescriptionView = value;
    notifyListeners();
  }

  double _sliderValue = 0.25;

  double get sliderValue => _sliderValue;

  set sliderValue(value) {
    _sliderValue = value;
    notifyListeners();
  }

  int _selectedChipIndex = 1;

  int get selectedChipIndex => _selectedChipIndex;

  set selectedChipIndex(value) {
    _selectedChipIndex = value;
    notifyListeners();
  }

  bool get isGoldRateFetching => _isGoldRateFetching;

  set isGoldRateFetching(value) {
    _isGoldRateFetching = value;
    notifyListeners();
  }

  bool get isChecked => _isChecked;
  bool get isAutoLeaseChecked => _isAutoLeaseChecked;

  set isChecked(bool value) {
    _isChecked = value;
    notifyListeners();
  }

  set isAutoLeaseChecked(bool value) {
    _isAutoLeaseChecked = value;
    notifyListeners();
  }

  bool _isGoldProUser = false;
  bool get isGoldProUser => _isGoldProUser;

  Future<void> init() async {
    state = ViewState.Busy;
    AppState.isGoldProBuyInProgress = false;
    _isGoldProUser =
        locator<UserService>().userPortfolio.augmont.fd.isGoldProUser;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _txnService.currentTransactionState = TransactionState.idle;
    });
    currentGoldBalance = BaseUtil.digitPrecision(
        userService.userFundWallet!.augGoldQuantity, 4, false);
    totalGoldBalance = chipsList[1].value;
    _isChecked = userService.userPortfolio.augmont.fd.isGoldProUser;
    await initAndSetPreferredPaymentOption();

    unawaited(fetchGoldRates());

    await verifyAugmontKyc();
    await getGoldProScheme();
    await getAssetOptionsModel().then((_) {
      isIntentFlow = assetOptionsModel!.data.intent;
    });

    setState(ViewState.Idle);
  }

  void dump() {
    goldFieldController.dispose();
  }

//VM Async Call Methods

  Future<bool> verifyAugmontKyc() async {
    if (!(_bankAndPanService.userKycData?.augmontKyc ?? false)) {
      final res = await _bankAndPanService.verifyAugmontKyc();
      return res;
    }
    return true;
  }

  Future<bool> getGoldProScheme() async {
    final res = await _paymentRepo.getGoldProScheme();
    if (res.isSuccess()) {
      _txnService.goldProScheme = res.model;
      return true;
    } else {
      unavailabilityText = res.errorMessage ??
          "${Constants.ASSET_GOLD_STAKE} not available at the moment, please try again after sometime";
      BaseUtil.showNegativeAlert(
          "Failed to fetch Gold Scheme", res.errorMessage);
      return false;
    }
  }

  Future<void> initiateGoldProTransaction() async {
    if (!isChecked) {
      BaseUtil.showNegativeAlert("Please accept the terms and conditions",
          "to continue saving in ${Constants.ASSET_GOLD_STAKE}");
      return;
    }
    AppState.isGoldProBuyInProgress = false;
    locator<AnalyticsService>()
        .track(eventName: AnalyticsEvents.goldProFinalSaveTapped, properties: {
      "grams to add": additionalGoldBalance,
      "amount to add": totalGoldAmount,
      "total lease value": totalGoldBalance,
      "current gold balance": currentGoldBalance,
      "expected returns": expectedGoldReturns,
      "returns percentage": 15.5
    });
    if (additionalGoldBalance == 0) {
      await _initiateLease();
    } else {
      await _initiateBuyAndLease();
    }
  }

  Future<void> _initiateBuyAndLease() async {
    await _txnService.initiateAugmontTransaction(
        details: GoldPurchaseDetails(
          goldBuyAmount: totalGoldAmount,
          goldRates: goldRates,
          couponCode: '',
          skipMl: false,
          goldInGrams: additionalGoldBalance,
          leaseQty: totalGoldBalance,
          isPro: true,
          upiChoice: selectedUpiApplication,
          isIntentFlow: assetOptionsModel!.data.intent,
        ),
        isAutoLeaseChecked: isAutoLeaseChecked);
  }

  GoldProInvestmentResponseModel? _leaseModel;
  GoldProInvestmentResponseModel? get leaseModel => _leaseModel;

  Future<void> _initiateLease() async {
    _txnService.isGoldBuyInProgress = true;
    AppState.blockNavigation();
    _txnService.currentGoldPurchaseDetails = GoldPurchaseDetails(
      goldBuyAmount: 0,
      goldRates: goldRates,
      couponCode: '',
      skipMl: false,
      goldInGrams: totalGoldBalance,
      leaseQty: totalGoldBalance,
      isPro: true,
    );
    _txnService.currentTxnAmount = 0;
    final res = await _paymentRepo.investInGoldPro(
        totalGoldBalance, _txnService.goldProScheme!.id, isAutoLeaseChecked);
    if (res.isSuccess()) {
      _leaseModel = res.model;
      _txnService.currentTransactionState = TransactionState.success;
      unawaited(locator<UserService>().getUserFundWalletData());
      unawaited(locator<UserService>().updatePortFolio());
      unawaited(_txnHistoryService.getGoldProTransactions(forced: true));
    } else {
      _txnService.isGoldBuyInProgress = false;
      BaseUtil.showNegativeAlert(res.errorMessage, "Please try again");
    }
    _txnService.isGoldBuyInProgress = false;
    AppState.unblockNavigation();
  }

//VM Async Helper Methods:

  Future<void> getAssetOptionsModel() async {
    final isNewUser = locator<UserService>().userSegments.contains(
          Constants.NEW_USER,
        );
    final res = await locator<GetterRepository>().getAssetOptions(
      'weekly',
      'gold',
      isNewUser: isNewUser,
    );
    if (res.code == 200) assetOptionsModel = res.model;
  }

//VM Helper Methods

  void onChipSelected(int index) {
    selectedChipIndex = index;
    totalGoldBalance = chipsList[selectedChipIndex].value;
    goldFieldController.text = totalGoldBalance.toString();
    switch (index) {
      case 0:
        updateSliderValue(0.0);
        break;
      case 1:
        updateSliderValue(0.25);
        break;
      case 2:
        updateSliderValue(0.5);
        break;
      case 3:
        updateSliderValue(0.75);
        break;
      case 4:
        updateSliderValue(1.0);
        break;
    }
    locator<AnalyticsService>().track(
      eventName: AnalyticsEvents.goldProGramsSelected,
      properties: {
        "grams": chipsList[selectedChipIndex].value,
        "best flag": chipsList[selectedChipIndex].isBest
      },
    );
  }

  void updateSliderValueFromGoldBalance() {
    double val = BaseUtil.digitPrecision(
        (totalGoldBalance - consecutiveDifference) / edgeDifference, 4);
    if (val >= 0 && val <= 1) sliderValue = val;
  }

  void updateSliderValue(double val) {
    sliderValue = val;
    totalGoldBalance = BaseUtil.digitPrecision(
        edgeDifference * val + consecutiveDifference, 1);
    goldFieldController.text = totalGoldBalance.toString();
    postUpdateChips();
  }

  void onTextFieldValueChanged(String val) {
    selectedChipIndex = -1;
    final value = double.tryParse(val);
    if (value != null) {
      totalGoldBalance = value;
    }
  }

  void decrementGoldBalance() {
    totalGoldBalance = BaseUtil.digitPrecision(totalGoldBalance, 1);
    if (totalGoldBalance <= minimumGrams) {
      totalGoldBalance = minimumGrams;
      goldFieldController.text = totalGoldBalance.toString();
      updateSliderValueFromGoldBalance();
      return;
    }
    Haptic.vibrate();
    totalGoldBalance -= 0.1;
    totalGoldBalance = BaseUtil.digitPrecision(totalGoldBalance, 1);
    goldFieldController.text = totalGoldBalance.toString();
    postUpdateChips();
  }

  void incrementGoldBalance() {
    totalGoldBalance = BaseUtil.digitPrecision(totalGoldBalance, 1);
    if (totalGoldBalance >= maximumGrams) {
      totalGoldBalance = maximumGrams;
      goldFieldController.text = totalGoldBalance.toString();
      updateSliderValueFromGoldBalance();
      return;
    }
    Haptic.vibrate();
    print("Before $totalGoldBalance");
    totalGoldBalance += 0.1;
    totalGoldBalance = BaseUtil.digitPrecision(totalGoldBalance, 1);
    goldFieldController.text = totalGoldBalance.toString();
    print("After $totalGoldBalance");
    postUpdateChips();
  }

  void postUpdateChips() {
    selectedChipIndex = -1;
    if (totalGoldBalance ==
        AppConfig.getValue(AppConfigKey.goldProInvestmentChips)[0].toDouble()) {
      selectedChipIndex = 0;
      Haptic.vibrate();
    } else if (totalGoldBalance ==
        AppConfig.getValue(AppConfigKey.goldProInvestmentChips)[1].toDouble()) {
      selectedChipIndex = 1;
      Haptic.vibrate();
    } else if (totalGoldBalance ==
        AppConfig.getValue(AppConfigKey.goldProInvestmentChips)[2].toDouble()) {
      selectedChipIndex = 2;
      Haptic.vibrate();
    } else if (totalGoldBalance ==
        AppConfig.getValue(AppConfigKey.goldProInvestmentChips)[3].toDouble()) {
      selectedChipIndex = 3;
      Haptic.vibrate();
    } else if (totalGoldBalance ==
        AppConfig.getValue(AppConfigKey.goldProInvestmentChips)[4].toDouble()) {
      selectedChipIndex = 4;
      Haptic.vibrate();
    }
  }

  void onProceedTapped() {
    Haptic.vibrate();
    locator<AnalyticsService>().track(
      eventName: AnalyticsEvents.proceedWithGoldPro,
      properties: {
        "total lease value": totalGoldBalance,
        "current gold balance": currentGoldBalance,
        "expected returns": expectedGoldReturns,
        "returns percentage": 15.5
      },
    );
    if (totalGoldBalance > maximumGrams) {
      BaseUtil.showNegativeAlert("Gold grams out of bound",
          "You can lease at most $maximumGrams grams");
      totalGoldBalance = maximumGrams;
      goldFieldController.text = "$maximumGrams";
      updateAmount();
      return;
    }
    if (totalGoldBalance < minimumGrams) {
      BaseUtil.showNegativeAlert("Gold grams too low to lease",
          "You have to lease at least $minimumGrams grams");
      totalGoldBalance = minimumGrams;
      goldFieldController.text = "$minimumGrams";
      updateAmount();
      return;
    }
    if (isGoldRateFetching) {
      BaseUtil.showNegativeAlert("Fetching latest gold rates", "Please wait");
      return;
    }
    _txnService.currentTransactionState = TransactionState.overView;
    AppState.isGoldProBuyInProgress = true;
  }

  void onCompleteKycTapped() {
    AppState.delegate!.parseRoute(Uri.parse('/kycVerify'));
    locator<AnalyticsService>().track(
      eventName: AnalyticsEvents.proceedWithKycGoldPro,
      properties: {
        "total lease value": totalGoldBalance,
        "current gold balance": currentGoldBalance,
        "expected returns": expectedGoldReturns,
        "returns percentage": 15.5
      },
    );
  }

  Future<void> fetchGoldRates() async {
    isGoldRateFetching = true;
    goldRates = await _augmontModel.getRates();
    updateAmount();
    isGoldRateFetching = false;
    if (goldRates == null) {
      BaseUtil.showNegativeAlert(
          locale.portalUnavailable, locale.currentRatesNotLoadedText1);
    }
  }

  void updateAmount() {
    double netTax =
        (goldRates?.cgstPercent ?? 0) + (goldRates?.sgstPercent ?? 0);

    if (goldBuyPrice != 0.0) {
      // If gold rate changes before request reaches to augmont gateway from
      // client.
      const variableAmount = 3;

      final amountWithPrecision = BaseUtil.digitPrecision(
          (goldBuyPrice! * additionalGoldBalance) +
              (netTax * goldBuyPrice! * additionalGoldBalance) / 100,
          2);

      // Add variable amount if
      totalGoldAmount = amountWithPrecision == 0
          ? amountWithPrecision
          : amountWithPrecision + variableAmount;

      double expectedGoldReturnsAmount = BaseUtil.digitPrecision(
          totalGoldBalance * goldBuyPrice! + netTax, 2, false);
      expectedGoldReturns =
          expectedGoldReturnsAmount + 0.155 * expectedGoldReturnsAmount * 5;
    } else {
      totalGoldAmount = 0.0;
      expectedGoldReturns = 0.0;
    }
  }

  double? get goldBuyPrice => goldRates != null ? goldRates!.goldBuyPrice : 0.0;

  double _getTaxOnAmount(double amount, double taxRate) {
    return BaseUtil.digitPrecision((amount * taxRate) / (100 + taxRate));
  }
}
