import 'dart:async';
import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/amount_chips_model.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/model/sub_combos_model.dart';
import 'package:felloapp/core/model/subscription_models/subscription_model.dart';
import 'package:felloapp/core/model/subscription_models/subscription_transaction_model.dart';
import 'package:felloapp/core/repository/getters_repo.dart';
import 'package:felloapp/core/repository/subscription_repo.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/finance/autosave/autosave_setup/autosave_process_vm.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:upi_pay/upi_pay.dart';

enum AutosaveState { IDLE, INIT, ACTIVE, PAUSED, INACTIVE, CANCELLED }

enum AutosavePauseOption {
  FOREVER,
  ONE_WEEK,
  TWO_WEEK,
  ONE_MONTH,
}

List defaultChipsAndComboList = [
  defaultAmountChipList,
  defaultAmountChipList,
  defaultSipComboList
];
List<AmountChipsModel> defaultAmountChipList = [
  AmountChipsModel(order: 0, value: 100, best: false, isSelected: false),
  AmountChipsModel(order: 0, value: 250, best: true, isSelected: false),
  AmountChipsModel(order: 0, value: 500, best: false, isSelected: false),
];

List<SubComboModel> defaultSipComboList = [
  SubComboModel(
    order: 0,
    title: "Balanced",
    popular: true,
    AUGGOLD99: 100,
    LENDBOXP2P: 1000,
    icon: '',
    isSelected: false,
  ),
  SubComboModel(
    order: 1,
    title: "Gamer",
    popular: false,
    AUGGOLD99: 50,
    LENDBOXP2P: 100,
    icon: '',
    isSelected: false,
  ),
  SubComboModel(
    order: 2,
    title: "Beginner",
    popular: false,
    AUGGOLD99: 500,
    LENDBOXP2P: 500,
    icon: '',
    isSelected: false,
  ),
];

class SubService extends ChangeNotifier {
  //DEPENDENCY - START

  final SubscriptionRepo _subscriptionRepo = locator<SubscriptionRepo>();
  final GetterRepository _getterRepo = locator<GetterRepository>();
  final CustomLogger _logger = locator<CustomLogger>();

  //DEPENDENCY - END

  //LOCAL VARIABLES - START
  List suggestions = [];
  Timer? timer;
  int pollCount = 0;
  List<SubscriptionTransactionModel> allSubTxnList = [];
  List<SubscriptionTransactionModel> lbSubTxnList = [];
  List<SubscriptionTransactionModel> augSubTxnList = [];

  bool hasNoMoreSubsTxns = false;
  bool hasNoMoreLbSubsTxns = false;
  bool hasNoMoreAugSubsTxns = false;
  UpiApplication? upiApplication;
  String? selectedUpiApplicationName;

  //LOCAL VARIABLES - END

  //GETTERS & SETTERS - START

  bool _autosaveVisible = true;
  bool get autosaveVisible => this._autosaveVisible;
  set autosaveVisible(bool value) {
    this._autosaveVisible = value;
    notifyListeners();
  }

  AutosaveState _autosaveState = AutosaveState.IDLE;
  AutosaveState get autosaveState => this._autosaveState;
  set autosaveState(AutosaveState value) {
    this._autosaveState = value;
    notifyListeners();
  }

  SubscriptionModel? _subscriptionData;
  SubscriptionModel? get subscriptionData => this._subscriptionData;
  set subscriptionData(value) {
    if (value == null) return;
    this._subscriptionData = value;
    setSubscriptionState();
  }

  bool _isPauseOrResuming = false;
  get isPauseOrResuming => this._isPauseOrResuming;
  set isPauseOrResuming(value) {
    this._isPauseOrResuming = value;
    notifyListeners();
  }

  //GETTERS & SETTERS - END

  // SUBSCRIPTION SERVICE CORE METHODS - START

  init() {
    autosaveVisible = AppConfig.getValue(AppConfigKey.showNewAutosave) as bool;
    print("-----------autosave visible $autosaveVisible");
    if (autosaveVisible) getSubscription();
  }

