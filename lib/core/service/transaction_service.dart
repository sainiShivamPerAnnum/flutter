import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/enums/transaction_service_enum.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/base_util.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class TransactionService
    extends PropertyChangeNotifier<TransactionServiceProperties> {
  final _dBModel = locator<DBModel>();
  final _baseUtil = locator<BaseUtil>();
  final _userService = locator<UserService>();
  final _logger = locator<CustomLogger>();

  List<UserTransaction> _txnList;
  DocumentSnapshot lastTxnDoc,
      lastPrizeTxnDoc,
      lastDepositTxnDoc,
      lastWithdrawalTxnDoc,
      lastRefundedTxnDoc;
  bool hasMoreTxns = true,
      hasMorePrizeTxns = true,
      hasMoreDepositTxns = true,
      hasMoreWithdrawalTxns = true,
      hasMoreRefundedTxns = true;

  List<UserTransaction> get txnList => _txnList;

  set txnList(List<UserTransaction> list) {
    _txnList = list;
    notifyListeners(TransactionServiceProperties.transactionList);
  }

  appendTxns(List<UserTransaction> list) {
    list.forEach((txn) {
      UserTransaction duplicate = _txnList
          .firstWhere((t) => t.timestamp == txn.timestamp, orElse: () => null);
      if (duplicate == null) _txnList.add(txn);
    });
    _txnList.sort((a, b) => b.timestamp.seconds.compareTo(a.timestamp.seconds));
    notifyListeners(TransactionServiceProperties.transactionList);
  }

  fetchTransactions({
    @required int limit,
    String status,
    String type,
    String subtype,
  }) async {
    if (_dBModel != null && _userService != null) {
      //fetch filtered transactions
      Map<String, dynamic> tMap = await _dBModel.getFilteredUserTransactions(
        user: _userService.baseUser,
        type: type,
        subtype: subtype,
        status: status,
        lastDocument: getLastTxnDocType(status: status, type: type),
        limit: limit,
      );
      // if transaction list is empty
      if (_txnList == null || _txnList.length == 0) {
        txnList = List.from(tMap['listOfTransactions']);
      } else {
        // if transaction list already have some items
        appendTxns(tMap['listOfTransactions']);
      }
      _logger.d("Current Transaction List length: ${_txnList.length}");
      // set proper lastDocument snapshot for further fetches
      if (tMap['lastDocument'] != null)
        setLastTxnDocType(
            status: status, type: type, lastDocSnapshot: tMap['lastDocument']);
      // check and set which category has no more items to fetch
      if (tMap['length'] < limit)
        setHasMoreTxnsValue(type: type, status: status);
    }
  }

  DocumentSnapshot getLastTxnDocType({String status, String type}) {
    if (status == null && type == null) return lastTxnDoc;
    if (status != null) return lastRefundedTxnDoc;
    if (type != null) {
      if (type == UserTransaction.TRAN_TYPE_DEPOSIT) return lastDepositTxnDoc;
      if (type == UserTransaction.TRAN_TYPE_PRIZE) return lastPrizeTxnDoc;
      if (type == UserTransaction.TRAN_TYPE_WITHDRAW)
        return lastWithdrawalTxnDoc;
    }
    return lastTxnDoc;
  }

  setLastTxnDocType(
      {String status, String type, DocumentSnapshot lastDocSnapshot}) {
    if (status == null && type == null) {
      lastTxnDoc = lastDocSnapshot;
      lastRefundedTxnDoc = lastDocSnapshot;
      lastDepositTxnDoc = lastDocSnapshot;
      lastWithdrawalTxnDoc = lastDocSnapshot;
      lastPrizeTxnDoc = lastDocSnapshot;
    } else if (status != null)
      lastRefundedTxnDoc = lastDocSnapshot;
    else if (type != null) {
      if (type == UserTransaction.TRAN_TYPE_DEPOSIT)
        lastDepositTxnDoc = lastDocSnapshot;
      if (type == UserTransaction.TRAN_TYPE_PRIZE)
        lastPrizeTxnDoc = lastDocSnapshot;
      if (type == UserTransaction.TRAN_TYPE_WITHDRAW)
        lastWithdrawalTxnDoc = lastDocSnapshot;
    }
  }

  setHasMoreTxnsValue({String status, String type}) {
    if (status == null && type == null) {
      hasMoreTxns = false;
      hasMorePrizeTxns = false;
      hasMoreDepositTxns = false;
      hasMoreRefundedTxns = false;
      hasMoreWithdrawalTxns = false;
      findFirstAugmontTransaction();
      _logger.d("Transaction fetch complete, no more operations from here on");
    } else if (status != null) {
      hasMoreRefundedTxns = false;
    } else if (type != null) {
      if (type == UserTransaction.TRAN_TYPE_DEPOSIT)
        hasMoreDepositTxns = false;
      else if (type == UserTransaction.TRAN_TYPE_WITHDRAW)
        hasMoreWithdrawalTxns = false;
      else if (type == UserTransaction.TRAN_TYPE_PRIZE)
        hasMorePrizeTxns = false;
    }
  }

  findFirstAugmontTransaction() {
    try {
      List<UserTransaction> reversedList = txnList.reversed.toList();
      _baseUtil.firstAugmontTransaction = reversedList.firstWhere((element) =>
          element.type == UserTransaction.TRAN_TYPE_DEPOSIT &&
          element.tranStatus == UserTransaction.TRAN_STATUS_COMPLETE &&
          element.subType == UserTransaction.TRAN_SUBTYPE_AUGMONT_GOLD);
    } catch (e) {
      _logger.i("No transaction found");
    }
  }

  updateTransactions() async {
    lastTxnDoc = null;
    hasMoreTxns = true;
    hasMorePrizeTxns = true;
    hasMoreDepositTxns = true;
    hasMoreWithdrawalTxns = true;
    hasMoreRefundedTxns = true;
    txnList.clear();
    await fetchTransactions(limit: 4);
    _logger.i("Transactions got updated");
  }

// helpers

  String getFormattedTxnAmount(double amount) {
    if (amount > 0)
      return "₹ ${amount.abs().toStringAsFixed(2)}";
    else
      return "- ₹ ${amount.abs().toStringAsFixed(2)}";
  }

  String getFormattedTime(Timestamp tTime) {
    DateTime now =
        DateTime.fromMillisecondsSinceEpoch(tTime.millisecondsSinceEpoch);
    return DateFormat('yyyy-MM-dd – hh:mm').format(now);
  }

  Widget getTileLead(String type) {
    IconData icon;
    Color iconColor;
    if (type == UserTransaction.TRAN_STATUS_COMPLETE) {
      icon = Icons.check_circle;
      iconColor = UiConstants.primaryColor;
    } else if (type == UserTransaction.TRAN_STATUS_CANCELLED) {
      icon = Icons.cancel;
      iconColor = Colors.red;
    } else if (type == UserTransaction.TRAN_STATUS_PENDING ||
        type == UserTransaction.TRAN_STATUS_PROCESSING) {
      icon = Icons.access_time_filled;
      iconColor = UiConstants.tertiarySolid;
    } else if (type == UserTransaction.TRAN_STATUS_REFUNDED) {
      icon = Icons.remove_circle;
      iconColor = Colors.blue;
    }
    if (icon != null) return Icon(icon, color: iconColor);

    return Image.asset("images/fello_logo.png", fit: BoxFit.contain);
  }

  String getTileTitle(String type) {
    if (type == UserTransaction.TRAN_SUBTYPE_ICICI) {
      return "ICICI Prudential Fund";
    } else if (type == UserTransaction.TRAN_SUBTYPE_AUGMONT_GOLD) {
      return "Digital Gold";
    } else if (type == UserTransaction.TRAN_SUBTYPE_TAMBOLA_WIN) {
      return "Tambola Win";
    } else if (type == UserTransaction.TRAN_SUBTYPE_REF_BONUS) {
      return "Referral Bonus";
    } else if (type == UserTransaction.TRAN_SUBTYPE_REWARD_REDEEM) {
      return "Rewards Redeemed";
    } else if (type == UserTransaction.TRAN_SUBTYPE_GLDN_TCK)
      return "Golden Ticket";
    return "Fello Rewards";
  }

  String getTileSubtitle(String type) {
    if (type == UserTransaction.TRAN_TYPE_DEPOSIT) {
      return "Deposit";
    } else if (type == UserTransaction.TRAN_TYPE_PRIZE) {
      return "Prize";
    } else if (type == UserTransaction.TRAN_TYPE_WITHDRAW) {
      return "Withdrawal";
    }
    return "";
  }

  Color getTileColor(String type) {
    if (type == UserTransaction.TRAN_STATUS_CANCELLED) {
      return Colors.redAccent;
    } else if (type == UserTransaction.TRAN_STATUS_COMPLETE) {
      return UiConstants.primaryColor;
    } else if (type == UserTransaction.TRAN_STATUS_PENDING) {
      return Colors.amber;
    } else if (type == UserTransaction.TRAN_STATUS_PROCESSING) {
      return Colors.amber;
    } else if (type == UserTransaction.TRAN_STATUS_REFUNDED) {
      return Colors.blue;
    }
    return Colors.black54;
  }

  // BEER FEST SPECIFIC CODE

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
    _logger.d(_baseUtil.firstAugmontTransaction);
    if (_baseUtil.firstAugmontTransaction != null &&
        _baseUtil.firstAugmontTransaction == transaction &&
        transaction.amount >= minBeerDeposit &&
        isOfferStillValid(transaction.timestamp)) return true;
    return false;
  }

// Clear transactions
  signOut() {
    lastTxnDoc = null;
    hasMoreTxns = true;
    hasMorePrizeTxns = true;
    hasMoreDepositTxns = true;
    hasMoreWithdrawalTxns = true;
    hasMoreRefundedTxns = true;
    txnList.clear();
  }
}
