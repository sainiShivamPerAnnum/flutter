import 'dart:async';
import 'dart:math';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/transaction_state_enum.dart';
import 'package:felloapp/core/model/asset_options_model.dart';
import 'package:felloapp/core/model/aug_gold_rates_model.dart';
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
import 'package:felloapp/ui/pages/finance/augmont/gold_buy/widgets/view_breakdown.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_pro/gold_pro_buy/gold_pro_buy_components/gold_pro_choice_chips.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/installed_upi_apps_finder.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:upi_pay/upi_pay.dart';

class GoldProBuyViewModel extends BaseViewModel {
  final AugmontTransactionService _txnService =
      locator<AugmontTransactionService>();
  final UserService userService = locator<UserService>();
  final AugmontService _augmontModel = locator<AugmontService>();
  final CustomLogger _logger = locator<CustomLogger>();
  final BankAndPanService _bankAndPanService = locator<BankAndPanService>();
  final PaymentRepository _paymentRepo = locator<PaymentRepository>();
  final TxnHistoryService _txnHistoryService = locator<TxnHistoryService>();
  S locale = locator<S>();
  TextEditingController goldFieldController =
      TextEditingController(text: "2.5");

  bool _isDescriptionView = false;
  double _totalGoldBalance = 0.0;
  double _currentGoldBalance = 0.0;
  double _additionalGoldBalance = 0;
  double _expectedGoldReturns = 0.0;
  double _totalGoldAmount = 0;
  bool _isGoldRateFetching = true;
  AugmontRates? goldRates;

  List<GoldProChoiceChipsModel> chipsList = [
    GoldProChoiceChipsModel(isBest: false, isSelected: false, value: 0.5),
    GoldProChoiceChipsModel(isBest: true, isSelected: true, value: 2.5),
    GoldProChoiceChipsModel(isBest: false, isSelected: false, value: 5.0),
    GoldProChoiceChipsModel(isBest: false, isSelected: false, value: 7.5),
    GoldProChoiceChipsModel(isBest: false, isSelected: false, value: 10),
  ];

  List<ApplicationMeta> appMetaList = [];
  UpiApplication? upiApplication;
  ApplicationMeta? selectedUpiApplication;
  AssetOptionsModel? assetOptionsModel;
  bool isIntentFlow = true;

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

  get isDescriptionView => _isDescriptionView;
  set isDescriptionView(value) {
    _isDescriptionView = value;
    notifyListeners();
  }

  double _sliderValue = 0.25;
  get sliderValue => _sliderValue;

  set sliderValue(value) {
    _sliderValue = value;
    notifyListeners();
  }

  int _selectedChipIndex = 1;
  get selectedChipIndex => _selectedChipIndex;

  set selectedChipIndex(value) {
    _selectedChipIndex = value;
    notifyListeners();
  }

  get isGoldRateFetching => _isGoldRateFetching;

  set isGoldRateFetching(value) {
    _isGoldRateFetching = value;
    notifyListeners();
  }

  Future<void> init() async {
    AppState.isGoldProBuyInProgress = false;
    _isGoldRateFetching = true;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _txnService.currentTransactionState = TransactionState.idle;
    });
    currentGoldBalance = BaseUtil.digitPrecision(
        userService.userFundWallet!.augGoldQuantity, 4, false);
    totalGoldBalance = chipsList[1].value;
    appMetaList = await UpiUtils.getUpiApps();
    await verifyAugmontKyc();
    await getGoldProScheme();
    await getAssetOptionsModel().then((_) {
      isIntentFlow = assetOptionsModel!.data.intent;
    });
    unawaited(fetchGoldRates());
  }

  void dump() {
    goldFieldController.dispose();
  }

