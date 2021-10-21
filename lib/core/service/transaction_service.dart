import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/util/locator.dart';
import 'package:logger/logger.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class TransactionService extends PropertyChangeNotifier {
  final _dBModel = locator<DBModel>();
  final _userService = locator<UserService>();
  final _logger = locator<Logger>();

  List<UserTransaction> _txnList;
  DocumentSnapshot lastTransactionListDocument;
  bool hasMoreTransactionListDocuments;

  List<UserTransaction> get txnList => _txnList;

  set txnList(List<UserTransaction> list) {
    _txnList = list;
    notifyListeners();
  }

  appendTxns(List<UserTransaction> list) {
    _txnList.addAll(list);
    notifyListeners();
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
      }
    }
  }

  updateTransactions() async {
    lastTransactionListDocument = null;
    hasMoreTransactionListDocuments = null;
    txnList.clear();
    await fetchTransactions(4);
    _logger.i("Transactions got updated");
  }
}
