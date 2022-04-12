import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/subscription_models/active_subscription_model.dart';
import 'package:felloapp/core/model/subscription_models/subscription_transaction_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/notifier_services/paytm_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';

class AutosaveTransactionsViewModel extends BaseModel {
  final _dBModel = locator<DBModel>();
  final _userService = locator<UserService>();
  final _logger = locator<CustomLogger>();
  final _paytmService = locator<PaytmService>();

  DocumentSnapshot lastDoc;
  bool _isMoreTxnsBeingFetched = false;
  List<AutosaveTransactionModel> _filteredList, autosavetranList;
  ScrollController tranListController;
  bool hasMoreTxns = true;
  ActiveSubscriptionModel _activeSubscription;

  ActiveSubscriptionModel get activeSubscription => this._activeSubscription;

  set activeSubscription(value) {
    this._activeSubscription = value;
    notifyListeners();
  }

  List<AutosaveTransactionModel> get getAutosavetranList =>
      this.autosavetranList;

  set setAutosavetranList(autosavetranList) {
    this.autosavetranList = autosavetranList;
    notifyListeners();
  }

  List<AutosaveTransactionModel> get filteredList => this._filteredList;

  set filteredList(value) {
    this._filteredList = value;
    notifyListeners();
  }

  get isMoreTxnsBeingFetched => this._isMoreTxnsBeingFetched;

  set isMoreTxnsBeingFetched(value) {
    this._isMoreTxnsBeingFetched = value;
    notifyListeners();
  }

  init() async {
    setState(ViewState.Busy);
    tranListController = ScrollController();
    await findActiveSubscription();
    await getMoreTransactions();
    setState(ViewState.Idle);
    tranListController.addListener(() async {
      if (tranListController.offset >=
              tranListController.position.maxScrollExtent &&
          !tranListController.position.outOfRange) {
        if (hasMoreTxns && state == ViewState.Idle) {
          isMoreTxnsBeingFetched = true;
          await getMoreTransactions();
          isMoreTxnsBeingFetched = false;
        }
      }
    });
  }

  getMoreTransactions() async {
    if (activeSubscription == null) {
      // filteredList = [];
      return;
    }
    final result = await _dBModel.getAutosaveTransactions(
        uid: _userService.baseUser.uid,
        subId: activeSubscription.subscriptionId,
        lastDocument: lastDoc,
        limit: 30);
    autosavetranList = result['listOfTransactions'];
    lastDoc = result['lastDocument'];
    if (autosavetranList.length <= 30) hasMoreTxns = false;
    if (filteredList == null)
      filteredList = autosavetranList;
    else {
      autosavetranList.forEach((txn) {
        AutosaveTransactionModel duplicate = filteredList
            .firstWhere((t) => t.txnId == txn.txnId, orElse: () => null);
        if (duplicate == null) filteredList.add(txn);
      });
      autosavetranList
          .sort((a, b) => b.createdOn.seconds.compareTo(a.createdOn.seconds));
    }
  }

  findActiveSubscription() async {
    activeSubscription = _paytmService.activeSubscription;
    if (activeSubscription != null) {}
  }
}
