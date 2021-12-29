import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/transaction_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/dialogs/transaction_details_dialog.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:felloapp/util/custom_logger.dart';

enum TranFilterType { Type, Subtype }

class TransactionsHistoryViewModel extends BaseModel {
  final _logger = locator<CustomLogger>();
  int _subfilter = 1;
  int _filter = 1;
  bool _init = true;
  bool _isMoreTxnsBeingFetched = false;
  Map<String, int> _tranTypeFilterItems = {
    "All": 1,
    "Deposit": 2,
    "Withdrawal": 3,
    "Prize": 4,
    "Refunded": 5
  };
  Map<String, int> _tranSubTypeFilterItems = {
    "All": 1,
    "ICICI": 2,
    "Augmont": 3
  };
  List<UserTransaction> _filteredList;
  ScrollController _scrollController;

  int get subFilter => _subfilter;

  int get filter => _filter;

  Map<String, int> get tranTypeFilterItems => _tranTypeFilterItems;

  Map<String, int> get tranSubTypeFilterItems => _tranSubTypeFilterItems;

  List<UserTransaction> get filteredList => _filteredList;

  ScrollController get tranListController => _scrollController;
  bool get isMoreTxnsBeingFetched => _isMoreTxnsBeingFetched;

  set subFilter(int val) {
    _subfilter = val;
    notifyListeners();
  }

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

  final Log dblog = new Log("DBModel");
  final Log bulog = new Log("BaseUtil");
  final dbProvider = locator<DBModel>();
  final baseProvider = locator<BaseUtil>();
  final TransactionService _transactionService = locator<TransactionService>();

  getTransactions() async {
    setState(ViewState.Busy);
    await _transactionService.fetchTransactions(30);
    _filteredList = _transactionService.txnList;
    filterTransactions();
    setState(ViewState.Idle);
  }

  getMoreTransactions() async {
    isMoreTxnsBeingFetched = true;
    await _transactionService.fetchTransactions(30);
    _filteredList = _transactionService.txnList;
    filterTransactions();
    isMoreTxnsBeingFetched = false;
  }

  filterTransactions() {
    filteredList = List.from(_transactionService.txnList);
    if (filter != 1 || subFilter != 1) {
      filteredList.clear();
      _transactionService.txnList.forEach((txn) {
        bool addItemFlag = true;
        if (filter != 1) {
          if (filter == 2) {
            //only deposits
            if (txn.type == UserTransaction.TRAN_TYPE_DEPOSIT)
              addItemFlag = true;
            else
              addItemFlag = false;
          } else if (filter == 3) {
            //only withdrawals
            if (txn.type == UserTransaction.TRAN_TYPE_WITHDRAW)
              addItemFlag = true;
            else
              addItemFlag = false;
          } else if (filter == 4) {
            //only prizes
            if (txn.type == UserTransaction.TRAN_TYPE_PRIZE)
              addItemFlag = true;
            else
              addItemFlag = false;
          } else if (filter == 5) {
            // only refunded txns
            if (txn.tranStatus == UserTransaction.TRAN_STATUS_REFUNDED)
              addItemFlag = true;
            else
              addItemFlag = false;
          }
        } else {
          addItemFlag = true;
        }
        if (addItemFlag) {
          if (subFilter != 1) {
            if (subFilter == 2) {
              //only ICICI
              if (txn.subType == UserTransaction.TRAN_SUBTYPE_ICICI)
                addItemFlag = true;
              else
                addItemFlag = false;
            } else {
              //only Augmont
              if (txn.subType == UserTransaction.TRAN_SUBTYPE_AUGMONT_GOLD)
                addItemFlag = true;
              else
                addItemFlag = false;
            }
          } else {
            addItemFlag = true;
          }
        }

        if (addItemFlag) filteredList.add(txn);
      });
    }
  }

  String _getFormattedTime(Timestamp tTime) {
    DateTime now =
        DateTime.fromMillisecondsSinceEpoch(tTime.millisecondsSinceEpoch);
    return DateFormat('yyyy-MM-dd – kk:mm').format(now);
  }

