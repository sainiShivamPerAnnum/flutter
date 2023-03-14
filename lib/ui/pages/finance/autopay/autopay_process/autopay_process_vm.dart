import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/amount_chips_model.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/paytm_service.dart';
import 'package:felloapp/core/service/subscription_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:upi_pay/upi_pay.dart';

enum FREQUENCY { daily, weekly }

enum STATUS { Pending, Complete, Init }

//TODO add chip tap to Enter amount setup
class AutosaveProcessViewModel extends BaseViewModel {
  final PaytmService? _paytmService = locator<PaytmService>();
  final CustomLogger? _logger = locator<CustomLogger>();
  final UserService? _userService = locator<UserService>();
  final AnalyticsService? _analyticsService = locator<AnalyticsService>();
  final ScratchCardService _gtService = ScratchCardService();
  final SubService _subService = locator<SubService>();
  S locale = locator<S>();

  // AutosaveState autosaveState = AutosaveState.IDLE;
  late List<ApplicationMeta> appsList;
  ApplicationMeta? _selectedUpiApp;

  ApplicationMeta? get selectedUpiApp => this._selectedUpiApp;

  set selectedUpiApp(value) {
    this._selectedUpiApp = value;
    notifyListeners();
  }

  int _currentPage = 0, minValue = 25;
  bool _isDaily = true;

  get isDaily => this._isDaily;

  set isDaily(value) {
    this._isDaily = value;
    if (value)
      minValue = 25;
    else
      minValue = 100;
    notifyListeners();
    print(isDaily);
  }

  int get currentPage => _currentPage;
  set currentPage(int val) {
    _currentPage = val;
    notifyListeners();
  }

  PageController pageController = PageController();
  TextEditingController amountFieldController = TextEditingController();
  List<AmountChipsModel> dailyChips = [], weeklyChips = [];

  getAvailableUpiApps() async {
    appsList = await _subService.getUPIApps();
  }

  // FocusNode sipAmountNode = FocusNode();
  // bool _showSetAmountView = false;
  // bool _isDaily = true;
  // bool _showProgressIndicator = false;
  // bool _showConfetti = false;
  // AnimationController? lottieAnimationController;
  // String _androidPackageName = "";
  // String _iosUrlScheme = "";
  // int lastTappedChipAmount = 0;

  // int _minValue = 25;
  // int maxAmount = 5000;
  // String _title = "Set up Autosave";
  // String get title => this._title;
  // bool _showAppLaunchButton = false;
  // int counter = 0;
  // int _currentPage = 0;
  // bool _showMinAlert = false;
  // Timer? _timer;

  // List<AmountChipsModel>? _dailyChips = [];
  // List<AmountChipsModel>? _weeklyChips = [];

  // get dailyChips => this._dailyChips;

  // set dailyChips(dailyChips) {
  //   this._dailyChips = dailyChips;
  //   notifyListeners();
  // }

  // get weeklyChips => this._weeklyChips;

  // set weeklyChips(weeklyChips) {
  //   this._weeklyChips = weeklyChips;
  //   notifyListeners();
  // }

  // get showAppLaunchButton => this._showAppLaunchButton;

  // set showAppLaunchButton(value) {
  //   this._showAppLaunchButton = value;
  //   notifyListeners();
  // }

  // bool get showConfetti => this._showConfetti;

  // set showConfetti(bool value) {
  //   this._showConfetti = value;
  //   notifyListeners();
  // }

  // get androidPackageName => this._androidPackageName;

  // set androidPackageName(value) {
  //   this._androidPackageName = value;
  //   notifyListeners();
  // }

  // get iosUrlScheme => this._iosUrlScheme;

  // set iosUrlScheme(value) {
  //   this._iosUrlScheme = value;
  //   notifyListeners();
  // }

  // bool get showMinAlert => this._showMinAlert;

  // set showMinAlert(bool value) {
  //   this._showMinAlert = value;
  //   notifyListeners();
  // }

  // get minValue => this._minValue;

  // set minValue(value) {
  //   this._minValue = value;
  //   notifyListeners();
  // }

  // double sliderValue = 500;
  // double saveAmount = 500;
  // String Function(Match) mathFunc = (Match match) => '${match[1]},';
  // static const kTileHeight = 50.0;

  // TextEditingController amountFieldController =
  //     new TextEditingController(text: '500');

  // PageController get pageController =>
  //     _paytmService!.subscriptionFlowPageController;

  // bool get showSetAmountView => this._showSetAmountView;

  // set showSetAmountView(showSetAmountView) {
  //   this._showSetAmountView = showSetAmountView;
  //   notifyListeners();
  // }

  // get currentPage => this._currentPage;

  // set currentPage(value) {
  //   this._currentPage = value;
  //   notifyListeners();
  // }

