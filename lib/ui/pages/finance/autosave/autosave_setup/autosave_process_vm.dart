import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/amount_chips_model.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/subscription_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:upi_pay/upi_pay.dart';

enum FREQUENCY { daily, weekly, monthly }

enum STATUS { Pending, Complete, Init }

//TODO add chip tap to Enter amount setup
class AutosaveProcessViewModel extends BaseViewModel {
  // final PaytmService? _paytmService = locator<PaytmService>();
  final CustomLogger? _logger = locator<CustomLogger>();
  final UserService? _userService = locator<UserService>();
  final AnalyticsService? _analyticsService = locator<AnalyticsService>();
  final ScratchCardService _gtService = ScratchCardService();
  final SubService _subService = locator<SubService>();
  final S locale = locator<S>();

  List<AmountChipsModel> dailyChips = defaultAmountChipList;
  List<AmountChipsModel> weeklyChips = defaultAmountChipList;
  List<AmountChipsModel> monthlyChips = defaultAmountChipList;
  late List<ApplicationMeta> appsList;
  ApplicationMeta? _selectedUpiApp;
  String finalButtonCta = "SETUP";

  int _selectedAssetOption = 2;
  int _totalInvestingAmount = 0;
  bool isUpdateFlow = false;

  get totalInvestingAmount => this._totalInvestingAmount;

  set totalInvestingAmount(value) {
    this._totalInvestingAmount = value;
    notifyListeners();
  }

  int get selectedAssetOption => this._selectedAssetOption;

  set selectedAssetOption(int value) {
    this._selectedAssetOption = value;
    if (value == 0) {
      floAmountFieldController!.text = '100';
      goldAmountFieldController!.text = '100';
      _totalInvestingAmount = 200;
    } else if (value == 1) {
      floAmountFieldController!.text = '100';
      goldAmountFieldController!.text = '0';
      _totalInvestingAmount = 100;
    } else {
      floAmountFieldController!.text = '0';
      goldAmountFieldController!.text = '100';
      _totalInvestingAmount = 100;
    }
    notifyListeners();
  }

  ApplicationMeta? get selectedUpiApp => this._selectedUpiApp;

  set selectedUpiApp(value) {
    this._selectedUpiApp = value;
    notifyListeners();
  }

  int _currentPage = 0, minValue = 25;
  // bool _isDaily = true;

  FREQUENCY _selectedFrequency = FREQUENCY.daily;

  FREQUENCY get selectedFrequency => this._selectedFrequency;

  set selectedFrequency(FREQUENCY value) {
    this._selectedFrequency = value;
    switch (value) {
      case FREQUENCY.daily:
        minValue = 25;
        break;
      case FREQUENCY.weekly:
        minValue = 100;
        break;
      case FREQUENCY.monthly:
        minValue = 200;
        break;
    }
    notifyListeners();
  }

  int get currentPage => _currentPage;
  set currentPage(int val) {
    _currentPage = val;
    notifyListeners();
  }

  bool _isSubscriptionCreationInProgress = false;

  get isSubscriptionCreationInProgress =>
      this._isSubscriptionCreationInProgress;

  set isSubscriptionCreationInProgress(value) {
    this._isSubscriptionCreationInProgress = value;
    notifyListeners();
  }

  PageController pageController = PageController();
  PageController? chipsController;
  PageController? comboController;
  PageController? optionsController;
  TextEditingController? goldAmountFieldController;
  TextEditingController? floAmountFieldController;

  List<AutosaveAssetModel> autosaveAssetOptionList = [];

  getAvailableUpiApps() async {
    appsList = await _subService.getUPIApps();
  }

  void proceed() {
    pageController.animateToPage(pageController.page!.toInt() + 1,
        duration: Duration(seconds: 1), curve: Curves.decelerate);
  }

  init() async {
    state = ViewState.Busy;
    await _subService.getSubscription();
    if (_subService.autosaveState == AutosaveState.IDLE) {
      goldAmountFieldController = TextEditingController(text: '100');
      await getAvailableUpiApps();
      _subService.getAutosaveSuggestions().then((suggestions) {
        dailyChips = _subService.suggestions[0][0];
        dailyChips = _subService.suggestions[0][1];
        dailyChips = _subService.suggestions[0][2];
      });
      autosaveAssetOptionList = [
        AutosaveAssetModel(
          asset: "assets/vectors/flogold.svg",
          title: "Flo + Gold",
          subtitle: "a cocktail you need in your portfolio",
          isPopular: true,
          isEnabled: _userService!.isSimpleKycVerified,
        ),
        AutosaveAssetModel(
          asset: Assets.felloFlo,
          title: "Fello Flo",
          subtitle: "10% returns, I myself have invested there",
          isEnabled: _userService!.isSimpleKycVerified,
        ),
        AutosaveAssetModel(
            asset: Assets.digitalGoldBar,
            title: "Digital Gold",
            subtitle: "stable returns last 6 months were lit",
            isEnabled: true)
      ];
      selectedAssetOption = _userService!.isSimpleKycVerified ? 0 : 2;
      if (_userService!.isSimpleKycVerified) {
        floAmountFieldController = TextEditingController(text: '100');
        selectedAssetOption = 0;
        pageController.addListener(
          () {
            if ((pageController.page ?? 0).toInt() != currentPage) {
              currentPage = pageController.page!.toInt();
            }
          },
        );
      }
    }

    setState(ViewState.Idle);
  }

