import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/model/amount_chips_model.dart';
import 'package:felloapp/core/service/analytics/analyticsProperties.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/paytm_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_buy/augmont_buy_vm.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';

// enum STATUS { Pending, Complete, Cancel }
//TODO add chip tap to Enter amount setup
class AutosaveProcessViewModel extends BaseViewModel {
  final PaytmService? _paytmService = locator<PaytmService>();
  final CustomLogger? _logger = locator<CustomLogger>();
  final UserService? _userService = locator<UserService>();
  final AnalyticsService? _analyticsService = locator<AnalyticsService>();
  final ScratchCardService _gtService = ScratchCardService();
  final AnalyticsService? _analyticService = locator<AnalyticsService>();
  S locale = locator<S>();

  FocusNode sipAmountNode = FocusNode();
  bool _showSetAmountView = false;
  bool _isDaily = true;
  bool _showProgressIndicator = false;
  bool _showConfetti = false;
  AnimationController? lottieAnimationController;
  String _androidPackageName = "";
  String _iosUrlScheme = "";
  int lastTappedChipAmount = 0;

  int _minValue = 25;
  int maxAmount = 5000;
  String _title = "Set up Autosave";
  String get title => this._title;
  bool _showAppLaunchButton = false;
  int counter = 0;
  int _currentPage = 0;
  bool _showMinAlert = false;
  Timer? _timer;

  List<AmountChipsModel>? _dailyChips = [];
  List<AmountChipsModel>? _weeklyChips = [];

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
      _paytmService!.subscriptionFlowPageController;
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

  get currentPage => this._currentPage;

  set currentPage(value) {
    this._currentPage = value;
    notifyListeners();
  }

