import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/amount_chips_model.dart';
import 'package:felloapp/core/model/sub_combos_model.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/bank_and_pan_service.dart';
import 'package:felloapp/core/service/subscription_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/modalsheets/autosave_combo_input_modalsheet.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
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
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  final ScratchCardService _gtService = ScratchCardService();
  final SubService _subService = locator<SubService>();
  final UserService _userService = locator<UserService>();
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

  MaxMin dailyMaxMinInfo = MaxMin(
    min: MaxMinAsset(AUGGOLD99: 50, LENDBOXP2P: 100),
    max: MaxMinAsset(AUGGOLD99: 5000, LENDBOXP2P: 10000),
  );

  MaxMin weeklyMaxMinInfo = MaxMin(
    min: MaxMinAsset(AUGGOLD99: 50, LENDBOXP2P: 100),
    max: MaxMinAsset(AUGGOLD99: 5000, LENDBOXP2P: 10000),
  );

  MaxMin monthlyMaxMinInfo = MaxMin(
    min: MaxMinAsset(AUGGOLD99: 50, LENDBOXP2P: 100),
    max: MaxMinAsset(AUGGOLD99: 5000, LENDBOXP2P: 10000),
  );

  late List<ApplicationMeta> appsList;
  ApplicationMeta? _selectedUpiApp;
  String finalButtonCta = "SETUP";
  SubComboModel? customComboModel;

  int _selectedAssetOption = 2;
  int _totalInvestingAmount = 0;
  bool isUpdateFlow = false;
  String? minMaxCapString;
  bool isComboSelected = false;

  int get totalInvestingAmount => _totalInvestingAmount;

  set totalInvestingAmount(int value) {
    _totalInvestingAmount = value;
    notifyListeners();
  }

  int get selectedAssetOption => _selectedAssetOption;

  set selectedAssetOption(int value) {
    _selectedAssetOption = value;
    if (value == 0) {
      floAmountFieldController!.text = '0';
      goldAmountFieldController!.text = '0';
      _totalInvestingAmount = 0;
      onComboTapped(2);
      comboController = PageController();
    } else if (value == 1) {
      floAmountFieldController!.text = '250';
      goldAmountFieldController!.text = '0';
      _totalInvestingAmount = 250;
    } else {
      floAmountFieldController!.text = '0';
      goldAmountFieldController!.text = '250';
      _totalInvestingAmount = 250;
    }
    notifyListeners();
  }

  ApplicationMeta? get selectedUpiApp => _selectedUpiApp;

  set selectedUpiApp(value) {
    _selectedUpiApp = value;
    notifyListeners();
  }

  int _currentPage = 0, minValue = 25;

  // bool _isDaily = true;

  FREQUENCY _selectedFrequency = FREQUENCY.daily;

  FREQUENCY get selectedFrequency => _selectedFrequency;

  set selectedFrequency(FREQUENCY value) {
    _selectedFrequency = value;
    deselectOtherComboIfAny(notify: false);
    switch (value) {
      case FREQUENCY.daily:
        if (selectedAssetOption != 0) {
          chipsController.jumpToPage(0);
          selectedAssetOption == 1
              ? floAmountFieldController?.text =
                  lbDailyChips[0].value.toString()
              : goldAmountFieldController?.text =
                  augDailyChips[0].value.toString();
        } else {
          comboController.jumpToPage(0);
          customComboModel = null;
          dailyCombos[2].isSelected = true;
          goldAmountFieldController?.text = dailyCombos[2].AUGGOLD99.toString();
          floAmountFieldController?.text = dailyCombos[2].LENDBOXP2P.toString();
        }
        break;
      case FREQUENCY.weekly:
        if (selectedAssetOption != 0) {
          chipsController.jumpToPage(1);
          selectedAssetOption == 1
              ? floAmountFieldController?.text =
                  lbWeeklyChips[0].value.toString()
              : goldAmountFieldController?.text =
                  augWeeklyChips[0].value.toString();
        } else {
          comboController.jumpToPage(1);
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
          chipsController.jumpToPage(2);
          selectedAssetOption == 1
              ? floAmountFieldController?.text =
                  lbMonthlyChips[0].value.toString()
              : goldAmountFieldController?.text =
                  augMonthlyChips[0].value.toString();
        } else {
          comboController.jumpToPage(2);
          customComboModel = null;
          monthlyCombos[2].isSelected = true;
          goldAmountFieldController?.text =
              monthlyCombos[2].AUGGOLD99.toString();
          floAmountFieldController?.text =
              monthlyCombos[2].LENDBOXP2P.toString();
        }
        break;
    }
    debugPrint("ComboModel : $customComboModel");
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

  get isSubscriptionCreationInProgress => _isSubscriptionCreationInProgress;

  set isSubscriptionCreationInProgress(value) {
    _isSubscriptionCreationInProgress = value;
    notifyListeners();
  }

  PageController? get pageController => _subService.pageController;
  PageController chipsController = PageController();
  PageController comboController = PageController();
  PageController? optionsController;
  TextEditingController? goldAmountFieldController;
  TextEditingController? floAmountFieldController;

  List<AutosaveAssetModel> autosaveAssetOptionList = [];

  getAvailableUpiApps() async {
    appsList = await _subService.getUPIApps();
  }

  void proceed() {
    if (_subService.pageController!.page!.toInt() == 1) {
      trackAssetChoiceNext();
    }
    _subService.pageController!
        .animateToPage(_subService.pageController!.page!.toInt() + 1,
            duration: const Duration(milliseconds: 500),
            curve: Curves.decelerate)
        .then(
      (_) {
        log("Page changed to ${_subService.pageController!.page!.toInt()}");
        if (_subService.pageController!.page!.toInt() == 1) {
          PreferenceHelper.setBool(
              PreferenceHelper.CACHE_IS_AUTOSAVE_FIRST_TIME, false);
        }

        if (_subService.pageController!.page!.toInt() == 3) {
          AppState.showAutoSaveSurveyBt = true;
        }
      },
    );
  }

  Future<void> init(InvestmentType? investmentType) async {
    state = ViewState.Busy;
    AppState.showAutosaveBt = true;
    if (investmentType != null) AppState.autosaveMiddleFlow = true;
    _subService.pageController = PageController();
    await _subService.getSubscription();
    if (_subService.autosaveState == AutosaveState.IDLE) {
      goldAmountFieldController = TextEditingController();
      await getAvailableUpiApps();
      unawaited(_subService.getAutosaveSuggestions().then((_) {
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
      }));
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
          subtitle:
              "The ${_userService.userSegments.contains(Constants.US_FLO_OLD) ? '10%' : '8%'} fund is now available for Autosave",
        ),
        AutosaveAssetModel(
          asset: Assets.digitalGoldBar,
          title: "Digital Gold",
          subtitle: "Stable returns are now automated with Autosave",
        )
      ];
      floAmountFieldController = TextEditingController();

      selectedAssetOption = _bankingService.isKYCVerified ? 0 : 2;

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (investmentType != null &&
            investmentType == InvestmentType.AUGGOLD99) {
          selectedAssetOption = 2;
          _subService.pageController!.jumpToPage(2);
        }
        if (investmentType != null &&
            investmentType == InvestmentType.LENDBOXP2P) {
          selectedAssetOption = 1;
          _subService.pageController!.jumpToPage(2);
        }
      });

      if (selectedAssetOption == 0) {
        dailyCombos[2].isSelected = true;
      }
      _subService.pageController!.addListener(
        () {
          if ((_subService.pageController!.page ?? 0).toInt() != currentPage) {
            currentPage = _subService.pageController!.page!.toInt();
          }
        },
      );
    }

    setState(ViewState.Idle);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!PreferenceHelper.getBool(
              PreferenceHelper.CACHE_IS_AUTOSAVE_FIRST_TIME) &&
          investmentType == null) {
        _subService.pageController!.jumpToPage(1);
      }
    });
  }

  dump() {
    _subService.pageController!.dispose();
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
    _subService.pageController = PageController();
    // if (_subService.autosaveState == AutosaveState.IDLE) {
    goldAmountFieldController = TextEditingController(
        text: _subService.subscriptionData!.augAmt ?? '0');
    unawaited(_subService.getAutosaveSuggestions().then((_) {
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
    }));
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
        subtitle:
            "The ${_userService.userSegments.contains(Constants.US_FLO_OLD) ? '10%' : '8%'} fund is now available for Autosave",
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
    _subService.pageController!.addListener(
      () {
        if ((_subService.pageController!.page ?? 0).toInt() != currentPage) {
          currentPage = _subService.pageController!.page!.toInt();
        }
      },
    );

    setState(ViewState.Idle);
  }

  updateDump() {
    _subService.pageController!.dispose();
    optionsController?.dispose();
    goldAmountFieldController?.dispose();
    floAmountFieldController?.dispose();
    _selectedAssetOption = 0;
    _selectedFrequency = FREQUENCY.daily;
    autosaveAssetOptionList.clear();
  }

  Future<void> createSubscription() async {
    AppState.showAutosaveBt = false;
    trackAutosaveUpiSubmit();
    await _subService.createSubscription(
      amount: totalInvestingAmount,
      freq: selectedFrequency.name.toUpperCase(),
      lbAmt: int.tryParse(floAmountFieldController?.text ?? '0')!,
      augAmt: int.tryParse(goldAmountFieldController?.text ?? '0')!,
      package: FlavorConfig.isDevelopment()
          ? (Platform.isAndroid
              ? "com.phonepe.app.preprod"
              : "com.phonepe.app.preprod")
          : selectedUpiApp!.packageName,
    );
  }

  Future<void> updateSubscription() async {
    if (isSubscriptionCreationInProgress) return;
    if (checkForLowAmount()) return;
    isSubscriptionCreationInProgress = true;
    if (isUpdateFlow) {
      await _subService.updateSubscription(
          freq: selectedFrequency.name.toUpperCase(),
          amount: totalInvestingAmount,
          lbAmt: int.tryParse(floAmountFieldController?.text ?? '0')!,
          augAmt: int.tryParse(goldAmountFieldController?.text ?? '0')!);
    } else {
      proceed();
      _trackAutosaveSetup();
    }
    isSubscriptionCreationInProgress = false;
  }

  String getGoals() {
    switch (selectedFrequency) {
      case FREQUENCY.daily:
        return getDailyGoals();
      case FREQUENCY.weekly:
        return getWeeklyGoals();
      case FREQUENCY.monthly:
        return getMonthlyGoals();
    }
  }

  String getDailyGoals() {
    if (selectedAssetOption == 1) {
      int floAmount = int.tryParse(floAmountFieldController?.text ?? "0") ?? 0;
      if (floAmount <= 100) {
        return Assets.goaGoalsBg;
      } else if (floAmount >= 101 && floAmount <= 500) {
        return Assets.iphoneGoalsBg;
      } else if (floAmount >= 501) {
        return Assets.carGoalsBg;
      }
    } else if (selectedAssetOption == 2) {
      int goldAmount =
          int.tryParse(goldAmountFieldController?.text ?? "0") ?? 0;
      if (goldAmount <= 100) {
        return Assets.goaGoalsBg;
      } else if (goldAmount >= 101 && goldAmount <= 500) {
        return Assets.iphoneGoalsBg;
      } else if (goldAmount >= 501) {
        return Assets.carGoalsBg;
      }
    }
    return Assets.goaGoalsBg;
  }

  String getWeeklyGoals() {
    if (selectedAssetOption == 1) {
      int floAmount = int.tryParse(floAmountFieldController?.text ?? "0") ?? 0;
      if (floAmount <= 1000) {
        return Assets.goaGoalsBg;
      } else if (floAmount > 1000 && floAmount <= 5000) {
        return Assets.carGoalsBg;
      } else if (floAmount > 5000) {
        return Assets.baliGoalsBg;
      }
    } else if (selectedAssetOption == 2) {
      int goldAmount =
          int.tryParse(goldAmountFieldController?.text ?? "0") ?? 0;
      if (goldAmount <= 1000) {
        return Assets.goaGoalsBg;
      } else if (goldAmount > 1000 && goldAmount <= 5000) {
        return Assets.carGoalsBg;
      } else if (goldAmount > 5000) {
        return Assets.baliGoalsBg;
      }
    }
    return Assets.goaGoalsBg;
  }

  String getMonthlyGoals() {
    if (selectedAssetOption == 1) {
      int floAmount = int.tryParse(floAmountFieldController?.text ?? "0") ?? 0;
      if (floAmount <= 5000) {
        return Assets.goaGoalsBg;
      } else if (floAmount > 5000 && floAmount <= 10000) {
        return Assets.iphoneGoalsBg;
      } else if (floAmount > 10000) {
        return Assets.carGoalsBg;
      }
    } else if (selectedAssetOption == 2) {
      int goldAmount =
          int.tryParse(goldAmountFieldController?.text ?? "0") ?? 0;
      if (goldAmount <= 5000) {
        return Assets.goaGoalsBg;
      } else if (goldAmount > 5000 && goldAmount <= 10000) {
        return Assets.iphoneGoalsBg;
      } else if (goldAmount > 10000) {
        return Assets.carGoalsBg;
      }
    }
    return Assets.goaGoalsBg;
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
        if (selectedAssetOption == 1) {
          lbDailyChips[index].isSelected = true;
          trackAutosaveChipsTapped(lbDailyChips[index]);
        } else {
          augDailyChips[index].isSelected = true;
          trackAutosaveChipsTapped(augDailyChips[index]);
        }

        break;
      case FREQUENCY.weekly:
        if (selectedAssetOption == 1) {
          lbWeeklyChips[index].isSelected = true;
          trackAutosaveChipsTapped(lbWeeklyChips[index]);
        } else {
          augWeeklyChips[index].isSelected = true;
          trackAutosaveChipsTapped(augWeeklyChips[index]);
        }
        break;
      case FREQUENCY.monthly:
        if (selectedAssetOption == 1) {
          lbMonthlyChips[index].isSelected = true;
          trackAutosaveChipsTapped(lbMonthlyChips[index]);
        } else {
          augMonthlyChips[index].isSelected = true;
          trackAutosaveChipsTapped(augMonthlyChips[index]);
        }
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
                : amt > dailyMaxMinInfo.max.LENDBOXP2P
                    ? "Amount too high"
                    : null;
            return;

          case FREQUENCY.weekly:
            minMaxCapString = amt < weeklyMaxMinInfo.min.LENDBOXP2P
                ? "Enter valid amount"
                : amt > weeklyMaxMinInfo.max.LENDBOXP2P
                    ? "Amount too high"
                    : null;
            return;
          case FREQUENCY.monthly:
            minMaxCapString = amt < monthlyMaxMinInfo.min.LENDBOXP2P
                ? "Enter valid amount"
                : amt > monthlyMaxMinInfo.max.LENDBOXP2P
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
                : amt > dailyMaxMinInfo.max.LENDBOXP2P
                    ? "Amount too high"
                    : null;
            return;

          case FREQUENCY.weekly:
            minMaxCapString = amt < weeklyMaxMinInfo.min.LENDBOXP2P
                ? "Enter valid amount"
                : amt > weeklyMaxMinInfo.max.LENDBOXP2P
                    ? "Amount too high"
                    : null;
            return;
          case FREQUENCY.monthly:
            minMaxCapString = amt < monthlyMaxMinInfo.min.LENDBOXP2P
                ? "Enter valid amount"
                : amt > monthlyMaxMinInfo.max.LENDBOXP2P
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
                : amt > dailyMaxMinInfo.max.AUGGOLD99
                    ? "Amount too high"
                    : null;
            return;

          case FREQUENCY.weekly:
            minMaxCapString = amt < weeklyMaxMinInfo.min.AUGGOLD99
                ? "Enter valid amount"
                : amt > weeklyMaxMinInfo.max.AUGGOLD99
                    ? "Amount too high"
                    : null;
            return;
          case FREQUENCY.monthly:
            minMaxCapString = amt < monthlyMaxMinInfo.min.AUGGOLD99
                ? "Enter valid amount"
                : amt > monthlyMaxMinInfo.max.AUGGOLD99
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
    isComboSelected = true;
    deselectOtherComboIfAny();
    switch (selectedFrequency) {
      case FREQUENCY.daily:
        dailyCombos[index].isSelected = true;

        floAmountFieldController!.text =
            dailyCombos[index].LENDBOXP2P.toString();
        goldAmountFieldController!.text =
            dailyCombos[index].AUGGOLD99.toString();
        trackAutosaveComboTapped(dailyCombos[index]);

        break;
      case FREQUENCY.weekly:
        weeklyCombos[index].isSelected = true;
        floAmountFieldController!.text =
            weeklyCombos[index].LENDBOXP2P.toString();
        goldAmountFieldController!.text =
            weeklyCombos[index].AUGGOLD99.toString();
        trackAutosaveComboTapped(weeklyCombos[index]);

        break;
      case FREQUENCY.monthly:
        monthlyCombos[index].isSelected = true;
        floAmountFieldController!.text =
            monthlyCombos[index].LENDBOXP2P.toString();
        goldAmountFieldController!.text =
            monthlyCombos[index].AUGGOLD99.toString();
        trackAutosaveComboTapped(monthlyCombos[index]);

        break;
    }
    totalInvestingAmount = int.tryParse(goldAmountFieldController!.text)! +
        int.tryParse(floAmountFieldController!.text)!;
    // notifyListeners();
  }

  void _deselectOtherChipIfAny() {
    for (final chip in augDailyChips) {
      chip.isSelected = false;
    }
    augWeeklyChips.forEach((chip) => chip.isSelected = false);
    augMonthlyChips.forEach((chip) => chip.isSelected = false);
    lbDailyChips.forEach((chip) => chip.isSelected = false);
    lbWeeklyChips.forEach((chip) => chip.isSelected = false);
    lbMonthlyChips.forEach((chip) => chip.isSelected = false);
  }

  void deselectOtherComboIfAny({bool notify = false}) {
    dailyCombos.forEach((chip) => chip.isSelected = false);
    weeklyCombos.forEach((chip) => chip.isSelected = false);
    monthlyCombos.forEach((chip) => chip.isSelected = false);
    if (notify) notifyListeners();
  }

  void onCompleteClose() {
    _analyticsService.track(eventName: AnalyticsEvents.asDoneTapped);
    AppState.backButtonDispatcher!.didPopRoute();
    _gtService.fetchAndVerifyScratchCardByID();
  }

  openCustomInputModalSheet(model, {bool isNew = true}) {
    trackAutosaveCustomComboTapped();
    return BaseUtil.openModalBottomSheet(
      isBarrierDismissible: true,
      addToScreenStack: true,
      enableDrag: Platform.isIOS,
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
    if (selectedAssetOption == 1) {
      updateMinMaxCapString(floAmountFieldController!.text);
    }
    if (selectedAssetOption == 2) {
      updateMinMaxCapString(goldAmountFieldController!.text);
    }
    if (selectedAssetOption != 0 &&
        minMaxCapString != null &&
        minMaxCapString!.isNotEmpty) {
      return BaseUtil.showNegativeAlert(
          "Invalid amount entered", "Please enter a valid amount to proceed");
    }
    Haptic.vibrate();
    await updateSubscription();
  }

  void onCenterGoldTextFieldChange(_) {
    totalInvestingAmount =
        int.tryParse(goldAmountFieldController?.text ?? '0') ?? 0;
  }

  void onCenterLbTextFieldChange(_) {
    totalInvestingAmount =
        int.tryParse(floAmountFieldController?.text ?? '0') ?? 0;
  }

  void trackAssetChoice(bool isVerified) {
    _analyticsService
        .track(eventName: AnalyticsEvents.asAssetTapped, properties: {
      "assetName": autosaveAssetOptionList[selectedAssetOption].asset,
      "isKycVerified": isVerified,
    });
  }

  void trackAssetChoiceNext() {
    _analyticsService
        .track(eventName: AnalyticsEvents.asChooseAssetNextTapped, properties: {
      "assetName": autosaveAssetOptionList[selectedAssetOption].asset,
    });
  }

  void trackAssetChoiceKyc() {
    _analyticsService.track(eventName: AnalyticsEvents.asDoKycNowTapped);
  }

  void _trackAutosaveSetup() {
    _analyticsService
        .track(eventName: AnalyticsEvents.asSetupConfirmation, properties: {
      "gold": goldAmountFieldController?.text ?? "0",
      "flo": floAmountFieldController?.text ?? "0",
      "asset": autosaveAssetOptionList[selectedAssetOption].title,
      "Frequency": selectedFrequency.name,
      "combo selected": isComboSelected
    });
  }

  void trackAutosaveComboTapped(SubComboModel model) {
    _analyticsService
        .track(eventName: AnalyticsEvents.asSelectComboTapped, properties: {
      "gold": model.AUGGOLD99,
      "flo": model.LENDBOXP2P,
      "popular": model.popular,
      "combo name": model.title
    });
  }

  void trackAutosaveCustomComboTapped() {
    _analyticsService.track(
      eventName: AnalyticsEvents.asCustomComboTapped,
    );
  }

  void trackAutosaveCustomComboSubmit() {
    _analyticsService.track(
      eventName: AnalyticsEvents.asCustomComboSubmit,
      properties: {
        "gold": customComboModel?.AUGGOLD99 ?? 0,
        "flo": customComboModel?.LENDBOXP2P ?? 0,
      },
    );
  }

  void trackAutosaveChipsTapped(AmountChipsModel model) {
    _analyticsService.track(
      eventName: AnalyticsEvents.asChipsTapped,
      properties: {
        "asset": selectedAssetOption == 1 ? "Flo" : "Gold",
        "amount": model.value,
        "best": model.best
      },
    );
  }

  void trackAutosaveUpiAppTapped() {
    _analyticsService.track(
      eventName: AnalyticsEvents.asChipsTapped,
      properties: {
        "appName": selectedUpiApp?.upiApplication.appName,
        "gold": goldAmountFieldController?.text,
        "flo": floAmountFieldController?.text,
        "frequency": selectedFrequency.name,
      },
    );
  }

  void trackAutosaveUpiSubmit() {
    _analyticsService.track(
      eventName: AnalyticsEvents.upiSubmitTappped,
      properties: {
        "appName": selectedUpiApp?.upiApplication.appName,
        "gold": goldAmountFieldController?.text,
        "flo": floAmountFieldController?.text,
        "frequency": selectedFrequency.name,
      },
    );
  }

  void trackAutosaveBackPress() {
    _analyticsService.track(
        eventName: AnalyticsEvents.asPrevTapped,
        properties: {"step": _subService.pageController!.page?.toInt() ?? 0});
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
