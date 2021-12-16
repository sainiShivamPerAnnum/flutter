import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/core/enums/transaction_service_enum.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:felloapp/base_util.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class TransactionService
    extends PropertyChangeNotifier<TransactionServiceProperties> {
  final _dBModel = locator<DBModel>();
  final _baseUtil = locator<BaseUtil>();
  final _userService = locator<UserService>();
  final _logger = locator<Logger>();

  List<UserTransaction> _txnList;
  DocumentSnapshot lastTransactionListDocument;
  bool hasMoreTransactionListDocuments = true;

  List<UserTransaction> get txnList => _txnList;

  set txnList(List<UserTransaction> list) {
    _txnList = list;
    notifyListeners(TransactionServiceProperties.transactionList);
  }

  appendTxns(List<UserTransaction> list) {
    _txnList.addAll(list);
    notifyListeners(TransactionServiceProperties.transactionList);
  }

  fetchTransactions(int limit) async {
    if (_dBModel != null && _userService != null) {
      Map<String, dynamic> tMap = await _dBModel.getFilteredUserTransactions(
          _userService.baseUser,
          null,
          null,
          lastTransactionListDocument,
          limit);

      if (_txnList == null || _txnList.length == 0) {
        txnList = List.from(tMap['listOfTransactions']);
      } else {
        appendTxns(List.from(tMap['listOfTransactions']));
      }
      _logger.d("Current Transaction List length: ${_txnList.length}");
      if (tMap['lastDocument'] != null) {
        lastTransactionListDocument = tMap['lastDocument'];
      }
      if (tMap['length'] < limit) {
        hasMoreTransactionListDocuments = false;
        findFirstAugmontTransaction();
      }
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
    lastTransactionListDocument = null;
    hasMoreTransactionListDocuments = true;
    txnList.clear();
    await fetchTransactions(4);
    _logger.i("Transactions got updated");
  }

// helpers

  String getFormattedTxnAmount(double amount) {
    if (amount > 0)
      return "₹ ${amount.abs().toStringAsFixed(2)}";
    else
      return "- ₹ ${amount.abs().toStringAsFixed(2)}";
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
    } else if (type == UserTransaction.TRAN_STATUS_PENDING) {
      icon = Icons.access_time_filled;
      iconColor = Colors.amber;
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
    } else if (type == UserTransaction.TRAN_STATUS_REFUNDED) {
      return Colors.blue;
    }
    return Colors.black87;
  }

  String getFormattedTime(Timestamp tTime) {
    DateTime now =
        DateTime.fromMillisecondsSinceEpoch(tTime.millisecondsSinceEpoch);
    return DateFormat('yyyy-MM-dd – kk:mm').format(now);
  }

// Clear transactions
  void signOut() {
    lastTransactionListDocument = null;
    hasMoreTransactionListDocuments = true;
    txnList?.clear();
  }
}
