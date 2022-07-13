import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/subscription_models/active_subscription_model.dart';
import 'package:felloapp/core/model/subscription_models/subscription_transaction_model.dart';
import 'package:felloapp/core/repository/subcription_repo.dart';
import 'package:felloapp/core/service/notifier_services/paytm_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';

class AutosaveTransactionsViewModel extends BaseModel {
  final _userService = locator<UserService>();
  final _subcriptionRepo = locator<SubcriptionRepo>();
  final _paytmService = locator<PaytmService>();

  String lastDocId;
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
    final ApiResponse<List<AutosaveTransactionModel>> result =
        await _subcriptionRepo.getAutosaveTransactions(
      uid: _userService.baseUser.uid,
      lastDocument: lastDocId,
      limit: 30,
    );
    if (result.code == 200) {
      autosavetranList = result.model;
      lastDocId = result.model.last.txnId;
      if (autosavetranList.length <= 30) hasMoreTxns = false;
      if (filteredList == null)
        filteredList = autosavetranList;
      else {
        autosavetranList.forEach((txn) {
          AutosaveTransactionModel duplicate = filteredList
              .firstWhere((t) => t.txnId == txn.txnId, orElse: () => null);
          if (duplicate == null) filteredList.add(txn);
        });
      }
    }
  }

  findActiveSubscription() async {
    activeSubscription = _paytmService.activeSubscription;
    if (activeSubscription != null) {}
  }
}