  dump() {
    pollCount = 0;
    _subscriptionData = null;
    hasNoMoreSubsTxns = false;
    timer?.cancel();
    allSubTxnList = [];
    autosaveState = AutosaveState.IDLE;
    allSubTxnList = [];
    lbSubTxnList = [];
    augSubTxnList = [];
    suggestions.clear();
    hasNoMoreLbSubsTxns = false;
    hasNoMoreAugSubsTxns = false;
    upiApplication = null;
    selectedUpiApplicationName = null;
  }

  // SUBSCRIPTION SERVICE CORE METHODS - END

  // SUBSCRIPTION CORE METHODS - START

  Future<bool> createSubscription({
    required String freq,
    required int lbAmt,
    required int augAmt,
    required int amount,
    required String package,
  }) async {
    pollCount = 0;
    autosaveState = AutosaveState.IDLE;
    final res = await _subscriptionRepo.createSubscription(
        amount: amount,
        freq: freq,
        lbAmt: lbAmt,
        package: package,
        augAmt: augAmt);
    if (res.isSuccess()) {
      try {
        getSubscription();
        const platform = MethodChannel("methodChannel/upiIntent");
        autosaveState = AutosaveState.INIT;
        final result = await platform.invokeMethod(
            'initiatePsp', {'redirectUrl': res.model, 'packageName': package});
        log("Result from initiatePsp: $result");
        if (subscriptionData != null)
          startPollingForCreateSubscriptionResponse();
        return true;
      } catch (e) {
        _logger.e("Create subscription failed: Platform Exception");
        return false;
      }
    } else {
      autosaveState = AutosaveState.IDLE;
      BaseUtil.showNegativeAlert(res.errorMessage, "Please try after sometime");
      return false;
    }
  }

  startPollingForCreateSubscriptionResponse() {
    timer = Timer.periodic(
      const Duration(seconds: 10),
      (t) {
        pollCount++;
        if (pollCount > 100) {
          t.cancel();
          autosaveState = AutosaveState.IDLE;
        }
        getSubscription().then((_) {
          if (subscriptionData!.status != AutosaveState.INIT.name &&
              subscriptionData!.status != AutosaveState.CANCELLED.name) {
            print("reached here too");
            t.cancel();
          }
        });
      },
    );
  }

  Future<void> getSubscription() async {
    final res = await _subscriptionRepo.getSubscription();
    if (res.isSuccess()) {
      subscriptionData = res.model;
    } else {
      subscriptionData = null;
      autosaveState = AutosaveState.IDLE;
    }
  }

  Future<bool> updateSubscription({
    required String freq,
    required int lbAmt,
    required int augAmt,
    required int amount,
  }) async {
    final res = await _subscriptionRepo.updateSubscription(
        freq: freq, lbAmt: lbAmt, augAmt: augAmt, amount: amount);
    if (res.isSuccess()) {
      subscriptionData = res.model;
      AppState.backButtonDispatcher!.didPopRoute();
      Future.delayed(const Duration(seconds: 1), () {
        BaseUtil.showPositiveAlert("Subscription updated successfully",
            "Effective changes will take place from tomorrow");
      });
      return true;
    } else {
      BaseUtil.showNegativeAlert(res.errorMessage, "Please try again");
      return false;
    }
  }

  Future<bool> pauseSubscription(AutosavePauseOption option) async {
    if (isPauseOrResuming) return false;
    isPauseOrResuming = true;
    final res = await _subscriptionRepo.pauseSubscription(option: option);
    isPauseOrResuming = false;
    if (res.isSuccess()) {
      subscriptionData = res.model;
      AppState.backButtonDispatcher!.didPopRoute();
      Future.delayed(const Duration(seconds: 1), () {
        BaseUtil.showPositiveAlert("Subscription paused successfully",
            "Effective changes will take place from tomorrow");
      });
      return true;
    } else {
      BaseUtil.showNegativeAlert(res.errorMessage, "Please try again");
      return false;
    }
  }

  Future<bool> resumeSubscription() async {
    if (isPauseOrResuming) return false;
    isPauseOrResuming = true;
    final res = await _subscriptionRepo.resumeSubscription();
    isPauseOrResuming = false;
    if (res.isSuccess()) {
      subscriptionData = res.model;
      Future.delayed(const Duration(seconds: 1), () {
        BaseUtil.showPositiveAlert("Subscription resumed successfully",
            "Effective changes will take place from tomorrow");
      });
      return true;
    } else {
      BaseUtil.showNegativeAlert(res.errorMessage, "Please try again");
      return false;
    }
  }

