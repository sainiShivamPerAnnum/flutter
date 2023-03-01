import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/subscription_models/subscription_model.dart';
import 'package:felloapp/core/repository/subscription_repo.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/dialogs/subscription_update_dialog.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';

enum AutosaveState {
  INIT,
  PROCESSING,
  ACTIVE,
  PAUSED,
  PAUSED_FOREVER,
  CANCELLED
}

enum AutosavePauseOption {
  FOREVER,
  ONE_WEEK,
  TWO_WEEK,
  ONE_MONTH,
}

class SubscriptionService extends ChangeNotifier {
  final SubscriptionRepo _subscriptionRepo = locator<SubscriptionRepo>();
  AutosaveState _autosaveState = AutosaveState.INIT;
  TextEditingController amountController = TextEditingController();
  int minValue = 25;
  int maxValue = 5000;
  String minAlert = "A minimum of Rs 25 is required";
  String maxAlert = "A maximum of Rs 5000 is allowed";
  bool _showMinAlert = false;
  bool _showMaxAlert = false;
  bool _isDaily = true;

  get isDaily => this._isDaily;

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
    autosaveState = AutosaveState.INIT;
  }

  Future<void> createSubscription(
      {required String freq,
      required int amount,
      required String package,
      required String asset}) async {
    pollCount = 0;
    autosaveState = AutosaveState.PROCESSING;

    final res = await _subscriptionRepo.createSubscription(
        freq: freq, amount: amount, package: package, asset: asset);
    if (res.isSuccess()) {
      bool launchRes = await BaseUtil.launchUrl(res.model!);
      if (!launchRes) {
        autosaveState = AutosaveState.INIT;
      } else {
        startPollingForResponse();
      }
    } else {
      autosaveState = AutosaveState.INIT;
      BaseUtil.showNegativeAlert(res.errorMessage, "Please try after sometime");
    }
  }

  startPollingForResponse() {
    timer = Timer.periodic(Duration(seconds: 15), (timer) {
      pollCount++;
      if (pollCount > 100) {
        timer.cancel();
        autosaveState = AutosaveState.INIT;
      }
      getSubscription();
    });
  }

  Future<void> getSubscription() async {
    final res = await _subscriptionRepo.getSubscription();
    if (res.isSuccess()) {
      subscriptionData = res.model;
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
        BaseUtil.showNegativeAlert("Subscription updated successfully",
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
    final res = await _subscriptionRepo.pauseSubscription(option: option);
    if (res.isSuccess()) {
      subscriptionData = res.model;
      AppState.backButtonDispatcher!.didPopRoute();
      Future.delayed(Duration(seconds: 1), () {
        BaseUtil.showNegativeAlert("Subscription paused successfully",
            "Effective changes will take place from tomorrow");
      });
    } else {
      BaseUtil.showNegativeAlert(res.errorMessage, "Please try again");
    }
  }

  Future<void> resumeSubscription() async {
    final res = await _subscriptionRepo.resumeSubscription();
    if (res.isSuccess()) {
      subscriptionData = res.model;
      AppState.backButtonDispatcher!.didPopRoute();
      Future.delayed(Duration(seconds: 1), () {
        BaseUtil.showNegativeAlert("Subscription resumed successfully",
            "Effective changes will take place from tomorrow");
      });
    } else {
      BaseUtil.showNegativeAlert(res.errorMessage, "Please try again");
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
      case "PROCESSING":
        autosaveState = AutosaveState.PROCESSING;
        break;
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
      case AutosaveState.PROCESSING:
        return;
      case AutosaveState.ACTIVE:
        amountController.text = subscriptionData?.amount?.toString() ?? '25';
        return BaseUtil.openDialog(
            isBarrierDismissible: false,
            addToScreenStack: true,
            hapticVibrate: true,
            content: EditSubscriptionDialog());
      case AutosaveState.INIT:
      case AutosaveState.CANCELLED:
        return createSubscription(
            freq: "DAILY",
            amount: 100,
            package: "com.phonepe.app",
            asset: "AUGGOLD99");
      case AutosaveState.PAUSED:
        return BaseUtil.showNegativeAlert(
            "Updating Autosave feature is not there yet",
            "Hold on for next release");
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
