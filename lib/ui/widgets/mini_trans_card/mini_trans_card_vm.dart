import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/service/transaction_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';

class MiniTransactionCardViewModel extends BaseModel {
  final _logger = locator<CustomLogger>();
  final _txnService = locator<TransactionService>();
  AppState appState;

  List<UserTransaction> get txnList => _txnService.txnList;
  TransactionService get txnService => _txnService;

  getMiniTransactions() async {
    _logger.d("Getting mini transactions");
    setState(ViewState.Busy);
    await _txnService.fetchTransactions(limit: 4);
    setState(ViewState.Idle);
  }

  viewAllTransaction() async {
    AppState.delegate.appState.currentAction = PageAction(
        state: PageState.addPage, page: TransactionsHistoryPageConfig);
  }
}
