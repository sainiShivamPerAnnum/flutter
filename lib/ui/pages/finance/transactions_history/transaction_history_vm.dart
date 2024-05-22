import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/subscription_models/subscription_transaction_model.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/service/notifier_services/transaction_history_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/subscription_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum TranFilterType { Type, Subtype }

class TransactionsHistoryViewModel extends BaseViewModel {
  final CustomLogger _logger = locator<CustomLogger>();
  final SubService _subscriptionService = locator<SubService>();
  final TxnHistoryService _txnHistoryService = locator<TxnHistoryService>();
  // final _lendboxMaturityService = locator<LendboxMaturityService>();

  int _filter = 1;
  bool _isMoreTxnsBeingFetched = false;
  List<UserTransaction> apiTxns = [];
  String? _filterValue = "All";
  String? lastSipTxnDocId;
  final List<String?> _tranTypeFilterItems = [
    "All",
    "Deposits",
    "Withdrawals",
  ];
  List<UserTransaction> _filteredList = [];
  ScrollController? _scrollController;
  ScrollController? _sipScrollController;

  ScrollController? get sipScrollController => _sipScrollController;

  set sipScrollController(value) {
    _sipScrollController = value;
  }

  PageController? _pageController;
  int _tabIndex = 0;
  int get filter => _filter;
  String? get filterValue => _filterValue;
  List<SubscriptionTransactionModel>? _filteredSIPList = [];
  List<String?> get tranTypeFilterItems => _tranTypeFilterItems;
  List<UserTransaction> get filteredList => _filteredList;
  List<SubscriptionTransactionModel>? get filteredSIPList => _filteredSIPList;

  ScrollController? get tranListController => _scrollController;
  PageController? get pageController => _pageController;
  int get tabIndex => _tabIndex;
  bool get isMoreTxnsBeingFetched => _isMoreTxnsBeingFetched;
  InvestmentType _investmentType = InvestmentType.AUGGOLD99;

  InvestmentType get investmentType => _investmentType;

  set investmentType(InvestmentType value) => _investmentType = value;

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

  set filterValue(String? filter) {
    _filterValue = filter;
    notifyListeners();
  }

  set tabIndex(int index) {
    _tabIndex = index;
    notifyListeners();
  }

  set filteredSIPList(List<SubscriptionTransactionModel>? value) {
    _filteredSIPList = value;
    notifyListeners();
  }

