import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/service/transaction_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:felloapp/util/custom_logger.dart';

enum TranFilterType { Type, Subtype }

class TransactionsHistoryViewModel extends BaseModel {
  final _logger = locator<CustomLogger>();
  int _subfilter = 1;
  //locators
  final TransactionService _txnService = locator<TransactionService>();

  //local variables
  int _filter = 1;
  bool _isMoreTxnsBeingFetched = false;
  Map<String, int> _tranTypeFilterItems = {
    "All": 1,
    "Deposit": 2,
    "Withdrawal": 3,
    "Prize": 4,
    // "Refunded": 5,
  };
  List<UserTransaction> _filteredList;
  ScrollController _scrollController;

  //getters
  int get filter => _filter;

  Map<String, int> get tranTypeFilterItems => _tranTypeFilterItems;

  List<UserTransaction> get filteredList => _filteredList;

  ScrollController get tranListController => _scrollController;

  bool get isMoreTxnsBeingFetched => _isMoreTxnsBeingFetched;

  //setters
  set filter(int val) {
    _filter = val;
    notifyListeners();
  }

  set filteredList(List<UserTransaction> val) {
    _filteredList = val;
    notifyListeners();
  }

  set isMoreTxnsBeingFetched(bool val) {
    _isMoreTxnsBeingFetched = val;
    notifyListeners();
  }

  init() {
    _scrollController = ScrollController();
    if (_txnService.txnList == null || _txnService.txnList.length < 5) {
      getTransactions();
    }
    if (_txnService.txnList != null) {
      filteredList = _txnService.txnList;
    } else {
      filteredList = [];
    }
    _scrollController.addListener(() async {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        if (_txnService.hasMoreTxns && state == ViewState.Idle) {
          getMoreTransactions();
        }
      }
    });
  }

  getTransactions() async {
    setState(ViewState.Busy);
    await _txnService.fetchTransactions(
      limit: 30,
    );
    _filteredList = _txnService.txnList;
    setState(ViewState.Idle);
  }

  getMoreTransactions() async {
    _logger.d("fetching more transactions...");
    isMoreTxnsBeingFetched = true;
    switch (filter) {
      case 1:
        if (_txnService.hasMoreTxns)
          await _txnService.fetchTransactions(limit: 30);
        break;
      case 2:
        if (_txnService.hasMoreDepositTxns)
          await _txnService.fetchTransactions(
              limit: 30, type: UserTransaction.TRAN_TYPE_DEPOSIT);
        break;
      case 3:
        if (_txnService.hasMoreWithdrawalTxns)
          await _txnService.fetchTransactions(
              limit: 30, type: UserTransaction.TRAN_TYPE_WITHDRAW);
        break;
      case 4:
        if (_txnService.hasMorePrizeTxns)
          await _txnService.fetchTransactions(
              limit: 30, type: UserTransaction.TRAN_TYPE_PRIZE);

        break;
      case 5:
        if (_txnService.hasMoreRefundedTxns)
          await _txnService.fetchTransactions(
              limit: 30, status: UserTransaction.TRAN_STATUS_REFUNDED);
        break;
      default:
        // if (_txnService.hasMoreTxns)
        //   await _txnService.fetchTransactions(limit: 30);
        break;
    }
    filterTransactions(update: false);
    isMoreTxnsBeingFetched = false;
  }

  filterTransactions({@required bool update}) {
    switch (filter) {
      case 1:
        filteredList = _txnService.txnList;
        break;
      case 2:
        filteredList = [
          ..._txnService.txnList
              .where((txn) => txn.type == UserTransaction.TRAN_TYPE_DEPOSIT)
        ];
        break;
      case 3:
        filteredList = [
          ..._txnService.txnList
              .where((txn) => txn.type == UserTransaction.TRAN_TYPE_WITHDRAW)
        ];
        break;
      case 4:
        filteredList = [
          ..._txnService.txnList
              .where((txn) => txn.type == UserTransaction.TRAN_TYPE_PRIZE)
        ];
        break;
      case 5:
        filteredList = [
          ..._txnService.txnList.where(
              (txn) => txn.tranStatus == UserTransaction.TRAN_STATUS_REFUNDED)
        ];
        break;
      default:
        filteredList = _txnService.txnList;
        break;
    }
    if (update && filteredList.length < 30) getMoreTransactions();
  }
}
