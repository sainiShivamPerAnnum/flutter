import 'dart:convert';
import 'dart:math';

import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/model/amount_chips_model.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/golden_ticket_service.dart';
import 'package:felloapp/core/service/notifier_services/paytm_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_scratch_dialog/gt_instant_view.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

// enum STATUS { Pending, Complete, Cancel }

class AutoSaveProcessViewModel extends BaseModel {
  final _paytmService = locator<PaytmService>();
  final _logger = locator<CustomLogger>();
  final _userService = locator<UserService>();
  final _analyticsService = locator<AnalyticsService>();
  final GoldenTicketService _gtService = GoldenTicketService();

  bool _showSetAmountView = false;
  bool _isDaily = true;
  bool _showProgressIndicator = false;
  bool _showConfetti = false;
  AnimationController lottieAnimationController;
  String _androidPackageName = "";
  String _iosUrlScheme = "";

  int _minValue = 25;
  int maxAmount = 5000;
  String _title = "Set up Autosave";
  String get title => this._title;
  bool _showAppLaunchButton = false;
  int counter = 0;
  bool _showMinAlert = false;

  List<AmountChipsModel> _dailyChips = [];
  List<AmountChipsModel> _weeklyChips = [];
  get dailyChips => this._dailyChips;

  set dailyChips(dailyChips) {
    this._dailyChips = dailyChips;
    notifyListeners();
  }

  get weeklyChips => this._weeklyChips;

  set weeklyChips(weeklyChips) {
    this._weeklyChips = weeklyChips;
    notifyListeners();
  }

  get showAppLaunchButton => this._showAppLaunchButton;

  set showAppLaunchButton(value) {
    this._showAppLaunchButton = value;
    notifyListeners();
  }

  bool get showConfetti => this._showConfetti;

  set showConfetti(bool value) {
    this._showConfetti = value;
    notifyListeners();
  }

  get androidPackageName => this._androidPackageName;

  set androidPackageName(value) {
    this._androidPackageName = value;
    notifyListeners();
  }

  get iosUrlScheme => this._iosUrlScheme;

  set iosUrlScheme(value) {
    this._iosUrlScheme = value;
    notifyListeners();
  }

  bool get showMinAlert => this._showMinAlert;

  set showMinAlert(bool value) {
    this._showMinAlert = value;
    notifyListeners();
  }

  get minValue => this._minValue;

  set minValue(value) {
    this._minValue = value;
    notifyListeners();
  }

  // double sliderValue = 500;
  double saveAmount = 500;
  RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  String Function(Match) mathFunc = (Match match) => '${match[1]},';
  static const kTileHeight = 50.0;

  // updateSliderValue(val) {
  //   sliderValue = val;
  //   saveAmount = calculateSaveAmount();
  //   notifyListeners();
  // }

  bool _isSubscriptionInProgress = false;
  bool _isSubscriptionAmountUpdateInProgress = false;

  TextEditingController vpaController = new TextEditingController();
  TextEditingController amountFieldController =
      new TextEditingController(text: '500');

  PageController get pageController =>
      _paytmService.subscriptionFlowPageController;
  // get subId => _paytmService.currentSubscriptionId;

  // set subId(value) {
  //   _paytmService.currentSubscriptionId = value;
  //   notifyListeners();
  // }

  get isSubscriptionAmountUpdateInProgress =>
      this._isSubscriptionAmountUpdateInProgress;

  set isSubscriptionAmountUpdateInProgress(value) {
    this._isSubscriptionAmountUpdateInProgress = value;
    notifyListeners();
  }

  bool get isSubscriptionInProgress => this._isSubscriptionInProgress;

  set isSubscriptionInProgress(bool value) {
    this._isSubscriptionInProgress = value;
    if (value) {
      AppState.screenStack.add(ScreenItem.loader);
    } else {
      if (AppState.screenStack.last == ScreenItem.loader) {
        AppState.screenStack.removeLast();
      }
    }
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
    if (value)
      minValue = 25;
    else
      minValue = 100;
    notifyListeners();
  }

  get showProgressIndicator => this._showProgressIndicator;