  // init() async {
  //   getChipAmounts();
  //   onAmountValueChanged(amountFieldController.text);
  // }

  // clear() {
  //   _timer?.cancel();
  //   lottieAnimationController?.dispose();
  // }

  // onAmountValueChanged(String val) {
  //   if (val == "00000") amountFieldController.text = '0';
  //   if (val != null && val.isNotEmpty) {
  //     if (int.tryParse(val)! < minValue)
  //       showMinAlert = true;
  //     else
  //       showMinAlert = false;
  //     if (int.tryParse(val)! > maxAmount) {
  //       amountFieldController.text = maxAmount.toString();
  //       val = maxAmount.toString();
  //       FocusManager.instance.primaryFocus!.unfocus();
  //     }
  //   } else {
  //     val = '0';
  //   }
  //   saveAmount = calculateSaveAmount(int.tryParse(val ?? '0')!);
  //   notifyListeners();
  // }

  // double calculateSaveAmount(int amount) {
  //   final double p = amount * (isDaily ? 365.0 : 52.0);
  //   final double r = 6;
  //   final double t = 1;
  //   final double ci = p * (pow(1 + r / 100, t) - 1);
  //   return p + ci;
  // }

  init() async {
    state = ViewState.Busy;
    await checkAutoPayState();
    setState(ViewState.Idle);
  }

  dump() {}

  checkAutoPayState() async {
    await _subService.getSubscription();
    amountFieldController.text = '100';
    // autosaveState = _subService.autosaveState;
    await getChipAmounts();
    // if (autosaveState == AutosaveState.IDLE)
    await getAvailableUpiApps();
    //If no data exists -> Upi apps screen
    //If state is INIT -> Processing screen
    //If State is active/paused -> show AutoPay details screen with pause/resume option
  }

  Future<void> createSubscription() async {
    final res = await _subService.createSubscription(
        freq: isDaily
            ? FREQUENCY.daily.name.toUpperCase()
            : FREQUENCY.weekly.name.toUpperCase(),
        amount: int.tryParse(amountFieldController.text)!,
        package: FlavorConfig.isDevelopment()
            ? "com.phonepe.app.preprod"
            : selectedUpiApp!.packageName,
        asset: "AUGGOLD99");
    // if (res) autosaveState = AutosaveState.IDLE;
  }
  // trackSIPUpdateEvent() {
  //   bool isSuggested = false;
  //   for (AmountChipsModel a in dailyChips) {
  //     if (a.value.toString() == amountFieldController.text) {
  //       isSuggested = true;
  //       break;
  //     }
  //   }
  //   _analyticService!
  //       .track(eventName: AnalyticsEvents.autoSaveUpdateTapped, properties: {
  //     "Previous Amount": _paytmService!.activeSubscription != null
  //         ? _paytmService!.activeSubscription!.autoAmount.toString()
  //         : "Not fetched",
  //     "New Amount": amountFieldController.text,
  //     "Previous Frequency": _paytmService!.activeSubscription!.autoFrequency,
  //     "New Frequency": isDaily ? "DAILY" : "MONTHLY",
  //     "Auto Suggest": isSuggested,
  //     "Total invested amount": AnalyticsProperties.getGoldInvestedAmount() +
  //         AnalyticsProperties.getFelloFloAmount(),
  //     "Amount invested in gold": AnalyticsProperties.getGoldInvestedAmount(),
  //     "Grams of gold owned": AnalyticsProperties.getGoldQuantityInGrams(),
  //     "Selected Chip Amount": lastTappedChipAmount,
  //   });
  // }

  // trackSIPSetUpEvent() {
  //   _analyticService!.track(
  //       eventName: AnalyticsEvents.enterAmountSetup,
  //       properties:
  //           AnalyticsProperties.getDefaultPropertiesMap(extraValuesMap: {
  //         "Frequency": isDaily ? "Daily" : "Weekly",
  //         "Amount": amountFieldController.text,
  //       }));
  // }

  getChipAmounts() async {
    dailyChips = await _paytmService!.getAmountChips(
          freq: Constants.DOC_IAR_DAILY_CHIPS,
        ) ??
        [];
    weeklyChips = await _paytmService!.getAmountChips(
          freq: Constants.DOC_IAR_WEEKLY_CHIPS,
        ) ??
        [];
  }

  // tryAgain() {
  //   _paytmService!.jumpToSubPage(0);
  //   showProgressIndicator = true;
  //   _paytmService!.fraction = 0;
  // }

  onCompleteClose() {
    _analyticsService!
        .track(eventName: AnalyticsEvents.autosaveCompleteScreenClosed);
    AppState.backButtonDispatcher!.didPopRoute();
    _gtService.fetchAndVerifyScratchCardByID();
  }
}