  void init(InvestmentType? investmentType, bool showAutosave) {
    _investmentType = investmentType ?? InvestmentType.AUGGOLD99;
    _scrollController = ScrollController();
    _sipScrollController = ScrollController();
    _pageController = PageController(initialPage: 0);
    if (showAutosave) {
      tabIndex = 1;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        pageController!.animateToPage(
          1,
          duration: const Duration(milliseconds: 200),
          curve: Curves.linear,
        );
      });
    }

    getTransactions();

    filteredList = _txnHistoryService.txnList;
    final bool? doesHaveSubscriptionTransaction =
        locator<UserService>().baseUser?.doesHaveSubscriptionTransaction;

    _sipScrollController!.addListener(() async {
      if (_sipScrollController!.offset >=
              _sipScrollController!.position.maxScrollExtent &&
          !_sipScrollController!.position.outOfRange) {
        if (state == ViewState.Idle &&
            (doesHaveSubscriptionTransaction ?? false)) {
          await getMoreSipTransactions(investmentType!);
        }
      }
    });

    _scrollController!.addListener(() async {
      if (_scrollController!.offset >=
              _scrollController!.position.maxScrollExtent &&
          !_scrollController!.position.outOfRange) {
        if (_txnHistoryService.hasMoreTxns && state == ViewState.Idle) {
          await getMoreTransactions();
        }
      }
    });
  }

  Future getTransactions() async {
    setState(ViewState.Busy);

    await _txnHistoryService.updateTransactions(_investmentType);
    _filteredList = _txnHistoryService.txnList;
    final bool? doesHaveSubscriptionTransaction =
        locator<UserService>().baseUser?.doesHaveSubscriptionTransaction;
    if (doesHaveSubscriptionTransaction ?? false) {
      await getLatestSIPTransactions(investmentType);
    }

    setState(ViewState.Idle);
  }

  Future<void> getMoreTransactions() async {
    _logger.d("fetching more transactions...");
    isMoreTxnsBeingFetched = true;
    switch (filter) {
      case 1:
        if (_txnHistoryService.hasMoreTxns) {
          await _txnHistoryService.fetchTransactions(
            subtype: _investmentType,
          );
        }
        break;
      case 2:
        if (_txnHistoryService.hasMoreDepositTxns) {
          await _txnHistoryService.fetchTransactions(
            subtype: _investmentType,
            type: UserTransaction.TRAN_TYPE_DEPOSIT,
          );
        }
        break;
      case 3:
        if (_txnHistoryService.hasMoreWithdrawalTxns) {
          await _txnHistoryService.fetchTransactions(
            subtype: _investmentType,
            type: UserTransaction.TRAN_TYPE_WITHDRAW,
          );
        }
        break;
      case 4:
        if (_txnHistoryService.hasMorePrizeTxns) {
          await _txnHistoryService.fetchTransactions(
            subtype: _investmentType,
            type: UserTransaction.TRAN_TYPE_PRIZE,
          );
        }

        break;
      case 5:
        if (_txnHistoryService.hasMoreRefundedTxns) {
          await _txnHistoryService.fetchTransactions(
            subtype: _investmentType,
            status: UserTransaction.TRAN_STATUS_REFUNDED,
          );
        }
        break;
      default:
        break;
    }
    filterTransactions(update: false);
    isMoreTxnsBeingFetched = false;
  }

  void filterTransactions({required bool update}) {
    switch (filter) {
      case 1:
        filteredList = _txnHistoryService.txnList;
        break;
      case 2:
        filteredList = [
          ..._txnHistoryService.txnList
              .where((txn) => txn.type == UserTransaction.TRAN_TYPE_DEPOSIT)
        ];
        break;
      case 3:
        filteredList = [
          ..._txnHistoryService.txnList
              .where((txn) => txn.type == UserTransaction.TRAN_TYPE_WITHDRAW)
        ];
        break;
      case 4:
        filteredList = [
          ..._txnHistoryService.txnList
              .where((txn) => txn.type == UserTransaction.TRAN_TYPE_PRIZE)
        ];
        break;
      case 5:
        filteredList = [
          ..._txnHistoryService.txnList.where(
            (txn) => txn.tranStatus == UserTransaction.TRAN_STATUS_REFUNDED,
          )
        ];
        break;
      default:
        filteredList = _txnHistoryService.txnList;
        break;
    }
    if (update && filteredList.length < 30) getMoreTransactions();
  }

  Future<void> getLatestSIPTransactions(InvestmentType asset) async {
    await _subscriptionService.getSubscriptionTransactionHistory(
      asset: asset.name,
    );

    filteredSIPList = (asset == InvestmentType.AUGGOLD99)
        ? _subscriptionService.augSubTxnList
        : _subscriptionService.lbSubTxnList;
  }

  Future<void> getMoreSipTransactions(InvestmentType asset) async {
    isMoreTxnsBeingFetched = true;

    await _subscriptionService.getSubscriptionTransactionHistory(
      paginate: true,
      asset: asset.name,
    );

    isMoreTxnsBeingFetched = false;

    if (asset == InvestmentType.AUGGOLD99 &&
        !_subscriptionService.hasNoMoreAugSubsTxns) {
      _filteredSIPList = _subscriptionService.augSubTxnList;
    } else {
      if (!_subscriptionService.hasNoMoreLbSubsTxns) {
        _filteredSIPList = _subscriptionService.lbSubTxnList;
      }
    }
  }
}
