import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/subscription_models/active_subscription_model.dart';
import 'package:felloapp/core/model/subscription_models/subscription_transaction_model.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/repository/subcription_repo.dart';
import 'package:felloapp/core/service/notifier_services/paytm_service.dart';
import 'package:felloapp/core/service/notifier_services/transaction_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:felloapp/util/custom_logger.dart';

enum TranFilterType { Type, Subtype }

class TransactionsHistoryViewModel extends BaseModel {
  final _logger = locator<CustomLogger>();
  final _userService = locator<UserService>();
  final _paytmService = locator<PaytmService>();
  final _subcriptionRepo = locator<SubscriptionRepo>();
  //locators
  final TransactionService _txnService = locator<TransactionService>();

  //local variables
  int _filter = 1;
  bool _isMoreTxnsBeingFetched = false;
  List<UserTransaction> apiTxns = [];
  String _filterValue = "All";
  List<String> _tranTypeFilterItems = [
    "All",
    "Deposits",
    "Withdrawals",
  ];
  List<UserTransaction> _filteredList;
  ScrollController _scrollController;
  PageController _pageController;
  int _tabIndex = 0;
  double tranAnimWidth = SizeConfig.screenWidth / 3;
  int get filter => _filter;
  String get filterValue => _filterValue;
  ActiveSubscriptionModel _activeSubscription;
  List<AutosaveTransactionModel> _filteredSIPList = [];
  bool _hasMoreSIPTxns = false;

  // Map<String, int> get tranTypeFilterItems => _tranTypeFilterItems;

  ActiveSubscriptionModel get activeSubscription => _activeSubscription;
  List<String> get tranTypeFilterItems => _tranTypeFilterItems;
  List<UserTransaction> get filteredList => _filteredList;
  List<AutosaveTransactionModel> get filteredSIPList => _filteredSIPList;

  ScrollController get tranListController => _scrollController;
  PageController get pageController => _pageController;
  int get tabIndex => _tabIndex;
  bool get getHasMoreTxns => this._hasMoreSIPTxns;
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

  set filterValue(String filter) {
    _filterValue = filter;
    notifyListeners();
  }

  set tabIndex(int index) {
    _tabIndex = index;
    notifyListeners();
  }

  set filteredSIPList(List<AutosaveTransactionModel> value) {
    _filteredSIPList = value;
    notifyListeners();
  }

  set activeSubscription(value) {
    _activeSubscription = value;
    notifyListeners();
  }

  set setHasMoreTxns(bool hasMoreTxns) {
    _hasMoreSIPTxns = hasMoreTxns;
    notifyListeners();
  }

  init() {
    _scrollController = ScrollController();
    _pageController = PageController(initialPage: 0);
    if (_txnService.txnList == null || _txnService.txnList.length < 5) {
      getTransactions().then((_) {
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          tranAnimWidth = 0;
          notifyListeners();
        });
      });
    }
    if (_txnService.txnList != null) {
      filteredList = _txnService.txnList;
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        tranAnimWidth = 0;
        notifyListeners();
      });
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
    getLatestSIPTransactions();
  }

  Future getTransactions() async {
    setState(ViewState.Busy);
    await _txnService.fetchTransactions();
    _filteredList = _txnService.txnList;
    setState(ViewState.Idle);
  }

  getMoreTransactions() async {
    _logger.d("fetching more transactions...");
    isMoreTxnsBeingFetched = true;
    switch (filter) {
      case 1:
        if (_txnService.hasMoreTxns) await _txnService.fetchTransactions();
        break;
      case 2:
        if (_txnService.hasMoreDepositTxns)
          await _txnService.fetchTransactions(
              type: UserTransaction.TRAN_TYPE_DEPOSIT);
        break;
      case 3:
        if (_txnService.hasMoreWithdrawalTxns)
          await _txnService.fetchTransactions(
              type: UserTransaction.TRAN_TYPE_WITHDRAW);
        break;
      case 4:
        if (_txnService.hasMorePrizeTxns)
          await _txnService.fetchTransactions(
              type: UserTransaction.TRAN_TYPE_PRIZE);

        break;
      case 5:
        if (_txnService.hasMoreRefundedTxns)
          await _txnService.fetchTransactions(
              status: UserTransaction.TRAN_STATUS_REFUNDED);
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

  getLatestSIPTransactions() async {
    setState(ViewState.Busy);
    activeSubscription = _paytmService.activeSubscription;
    if (activeSubscription == null) {
      setState(ViewState.Idle);
      return;
    }
    final ApiResponse<List<AutosaveTransactionModel>> result =
        await _subcriptionRepo.getAutosaveTransactions(
      uid: _userService.baseUser.uid,
      lastDocument: null,
      limit: 5,
    );
    if (result.code == 200) {
      filteredSIPList = result.model;
      if (filteredSIPList.isNotEmpty && filteredSIPList.length > 4) {
        _hasMoreSIPTxns = true;
      }
    }
    setState(ViewState.Idle);
  }
}
