import 'dart:math';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/amount_chips_model.dart';
import 'package:felloapp/core/model/subscription_models/active_subscription_model.dart';
import 'package:felloapp/core/model/subscription_models/subscription_transaction_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/paytm_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/others/finance/autopay/user_autopay_details/user_autopay_details_view.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class UserAutosaveDetailsViewModel extends BaseModel {
  final _dbModel = locator<DBModel>();
  final _userService = locator<UserService>();
  final _paytmService = locator<PaytmService>();
  final _dBModel = locator<DBModel>();
  final _logger = locator<CustomLogger>();
  final _analyticsService = locator<AnalyticsService>();

  ActiveSubscriptionModel _activeSubscription;
  List<AutosaveTransactionModel> _filteredList;

  List<AutosaveTransactionModel> get filteredList => this._filteredList;

  set filteredList(value) {
    this._filteredList = value;
    notifyListeners();
  }

  ActiveSubscriptionModel get activeSubscription => this._activeSubscription;

  set activeSubscription(value) {
    this._activeSubscription = value;
    notifyListeners();
  }

  TextEditingController subIdController,
      pUpiController,
      subAmountController,
      subStatusController,
      amountFieldController;
  bool isVerified = true;
  bool _isPausingInProgress = false;
  bool _isResumingInProgress = false;
  bool _showMinAlert = false;
  int _minValue = 25;

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

  bool get isResumingInProgress => this._isResumingInProgress;

  set isResumingInProgress(bool value) {
    this._isResumingInProgress = value;
    notifyListeners();
  }

  bool _isInEditMode = false;
  bool hasMoreTxns = false;

  int maxAmount = 5000;
  bool get getHasMoreTxns => this.hasMoreTxns;

  set setHasMoreTxns(bool hasMoreTxns) {
    this.hasMoreTxns = hasMoreTxns;
    notifyListeners();
  }

  bool get isInEditMode => this._isInEditMode;

  set isInEditMode(bool value) {
    this._isInEditMode = value;
    notifyListeners();
  }

  bool get isPausingInProgress => _isPausingInProgress;

  set isPausingInProgress(bool val) {
    this._isPausingInProgress = val;
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

  init() async {
    _analyticsService.track(
        eventName: AnalyticsEvents.autosaveUserDetailsScreenViewed);
    setState(ViewState.Busy);
    _paytmService.isOnSubscriptionFlow = false;
    subIdController = new TextEditingController();
    pUpiController = new TextEditingController();
    subAmountController = new TextEditingController();
    amountFieldController = new TextEditingController();
    subStatusController = new TextEditingController(text: "Active");
    await findActiveSubscription();
    await getChipAmounts();
    if (activeSubscription != null) await getLatestTransactions();
    setState(ViewState.Idle);
  }

  findActiveSubscription() async {
    activeSubscription = _paytmService.activeSubscription;
    // await _dbModel.getActiveSubscriptionDetails(_userService.baseUser.uid);
    if (activeSubscription != null) {
      subIdController.text = activeSubscription.subscriptionId;
      pUpiController.text = activeSubscription.vpa;
      subAmountController.text =
          "${activeSubscription.autoAmount.toString()}/${activeSubscription.autoFrequency}";
      subStatusController.text = activeSubscription.status;
      amountFieldController.text =
          activeSubscription.autoAmount.toInt().toString();
      isDaily = activeSubscription.autoFrequency == "DAILY" ? true : false;
      isDaily ? minValue = 25 : minValue = 100;
      onAmountValueChanged(amountFieldController.text);
    }
  }

  pauseSubscription(int pauseValue) async {
    bool response =
        await _paytmService.pauseSubscription(getResumeDate(pauseValue));
    isPausingInProgress = false;
    if (!response) {
      BaseUtil.showNegativeAlert(
          "Failed to pause Autosave", "Please try again");
    } else {
      trackPause(pauseValue);
      BaseUtil.showPositiveAlert("Autosave paused successfully",
          "For more details check Autosave section");
      AppState.backButtonDispatcher.didPopRoute();
      AppState.backButtonDispatcher.didPopRoute();
    }
  }

  trackPause(int pauseValue) {
    switch (pauseValue) {
      case 1:
        _analyticsService.track(
            eventName: AnalyticsEvents.autosavePauseOneWeek);
        return;
      case 2:
        _analyticsService.track(
            eventName: AnalyticsEvents.autosavePauseTwoWeeks);
        return;
      case 3:
        _analyticsService.track(
            eventName: AnalyticsEvents.autosavePauseOneMonth);
        return;
      case 4:
        _analyticsService.track(
            eventName: AnalyticsEvents.autosavePauseForever);
        return;
      default:
        _analyticsService.track(
            eventName: AnalyticsEvents.autosavePauseForever);
        return;
    }
  }

  String getResumeDate(int pauseValue) {
    switch (pauseValue) {
      case 1:
        return "ONEWEEK";
      case 2:
        return "TWOWEEK";
      case 3:
        return "ONEMONTH";
      case 4:
        return "FOREVER";
      default:
        return "FOREVER";
    }
  }

  getLatestTransactions() async {
    if (activeSubscription == null) {
      return;
    }
    final result = await _dBModel.getAutosaveTransactions(
        uid: _userService.baseUser.uid,
        subId: activeSubscription.subscriptionId,
        lastDocument: null,
        limit: 5);
    filteredList = result['listOfTransactions'];
    if (filteredList != null && filteredList.isNotEmpty) {
      if (filteredList.length > 4) hasMoreTxns = true;
    }
  }

  getChipAmounts() async {
    dailyChips =
        await _paytmService.getAmountChips(Constants.DOC_IAR_DAILY_CHIPS);
    weeklyChips =
        await _paytmService.getAmountChips(Constants.DOC_IAR_WEEKLY_CHIPS);
  }

  //==========================UPDATE METHODS==============================//

  bool _isDaily = true;
  double saveAmount = 500;
  bool _isSubscriptionAmountUpdateInProgress = false;

  RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  String Function(Match) mathFunc = (Match match) => '${match[1]},';

  get isDaily => this._isDaily;

  set isDaily(value) {
    this._isDaily = value;
    _logger.d("Isdaily: $isDaily");
    if (value)
      minValue = 25;
    else
      minValue = 100;
    notifyListeners();
  }

  get isSubscriptionAmountUpdateInProgress =>
      this._isSubscriptionAmountUpdateInProgress;

  set isSubscriptionAmountUpdateInProgress(value) {
    this._isSubscriptionAmountUpdateInProgress = value;
    notifyListeners();
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

  getTitle(ActiveSubscriptionModel activeAutosave) {
    if (activeAutosave.status == Constants.SUBSCRIPTION_ACTIVE)
      return "Autosave Active";
    else if (activeAutosave.status == Constants.SUBSCRIPTION_INACTIVE) {
      if (activeAutosave.resumeDate.isEmpty) {
        return "Autosave Inactive";
      } else {
        return "Autosave Paused";
      }
    }
  }

  getRichText() {
    if (activeSubscription.status == Constants.SUBSCRIPTION_ACTIVE)
      return "Verified and active";
    else if (activeSubscription.status == Constants.SUBSCRIPTION_INACTIVE) {
      if (activeSubscription.resumeDate.isEmpty) {
        return "currently Inactive";
      } else {
        return "Verified and paused";
      }
    }
  }

  getRichTextColor() {
    if (activeSubscription.status == Constants.SUBSCRIPTION_ACTIVE)
      return UiConstants.primaryColor;
    else if (activeSubscription.status == Constants.SUBSCRIPTION_INACTIVE) {
      if (activeSubscription.resumeDate.isEmpty) {
        return Colors.red;
      } else {
        return UiConstants.tertiarySolid;
      }
    }
  }

  setSubscriptionAmount(double amount) async {
    if (amount < minValue) {
      return BaseUtil.showNegativeAlert(
        'Minimum amount should be ₹ $minValue',
        'Please enter a minimum amount of ₹ $minValue',
      );
    }

    if (amount == _paytmService.activeSubscription.autoAmount) {
      if (isDaily &&
          _paytmService.activeSubscription.autoFrequency == "DAILY") {
        return AppState.backButtonDispatcher.didPopRoute();
      }
      if (!isDaily &&
          _paytmService.activeSubscription.autoFrequency == "WEEKLY") {
        return AppState.backButtonDispatcher.didPopRoute();
      }
    }

    if (isDaily && _paytmService.activeSubscription.autoFrequency == "WEEKLY")
      _analyticsService.track(
          eventName: AnalyticsEvents.autosaveWeeklyToDailySaver);
    if (!isDaily && _paytmService.activeSubscription.autoFrequency == "DAILY")
      _analyticsService.track(
          eventName: AnalyticsEvents.autosaveDailyToWeeklySaver);

    isSubscriptionAmountUpdateInProgress = true;
    final res = await _paytmService.updateDailySubscriptionAmount(
        amount: amount, freq: isDaily ? "DAILY" : "WEEKLY");
    isSubscriptionAmountUpdateInProgress = false;
    if (res) {
      _paytmService.getActiveSubscriptionDetails();
      AppState.backButtonDispatcher.didPopRoute();
      // init();
      BaseUtil.showPositiveAlert("Autosave amount update successful",
          "Check Autosave section for more details");
    } else {
      BaseUtil.showNegativeAlert(
          "Amount update failed", "Please try again in sometime");
    }
  }

  pauseResume(model) async {
    if (_paytmService.activeSubscription.status ==
        Constants.SUBSCRIPTION_INACTIVE) {
      if (model.isResumingInProgress) return;
      isResumingInProgress = true;
      bool response = await _paytmService.resumeSubscription();
      if (!response) {
        isResumingInProgress = false;
        BaseUtil.showNegativeAlert(
            "Failed to resume Autosave", "Please try again");
      } else {
        BaseUtil.showPositiveAlert("Autosave resumed successfully",
            "For more details check Autosave section");
        AppState.backButtonDispatcher.didPopRoute();
      }
    } else {
      _analyticsService.track(eventName: AnalyticsEvents.autosavePauseModal);
      BaseUtil.openModalBottomSheet(
        addToScreenStack: true,
        hapticVibrate: true,
        backgroundColor: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(SizeConfig.roundness32),
          topRight: Radius.circular(SizeConfig.roundness32),
        ),
        isBarrierDismissable: false,
        isScrollControlled: true,
        content: PauseAutosaveModal(
          model: model,
        ),
      );
    }
  }
}
