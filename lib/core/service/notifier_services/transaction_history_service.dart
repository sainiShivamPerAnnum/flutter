import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/transaction_history_service_enum.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/repository/transactions_history_repo.dart';
import 'package:felloapp/util/base_util.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class TransactionHistoryService
    extends PropertyChangeNotifier<TransactionHistoryServiceProperties> {
  final CustomLogger? _logger = locator<CustomLogger>();
  final S locale = locator<S>();
  final BaseUtil? _baseUtil = locator<BaseUtil>();
  final TransactionHistoryRepository? _transactionHistoryRepo =
      locator<TransactionHistoryRepository>();
  List<UserTransaction>? _txnList;
  String? lastTxnDocId;
  String? lastPrizeTxnDocId;
  String? lastDepositTxnDocId;
  String? lastWithdrawalTxnDocId;
  String? lastRefundedTxnDocId;
  bool hasMoreTxns = true;
  bool hasMorePrizeTxns = true;
  bool hasMoreDepositTxns = true;
  bool hasMoreWithdrawalTxns = true;
  bool hasMoreRefundedTxns = true;

  List<UserTransaction>? get txnList => _txnList;

  set txnList(List<UserTransaction>? list) {
    _txnList = list;
    notifyListeners(TransactionHistoryServiceProperties.TransactionHistoryList);
  }

  appendTxns(List<UserTransaction> list) {
    list.forEach((txn) {
      UserTransaction? duplicate =
          _txnList!.firstWhereOrNull((t) => t.timestamp == txn.timestamp);
      if (duplicate == null) _txnList!.add(txn);
    });
    _txnList!
        .sort((a, b) => b.timestamp!.seconds.compareTo(a.timestamp!.seconds));
    notifyListeners(TransactionHistoryServiceProperties.TransactionHistoryList);
  }

  fetchTransactions({
    String? status,
    String? type,
    required InvestmentType subtype,
  }) async {
    //fetch filtered transactions
    final response = await _transactionHistoryRepo!.getUserTransactions(
      type: type,
      subtype: subtype.name,
      status: status,
      start: getLastTxnDocType(status: status, type: type),
    );

    if (!response.isSuccess()) {
      return BaseUtil.showNegativeAlert(
        response.errorMessage ?? locale.txnFetchFailed,
        locale.obPleaseTryAgain,
      );
    }
    // if transaction list is empty
    if (_txnList == null || _txnList!.length == 0) {
      txnList = response.model!.transactions;
    } else {
      // if transaction list already have some items
      appendTxns(response.model!.transactions!);
    }
    _logger!.d("Current Transaction List length: ${_txnList!.length}");
    // set proper lastDocument snapshot for further fetches
    if (response.model!.transactions!.isNotEmpty)
      setLastTxnDocType(
        status: status,
        type: type,
        lastDocId: response.model!.transactions!.last.docKey,
      );
    // check and set which category has no more items to fetch
    if (response.model!.isLastPage!)
      setHasMoreTxnsValue(type: type, status: status);
  }

  String? getLastTxnDocType({String? status, String? type}) {
    if (status == null && type == null) return lastTxnDocId;
    if (status != null) return lastRefundedTxnDocId;
    if (type != null) {
      if (type == UserTransaction.TRAN_TYPE_DEPOSIT) return lastDepositTxnDocId;
      if (type == UserTransaction.TRAN_TYPE_PRIZE) return lastPrizeTxnDocId;
      if (type == UserTransaction.TRAN_TYPE_WITHDRAW)
        return lastWithdrawalTxnDocId;
    }
    return lastTxnDocId;
  }

  setLastTxnDocType({String? status, String? type, String? lastDocId}) {
    if (status == null && type == null) {
      lastTxnDocId = lastDocId;
      lastRefundedTxnDocId = lastDocId;
      lastDepositTxnDocId = lastDocId;
      lastWithdrawalTxnDocId = lastDocId;
      lastPrizeTxnDocId = lastDocId;
    } else if (status != null)
      lastRefundedTxnDocId = lastDocId;
    else if (type != null) {
      if (type == UserTransaction.TRAN_TYPE_DEPOSIT)
        lastDepositTxnDocId = lastDocId;
      if (type == UserTransaction.TRAN_TYPE_PRIZE)
        lastPrizeTxnDocId = lastDocId;
      if (type == UserTransaction.TRAN_TYPE_WITHDRAW)
        lastWithdrawalTxnDocId = lastDocId;
    }
  }

  setHasMoreTxnsValue({String? status, String? type}) {
    if (status == null && type == null) {
      hasMoreTxns = false;
      hasMorePrizeTxns = false;
      hasMoreDepositTxns = false;
      hasMoreRefundedTxns = false;
      hasMoreWithdrawalTxns = false;
      findFirstAugmontTransaction();
      _logger!.d("Transaction fetch complete, no more operations from here on");
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
      List<UserTransaction> reversedList = txnList!.reversed.toList();
      _baseUtil!.firstAugmontTransaction = reversedList.firstWhere((element) =>
          element.type == UserTransaction.TRAN_TYPE_DEPOSIT &&
          element.tranStatus == UserTransaction.TRAN_STATUS_COMPLETE &&
          element.subType == UserTransaction.TRAN_SUBTYPE_AUGMONT_GOLD);
    } catch (e) {
      _logger!.i("No transaction found");
    }
  }

  updateTransactions(InvestmentType investmentType) async {
    lastTxnDocId = null;
    hasMoreTxns = true;
    hasMorePrizeTxns = true;
    hasMoreDepositTxns = true;
    hasMoreWithdrawalTxns = true;
    hasMoreRefundedTxns = true;
    txnList?.clear();
    await fetchTransactions(subtype: investmentType);
    _logger!.i("Transactions got updated");
  }

  // Clear transactions
  signOut() {
    lastTxnDocId = null;
    hasMoreTxns = true;
    hasMorePrizeTxns = true;
    hasMoreDepositTxns = true;
    hasMoreWithdrawalTxns = true;
    hasMoreRefundedTxns = true;
    if (txnList != null) txnList!.clear();
  }

  //UI HELPERS

  String getFormattedTxnAmount(double amount) {
    if (amount > 0)
      return "₹${amount == amount.toInt() ? amount.toInt() : amount.toStringAsFixed(2)}";
    else
      return "- ₹${amount == amount.toInt() ? amount.abs().toInt() : amount.abs().toStringAsFixed(2)}";
  }

  String getFormattedTime(Timestamp tTime) {
    DateTime now =
        DateTime.fromMillisecondsSinceEpoch(tTime.millisecondsSinceEpoch);
    return DateFormat('yyyy-MM-dd – hh:mm a').format(now);
  }

  String getFormattedDate(Timestamp time) {
    DateTime now =
        DateTime.fromMillisecondsSinceEpoch(time.millisecondsSinceEpoch);
    return DateFormat('MMMM dd').format(now);
  }

  getFormattedDateAndTime(Timestamp time) {
    DateTime now =
        DateTime.fromMillisecondsSinceEpoch(time.millisecondsSinceEpoch);
    return DateFormat('d MMMM, yyyy - hh:mm a').format(now);
  }

  String getFormattedSIPDate(DateTime time) {
    DateTime now =
        DateTime.fromMillisecondsSinceEpoch(time.millisecondsSinceEpoch);
    return DateFormat('MMMMd').format(now);
  }

  Widget getTileLead(String type) {
    IconData? icon;
    Color? iconColor;
    if (type == UserTransaction.TRAN_STATUS_COMPLETE) {
      icon = Icons.check_circle;
      iconColor = UiConstants.primaryColor;
    } else if (type == UserTransaction.TRAN_STATUS_CANCELLED ||
        type == UserTransaction.TRAN_STATUS_FAILED) {
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
      return locale.icici;
    } else if (type == UserTransaction.TRAN_SUBTYPE_AUGMONT_GOLD) {
      return locale.digitalGoldText;
    } else if (type == UserTransaction.TRAN_SUBTYPE_TAMBOLA_WIN) {
      return locale.tambolaWin;
    } else if (type == UserTransaction.TRAN_SUBTYPE_REF_BONUS) {
      return locale.refBonus;
    } else if (type == UserTransaction.TRAN_SUBTYPE_REWARD_REDEEM) {
      return locale.rewardsRedemeed;
    } else if (type == UserTransaction.TRAN_SUBTYPE_GLDN_TCK)
      return locale.scratchCard;
    return locale.felloRewards;
  }

  String getTileSubtitle(String type) {
    if (type == UserTransaction.TRAN_TYPE_DEPOSIT) {
      return locale.btnDeposit.toUpperCase();
    } else if (type == UserTransaction.TRAN_TYPE_PRIZE) {
      return locale.prizeText;
    } else if (type == UserTransaction.TRAN_TYPE_WITHDRAW) {
      return locale.withdrawal;
    }
    return locale.autoSipText;
  }

  Color getTransactionTypeColor(String type) {
    print(type);
    if (type == UserTransaction.TRAN_TYPE_DEPOSIT) {
      return UiConstants.kTealTextColor;
    } else if (type == UserTransaction.TRAN_TYPE_PRIZE) {
      return UiConstants.kTealTextColor;
    } else if (type == UserTransaction.TRAN_TYPE_WITHDRAW) {
      return UiConstants.kPeachTextColor;
    }
    return UiConstants.kTextColor;
  }

  Color getTileColor(String? type) {
    if (type == UserTransaction.TRAN_STATUS_CANCELLED ||
        type == UserTransaction.TRAN_STATUS_FAILED) {
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
}
