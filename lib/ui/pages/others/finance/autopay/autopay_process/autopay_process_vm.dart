import 'dart:convert';
import 'dart:math';

import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/model/amount_chips_model.dart';
import 'package:felloapp/core/service/notifier_services/paytm_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
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

  bool _showSetAmountView = false;
  bool _isDaily = true;
  bool _showProgressIndicator = false;
  int _fraction = 0;
  int minAmount = 10;
  int maxAmount = 5000;
  String _title = "Set up Autosave";
  String get title => this._title;
  bool _showAppLaunchButton = false;
  int counter = 0;

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

  // List<String> autosaveBenifits = [
  //   "https://img.freepik.com/free-vector/rebate-program-consumer-benefit-selling-discount-customer-reward-online-store-e-shopping-internet-shop-money-savings-cumulative-bonuses-vector-isolated-concept-metaphor-illustration_335657-2754.jpg?t=st=1649673787~exp=1649674387~hmac=30b282fd0156a96e060169f8a9cc7f0f01fed296dcd524b4cba491a238b88e8a&w=826",
  //   "https://img.freepik.com/free-vector/vintage-theatre-tickets-template-golden-tickets-isolated_53562-6579.jpg?w=826"
  //       "https://img.freepik.com/free-vector/indian-rupee-coins-falling-background_23-2148005748.jpg?t=st=1649674476~exp=1649675076~hmac=0e02a76793ab8663a09722875f0acdfca3c1f61f3aabe676a99abc7cb90e5e9e&w=826"
  // ];

  get showAppLaunchButton => this._showAppLaunchButton;

  set showAppLaunchButton(value) {
    this._showAppLaunchButton = value;
    notifyListeners();
  }

  // double sliderValue = 500;
  double saveAmount = 500;
  RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  String Function(Match) mathFunc = (Match match) => '${match[1]},';
  static const kTileHeight = 50.0;

  final completeColor = UiConstants.primaryColor;
  final inProgressColor = UiConstants.tertiarySolid;
  final todoColor = Color(0xffd1d2d7);
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

  get showProgressIndicator => this._showProgressIndicator;

  set showProgressIndicator(value) {
    this._showProgressIndicator = value;
    notifyListeners();
  }

  get fraction => this._fraction;

  set fraction(value) {
    this._fraction = value;
    _logger.d("Fraction value: $_fraction");
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
      fraction = page;
      // getTitle();
      print(pageController.page);
      showProgressIndicator = true;
      _paytmService.processText = "processing";
    });
    onAmountValueChanged(amountFieldController.text);
  }

  Color getColor(int index) {
    if (index == fraction) {
      return inProgressColor;
    } else if (index < fraction) {
      return completeColor;
    } else {
      return todoColor;
    }
  }

  onAmountValueChanged(String val) {
    if (val != null && val.isNotEmpty) {
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
    fraction = 0;
  }

  initiateCustomSubscription() async {
    if (counter > 4) {
      return BaseUtil.showNegativeAlert(
          "Too many attempts", "Please try again later");
    }
    if (!_userService.baseUser.isAugmontOnboarded) {
      return BaseUtil.showNegativeAlert("You are not onboarded to augmont yet",
          "Please finish augmont onboarding first");
    }

    isSubscriptionInProgress = true;

    // await _paytmService.getActiveSubscriptionDetails();
    // if (_paytmService.activeSubscription != null) {
    //   BaseUtil.showNegativeAlert("You are already subscribed",
    //       "Check Autosave details sections for more info");
    //   isSubscriptionInProgress = false;
    //   return;
    // }

    PaytmResponse response =
        await _paytmService.initiateCustomSubscription(vpaController.text);
    isSubscriptionInProgress = false;
    if (response.status) {
      _paytmService.jumpToSubPage(1);
      fraction = 1;
      AppState.screenStack.add(ScreenItem.loader);
      Future.delayed(Duration(minutes: 8), () {
        if (AppState.screenStack.last == ScreenItem.loader) {
          AppState.screenStack.removeLast();
          AppState.backButtonDispatcher.didPopRoute();
          BaseUtil.showNegativeAlert(
              "Its taking too long", "We'll inform you in 15 mins");
        }
      });
    } else
      BaseUtil.showNegativeAlert(
        response.title ?? "Something went wrong!!",
        response.subtitle ?? "Please try again",
      );
  }

  setSubscriptionAmount(double amount) async {
    if (amount == null || amount == 0) {
      BaseUtil.showNegativeAlert(
          "No Amount Entered", "Please enter some amount to continue");
      return;
    }
    if (amount < 10) {
      return BaseUtil.showNegativeAlert(
        'Minimum amount should be ₹ 10',
        'Please enter a minimum amount of ₹ 10',
      );
    }
    if (_paytmService.activeSubscription != null) {
      isSubscriptionAmountUpdateInProgress = true;
      final res = await _paytmService.updateDailySubscriptionAmount(
          amount: amount, freq: isDaily ? "DAILY" : "WEEKLY");
      isSubscriptionAmountUpdateInProgress = false;
      if (res) {
        _paytmService.jumpToSubPage(3);
        showProgressIndicator = false;
        Future.delayed(Duration(seconds: 4), () {
          while (AppState.screenStack.length > 1)
            AppState.backButtonDispatcher.didPopRoute();
          _paytmService.currentSubscriptionId = null;
        });
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
      _paytmService.getActiveSubscriptionDetails();
      _paytmService.jumpToSubPage(2);
      fraction = 2;
      showProgressIndicator = false;
      // onAmountValueChanged(amountFieldController.text);

    } else {
      BaseUtil.showNegativeAlert(
          "Something went wrong!", "Please try again after sometime");
      showProgressIndicator = false;
    }
  }

  checkForUPIAppExistence(upi) async {
    String androidPackageName = "net.one97.paytm";
    String iosUrlScheme = "paytmmp://mini-app?";
    // switch (upi) {
    //   case 'upi':
    //     androidPackageName = 'BHIM';
    //     iosUrlScheme = "";
    //     break;
    //   case 'paytm':
    //     androidPackageName = 'BHIM';
    //     iosUrlScheme = "";
    //     break;
    //   case 'ybl':
    //     androidPackageName = 'BHIM';
    //     iosUrlScheme = "";
    //     break;
    //   case 'ibl':
    //     androidPackageName = 'BHIM';
    //     iosUrlScheme = "";
    //     break;
    //   case 'axl':
    //     androidPackageName = 'BHIM';
    //     iosUrlScheme = "";
    //     break;
    //   case 'okhdfcbank':
    //     androidPackageName = 'BHIM';
    //     iosUrlScheme = "";
    //     break;
    //   case 'okaksix':
    //     androidPackageName = 'BHIM';
    //     iosUrlScheme = "";
    //     break;
    //   case 'apl':
    //     androidPackageName = 'BHIM';
    //     iosUrlScheme = "";
    //     break; // case 'indus':
    //   //   return "BHIM Indus Pay";
    //   // case 'boi':
    //   //   return "BHIM BOI UPI";
    //   // case 'cnrb':
    //   //   return "BHIM Canara";
    //   // default:
    //   //   return "preferred UPI";
    // }
    if (await LaunchApp.isAppInstalled(
        androidPackageName: androidPackageName, iosUrlScheme: iosUrlScheme)) {
      showAppLaunchButton = true;
    }
  }
}