  List<Widget> getTxns() {
    List<ListTile> _tiles = [];
    for (int index = 0; index < filteredList.length; index++) {
      _tiles.add(ListTile(
        onTap: () {
          Haptic.vibrate();
          // if (filteredList[index].tranStatus !=
          //     UserTransaction.TRAN_STATUS_CANCELLED)
          bool freeBeerStatus = getBeerTicketStatus(filteredList[index]);
          showDialog(
              context: AppState.delegate.navigatorKey.currentContext,
              builder: (BuildContext context) {
                AppState.screenStack.add(ScreenItem.dialog);
                return TransactionDetailsDialog(
                    filteredList[index], freeBeerStatus);
              });
        },
        dense: true,
        leading: Container(
          padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
          height: SizeConfig.blockSizeVertical * 5,
          width: SizeConfig.blockSizeVertical * 5,
          child:
              _transactionService.getTileLead(filteredList[index].tranStatus),
        ),
        title: Text(
          _transactionService.getTileTitle(
            filteredList[index].subType.toString(),
          ),
          style: TextStyle(
            fontSize: SizeConfig.mediumTextSize,
          ),
        ),
        subtitle: Text(
          _transactionService.getTileSubtitle(filteredList[index].type),
          style: TextStyle(
            color: _transactionService
                .getTileColor(filteredList[index].tranStatus),
            fontSize: SizeConfig.smallTextSize,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _transactionService
                  .getFormattedTxnAmount(filteredList[index].amount),
              // (filteredList[index].type == "WITHDRAWAL" ? "- " : "+ ") +
              //     "₹ ${filteredList[index].type == "WITHDRAWAL" ? (filteredList[index].amount * -1).toString() : filteredList[index].amount.toString()}",
              style: TextStyle(
                color: _transactionService
                    .getTileColor(filteredList[index].tranStatus),
                fontSize: SizeConfig.mediumTextSize,
              ),
            ),
            SizedBox(height: 4),
            Text(
              _getFormattedTime(filteredList[index].timestamp),
              style: TextStyle(
                  color: _transactionService
                      .getTileColor(filteredList[index].tranStatus),
                  fontSize: SizeConfig.smallTextSize),
            )
          ],
        ),
      ));
    }

    return _tiles;
  }

  init() {
    _scrollController = ScrollController();
    if (_transactionService.txnList == null ||
        _transactionService.txnList.length < 5) {
      getTransactions();
    }
    if (_init) {
      if (_transactionService.txnList != null) {
        filteredList = List.from(_transactionService.txnList);
      } else {
        filteredList = [];
      }
      _scrollController.addListener(() async {
        if (_scrollController.offset >=
                _scrollController.position.maxScrollExtent &&
            !_scrollController.position.outOfRange) {
          if (_transactionService.hasMoreTransactionListDocuments &&
              state == ViewState.Idle) {
            _logger.d("init pagination");
            getMoreTransactions();
          }
        }
      });
      _init = false;
    }
  }

//TODO added in 2 different places! here and mini_trans_card_vm.dart
  bool isOfferStillValid(Timestamp time) {
    String _timeoutMins = BaseRemoteConfig.remoteConfig
        .getString(BaseRemoteConfig.OCT_FEST_OFFER_TIMEOUT);
    if (_timeoutMins == null || _timeoutMins.isEmpty) _timeoutMins = '10';
    int _timeout = int.tryParse(_timeoutMins);

    DateTime tTime =
        DateTime.fromMillisecondsSinceEpoch(time.millisecondsSinceEpoch);
    Duration difference = DateTime.now().difference(tTime);
    if (difference.inSeconds <= _timeout * 60) {
      return true;
    }
    return false;
  }

  bool getBeerTicketStatus(UserTransaction transaction) {
    double minBeerDeposit = double.tryParse(BaseRemoteConfig.remoteConfig
            .getString(BaseRemoteConfig.OCT_FEST_MIN_DEPOSIT) ??
        '150.0');
    _logger.d(baseProvider.firstAugmontTransaction);
    if (baseProvider.firstAugmontTransaction != null &&
        baseProvider.firstAugmontTransaction == transaction &&
        transaction.amount >= minBeerDeposit &&
        isOfferStillValid(transaction.timestamp)) return true;
    return false;
  }
}