//VM Async Call Methods

  Future<void> verifyAugmontKyc() async {
    if (!_bankAndPanService.userKycData!.augmontKyc) {
      await _bankAndPanService.verifyAugmontKyc();
    }
  }

  Future<void> getGoldProScheme() async {
    final res = await _paymentRepo.getGoldProScheme();
    if (res.isSuccess()) {
      _txnService.goldProScheme = res.model;
    } else {
      BaseUtil.showNegativeAlert(
          "Failed to fetch Gold Scheme", res.errorMessage);
    }
  }

  Future<void> initiateGoldProTransaction() async {
    AppState.isGoldProBuyInProgress = false;
    locator<AnalyticsService>().track(
      eventName: AnalyticsEvents.goldProFinalSaveTapped,
      properties: {
        "grams to add": additionalGoldBalance,
        "amount to add": totalGoldAmount,
        "total lease value": totalGoldBalance,
        "current gold balance": currentGoldBalance,
        "expected returns": expectedGoldReturns,
        "returns percentage": 15.5
      },
    );
    if (additionalGoldBalance == 0) {
      await _initiateLease();
    } else {
      await _initiateBuyAndLease();
    }
  }

  Future<void> _initiateBuyAndLease() async {
    if (isIntentFlow) {
      await BaseUtil.openModalBottomSheet(
        isBarrierDismissible: true,
        backgroundColor: const Color(0xff1A1A1A),
        addToScreenStack: true,
        isScrollControlled: true,
        content: UpiAppsGridView(
          apps: appMetaList,
          padTop: true,
          onTap: (i) {
            Haptic.vibrate();
            AppState.backButtonDispatcher!.didPopRoute();
            selectedUpiApplication = appMetaList[i];
            _txnService.initiateAugmontTransaction(
              details: GoldPurchaseDetails(
                goldBuyAmount: totalGoldAmount,
                goldRates: goldRates,
                couponCode: '',
                skipMl: false,
                goldInGrams: additionalGoldBalance,
                leaseQty: totalGoldBalance,
                isPro: true,
                upiChoice: selectedUpiApplication,
              ),
            );
          },
        ),
      );
    } else {
      await _txnService.initiateAugmontTransaction(
        details: GoldPurchaseDetails(
          goldBuyAmount: totalGoldAmount,
          goldRates: goldRates,
          couponCode: '',
          skipMl: false,
          goldInGrams: additionalGoldBalance,
          leaseQty: totalGoldBalance,
          isPro: true,
        ),
      );
    }
  }

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
        totalGoldBalance, _txnService.goldProScheme!.id);
    if (res.isSuccess()) {
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
    final res =
        await locator<GetterRepository>().getAssetOptions('weekly', 'gold');
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
        updateSliderValue(0.21);
        break;
      case 2:
        updateSliderValue(0.47);
        break;
      case 3:
        updateSliderValue(0.74);
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
    double val = BaseUtil.digitPrecision((totalGoldBalance - 0.5) / 9.5, 1);
    if (val >= 0 && val <= 1) sliderValue = val;
  }

  void updateSliderValue(double val) {
    sliderValue = val;
    totalGoldBalance = BaseUtil.digitPrecision(9.5 * val + 0.5, 1);
    goldFieldController.text = totalGoldBalance.toString();
    postUpdateChips();
  }

  void onTextFieldValueChanged(String val) {
    if (double.tryParse(val) != null) {
      totalGoldBalance = double.tryParse(val)!;
    }
  }

  void decrementGoldBalance() {
    totalGoldBalance = BaseUtil.digitPrecision(totalGoldBalance, 1);
    if (totalGoldBalance <= 0.5) {
      totalGoldBalance = 0.5;
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
    if (totalGoldBalance >= 10) {
      totalGoldBalance = 10;
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
    if (totalGoldBalance == 0.5) {
      selectedChipIndex = 0;
      Haptic.vibrate();
    } else if (totalGoldBalance == 2.5) {
      selectedChipIndex = 1;
      Haptic.vibrate();
    } else if (totalGoldBalance == 5.0) {
      selectedChipIndex = 2;
      Haptic.vibrate();
    } else if (totalGoldBalance == 7.5) {
      selectedChipIndex = 3;
      Haptic.vibrate();
    } else if (totalGoldBalance == 10.0) {
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
    if (totalGoldBalance > 10) {
      BaseUtil.showNegativeAlert(
          "Gold grams out of bound", "You can lease at most 10 grams");
      totalGoldBalance = 10;
      goldFieldController.text = "10";
      updateAmount();
      return;
    }
    if (totalGoldBalance < 0.5) {
      BaseUtil.showNegativeAlert("Gold grams too low to lease",
          "You have to lease at least 0.5 grams");
      totalGoldBalance = 0.5;
      goldFieldController.text = "0.5";
      updateAmount();
      return;
    }
    if (isGoldRateFetching) {
      BaseUtil.showNegativeAlert("Fetching latest gold rates", "Please wait");
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
      additionalGoldBalance += 0.0004;
      totalGoldAmount = BaseUtil.digitPrecision(
          (goldBuyPrice! * additionalGoldBalance) +
              (netTax * goldBuyPrice! * additionalGoldBalance) / 100,
          2);

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