  Future<void> getSubscriptionTransactionHistory(
      {bool paginate = false, String asset = ''}) async {
    if (asset.isEmpty) {
      if (allSubTxnList.isNotEmpty && !paginate) return;
      if (hasNoMoreSubsTxns) return;
      final res = await _subscriptionRepo.getSubscriptionTransactionHistory(
          limit: 30,
          offset: allSubTxnList.isEmpty ? null : allSubTxnList.length);
      if (res.isSuccess()) {
        if (res.model!.length < 30) hasNoMoreSubsTxns = true;
        allSubTxnList.addAll(res.model!);
      }
    } else if (asset == Constants.ASSET_TYPE_AUGMONT) {
      if (augSubTxnList.isNotEmpty && !paginate) return;

      if (hasNoMoreSubsTxns) {
        augSubTxnList.clear();
        allSubTxnList.map((txn) {
          if (txn.augMap != null) return txn;
        }).forEach((txn) {
          if (txn != null) augSubTxnList.add(txn);
        });
        return;
      }
      if (hasNoMoreAugSubsTxns) return;
      final res = await _subscriptionRepo.getSubscriptionTransactionHistory(
          limit: 30,
          offset: augSubTxnList.isEmpty ? null : augSubTxnList.length,
          asset: asset);
      if (res.isSuccess()) {
        if (res.model!.length < 30) hasNoMoreAugSubsTxns = true;
        augSubTxnList.addAll(res.model!);
      }
    } else if (asset == Constants.ASSET_TYPE_LENDBOX) {
      if (lbSubTxnList.isNotEmpty && !paginate) return;
      if (hasNoMoreSubsTxns) {
        lbSubTxnList.clear();
        allSubTxnList.map((txn) {
          if (txn.augMap != null) return txn;
        }).forEach((txn) {
          if (txn != null) lbSubTxnList.add(txn);
        });
        return;
      }
      if (hasNoMoreLbSubsTxns) return;
      final res = await _subscriptionRepo.getSubscriptionTransactionHistory(
          limit: 30, offset: lbSubTxnList.isEmpty ? null : lbSubTxnList.length);
      if (res.isSuccess()) {
        if (res.model!.length < 30) hasNoMoreLbSubsTxns = true;
        lbSubTxnList.addAll(res.model!);
      }
    }
  }
  // SUBSCRIPTION CORE METHODS - END

  //Helpers

  Future<void> getAutosaveSuggestions() async {
    if (suggestions.isNotEmpty) return;

    //Get daily frequency data

    // List<List<AmountChipsModel>> suggestionAmountChipsCategories = [];
    final dailyFreqData =
        await getAmountChipsAndCombos(freq: FREQUENCY.daily.name);
    final weeklyFreqData =
        await getAmountChipsAndCombos(freq: FREQUENCY.weekly.name);
    final monthlyFreqData =
        await getAmountChipsAndCombos(freq: FREQUENCY.monthly.name);
    List augChips = [dailyFreqData[0], weeklyFreqData[0], monthlyFreqData[0]];
    List lbChips = [dailyFreqData[1], weeklyFreqData[1], monthlyFreqData[1]];
    List combos = [dailyFreqData[2], weeklyFreqData[2], monthlyFreqData[2]];
    List minMaxInfo = [dailyFreqData[3], weeklyFreqData[3], monthlyFreqData[3]];

    suggestions.addAll([augChips, lbChips, combos, minMaxInfo]);
  }

  Future<List> getAmountChipsAndCombos({required String freq}) async {
    ApiResponse<List> data = await _getterRepo.getSubCombosAndChips(freq: freq);
    if (data.isSuccess())
      return data.model!;
    else
      return defaultChipsAndComboList;
  }

  // Future<List<SubComboModel>> getSipCombos({required String freq}) async {
  //   ApiResponse<List<SubComboModel>> data =
  //       await _getterRepo.getSubCombos(freq: freq);
  //   if (data.isSuccess())
  //     return data.model!;
  //   else
  //     return defaultSipComboList;
  // }

