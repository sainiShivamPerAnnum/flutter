import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/amount_chips_model.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/model/sub_combos_model.dart';
import 'package:felloapp/core/model/subscription_models/all_subscription_model.dart';
import 'package:felloapp/core/model/subscription_models/subscription_transaction_model.dart';
import 'package:felloapp/core/repository/getters_repo.dart';
import 'package:felloapp/core/repository/subscription_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/feature/sip/ui/sip_process_view.dart';
import 'package:felloapp/feature/sip/ui/sip_setup/sip_intro.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/finance/autosave/autosave_setup/autosave_process_view.dart';
import 'package:felloapp/ui/pages/finance/autosave/autosave_setup/autosave_process_vm.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:upi_pay/upi_pay.dart';

enum AutosaveState { IDLE, INIT, ACTIVE, PAUSED, INACTIVE, CANCELLED }

enum FREQUENCY { daily, weekly, monthly }

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
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  final UserService _userService = locator<UserService>();

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
  PageController? pageController;

  //LOCAL VARIABLES - END

  //GETTERS & SETTERS - START

  bool _autosaveVisible = true;

  bool get autosaveVisible => _autosaveVisible;

  set autosaveVisible(bool value) {
    _autosaveVisible = value;
    notifyListeners();
  }

  List<AutosaveState> _autosaveStates = [];

  List<AutosaveState> get autosaveState => _autosaveStates;

  set autosaveState(List<AutosaveState> value) {
    _autosaveStates = value;
    notifyListeners();
  }

  AllSubscriptionModel? _subscriptionData;

  AllSubscriptionModel? get subscriptionData => _subscriptionData;

  set subscriptionData(value) {
    // if (value == null) return;
    _subscriptionData = value;
    setSubscriptionState();
  }

  bool _isPauseOrResuming = false;

  get isPauseOrResuming => _isPauseOrResuming;

  set isPauseOrResuming(value) {
    _isPauseOrResuming = value;
    notifyListeners();
  }

  //GETTERS & SETTERS - END

  // SUBSCRIPTION SERVICE CORE METHODS - START

  Future<void> init() async {
    autosaveVisible = AppConfig.getValue(AppConfigKey.showNewAutosave) as bool;
    debugPrint("-----------autoSave visible $autosaveVisible");
    if (autosaveVisible) await getSubscription();
  }

  void dump() {
    pollCount = 0;
    _subscriptionData = null;
    hasNoMoreSubsTxns = false;
    timer?.cancel();
    allSubTxnList = [];

    ///TODO(@Hirdesh2101)
    // autosaveState = AutosaveState.IDLE;
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

    ///TODO(@Hirdesh2101)
    // autosaveState = AutosaveState.IDLE;
    final res = await _subscriptionRepo.createSubscription(
        amount: amount,
        freq: freq,
        lbAmt: lbAmt,
        package: package,
        augAmt: augAmt);
    if (res.isSuccess()) {
      try {
        // autosaveState = AutosaveState.INIT;
        if (Platform.isIOS) {
          BaseUtil.launchUrl(res.model!);
        } else {
          const platform = MethodChannel("methodChannel/upiIntent");
          final result = await platform.invokeMethod('initiatePsp', {
            'redirectUrl': res.model,
            'packageName': FlavorConfig.isDevelopment()
                ? "com.phonepe.app.preprod"
                : package
          });
          log("Result from initiatePsp: $result");
        }
        if (subscriptionData != null) {
          startPollingForCreateSubscriptionResponse();
        }

        return true;
      } catch (e) {
        _logger.e("Create subscription failed: Platform Exception");
        return false;
      }
    } else {
      // autosaveState = AutosaveState.IDLE;
      BaseUtil.showNegativeAlert(res.errorMessage, "Please try after sometime");
      return false;
    }
  }

  void startPollingForCreateSubscriptionResponse() {
    timer = Timer.periodic(
      const Duration(seconds: 10),
      (t) {
        pollCount++;
        if (pollCount > 100) {
          t.cancel();

          ///TODO(@Hirdesh2101)
          // autosaveState = AutosaveState.IDLE;
        }
        getSubscription().then((_) {
          // if (subscriptionData!.status != AutosaveState.INIT.name &&
          //     subscriptionData!.status != AutosaveState.CANCELLED.name) {
          //   _logger.i("Autosave Polling cancelled.");
          //   t.cancel();
          // }
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
    }
  }

  ///TODO(@Hirdesh2101)
  // Future<bool> updateSubscription({
  //   required String freq,
  //   required int lbAmt,
  //   required int augAmt,
  //   required int amount,
  // }) async {
  //   final res = await _subscriptionRepo.updateSubscription(
  //       freq: freq, lbAmt: lbAmt, augAmt: augAmt, amount: amount);
  //   if (res.isSuccess()) {
  //     subscriptionData = res.model;
  //     AppState.backButtonDispatcher!.didPopRoute();
  //     Future.delayed(const Duration(seconds: 1), () {
  //       BaseUtil.showPositiveAlert("Subscription updated successfully",
  //           "Effective changes will take place from tomorrow");
  //     });
  //     return true;
  //   } else {
  //     BaseUtil.showNegativeAlert(res.errorMessage, "Please try again");
  //     return false;
  //   }
  // }

  // Future<bool> pauseSubscription(AutosavePauseOption option) async {
  //   if (isPauseOrResuming) return false;
  //   isPauseOrResuming = true;
  //   final res = await _subscriptionRepo.pauseSubscription(option: option);
  //   isPauseOrResuming = false;
  //   if (res.isSuccess()) {
  //     subscriptionData = res.model;
  //     AppState.backButtonDispatcher!.didPopRoute();
  //     Future.delayed(const Duration(seconds: 1), () {
  //       BaseUtil.showPositiveAlert("Subscription paused successfully",
  //           "Effective changes will take place from tomorrow");
  //     });
  //     return true;
  //   } else {
  //     BaseUtil.showNegativeAlert(res.errorMessage, "Please try again");
  //     return false;
  //   }
  // }

  // Future<bool> resumeSubscription() async {
  //   if (isPauseOrResuming) return false;
  //   isPauseOrResuming = true;
  //   final res = await _subscriptionRepo.resumeSubscription();
  //   isPauseOrResuming = false;
  //   if (res.isSuccess()) {
  //     subscriptionData = res.model;
  //     Future.delayed(const Duration(seconds: 1), () {
  //       BaseUtil.showPositiveAlert("Subscription resumed successfully",
  //           "Effective changes will take place from tomorrow");
  //     });
  //     return true;
  //   } else {
  //     BaseUtil.showNegativeAlert(res.errorMessage, "Please try again");
  //     return false;
  //   }
  // }

  Future<void> getSubscriptionTransactionHistory(
      {bool paginate = false, String asset = ''}) async {
    if (asset.isEmpty) {
      if (allSubTxnList.isNotEmpty && !paginate) return;
      if (hasNoMoreSubsTxns) return;
      final res = await _subscriptionRepo.getSubscriptionTransactionHistory(
          limit: 30,
          offset: allSubTxnList.isEmpty ? null : allSubTxnList.length,
          asset: '');
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
          limit: 30,
          offset: lbSubTxnList.isEmpty ? null : lbSubTxnList.length,
          asset: asset);
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
    if (data.isSuccess()) {
      return data.model!;
    } else {
      return defaultChipsAndComboList;
    }
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
    print("Apps: getting upi apps");

    if (Platform.isIOS) {
      const platform = MethodChannel("methodChannel/deviceData");
      try {
        if (AppConfig.getValue<String>(AppConfigKey.enabled_psp_apps)
            .contains('E')) {
          final result = await platform
              .invokeMethod('isAppInstalled', {"appName": "phonepe"});
          if (result) {
            appMetaList.add(ApplicationMeta.ios(UpiApplication.phonePe));
          }
        }
        if (AppConfig.getValue<String>(AppConfigKey.enabled_psp_apps)
            .contains('P')) {
          final result = await platform
              .invokeMethod('isAppInstalled', {"appName": "paytm"});
          if (result) {
            appMetaList.add(ApplicationMeta.ios(UpiApplication.paytm));
          }
        }
        if (AppConfig.getValue<String>(AppConfigKey.enabled_psp_apps)
            .contains('G')) {
          final result = await platform
              .invokeMethod('isAppInstalled', {"appName": "gpay"});
          if (result) {
            appMetaList.add(ApplicationMeta.ios(UpiApplication.googlePay));
          }
        }
        return appMetaList;
      } on PlatformException catch (e) {
        print("Failed to fetch installed applications on ios $e");
        return appMetaList;
      }
    } else {
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
        print("Apps: No Apps found");

        BaseUtil.showNegativeAlert(locale.unableToGetUpi, locale.tryLater);
        return [];
      }
    }
  }

  setSubscriptionState() {
    num length = subscriptionData?.subs!.length ?? 0;
    for (var i = 0; i < length; i++) {
      switch (subscriptionData?.subs?[i].status) {
        case "INIT":
          autosaveState[i] = AutosaveState.INIT;
          break;
        case "ACTIVE":
          timer?.cancel();
          autosaveState[i] = AutosaveState.ACTIVE;
          break;
        case "PAUSE_FROM_APP":
          autosaveState[i] = AutosaveState.PAUSED;
          break;
        case "PAUSE_FROM_APP_FOREVER":
          autosaveState[i] = AutosaveState.PAUSED;
          break;
        case "PAUSE_FROM_PSP":
          autosaveState[i] = AutosaveState.PAUSED;
          break;
        case "CANCELLED":
          autosaveState[i] = AutosaveState.CANCELLED;
          break;
        default:
          autosaveState[i] = AutosaveState.IDLE;
          break;
      }
    }
  }

  ///TODO(@Hirdesh2101)
  handleTap({InvestmentType? type}) {
    return AppState.delegate!.appState.currentAction = PageAction(
      page: SipPageConfig,
      widget: SipProcessView(),
      state: PageState.addWidget,
    );
    // Haptic.vibrate();
    // // _analyticsService.track(
    // //     eventName: AnalyticsEvents.asCardTapped,
    // //     properties: {"status": autosaveState.name, "location": "Save section"});
    // switch (autosaveState) {
    //   case AutosaveState.INIT:
    //     return BaseUtil.showNegativeAlert(
    //         "Subscription in processing", "please check back after sometime");
    //   case AutosaveState.IDLE:
    //     if (type != null && type == InvestmentType.AUGGOLD99) {
    //       locator<AnalyticsService>().track(
    //         eventName: AnalyticsEvents.autosaveCardInGoldSectionTapped,
    //         properties: {
    //           'progress_bar_completed':
    //               (_userService.userFundWallet?.augGoldQuantity ?? 0) > 0.5
    //                   ? "YES"
    //                   : (_userService.userFundWallet?.augGoldQuantity ?? 0) /
    //                       0.5,
    //           "existing lease amount":
    //               _userService.userPortfolio.augmont.fd.balance,
    //           "existing lease grams":
    //               _userService.userFundWallet?.wAugFdQty ?? 0
    //         },
    //       );
    //       return AppState.delegate!.appState.currentAction = PageAction(
    //         page: SipPageConfig,
    //         widget: SipProcessView(),
    //         state: PageState.addWidget,
    //       );
    //     } else {
    //       return AppState.delegate!.appState.currentAction = PageAction(
    //         page: SipPageConfig,
    //         widget: SipProcessView(),
    //         state: PageState.addWidget,
    //       );

    //       // AppState.delegate!.appState.currentAction = PageAction(
    //       //   page: (PreferenceHelper.getBool(
    //       //           PreferenceHelper.CACHE_IS_AUTOSAVE_FIRST_TIME,
    //       //           def: true))
    //       //       ? AutosaveOnboardingViewPageConfig
    //       //       : AutosaveProcessViewPageConfig,
    //       //   state: PageState.addPage,
    //       // );
    //     }

    //   case AutosaveState.PAUSED:
    //   case AutosaveState.INACTIVE:
    //   case AutosaveState.ACTIVE:
    //     return AppState.delegate!.appState.currentAction = PageAction(
    //       page: AutosaveDetailsViewPageConfig,
    //       state: PageState.addPage,
    //     );
    //   default:
    //     return;
    // }
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
