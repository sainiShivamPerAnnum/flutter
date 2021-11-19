import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/core/enums/transaction_service_enum.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/util/locator.dart';
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
  bool hasMoreTransactionListDocuments;

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
        _logger.d("Transactions list length: ${txnList.length}");
      } else {
        appendTxns(List.from(tMap['listOfTransactions']));
      }
      if (tMap['lastDocument'] != null) {
        lastTransactionListDocument = tMap['lastDocument'];
      }
      if (tMap['length'] < 30) {
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
    hasMoreTransactionListDocuments = null;
    txnList.clear();
    await fetchTransactions(4);
    _logger.i("Transactions got updated");
  }

  signOut() {
    lastTransactionListDocument = null;
    hasMoreTransactionListDocuments = null;
    txnList.clear();
  }
}