  set showProgressIndicator(value) {
    this._showProgressIndicator = value;
    notifyListeners();
  }

  init(int page) async {
    getChipAmounts();
    counter = 0;
    _paytmService.isOnSubscriptionFlow = true;
    showProgressIndicator = true;
    if (_paytmService.activeSubscription != null)
      vpaController.text = _paytmService.activeSubscription.vpa;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _paytmService.jumpToSubPage(page);
      _paytmService.fraction = page;
      if (page == 1)
        checkForUPIAppExistence(vpaController.text.trim().split("@").last);
      // getTitle();
      print(pageController.page);
      showProgressIndicator = true;
      _paytmService.processText = "processing";
    });
    onAmountValueChanged(amountFieldController.text);
  }

  onAmountValueChanged(String val) {
    if (val == "00000") amountFieldController.text = '0';
    if (val != null && val.isNotEmpty) {
      if (int.tryParse(val) < minValue)
        showMinAlert = true;
      else
        showMinAlert = false;
      if (int.tryParse(val) > maxAmount) {
        amountFieldController.text = maxAmount.toString();
        val = maxAmount.toString();
        FocusManager.instance.primaryFocus.unfocus();
      }
    } else {
      val = '0';
    }
    saveAmount = calculateSaveAmount(int.tryParse(val ?? '0'));
    notifyListeners();
  }

  double calculateSaveAmount(int amount) {
    final double p = amount * (isDaily ? 365.0 : 52.0);
    final double r = 6;
    final double t = 1;
    final double ci = p * (pow(1 + r / 100, t) - 1);
    return p + ci;
  }

  // getTitle() {
  //   switch (pageController.page.toInt()) {
  //     case 0:
  //       title = "Enter UPI Id";
  //       return;
  //     case 1:
  //       title = "Processing, please wait";
  //       return;
  //     case 2:
  //       title = "Subscription Successful";
  //       return;
  //     case 3:
  //       title = "Subscription Failed";
  //       return;
  //     case 4:
  //       title = "Set Daily Amount";
  //       return;
  //     default:
  //       title = "Set up Autosave";
  //       return;
  //   }
  // }

  getChipAmounts() async {
    dailyChips =
        await _paytmService.getAmountChips(Constants.DOC_IAR_DAILY_CHIPS);
    weeklyChips =
        await _paytmService.getAmountChips(Constants.DOC_IAR_WEEKLY_CHIPS);
  }

  tryAgain() {
    _paytmService.jumpToSubPage(0);
    showProgressIndicator = true;
    _paytmService.fraction = 0;
  }

  onCompleteClose() {
    _analyticsService.track(
        eventName: AnalyticsEvents.autosaveCompleteScreenClosed);
    AppState.backButtonDispatcher.didPopRoute();
    _gtService.fetchAndVerifyGoldenTicketByID().then((bool res) {
      if (res) {
        _analyticsService.track(
            eventName: AnalyticsEvents.autosaveSetupGTReceived);
        _gtService.showInstantGoldenTicketView(
            title: 'Your Autosave setup was successful!',
            source: GTSOURCE.autosave);
      }
    });
  }

  initiateCustomSubscription() async {
    _analyticsService.track(eventName: AnalyticsEvents.autosaveSetupInitiated);
    _analyticsService.track(eventName: AnalyticsEvents.autosaveUpiEntered);
    if (counter > 4) {
      return BaseUtil.showNegativeAlert(
          "Too many attempts", "Please try again later");
    }
    if (!_userService.baseUser.isAugmontOnboarded) {
      return BaseUtil.showNegativeAlert("You are not onboarded to augmont yet",
          "Please finish augmont onboarding first");
    }
    isSubscriptionInProgress = true;
    PaytmResponse response =
        await _paytmService.initiateCustomSubscription(vpaController.text);
    isSubscriptionInProgress = false;
    if (response.status) {
      _analyticsService.track(
          eventName: AnalyticsEvents.autosaveMandateGenerated);
      checkForUPIAppExistence(vpaController.text.trim().split("@").last);
      _paytmService.jumpToSubPage(1);
      _paytmService.fraction = 1;
      Future.delayed(Duration(minutes: 8), () {
        if (_paytmService.fraction == 1) {
          _analyticsService.track(
              eventName: AnalyticsEvents.autosaveMandateTimeout);
          AppState.backButtonDispatcher.didPopRoute();
          BaseUtil.showNegativeAlert(
              "Your Autosave is taking longer than usual.",
              "We'll get back to you in 10 mins");
        }
      });
    } else
      BaseUtil.showNegativeAlert(
        response.title ?? "Something went wrong!!",
        response.subtitle ?? "Please try again",
      );
  }

  setSubscriptionAmount(double amount) async {
    if (isDaily)
      _analyticsService.track(eventName: AnalyticsEvents.autosaveDailySaver);
    else
      _analyticsService.track(eventName: AnalyticsEvents.autosaveWeeklySaver);

    if (amount == null || amount == 0) {
      BaseUtil.showNegativeAlert(
          "No Amount Entered", "Please enter some amount to continue");
      return;
    }
    if (amount < minValue) {
      return BaseUtil.showNegativeAlert(
        'Minimum amount should be ₹ $minValue',
        'Please enter a minimum amount of ₹ $minValue',
      );
    }
    if (_paytmService.activeSubscription != null) {
      isSubscriptionAmountUpdateInProgress = true;
      final res = await _paytmService.updateDailySubscriptionAmount(
          amount: amount, freq: isDaily ? "DAILY" : "WEEKLY");
      isSubscriptionAmountUpdateInProgress = false;
      if (res) {
        _paytmService.jumpToSubPage(3);
        _paytmService.getActiveSubscriptionDetails();
        showProgressIndicator = false;
        Future.delayed(Duration(milliseconds: 1000), () {
          lottieAnimationController.forward();
          _paytmService.currentSubscriptionId = null;
        });
        _analyticsService.track(
            eventName: AnalyticsEvents.autosaveSetupCompleted);

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
      // subId = res['subId'] ?? "";
      if (res['gtId'] != null && res['gtId'].toString().isNotEmpty) {
        _logger.d(res.toString());
        GoldenTicketService.goldenTicketId = res['gtId'];
      }
      _paytmService.getActiveSubscriptionDetails();
      _paytmService.jumpToSubPage(2);
      _paytmService.fraction = 2;
      showProgressIndicator = false;
      // onAmountValueChanged(amountFieldController.text);

    } else if (res['status'] == false) {
      tryAgain();
      BaseUtil.showNegativeAlert("Something went wrong!!",
          res['message'] ?? "Please try after sometime");
    } else {
      tryAgain();
      BaseUtil.showNegativeAlert(
          "Something went wrong!", "Please try again after sometime");
    }
  }

  checkForUPIAppExistence(String upi) async {
    switch (upi) {
      case 'upi':
        androidPackageName = "in.org.npci.upiapp";
        iosUrlScheme = "bhim";
        break;
      case 'paytm':
        androidPackageName = "net.one97.paytm";
        iosUrlScheme = "paytm";
        break;
      case 'ybl':
        androidPackageName = "com.phonepe.app";
        iosUrlScheme = "phonepe";
        break;
      case 'ibl':
        androidPackageName = "com.phonepe.app";
        iosUrlScheme = "phonepe";
        break;
      case 'axl':
        androidPackageName = "com.phonepe.app";
        iosUrlScheme = "phonepe";
        break;
      case 'okhdfcbank':
        androidPackageName = "com.google.android.apps.nbu.paisa.user";
        iosUrlScheme = "gpay";
        break;
      case 'okaxis':
        androidPackageName = "com.google.android.apps.nbu.paisa.user";
        iosUrlScheme = "gpay";
        break;
      case 'apl':
        androidPackageName = "in.amazon.mShop.android.shopping";
        iosUrlScheme = "amazon";
        break; // case 'indus':
    }
    if (await LaunchApp.isAppInstalled(
        androidPackageName: androidPackageName, iosUrlScheme: iosUrlScheme)) {
      showAppLaunchButton = true;
    }
  }
}