  init(int page) async {
    getChipAmounts();
    pageController.addListener(() {
      currentPage = pageController.page!.round();
    });
    counter = 0;
    _paytmService!.isOnSubscriptionFlow = true;
    showProgressIndicator = true;
    if (FlavorConfig.isDevelopment()) vpaController.text = "7777777777@paytm";
    if (_paytmService!.activeSubscription != null)
      vpaController.text = _paytmService!.activeSubscription!.vpa!;
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _paytmService!.jumpToSubPage(page);
      _paytmService!.fraction = page;
      if (page == 1) {
        checkForUPIAppExistence(vpaController.text.trim().split("@").last);
      }
      // getTitle();
      print(pageController.page);
      showProgressIndicator = true;
      _paytmService!.processText = "processing";
    });
    onAmountValueChanged(amountFieldController.text);
  }

  clear() {
    _timer?.cancel();
    lottieAnimationController?.dispose();
  }

  onAmountValueChanged(String val) {
    if (val == "00000") amountFieldController.text = '0';
    if (val != null && val.isNotEmpty) {
      if (int.tryParse(val)! < minValue)
        showMinAlert = true;
      else
        showMinAlert = false;
      if (int.tryParse(val)! > maxAmount) {
        amountFieldController.text = maxAmount.toString();
        val = maxAmount.toString();
        FocusManager.instance.primaryFocus!.unfocus();
      }
    } else {
      val = '0';
    }
    saveAmount = calculateSaveAmount(int.tryParse(val ?? '0')!);
    notifyListeners();
  }

  double calculateSaveAmount(int amount) {
    final double p = amount * (isDaily ? 365.0 : 52.0);
    final double r = 6;
    final double t = 1;
    final double ci = p * (pow(1 + r / 100, t) - 1);
    return p + ci;
  }

  checkTransactionStatus() {
    _timer = Timer.periodic(Duration(seconds: 15), (timer) async {
      if (_paytmService!.subscriptionFlowPageController.page == 1.0) {
        _logger!.d("Fetching Autosave details");
        await _paytmService!.getActiveSubscriptionDetails();
        if (_paytmService!.activeSubscription != null &&
            _paytmService!.activeSubscription!.status ==
                Constants.SUBSCRIPTION_INACTIVE &&
            pageController.page == 1.0) {
          _paytmService!.jumpToSubPage(2);
          _paytmService!.fraction = 2;
          showProgressIndicator = false;
        }
      }
    });
  }

  trackSIPUpdateEvent() {
    bool isSuggested = false;
    for (AmountChipsModel a in dailyChips) {
      if (a.value.toString() == amountFieldController.text) {
        isSuggested = true;
        break;
      }
    }
    _analyticService!
        .track(eventName: AnalyticsEvents.autoSaveUpdateTapped, properties: {
      "Previous Amount": _paytmService!.activeSubscription != null
          ? _paytmService!.activeSubscription!.autoAmount.toString()
          : "Not fetched",
      "New Amount": amountFieldController.text,
      "Previous Frequency": _paytmService!.activeSubscription!.autoFrequency,
      "New Frequency": isDaily ? "DAILY" : "MONTHLY",
      "Auto Suggest": isSuggested,
      "Total invested amount": AnalyticsProperties.getGoldInvestedAmount() +
          AnalyticsProperties.getFelloFloAmount(),
      "Amount invested in gold": AnalyticsProperties.getGoldInvestedAmount(),
      "Grams of gold owned": AnalyticsProperties.getGoldQuantityInGrams(),
      "Selected Chip Amount": lastTappedChipAmount,
    });
  }

  trackSIPSetUpEvent() {
    _analyticService!.track(
        eventName: AnalyticsEvents.enterAmountSetup,
        properties:
            AnalyticsProperties.getDefaultPropertiesMap(extraValuesMap: {
          "Frequency": isDaily ? "Daily" : "Weekly",
          "Amount": amountFieldController.text,
        }));
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
    dailyChips = await _paytmService!.getAmountChips(
      freq: Constants.DOC_IAR_DAILY_CHIPS,
    );
    weeklyChips = await _paytmService!.getAmountChips(
      freq: Constants.DOC_IAR_WEEKLY_CHIPS,
    );
  }

  tryAgain() {
    _paytmService!.jumpToSubPage(0);
    showProgressIndicator = true;
    _paytmService!.fraction = 0;
  }

  onCompleteClose() {
    _analyticsService!
        .track(eventName: AnalyticsEvents.autosaveCompleteScreenClosed);
    AppState.backButtonDispatcher!.didPopRoute();
    _gtService.fetchAndVerifyScratchCardByID();
  }

  initiateCustomSubscription() async {
    _analyticsService!.track(eventName: AnalyticsEvents.autosaveSetupInitiated);
    _analyticsService!.track(eventName: AnalyticsEvents.autosaveUpiEntered);

    if (counter > 4) {
      return BaseUtil.showNegativeAlert(
          locale.tooManyAttempts, locale.tryLater);
    }
    if (!_userService!.baseUser!.isAugmontOnboarded!) {
      return BaseUtil.showNegativeAlert(
          locale.augmountOnboardTitle, locale.augmountOnboardSubTitle);
    }
    isSubscriptionInProgress = true;
    AppState.screenStack.add(ScreenItem.loader);
    PaytmResponse response =
        await _paytmService!.initiateCustomSubscription(vpaController.text);
    isSubscriptionInProgress = false;
    if (AppState.screenStack.last == ScreenItem.loader) {
      AppState.screenStack.removeLast();
    }
    if (response.status!) {
      _analyticsService!
          .track(eventName: AnalyticsEvents.upiSubmitTappped, properties: {
        "verification status": "Sucess",
        "UPI Id": vpaController.text,
      });
      checkForUPIAppExistence(vpaController.text.trim().split("@").last);
      checkTransactionStatus();
      _paytmService!.jumpToSubPage(1);
      _paytmService!.fraction = 1;
      Future.delayed(Duration(minutes: 8), () {
        if (_paytmService!.fraction == 1) {
          _paytmService!.fraction = 0;
          _analyticsService!
              .track(eventName: AnalyticsEvents.upiSubmitTappped, properties: {
            "verification status": "Pending",
            "UPI Id": vpaController.text,
          });
          AppState.backButtonDispatcher!.didPopRoute();
          showAutosavePendingDialog();
        }
      });
    } else
      BaseUtil.showNegativeAlert(
        response.title ?? locale.obSomeThingWentWrong,
        response.subtitle ?? locale.obPleaseTryAgain,
      );
  }

  setSubscriptionAmount(double amount) async {
    if (amount == 0) {
      BaseUtil.showNegativeAlert(
          locale.noAmountEntered, locale.pleaseEnterSomeAmount);
      return;
    }
    if (amount < minValue) {
      return BaseUtil.showNegativeAlert(
        locale.minAmountShouldBe + '$minValue',
        locale.enterMinAmount + '$minValue',
      );
    }
    if (_paytmService!.activeSubscription != null) {
      isSubscriptionAmountUpdateInProgress = true;
      final res = await (_paytmService!.updateDailySubscriptionAmount(
          amount: amount, freq: isDaily ? "DAILY" : "WEEKLY") as Future<bool>);
      isSubscriptionAmountUpdateInProgress = false;
      if (res) {
        _paytmService!.jumpToSubPage(3);
        _paytmService!.fraction = 0;
        // _paytmService!.getActiveSubscriptionDetails();
        showProgressIndicator = false;
        // Future.delayed(Duration(milliseconds: 1000), () {
        //   lottieAnimationController.forward();
        //   _paytmService.currentSubscriptionId = null;
        // });

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
        _logger!.d(res.toString());
        ScratchCardService.scratchCardId = res['gtId'];
      }
      if (_paytmService!.subscriptionFlowPageController.page == 1.0) {
        // _paytmService!.getActiveSubscriptionDetails();
        _paytmService!.jumpToSubPage(2);
        _paytmService!.fraction = 2;
        showProgressIndicator = false;
      }
      // onAmountValueChanged(amountFieldController.text);

    } else if (res['status'] == false) {
      tryAgain();
      BaseUtil.showNegativeAlert(
          locale.obSomeThingWentWrong, res['message'] ?? locale.tryLater);
    } else {
      tryAgain();
      BaseUtil.showNegativeAlert(locale.obSomeThingWentWrong, locale.tryLater);
    }
  }

  showAutosavePendingDialog() {
    Future.delayed(Duration(seconds: 1), () {
      BaseUtil.openDialog(
        addToScreenStack: true,
        hapticVibrate: true,
        isBarrierDismissible: false,
        content: PendingDialog(
          title: locale.processing,
          subtitle: locale.autoSaveDelay,
          duration: '20' + locale.minutes,
        ),
      );
    });
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
