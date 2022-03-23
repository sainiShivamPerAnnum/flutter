import 'dart:convert';
import 'dart:math';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/service/paytm_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

// enum STATUS { Pending, Complete, Cancel }

class AutoPayProcessViewModel extends BaseModel {
  final _paytmService = locator<PaytmService>();
  final _logger = locator<CustomLogger>();

  bool _showSetAmountView = false;
  bool _isDaily = true;

  String _title = "Set up Autopay";
  String get title => this._title;
  // double sliderValue = 500;
  double saveAmount = 500;
  RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  String Function(Match) mathFunc = (Match match) => '${match[1]},';

  // updateSliderValue(val) {
  //   sliderValue = val;
  //   saveAmount = calculateSaveAmount();
  //   notifyListeners();
  // }

  bool _isSubscriptionInProgress = false;
  bool _isSubscriptionAmountUpdateInProgress = false;

  TextEditingController vpaController =
      new TextEditingController(text: "7777777777@paytm");
  TextEditingController amountFieldController =
      new TextEditingController(text: '500');

  get pageController => _paytmService.subscriptionFlowPageController;
  get subId => _paytmService.currentSubscriptionId;

  set subId(value) {
    _paytmService.currentSubscriptionId = value;
    notifyListeners();
  }

  get isSubscriptionAmountUpdateInProgress =>
      this._isSubscriptionAmountUpdateInProgress;

  set isSubscriptionAmountUpdateInProgress(value) {
    this._isSubscriptionAmountUpdateInProgress = value;
  }

  bool get isSubscriptionInProgress => this._isSubscriptionInProgress;

  set isSubscriptionInProgress(bool value) {
    this._isSubscriptionInProgress = value;
    notifyListeners();
  }

  bool get showSetAmountView => this._showSetAmountView;

  set showSetAmountView(showSetAmountView) {
    this._showSetAmountView = showSetAmountView;
    notifyListeners();
  }

  set title(String value) {
    this._title = value;
    notifyListeners();
  }

  get isDaily => this._isDaily;

  set isDaily(value) {
    this._isDaily = value;
    notifyListeners();
  }

  init() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _paytmService.jumpToSubPage(0);
      getTitle();
    });
  }

  onAmountValueChanged(String val) {
    saveAmount = calculateSaveAmount(int.tryParse(val ?? '0'));
    notifyListeners();
  }

  double calculateSaveAmount(int amount) {
    return amount * 365 + 0.06 * amount;
  }

  getTitle() {
    switch (pageController.page.toInt()) {
      case 0:
        title = "Enter UPI Id";
        return;
      case 1:
        title = "Processing, please wait";
        return;
      case 2:
        title = "Subscription Successful";
        return;
      case 3:
        title = "Subscription Failed";
        return;
      case 4:
        title = "Set Daily Amount";
        return;
      default:
        title = "Set up Autopay";
        return;
    }
  }

  tryAgain() {
    _paytmService.jumpToSubPage(0);
  }

  initiateCustomSubscription() async {
    isSubscriptionInProgress = true;
    PaytmResponse response =
        await _paytmService.initiateCustomSubscription(vpaController.text);
    isSubscriptionInProgress = false;
    if (response.status) {
      _paytmService.jumpToSubPage(1);
      AppState.screenStack.add(ScreenItem.loader);
      Future.delayed(Duration(seconds: 30), () {
        if (AppState.screenStack.last == ScreenItem.loader) {
          AppState.screenStack.removeLast();
          _paytmService.jumpToSubPage(3);
        }
      });
    } else
      switch (response.errorCode) {
        case INVALID_VPA_DETECTED:
          BaseUtil.showNegativeAlert(
            response.reason,
            'Please enter a valid vpa address',
          );
          break;
        default:
          BaseUtil.showNegativeAlert(
            response.reason,
            'Please try again',
          );
          break;
      }
  }

  setSubscriptionAmount(double amount) async {
    if (subId != null && subId.isNotEmpty) {
      isSubscriptionAmountUpdateInProgress = true;
      final res =
          await _paytmService.updateDailySubscriptionAmount(subId, amount);
      isSubscriptionAmountUpdateInProgress = false;
      if (res) {
        while (AppState.screenStack.length > 1)
          AppState.backButtonDispatcher.didPopRoute();
        _paytmService.currentSubscriptionId = null;
        BaseUtil.showPositiveAlert(
            "Subscription Successful", "Check transactions for more details");
      } else {
        BaseUtil.showNegativeAlert(
            "Amount update failed", "Please try again in sometime");
      }
    }
  }

  handleSubscriptionPayload(Map<String, dynamic> data) {
    if (AppState.screenStack.last == ScreenItem.loader) {
      AppState.screenStack.removeLast();
    }
    final res = json.decode(data['payload']);
    print(res['status']);
    if (res != null && res['status'] != null && res['status'] == true) {
      subId = res['subId'] ?? "";
      _paytmService.jumpToSubPage(2);
      onAmountValueChanged(amountFieldController.text);
      Future.delayed(Duration(seconds: 3), () {
        _paytmService.jumpToSubPage(4);
      });
    } else {
      _paytmService.jumpToSubPage(3);
    }
  }
}