  dump() {
    pageController.dispose();
    optionsController?.dispose();
    goldAmountFieldController?.dispose();
    floAmountFieldController?.dispose();
  }

  updateInit() {
    isUpdateFlow = true;
    finalButtonCta = "UPDATE";
    state = ViewState.Busy;
    // if (_subService.autosaveState == AutosaveState.IDLE) {
    goldAmountFieldController = TextEditingController(
        text: _subService.subscriptionData!.augAmt ?? '100');
    _subService.getAutosaveSuggestions().then((suggestions) {
      dailyChips = _subService.suggestions[0][0];
      dailyChips = _subService.suggestions[0][1];
      dailyChips = _subService.suggestions[0][2];
    });
    autosaveAssetOptionList = [
      AutosaveAssetModel(
        asset: "assets/vectors/flogold.svg",
        title: "Flo + Gold",
        subtitle: "a cocktail you need in your portfolio",
        isPopular: true,
        isEnabled: _userService!.isSimpleKycVerified,
      ),
      AutosaveAssetModel(
        asset: Assets.felloFlo,
        title: "Fello Flo",
        subtitle: "10% returns, I myself have invested there",
        isEnabled: _userService!.isSimpleKycVerified,
      ),
      AutosaveAssetModel(
          asset: Assets.digitalGoldBar,
          title: "Digital Gold",
          subtitle: "stable returns last 6 months were lit",
          isEnabled: true)
    ];
    // if (_userService!.isSimpleKycVerified) {
    floAmountFieldController = TextEditingController(
        text: _subService.subscriptionData!.lbAmt ?? '100');
    selectedAssetOption = _userService!.isSimpleKycVerified ? 0 : 2;
    // }
    pageController.addListener(
      () {
        if ((pageController.page ?? 0).toInt() != currentPage) {
          currentPage = pageController.page!.toInt();
        }
      },
    );

    setState(ViewState.Idle);
  }

  updateDump() {
    pageController.dispose();
    optionsController?.dispose();
    goldAmountFieldController?.dispose();
    floAmountFieldController?.dispose();
  }

  Future<void> createOrUpdateSubscription() async {
    if (isSubscriptionCreationInProgress) return;
    if (checkForLowAmount()) return;
    isSubscriptionCreationInProgress = true;
    if (isUpdateFlow)
      await _subService.updateSubscription(
          freq: selectedFrequency.name.toUpperCase(),
          amount: totalInvestingAmount,
          lbAmt: int.tryParse(floAmountFieldController?.text ?? '0')!,
          augAmt: int.tryParse(goldAmountFieldController?.text ?? '0')!);
    else
      await _subService.createSubscription(
        amount: totalInvestingAmount,
        freq: selectedFrequency.name.toUpperCase(),
        lbAmt: int.tryParse(floAmountFieldController?.text ?? '0')!,
        augAmt: int.tryParse(goldAmountFieldController?.text ?? '0')!,
        package: FlavorConfig.isDevelopment()
            ? "com.phonepe.app.preprod"
            : selectedUpiApp!.packageName,
      );
    isSubscriptionCreationInProgress = false;
  }

  bool checkForLowAmount() {
    return false;
  }

  int getChipsLength() {
    switch (selectedFrequency) {
      case FREQUENCY.daily:
        return dailyChips.length;
      case FREQUENCY.weekly:
        return weeklyChips.length;
      case FREQUENCY.monthly:
        return monthlyChips.length;
    }
  }

  List<AmountChipsModel> getChips(FREQUENCY freq) {
    switch (selectedFrequency) {
      case FREQUENCY.daily:
        return dailyChips;
      case FREQUENCY.weekly:
        return weeklyChips;
      case FREQUENCY.monthly:
        return monthlyChips;
    }
  }

  void onChipTapped(int val, int index) {
    Haptic.vibrate();
    if (selectedAssetOption == 1) {
      floAmountFieldController!.text = val.toString();
    }
    if (selectedAssetOption == 2) {
      goldAmountFieldController!.text = val.toString();
    }
    totalInvestingAmount =
        int.tryParse(goldAmountFieldController?.text ?? '0')! +
            int.tryParse(floAmountFieldController?.text ?? '0')!;
    _deselectOtherChipIfAny();
    switch (selectedFrequency) {
      case FREQUENCY.daily:
        dailyChips[index].isSelected = true;
        break;
      case FREQUENCY.weekly:
        weeklyChips[index].isSelected = true;
        break;
      case FREQUENCY.monthly:
        monthlyChips[index].isSelected = true;
        break;
    }
    notifyListeners();
  }

  void _deselectOtherChipIfAny() {
    dailyChips.forEach((chip) => chip.isSelected = false);
    weeklyChips.forEach((chip) => chip.isSelected = false);
    monthlyChips.forEach((chip) => chip.isSelected = false);
  }

  onCompleteClose() {
    _analyticsService!
        .track(eventName: AnalyticsEvents.autosaveCompleteScreenClosed);
    AppState.backButtonDispatcher!.didPopRoute();
    _gtService.fetchAndVerifyScratchCardByID();
  }
}

class AutosaveAssetModel {
  final String asset;
  final String title;
  final String subtitle;
  final bool isPopular;
  final bool isEnabled;

  AutosaveAssetModel(
      {required this.asset,
      required this.title,
      required this.subtitle,
      required this.isEnabled,
      this.isPopular = false});
}
