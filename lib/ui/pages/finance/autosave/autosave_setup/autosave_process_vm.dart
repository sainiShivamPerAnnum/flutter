import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/amount_chips_model.dart';
import 'package:felloapp/core/model/sub_combos_model.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
import 'package:felloapp/core/service/payments/bank_and_pan_service.dart';
import 'package:felloapp/core/service/subscription_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/modalsheets/autosave_combo_input_modalsheet.dart';
import 'package:felloapp/util/assets.dart';
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

class AutosaveProcessViewModel extends BaseViewModel {
  final BankAndPanService _bankingService = locator<BankAndPanService>();
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

  MaxMin dailyMaxMinInfo =
      MaxMin(min: MinAsset(AUGGOLD99: 50, LENDBOXP2P: 100), max: 500);

  MaxMin weeklyMaxMinInfo =
      MaxMin(min: MinAsset(AUGGOLD99: 50, LENDBOXP2P: 100), max: 500);

  MaxMin monthlyMaxMinInfo =
      MaxMin(min: MinAsset(AUGGOLD99: 50, LENDBOXP2P: 100), max: 500);

  late List<ApplicationMeta> appsList;
  ApplicationMeta? _selectedUpiApp;
  String finalButtonCta = "SETUP";
  SubComboModel? customComboModel;

  int _selectedAssetOption = 2;
  int _totalInvestingAmount = 0;
  bool isUpdateFlow = false;
  String? minMaxCapString;

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
    deselectOtherComboIfAny(notify: false);
    switch (value) {
      case FREQUENCY.daily:
        if (selectedAssetOption != 0) {
          chipsController!.jumpToPage(0);
          selectedAssetOption == 1
              ? floAmountFieldController?.text =
                  lbDailyChips[0].value.toString()
              : goldAmountFieldController?.text =
                  augDailyChips[0].value.toString();
        } else {
          comboController!.jumpToPage(0);
          customComboModel = null;
          dailyCombos[2].isSelected = true;
          goldAmountFieldController?.text = dailyCombos[2].AUGGOLD99.toString();
          floAmountFieldController?.text = dailyCombos[2].LENDBOXP2P.toString();
        }
        break;
      case FREQUENCY.weekly:
        if (selectedAssetOption != 0) {
          chipsController!.jumpToPage(1);
          selectedAssetOption == 1
              ? floAmountFieldController?.text =
                  lbWeeklyChips[0].value.toString()
              : goldAmountFieldController?.text =
                  augWeeklyChips[0].value.toString();
        } else {
          comboController!.jumpToPage(1);
          customComboModel = null;
          weeklyCombos[2].isSelected = true;
          goldAmountFieldController?.text =
              weeklyCombos[2].AUGGOLD99.toString();
          floAmountFieldController?.text =
              weeklyCombos[2].LENDBOXP2P.toString();
        }
        break;
      case FREQUENCY.monthly:
        if (selectedAssetOption != 0) {
          chipsController!.jumpToPage(2);
          selectedAssetOption == 1
              ? floAmountFieldController?.text =
                  lbMonthlyChips[0].value.toString()
              : goldAmountFieldController?.text =
                  augMonthlyChips[0].value.toString();
        } else {
          comboController!.jumpToPage(2);
          customComboModel = null;
          monthlyCombos[2].isSelected = true;
          goldAmountFieldController?.text =
              monthlyCombos[2].AUGGOLD99.toString();
          floAmountFieldController?.text =
              monthlyCombos[2].LENDBOXP2P.toString();
        }
        break;
    }
    print("ComboModel : $customComboModel");
    totalInvestingAmount =
        (int.tryParse(floAmountFieldController?.text ?? '') ?? 0) +
            (int.tryParse(goldAmountFieldController?.text ?? '') ?? 0);

