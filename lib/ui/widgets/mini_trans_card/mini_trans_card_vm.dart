import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/service/notifier_services/transaction_history_service.dart';
import 'package:felloapp/core/service/payments/augmont_transaction_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';

class MiniTransactionCardViewModel extends BaseViewModel {
  final _logger = locator<CustomLogger>();

  final _txnHistoryService = locator<TransactionHistoryService>();
  AppState appState;

  List<UserTransaction> get txnList => _txnHistoryService.txnList;

  TransactionHistoryService get txnHistoryService => _txnHistoryService;

  getMiniTransactions() async {
    _logger.d("Getting mini transactions");
    setState(ViewState.Busy);
    await _txnHistoryService.updateTransactions();
    setState(ViewState.Idle);
  }

  viewAllTransaction() async {
    AppState.delegate.appState.currentAction = PageAction(
        state: PageState.addPage, page: TransactionsHistoryPageConfig);
  }
}
