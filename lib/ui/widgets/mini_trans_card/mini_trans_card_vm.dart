import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/transaction_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';

class MiniTransactionCardViewModel extends BaseModel {
  final Log dblog = new Log("DBModel");
  final Log bulog = new Log("BaseUtil");
  final dbProvider = locator<DBModel>();
  final baseProvider = locator<BaseUtil>();
  final _txnService = locator<TransactionService>();
  AppState appState;

  List<UserTransaction> get txnList => _txnService.txnList;
  TransactionService get txnService => _txnService;

  getMiniTransactions() async {
    bulog.debug("Getting mini transactions");
    setState(ViewState.Busy);
    await _txnService.fetchTransactions(4);
    setState(ViewState.Idle);
  }

  viewAllTransaction() async {
    AppState.delegate.appState.currentAction = PageAction(
        state: PageState.addPage, page: TransactionsHistoryPageConfig);
  }

  bool isOfferStillValid(Timestamp time) {
    String _timeoutMins = BaseRemoteConfig.remoteConfig
        .getString(BaseRemoteConfig.OCT_FEST_OFFER_TIMEOUT);
    if (_timeoutMins == null || _timeoutMins.isEmpty) _timeoutMins = '10';
    int _timeout = int.tryParse(_timeoutMins);

    DateTime tTime =
        DateTime.fromMillisecondsSinceEpoch(time.millisecondsSinceEpoch);
    Duration difference = DateTime.now().difference(tTime);
    if (difference.inSeconds <= _timeout * 60) {
      log("offer Still valid");
      return true;
    }
    log("offer no more valid");
    return false;
  }

  bool getBeerTicketStatus(UserTransaction transaction) {
    double minBeerDeposit = double.tryParse(BaseRemoteConfig.remoteConfig
            .getString(BaseRemoteConfig.OCT_FEST_MIN_DEPOSIT) ??
        '150.0');
    if (baseProvider.firstAugmontTransaction != null &&
        baseProvider.firstAugmontTransaction == transaction &&
        transaction.amount >= minBeerDeposit &&
        isOfferStillValid(transaction.timestamp)) return true;
    return false;
  }
}
