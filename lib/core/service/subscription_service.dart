import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:felloapp/base_util.dart';
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
import 'package:felloapp/feature/sip/ui/sip_process_view.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:upi_pay/upi_pay.dart';

import '../model/subscription_models/subscription_status_response.dart';

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

  //LOCAL VARIABLES - START
  List suggestions = [];
  Timer? timer;

  List<SubscriptionTransactionModel> allSubTxnList = [];
  List<SubscriptionTransactionModel> lbSubTxnList = [];
  List<SubscriptionTransactionModel> augSubTxnList = [];

  bool hasNoMoreSubsTxns = false;
  bool hasNoMoreLbSubsTxns = false;
  bool hasNoMoreAugSubsTxns = false;
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

  AllSubscriptionModel? _subscriptionData;

  AllSubscriptionModel? get subscriptionData => _subscriptionData;

  set subscriptionData(AllSubscriptionModel? value) {
    _subscriptionData = value;
  }

  bool _isPauseOrResuming = false;

  bool get isPauseOrResuming => _isPauseOrResuming;

  set isPauseOrResuming(value) {
    _isPauseOrResuming = value;
    notifyListeners();
  }

  //GETTERS & SETTERS - END

  // SUBSCRIPTION SERVICE CORE METHODS - START

  Future<void> init() async {
    autosaveVisible = AppConfig.getValue(AppConfigKey.showNewAutosave) as bool;
    debugPrint("-----------autoSave visible $autosaveVisible");
  }

  void dump() {
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
    selectedUpiApplicationName = null;
  }

  // SUBSCRIPTION SERVICE CORE METHODS - END

  // SUBSCRIPTION CORE METHODS - START

  Future<void> createSubscription({
    required String freq,
    required num lbAmt,
    required num augAmt,
    required num amount,
    required String package,
  }) async {
    final res = await _subscriptionRepo.createSubscription(
      amount: amount,
      freq: freq,
      lbAmt: lbAmt,
      package: package,
      augAmt: augAmt,
    );

    if (res.isSuccess()) {
      final intent = res.model!.data.intent;
      final intentUrl = intent.redirectUrl;
      final id = intent.id;
      if (intentUrl.isNotEmpty) {
        try {
          if (Platform.isIOS) {
            await BaseUtil.launchUrl(intentUrl);
            return;
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
        } catch (e) {
          _logger.e("Create subscription failed: Platform Exception");
        }

        if (subscriptionData != null) {
          final result = await _pollForSubscriptionStatus(id);
          final data = result?.model?.data;
          if (result != null && result.isSuccess() && data != null) {
            if (data.status.isActive) {}

            if (data.status.isCancelled) {}
          } else {
            _logger.d('Something went wrong while creating subscription');
          }
        }
      }
    } else {
      BaseUtil.showNegativeAlert(
        res.errorMessage,
        "Please try after sometime",
      );
    }
  }

  Future<ApiResponse<SubscriptionStatusResponse>?> _pollForSubscriptionStatus(
    String subscriptionKey,
  ) async {
    int pollCount = 0;
    const pollLimit = 6;
    const relayDuration = Duration(seconds: 5);

    ApiResponse<SubscriptionStatusResponse>? lastResult;

    while (pollCount < pollLimit) {
      // delay between two requests.
      if (pollCount < 1) {
        await Future.delayed(
          relayDuration,
        );
      }

      lastResult = await getSubscriptionByStatus(subscriptionKey);
      final data = lastResult.model?.data;

      // Termination condition for polling:
      // - Either the request fails completely then break further polling and
      // propagate error response to further.
      // - Or request completes with success and the status of subscription is
      // active.
      final predicate =
          lastResult.isSuccess() && data != null && data.status.isActive ||
              !lastResult.isSuccess();

      if (predicate) {
        return lastResult;
      }

      pollCount++;
    }

    return lastResult;
  }

  Future<void> getSubscription() async {
    final res = await _subscriptionRepo.getSubscription();
    subscriptionData = res.isSuccess() ? res.model : null;
  }

  Future<ApiResponse<SubscriptionStatusResponse>> getSubscriptionByStatus(
    String subscriptionKey,
  ) async {
    final response = await _subscriptionRepo.getTransactionStatus(
      subscriptionKey,
    );
    return response;
  }

  Future<bool> updateSubscription({
    required String freq,
    required String id,
    required int amount,
  }) async {
    final res = await _subscriptionRepo.updateSubscription(
        freq: freq, id: id, amount: amount);
    if (res.isSuccess()) {
      await getSubscription();
      return true;
    } else {
      BaseUtil.showNegativeAlert(res.errorMessage, "Please try again");
      return false;
    }
  }

  Future<bool> pauseSubscription(AutosavePauseOption option, String id) async {
    if (isPauseOrResuming) return false;
    isPauseOrResuming = true;
    final res =
        await _subscriptionRepo.pauseSubscription(option: option, id: id);
    isPauseOrResuming = false;
    if (res.isSuccess()) {
      await getSubscription();
      return true;
    } else {
      BaseUtil.showNegativeAlert(res.errorMessage, "Please try again");
      return false;
    }
  }

  Future<bool> resumeSubscription(String id) async {
    if (isPauseOrResuming) return false;
    isPauseOrResuming = true;
    final res = await _subscriptionRepo.resumeSubscription(id);
    isPauseOrResuming = false;
    if (res.isSuccess()) {
      await getSubscription();
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
    return data.isSuccess() ? data.model! : defaultChipsAndComboList;
  }

  Future<int> getPhonePeVersionCode() async {
    final res = await _subscriptionRepo.getPhonepeVersionCode();
    return res.isSuccess() ? res.model! : 0;
  }

  Future<List<ApplicationMeta>> getUPIApps() async {
    S locale = locator<S>();
    List<ApplicationMeta> appMetaList = [];

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
        _logger.d('Failed to fetch installed applications on ios $e');
        return appMetaList;
      }
    } else {
      try {
        List<ApplicationMeta> allUpiApps =
            await UpiPay.getInstalledUpiApplications(
                statusType: UpiApplicationDiscoveryAppStatusType.all);

        for (final element in allUpiApps) {
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

          // debug assertion to avoid this in production.
          assert(() {
            if (element.upiApplication.appName == "PhonePe Simulator" &&
                AppConfig.getValue<String>(AppConfigKey.enabled_psp_apps)
                    .contains('E')) {
              appMetaList.add(element);
            }
            return true;
          }());

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
        }

        return appMetaList;
      } catch (e) {
        _logger.d('Failed to list all psp app due to error: $e');

        BaseUtil.showNegativeAlert(
          locale.unableToGetUpi,
          locale.tryLater,
        );

        return [];
      }
    }
  }

  ///TODO(@Hirdesh2101)
  void handleTap({InvestmentType? type}) {
    AppState.delegate!.appState.currentAction = PageAction(
      page: SipPageConfig,
      widget: const SipProcessView(),
      state: PageState.addWidget,
    );
  }
}
