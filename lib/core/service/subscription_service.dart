import 'dart:async';
import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/model/subscription_models/subscription_model.dart';
import 'package:felloapp/core/model/subscription_models/subscription_transaction_model.dart';
import 'package:felloapp/core/repository/subscription_repo.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/dialogs/subscription_update_dialog.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:upi_pay/upi_pay.dart';

enum AutosaveState { IDLE, INIT, ACTIVE, PAUSED, PAUSED_FOREVER, CANCELLED }

enum AutosavePauseOption {
  FOREVER,
  ONE_WEEK,
  TWO_WEEK,
  ONE_MONTH,
}

class SubService extends ChangeNotifier {
  final SubscriptionRepo _subscriptionRepo = locator<SubscriptionRepo>();
  AutosaveState _autosaveState = AutosaveState.IDLE;
  TextEditingController amountController = TextEditingController();
  int minValue = 25;
  int maxValue = 5000;
  bool _autosaveVisible = true;
  bool get autosaveVisible => this._autosaveVisible;
  set autosaveVisible(bool value) {
    this._autosaveVisible = value;
    notifyListeners();
  }

  String minAlert = "A minimum of Rs 25 is required";
  String maxAlert = "A maximum of Rs 5000 is allowed";
  bool _showMinAlert = false;
  bool _showMaxAlert = false;
  bool _isDaily = true;
  List<SubscriptionTransactionModel> subscriptionTxnsHistoryList = [];
  bool hasNoMoreSubsTxns = false;
  get isDaily => this._isDaily;
  UpiApplication? upiApplication;
  String? selectedUpiApplicationName;
  set isDaily(value) {
    this._isDaily = value;
    notifyListeners();
  }

  get showMinAlert => this._showMinAlert;

  set showMinAlert(value) {
    this._showMinAlert = value;
    notifyListeners();
  }

  get showMaxAlert => this._showMaxAlert;

  set showMaxAlert(value) {
    this._showMaxAlert = value;
    notifyListeners();
  }

  get autosaveState => this._autosaveState;

  set autosaveState(value) {
    this._autosaveState = value;
    notifyListeners();
  }

  SubscriptionModel? _subscriptionData;

  SubscriptionModel? get subscriptionData => this._subscriptionData;

  set subscriptionData(value) {
    this._subscriptionData = value;
    if (value == null) return;
    amountController.text = subscriptionData!.amount.toString();
    setSubscriptionState(subscriptionData!.status!);
  }

  Timer? timer;
  int pollCount = 0;

  init() {
    getSubscription();
  }

  dump() {
    pollCount = 0;
    _subscriptionData = null;
    hasNoMoreSubsTxns = false;
    _isDaily = true;
    timer?.cancel();

    subscriptionTxnsHistoryList = [];
    autosaveState = AutosaveState.IDLE;
  }

  Future<void> createSubscription(
      {required String freq,
      required int amount,
      required String package,
      required String asset}) async {
    pollCount = 0;
    autosaveState = AutosaveState.IDLE;

    final res = await _subscriptionRepo.createSubscription(
        freq: freq, amount: amount, package: package, asset: asset);
    if (res.isSuccess()) {
      // try {
      const platform = MethodChannel("methodChannel/upiIntent");

      final result = await platform.invokeMethod(
          'initiatePsp', {'redirectUrl': res.model, 'packageName': package});
      // platform.setMethodCallHandler((call) {
      //   final String argument = call.arguments;
      //   switch (call.method) {
      //     case "onSuccess":
      //       log("Result from call handler $argument");
      //       break;
      //   }
      //   return Future.value();
      // });
      log("Result from initiatePsp: $result");

      // version = result;
      // return ApiResponse(model: version, code: 200);
      // } catch (e) {
      //   debugPrint(e.toString());
      //   // version = 0;
      //   // return ApiResponse.withError("Unable to get PhonePe version code", 400);
      // }
      // bool launchRes = await BaseUtil.launchUrl(res.model!);
      // if (!launchRes) {
      // } else {
      //   autosaveState = AutosaveState.INIT;
      //   startPollingForResponse();
      // }
    } else {
      autosaveState = AutosaveState.IDLE;
      BaseUtil.showNegativeAlert(res.errorMessage, "Please try after sometime");
    }
  }

  startPollingForResponse() {
    timer = Timer.periodic(Duration(seconds: 10), (t) {
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
    });
  }

  Future<int> getPhonePeVersionCode() async {
    final res = await _subscriptionRepo.getPhonepeVersionCode();
    if (res.isSuccess()) {
      return res.model!;
    } else {
      return 0;
    }
  }

  Future<void> getSubscription() async {
    final res = await _subscriptionRepo.getSubscription();
    if (res.isSuccess()) {
      subscriptionData = res.model;
    } else {
      autosaveState = AutosaveState.IDLE;
      subscriptionData = null;
    }
  }

  Future<void> updateSubscription() async {
    if (amountController.text.isEmpty)
      return BaseUtil.showNegativeAlert(
          "Please enter some amount", "No amount entered");
    final res = await _subscriptionRepo.updateSubscription(
        freq: isDaily ? "DAILY" : "WEEKLY",
        amount: int.tryParse(amountController.text)!);
    if (res.isSuccess()) {
      subscriptionData = res.model;
      AppState.backButtonDispatcher!.didPopRoute();
      Future.delayed(Duration(seconds: 1), () {
        BaseUtil.showPositiveAlert("Subscription updated successfully",
            "Effective changes will take place from tomorrow");
      });
    } else {
      BaseUtil.showNegativeAlert(res.errorMessage, "Please try again");
    }
  }