    if (selectedAssetOption == 1) {
      updateMinMaxCapString(floAmountFieldController?.text);
    }
    if (selectedAssetOption == 2) {
      updateMinMaxCapString(goldAmountFieldController?.text);
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

        dailyMaxMinInfo = _subService.suggestions[3][0];
        weeklyMaxMinInfo = _subService.suggestions[3][1];
        monthlyMaxMinInfo = _subService.suggestions[3][2];
      });
      autosaveAssetOptionList = [
        AutosaveAssetModel(
          asset: "assets/vectors/flogold.svg",
          title: "Fello Flo + Digital Gold",
          subtitle: "Save in both of your favorite assets & earn great returns",
          isPopular: true,
        ),
        AutosaveAssetModel(
          asset: Assets.felloFlo,
          title: "Fello Flo",
          subtitle: "The 10% fund is now available for Autosave",
        ),
        AutosaveAssetModel(
          asset: Assets.digitalGoldBar,
          title: "Digital Gold",
          subtitle: "Stable returns are now automated with Autosave",
        )
      ];
      floAmountFieldController = TextEditingController();

      selectedAssetOption = _bankingService.isKYCVerified ? 0 : 2;
      if (selectedAssetOption == 0) {
        dailyCombos[2].isSelected = true;
      }
      pageController.addListener(
        () {
          if ((pageController.page ?? 0).toInt() != currentPage) {
            currentPage = pageController.page!.toInt();
          }
        },
      );
    }

    setState(ViewState.Idle);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!PreferenceHelper.getBool(
          PreferenceHelper.CACHE_IS_AUTOSAVE_FIRST_TIME))
        pageController.jumpToPage(1);
    });
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

      dailyMaxMinInfo = _subService.suggestions[3][0];
      weeklyMaxMinInfo = _subService.suggestions[3][1];
      monthlyMaxMinInfo = _subService.suggestions[3][2];
    });
    autosaveAssetOptionList = [
      AutosaveAssetModel(
        asset: "assets/vectors/flogold.svg",
        title: "Fello Flo + Digital Gold",
        subtitle: "Save in both of your favorite assets & earn great returns",
        isPopular: true,
      ),
      AutosaveAssetModel(
        asset: Assets.felloFlo,
        title: "Fello Flo",
        subtitle: "The 10% fund is now available for Autosave",
      ),
      AutosaveAssetModel(
        asset: Assets.digitalGoldBar,
        title: "Digital Gold",
        subtitle: "Stable returns are now automated with Autosave",
      )
    ];
    floAmountFieldController =
        TextEditingController(text: _subService.subscriptionData!.lbAmt ?? '0');
    selectedAssetOption = _bankingService.isKYCVerified ? 0 : 2;
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
    updateMinMaxCapString(val.toString());

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

  void updateMinMaxCapString(String? val) {
    if (val == null || val.isEmpty) {
      minMaxCapString = "Enter valid amount";
      totalInvestingAmount = 0;
    } else {
      int amt = int.tryParse(val) ?? 0;
      if (selectedAssetOption == 0) {
        switch (selectedFrequency) {
          case FREQUENCY.daily:
            minMaxCapString = amt < dailyMaxMinInfo.min.LENDBOXP2P
                ? "Enter valid amount"
                : amt > dailyMaxMinInfo.max
                    ? "Amount too high"
                    : null;
            return;

          case FREQUENCY.weekly:
            minMaxCapString = amt < weeklyMaxMinInfo.min.LENDBOXP2P
                ? "Enter valid amount"
                : amt > weeklyMaxMinInfo.max
                    ? "Amount too high"
                    : null;
            return;
          case FREQUENCY.monthly:
            minMaxCapString = amt < monthlyMaxMinInfo.min.LENDBOXP2P
                ? "Enter valid amount"
                : amt > monthlyMaxMinInfo.max
                    ? "Amount too high"
                    : null;
            return;

          default:
            minMaxCapString = null;
        }
      } else if (selectedAssetOption == 1) {
        switch (selectedFrequency) {
          case FREQUENCY.daily:
            minMaxCapString = amt < dailyMaxMinInfo.min.LENDBOXP2P
                ? "Enter valid amount"
                : amt > dailyMaxMinInfo.max
                    ? "Amount too high"
                    : null;
            return;

          case FREQUENCY.weekly:
            minMaxCapString = amt < weeklyMaxMinInfo.min.LENDBOXP2P
                ? "Enter valid amount"
                : amt > weeklyMaxMinInfo.max
                    ? "Amount too high"
                    : null;
            return;
          case FREQUENCY.monthly:
            minMaxCapString = amt < monthlyMaxMinInfo.min.LENDBOXP2P
                ? "Enter valid amount"
                : amt > monthlyMaxMinInfo.max
                    ? "Amount too high"
                    : null;
            return;

          default:
            minMaxCapString = null;
        }
      } else {
        switch (selectedFrequency) {
          case FREQUENCY.daily:
            minMaxCapString = amt < dailyMaxMinInfo.min.AUGGOLD99
                ? "Enter valid amount"
                : amt > dailyMaxMinInfo.max
                    ? "Amount too high"
                    : null;
            return;

          case FREQUENCY.weekly:
            minMaxCapString = amt < weeklyMaxMinInfo.min.AUGGOLD99
                ? "Enter valid amount"
                : amt > weeklyMaxMinInfo.max
                    ? "Amount too high"
                    : null;
            return;
          case FREQUENCY.monthly:
            minMaxCapString = amt < monthlyMaxMinInfo.min.AUGGOLD99
                ? "Enter valid amount"
                : amt > monthlyMaxMinInfo.max
                    ? "Amount too high"
                    : null;
            return;

          default:
            minMaxCapString = null;
        }
      }
    }
    notifyListeners();
  }

  void onComboTapped(int index) {
    Haptic.vibrate();
    if (customComboModel != null) customComboModel!.isSelected = false;
    minMaxCapString = null;
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

  Future<void> setupCtaOnPressed() async {
    if (selectedAssetOption == 1)
      updateMinMaxCapString(floAmountFieldController!.text);
    if (selectedAssetOption == 2)
      updateMinMaxCapString(goldAmountFieldController!.text);
    if (selectedAssetOption != 0 &&
        minMaxCapString != null &&
        minMaxCapString!.isNotEmpty)
      return BaseUtil.showNegativeAlert(
          "Invalid amount entered", "Please enter a valid amount to proceed");
    Haptic.vibrate();
    await updateSubscription();
  }

  onCenterGoldTextFieldChange(val) {
    totalInvestingAmount =
        int.tryParse(goldAmountFieldController?.text ?? '0') ?? 0;
  }

  onCenterLbTextFieldChange(val) {
    totalInvestingAmount =
        int.tryParse(floAmountFieldController?.text ?? '0') ?? 0;
  }
}

class AutosaveAssetModel {
  final String asset;
  final String title;
  final String subtitle;
  final bool isPopular;

  AutosaveAssetModel(
      {required this.asset,
      required this.title,
      required this.subtitle,
      this.isPopular = false});
}
