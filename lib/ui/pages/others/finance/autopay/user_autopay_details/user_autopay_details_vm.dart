import 'dart:math';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/subscription_models/active_subscription_model.dart';
import 'package:felloapp/core/model/subscription_models/subscription_transaction_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:felloapp/core/service/notifier_services/paytm_service.dart';

class UserAutoPayDetailsViewModel extends BaseModel {
  final _dbModel = locator<DBModel>();
  final _userService = locator<UserService>();
  final _paytmService = locator<PaytmService>();
  final _dBModel = locator<DBModel>();

  ActiveSubscriptionModel _activeSubscription;
  List<AutopayTransactionModel> _filteredList;

  List<AutopayTransactionModel> get filteredList => this._filteredList;

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
  bool _isInEditMode = false;
  bool hasMoreTxns = false;

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

  init() async {
    setState(ViewState.Busy);

    subIdController = new TextEditingController();
    pUpiController = new TextEditingController();
    subAmountController = new TextEditingController();
    amountFieldController = new TextEditingController();
    subStatusController = new TextEditingController(text: "Active");
    await findActiveSubscription();
    await getLatestTransactions();
    setState(ViewState.Idle);
  }

  findActiveSubscription() async {
    activeSubscription = _paytmService.activeSubscription;
    // await _dbModel.getActiveSubscriptionDetails(_userService.baseUser.uid);
    if (activeSubscription != null) {
      subIdController.text = activeSubscription.subId;
      pUpiController.text = activeSubscription.vpa;
      subAmountController.text =
          "${activeSubscription.autoAmount.toString()}/${activeSubscription.autoFrequency}";
      subStatusController.text = activeSubscription.status;
      amountFieldController.text =
          activeSubscription.autoAmount.toInt().toString();
    }
  }

  pauseSubscription() async {
    isPausingInProgress = true;
    bool response =
        await _paytmService.pauseDailySubscription(activeSubscription.subId, 2);
    if (response) {
      AppState.backButtonDispatcher.didPopRoute();
      BaseUtil.showPositiveAlert("Subscription paused for 2 days",
          "Remember it will automatically after 2 days");
    } else
      BaseUtil.showNegativeAlert(
          "Failed to pause Subscription", "Please try again");
    isPausingInProgress = false;
  }

  getLatestTransactions() async {
    if (activeSubscription == null) {
      return;
    }
    final result = await _dBModel.getAutopayTransactions(
        uid: _userService.baseUser.uid,
        subId: activeSubscription.subId,
        lastDocument: null,
        limit: 5);
    filteredList = result['listOfTransactions'];
    if (filteredList != null && filteredList.isNotEmpty) {
      if (filteredList.length > 4) hasMoreTxns = true;
    }
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
    notifyListeners();
  }

  get isSubscriptionAmountUpdateInProgress =>
      this._isSubscriptionAmountUpdateInProgress;

  set isSubscriptionAmountUpdateInProgress(value) {
    this._isSubscriptionAmountUpdateInProgress = value;
    notifyListeners();
  }

  onAmountValueChanged(String val) {
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

  setSubscriptionAmount(double amount) async {
    isSubscriptionAmountUpdateInProgress = true;
    final res = await _paytmService.updateDailySubscriptionAmount(
        subId: activeSubscription.subId,
        amount: amount,
        freq: isDaily ? "DAILY" : "WEEKLY");
    isSubscriptionAmountUpdateInProgress = false;
    if (res) {
      _paytmService.getActiveSubscriptionDetails();

      BaseUtil.showPositiveAlert(
          "Subscription Successful", "Check transactions for more details");
    } else {
      BaseUtil.showNegativeAlert(
          "Amount update failed", "Please try again in sometime");
    }
  }
}