  bool _isPausing = false;
  bool _isResuming = false;

  get isResuming => this._isResuming;

  set isResuming(value) {
    this._isResuming = value;
    notifyListeners();
  }

  get isPausing => this._isPausing;
  set isPausing(value) {
    this._isPausing = value;
    notifyListeners();
  }

  Future<void> pauseSubscription(AutosavePauseOption option) async {
    isPausing = true;
    final res = await _subscriptionRepo.pauseSubscription(option: option);
    if (res.isSuccess()) {
      subscriptionData = res.model;
      AppState.backButtonDispatcher!.didPopRoute();
      Future.delayed(Duration(seconds: 1), () {
        BaseUtil.showPositiveAlert("Subscription paused successfully",
            "Effective changes will take place from tomorrow");
      });
    } else {
      BaseUtil.showNegativeAlert(res.errorMessage, "Please try again");
    }
    isPausing = false;
  }

  Future<void> resumeSubscription() async {
    isPausing = true;
    final res = await _subscriptionRepo.resumeSubscription();
    if (res.isSuccess()) {
      subscriptionData = res.model;
      AppState.backButtonDispatcher!.didPopRoute();
      Future.delayed(Duration(seconds: 1), () {
        BaseUtil.showPositiveAlert("Subscription resumed successfully",
            "Effective changes will take place from tomorrow");
      });
    } else {
      BaseUtil.showNegativeAlert(res.errorMessage, "Please try again");
    }
    isPausing = false;
  }

  Future<void> getSubscriptionTransactionHistory(
      {bool firstFetch = false}) async {
    if (firstFetch) subscriptionTxnsHistoryList = [];
    if (hasNoMoreSubsTxns) return;
    final res = await _subscriptionRepo.getSubscriptionTransactionHistory(
        limit: 30, offset: firstFetch ? 1 : subscriptionTxnsHistoryList.length);
    if (res.isSuccess()) {
      if (res.model!.length < 30) hasNoMoreSubsTxns = true;
      subscriptionTxnsHistoryList.addAll(res.model!);
    }
  }

  // Future<void> getUserUpiAppChoice() async {
  //   await getUPIApps();
  //   BaseUtil.openModalBottomSheet(
  //     addToScreenStack: true,
  //     backgroundColor: UiConstants.kBackgroundColor,
  //     isBarrierDismissible: false,
  //     isScrollControlled: true,
  //     borderRadius: BorderRadius.only(
  //       topLeft: Radius.circular(SizeConfig.roundness12),
  //       topRight: Radius.circular(SizeConfig.roundness12),
  //     ),
  //     content: SubsUPIAppsBottomSheet(subscriptionService: this),
  //   );
  // }

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

  setSubscriptionState(String status) {
    switch (status) {
      case "INIT":
        autosaveState = AutosaveState.INIT;
        break;
      case "ACTIVE":
        timer?.cancel();
        autosaveState = AutosaveState.ACTIVE;
        break;
      // case "PROCESSING":
      //   autosaveState = AutosaveState.PROCESSING;
      //   break;
      case "PAUSE_FROM_APP":
        autosaveState = AutosaveState.PAUSED;
        break;
      case "PAUSE_FROM_APP_FOREVER":
        autosaveState = AutosaveState.PAUSED_FOREVER;
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
    switch (autosaveState) {
      case AutosaveState.INIT:
        return BaseUtil.showNegativeAlert(
            "Subscription in processing", "please check back after sometime");
      case AutosaveState.ACTIVE:
        amountController.text = subscriptionData?.amount?.toString() ?? '25';
        return BaseUtil.openDialog(
            isBarrierDismissible: false,
            addToScreenStack: true,
            hapticVibrate: true,
            content: EditSubscriptionDialog());
      case AutosaveState.IDLE:
        // return getUserUpiAppChoice();
        return AppState.delegate!.appState.currentAction = PageAction(
          page: AutosaveProcessViewPageConfig,
          state: PageState.addPage,
        );
      // return createSubscription(
      //     freq: "DAILY",
      //     amount: 100,
      //     package: "com.phonepe.app",
      //     asset: "AUGGOLD99");
      case AutosaveState.PAUSED:
        return resumeSubscription();
      case AutosaveState.PAUSED_FOREVER:
        return resumeSubscription();
      default:
        return;
    }
  }

  onAmountValueChanged(String val) {
    if (val == "00000") amountController.text = '0';
    if (val != null && val.isNotEmpty) {
      if (int.tryParse(val)! < minValue)
        showMinAlert = true;
      else
        showMinAlert = false;
      if (int.tryParse(val)! > maxValue) {
        amountController.text = maxValue.toString();
        val = maxValue.toString();
        FocusManager.instance.primaryFocus!.unfocus();
      }
    } else {
      val = '0';
    }
    // saveAmount = calculateSaveAmount(int.tryParse(val ?? '0')!);
    notifyListeners();
  }
}