  Future<int> getPhonePeVersionCode() async {
    final res = await _subscriptionRepo.getPhonepeVersionCode();
    if (res.isSuccess()) {
      return res.model!;
    } else {
      return 0;
    }
  }

  Future<List<ApplicationMeta>> getUPIApps() async {
    S locale = locator<S>();
    List<ApplicationMeta> appMetaList = [];
    try {
      List<ApplicationMeta> allUpiApps =
          await UpiPay.getInstalledUpiApplications(
              statusType: UpiApplicationDiscoveryAppStatusType.all);

      allUpiApps.forEach((element) {
        if (element.upiApplication.appName == "Paytm" &&
            AppConfig.getValue<String>(AppConfigKey.enabled_psp_apps)
                .contains('P')) {
          appMetaList.add(element);
        }
        if (element.upiApplication.appName == "PhonePe" &&
            AppConfig.getValue<String>(AppConfigKey.enabled_psp_apps)
                .contains('E')) {
          appMetaList.add(element);
        }
        if (element.upiApplication.appName == "PhonePe Preprod" &&
            AppConfig.getValue<String>(AppConfigKey.enabled_psp_apps)
                .contains('E')) {
          appMetaList.add(element);
        }
        if (element.upiApplication.appName == "Google Pay" &&
            AppConfig.getValue<String>(AppConfigKey.enabled_psp_apps)
                .contains('G')) {
          appMetaList.add(element);
        }
      });
      return appMetaList;
    } catch (e) {
      BaseUtil.showNegativeAlert(locale.unableToGetUpi, locale.tryLater);
      return [];
    }
  }

  setSubscriptionState() {
    switch (subscriptionData!.status) {
      case "INIT":
        autosaveState = AutosaveState.INIT;
        break;
      case "ACTIVE":
        timer?.cancel();
        autosaveState = AutosaveState.ACTIVE;
        break;
      case "PAUSE_FROM_APP":
        autosaveState = AutosaveState.PAUSED;
        break;
      case "PAUSE_FROM_APP_FOREVER":
        autosaveState = AutosaveState.PAUSED;
        break;
      case "PAUSE_FROM_PSP":
        autosaveState = AutosaveState.PAUSED;
        break;
      case "CANCELLED":
        autosaveState = AutosaveState.CANCELLED;
        break;
      default:
        autosaveState = AutosaveState.INIT;
        break;
    }
  }

  handleTap() {
    print(_autosaveState);
    Haptic.vibrate();
    switch (autosaveState) {
      case AutosaveState.INIT:
        return BaseUtil.showNegativeAlert(
            "Subscription in processing", "please check back after sometime");
      case AutosaveState.IDLE:
        return AppState.delegate!.appState.currentAction = PageAction(
          page: (PreferenceHelper.getBool(
                  PreferenceHelper.CACHE_IS_AUTOSAVE_FIRST_TIME,
                  def: true))
              ? AutosaveOnboardingViewPageConfig
              : AutosaveProcessViewPageConfig,
          state: PageState.addPage,
        );
      case AutosaveState.PAUSED:
      case AutosaveState.INACTIVE:
      case AutosaveState.ACTIVE:
        return AppState.delegate!.appState.currentAction = PageAction(
          page: AutosaveDetailsViewPageConfig,
          state: PageState.addPage,
        );
      default:
        return;
    }
  }

  // onAmountValueChanged(String val) {
  //   if (val == "00000") amountController.text = '0';
  //   if (val != null && val.isNotEmpty) {
  //     if (int.tryParse(val)! < minValue)
  //       showMinAlert = true;
  //     else
  //       showMinAlert = false;
  //     if (int.tryParse(val)! > maxValue) {
  //       amountController.text = maxValue.toString();
  //       val = maxValue.toString();
  //       FocusManager.instance.primaryFocus!.unfocus();
  //     }
  //   } else {
  //     val = '0';
  //   }
  //   // saveAmount = calculateSaveAmount(int.tryParse(val ?? '0')!);
  //   notifyListeners();
  // }
}
