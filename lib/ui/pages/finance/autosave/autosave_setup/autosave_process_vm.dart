import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/amount_chips_model.dart';
import 'package:felloapp/core/model/sub_combos_model.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/subscription_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/modalsheets/autosave_combo_input_modalsheet.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
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

  List<AmountChipsModel> augDailyChips = defaultAmountChipList;
  List<AmountChipsModel> augWeeklyChips = defaultAmountChipList;
  List<AmountChipsModel> augMonthlyChips = defaultAmountChipList;

  List<AmountChipsModel> lbDailyChips = defaultAmountChipList;
  List<AmountChipsModel> lbWeeklyChips = defaultAmountChipList;
  List<AmountChipsModel> lbMonthlyChips = defaultAmountChipList;

  List<SubComboModel> dailyCombos = defaultSipComboList;
  List<SubComboModel> weeklyCombos = defaultSipComboList;
  List<SubComboModel> monthlyCombos = defaultSipComboList;
  late List<ApplicationMeta> appsList;
  ApplicationMeta? _selectedUpiApp;
  String finalButtonCta = "SETUP";
  SubComboModel? customComboModel;
  bool readOnly = true;

  int _selectedAssetOption = 2;
  int _totalInvestingAmount = 0;
  bool isUpdateFlow = false;

  int get totalInvestingAmount => this._totalInvestingAmount;

  set totalInvestingAmount(int value) {
    this._totalInvestingAmount = value;
    notifyListeners();
  }

  int get selectedAssetOption => this._selectedAssetOption;

  set selectedAssetOption(int value) {
    this._selectedAssetOption = value;
    if (value == 0) {
      floAmountFieldController!.text = '0';
      goldAmountFieldController!.text = '0';
      _totalInvestingAmount = 0;
      onComboTapped(2);
      comboController = PageController();
    } else if (value == 1) {
      floAmountFieldController!.text = '100';
      goldAmountFieldController!.text = '0';
      _totalInvestingAmount = 100;
      readOnly = true;
    } else {
      floAmountFieldController!.text = '0';
      goldAmountFieldController!.text = '100';
      _totalInvestingAmount = 100;
      readOnly = true;
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
        selectedAssetOption != 0
            ? chipsController!.jumpToPage(
                0,
              )
            : comboController!.jumpToPage(
                0,
              );
        break;
      case FREQUENCY.weekly:
        minValue = 100;
        selectedAssetOption != 0
            ? chipsController!.jumpToPage(
                1,
              )
            : comboController!.jumpToPage(
                1,
              );
        break;
      case FREQUENCY.monthly:
        minValue = 200;
        selectedAssetOption != 0
            ? chipsController!.jumpToPage(
                2,
              )
            : comboController!.jumpToPage(
                2,
              );
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
  PageController? chipsController = PageController();
  PageController? comboController = PageController();
  PageController? optionsController;
  TextEditingController? goldAmountFieldController;
  TextEditingController? floAmountFieldController;

  List<AutosaveAssetModel> autosaveAssetOptionList = [];

  enableField() {
    if (readOnly) {
      readOnly = false;
      notifyListeners();
    }
  }

  getAvailableUpiApps() async {
    appsList = await _subService.getUPIApps();
  }

  void proceed() {
    pageController
        .animateToPage(pageController.page!.toInt() + 1,
            duration: Duration(milliseconds: 500), curve: Curves.decelerate)
        .then(
      (_) {
        if (pageController.page!.toInt() == 1) {
          PreferenceHelper.setBool(
              PreferenceHelper.CACHE_IS_AUTOSAVE_FIRST_TIME, false);
        }
        if (pageController.page!.toInt() > 2) {
          AppState.showAutosaveBt = true;
          print("--------------------------------");
        }
      },
    );
  }

  init() async {
    state = ViewState.Busy;

    await _subService.getSubscription();
    if (_subService.autosaveState == AutosaveState.IDLE) {
      goldAmountFieldController = TextEditingController();
      await getAvailableUpiApps();
      _subService.getAutosaveSuggestions().then((_) {
        augDailyChips = _subService.suggestions[0][0];
        augWeeklyChips = _subService.suggestions[0][1];
        augMonthlyChips = _subService.suggestions[0][2];

        lbDailyChips = _subService.suggestions[1][0];
        lbWeeklyChips = _subService.suggestions[1][1];
        lbMonthlyChips = _subService.suggestions[1][2];

        dailyCombos = _subService.suggestions[2][0];
        weeklyCombos = _subService.suggestions[2][1];
        monthlyCombos = _subService.suggestions[2][2];
      });
      autosaveAssetOptionList = [
        AutosaveAssetModel(
          asset: "assets/vectors/flogold.svg",
          title: "Fello Flo + Digital Gold",
          subtitle: "Save in both of your favorite assets & earn great returns",
          isPopular: true,
          isEnabled: _userService!.isSimpleKycVerified,
        ),
        AutosaveAssetModel(
          asset: Assets.felloFlo,
          title: "Fello Flo",
          subtitle: "The 10% fund is now available for Autosave",
          isEnabled: _userService!.isSimpleKycVerified,
        ),
        AutosaveAssetModel(
            asset: Assets.digitalGoldBar,
            title: "Digital Gold",
            subtitle: "Stable returns are now automated with Autosave",
            isEnabled: true)
      ];
      floAmountFieldController = TextEditingController();

      selectedAssetOption = _userService!.isSimpleKycVerified ? 0 : 2;
      // if (_userService!.isSimpleKycVerified) {
      pageController.addListener(
        () {
          if ((pageController.page ?? 0).toInt() != currentPage) {
            currentPage = pageController.page!.toInt();
          }
        },
      );
      // }
    }

    setState(ViewState.Idle);
    if (!PreferenceHelper.getBool(
        PreferenceHelper.CACHE_IS_AUTOSAVE_FIRST_TIME))
      pageController.jumpToPage(1);
  }

  dump() {
    pageController.dispose();
    optionsController?.dispose();
    goldAmountFieldController?.dispose();
    floAmountFieldController?.dispose();
    _selectedAssetOption = 0;
    _selectedFrequency = FREQUENCY.daily;
    autosaveAssetOptionList.clear();
  }

  updateInit() async {
    isUpdateFlow = true;
    finalButtonCta = "UPDATE";
    state = ViewState.Busy;
    // if (_subService.autosaveState == AutosaveState.IDLE) {
    goldAmountFieldController = TextEditingController(
        text: _subService.subscriptionData!.augAmt ?? '0');
    _subService.getAutosaveSuggestions().then((_) {
      augDailyChips = _subService.suggestions[0][0];
      augWeeklyChips = _subService.suggestions[0][1];
      augMonthlyChips = _subService.suggestions[0][2];

      lbDailyChips = _subService.suggestions[1][0];
      lbWeeklyChips = _subService.suggestions[1][1];
      lbMonthlyChips = _subService.suggestions[1][2];

      dailyCombos = _subService.suggestions[2][0];
      weeklyCombos = _subService.suggestions[2][1];
      monthlyCombos = _subService.suggestions[2][2];
    });
    autosaveAssetOptionList = [
      AutosaveAssetModel(
        asset: "assets/vectors/flogold.svg",
        title: "Fello Flo + Digital Gold",
        subtitle: "Save in both of your favorite assets & earn great returns",
        isPopular: true,
        isEnabled: _userService!.isSimpleKycVerified,
      ),
      AutosaveAssetModel(
        asset: Assets.felloFlo,
        title: "Fello Flo",
        subtitle: "The 10% fund is now available for Autosave",
        isEnabled: _userService!.isSimpleKycVerified,
      ),
      AutosaveAssetModel(
          asset: Assets.digitalGoldBar,
          title: "Digital Gold",
          subtitle: "Stable returns are now automated with Autosave",
          isEnabled: true)
    ];
    floAmountFieldController =
        TextEditingController(text: _subService.subscriptionData!.lbAmt ?? '0');
    selectedAssetOption = _userService!.isSimpleKycVerified ? 0 : 2;
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
    _selectedAssetOption = 0;
    _selectedFrequency = FREQUENCY.daily;
    autosaveAssetOptionList.clear();
  }

  Future<void> createSubscription() async {
    AppState.showAutosaveBt = false;
    await _subService.createSubscription(
      amount: totalInvestingAmount,
      freq: selectedFrequency.name.toUpperCase(),
      lbAmt: int.tryParse(floAmountFieldController?.text ?? '0')!,
      augAmt: int.tryParse(goldAmountFieldController?.text ?? '0')!,
      package: FlavorConfig.isDevelopment()
          ? "com.phonepe.app.preprod"
          : selectedUpiApp!.packageName,
    );
  }

  Future<void> updateSubscription() async {
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
      proceed();
    isSubscriptionCreationInProgress = false;
  }

  bool checkForLowAmount() {
    return false;
  }

  int getChipsLength() {
    switch (selectedFrequency) {
      case FREQUENCY.daily:
        return selectedAssetOption == 1
            ? lbDailyChips.length
            : augDailyChips.length;
      case FREQUENCY.weekly:
        return selectedAssetOption == 1
            ? lbWeeklyChips.length
            : augWeeklyChips.length;
      case FREQUENCY.monthly:
        return selectedAssetOption == 1
            ? lbMonthlyChips.length
            : augMonthlyChips.length;
    }
  }

  List<AmountChipsModel> getChips(FREQUENCY freq) {
    switch (selectedFrequency) {
      case FREQUENCY.daily:
        return selectedAssetOption == 1 ? lbDailyChips : augDailyChips;
      case FREQUENCY.weekly:
        return selectedAssetOption == 1 ? lbWeeklyChips : augWeeklyChips;
      case FREQUENCY.monthly:
        return selectedAssetOption == 1 ? lbMonthlyChips : augMonthlyChips;
    }
  }

  List<SubComboModel> getCombos(FREQUENCY freq) {
    switch (selectedFrequency) {
      case FREQUENCY.daily:
        return dailyCombos;
      case FREQUENCY.weekly:
        return weeklyCombos;
      case FREQUENCY.monthly:
        return monthlyCombos;
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
        selectedFrequency == 1
            ? lbDailyChips[index].isSelected = true
            : augDailyChips[index].isSelected = true;
        break;
      case FREQUENCY.weekly:
        selectedFrequency == 1
            ? lbWeeklyChips[index].isSelected = true
            : augWeeklyChips[index].isSelected = true;
        break;
      case FREQUENCY.monthly:
        selectedFrequency == 1
            ? lbMonthlyChips[index].isSelected = true
            : augMonthlyChips[index].isSelected = true;
        break;
    }
    notifyListeners();
  }

  void onComboTapped(int index) {
    Haptic.vibrate();
    if (customComboModel != null) customComboModel!.isSelected = false;
    deselectOtherComboIfAny();
    switch (selectedFrequency) {
      case FREQUENCY.daily:
        dailyCombos[index].isSelected = true;
        floAmountFieldController!.text =
            dailyCombos[index].LENDBOXP2P.toString();
        goldAmountFieldController!.text =
            dailyCombos[index].AUGGOLD99.toString();

        break;
      case FREQUENCY.weekly:
        weeklyCombos[index].isSelected = true;
        floAmountFieldController!.text =
            weeklyCombos[index].LENDBOXP2P.toString();
        goldAmountFieldController!.text =
            weeklyCombos[index].AUGGOLD99.toString();
        break;
      case FREQUENCY.monthly:
        monthlyCombos[index].isSelected = true;
        floAmountFieldController!.text =
            monthlyCombos[index].LENDBOXP2P.toString();
        goldAmountFieldController!.text =
            monthlyCombos[index].AUGGOLD99.toString();
        break;
    }
    totalInvestingAmount = int.tryParse(goldAmountFieldController!.text)! +
        int.tryParse(floAmountFieldController!.text)!;
    // notifyListeners();
  }

  void _deselectOtherChipIfAny() {
    augDailyChips.forEach((chip) => chip.isSelected = false);
    augWeeklyChips.forEach((chip) => chip.isSelected = false);
    augMonthlyChips.forEach((chip) => chip.isSelected = false);
    lbDailyChips.forEach((chip) => chip.isSelected = false);
    lbWeeklyChips.forEach((chip) => chip.isSelected = false);
    lbMonthlyChips.forEach((chip) => chip.isSelected = false);
  }

  deselectOtherComboIfAny({bool notify = false}) {
    dailyCombos.forEach((chip) => chip.isSelected = false);
    weeklyCombos.forEach((chip) => chip.isSelected = false);
    monthlyCombos.forEach((chip) => chip.isSelected = false);
    if (notify) notifyListeners();
  }

  onCompleteClose() {
    _analyticsService!
        .track(eventName: AnalyticsEvents.autosaveCompleteScreenClosed);
    AppState.backButtonDispatcher!.didPopRoute();
    _gtService.fetchAndVerifyScratchCardByID();
  }

  openCustomInputModalSheet(model, {bool isNew = true}) {
    if (!isNew) {
      floAmountFieldController!.text = customComboModel!.AUGGOLD99.toString();
      goldAmountFieldController!.text = customComboModel!.LENDBOXP2P.toString();
      customComboModel!.isSelected = true;
      totalInvestingAmount =
          customComboModel!.AUGGOLD99 + customComboModel!.LENDBOXP2P;
      deselectOtherComboIfAny();
      notifyListeners();
    }
    return BaseUtil.openModalBottomSheet(
      isBarrierDismissible: true,
      addToScreenStack: true,
      backgroundColor: UiConstants.kBackgroundColor,
      isScrollControlled: true,
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(SizeConfig.roundness32),
          topRight: Radius.circular(SizeConfig.roundness32)),
      hapticVibrate: true,
      content: AutosaveComboInputFieldsModalSheet(model: model),
    );
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
