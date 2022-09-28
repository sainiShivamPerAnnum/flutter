import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/service/notifier_services/transaction_history_service.dart';
import 'package:felloapp/core/service/payments/augmont_transaction_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/others/finance/transactions_history/transactions_history_view.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';

class MiniTransactionCardViewModel extends BaseViewModel {
  final _logger = locator<CustomLogger>();

  final _txnHistoryService = locator<TransactionHistoryService>();
  AppState appState;
  bool _isRefreshing = false;
  bool get isRefreshing => this._isRefreshing;

  set isRefreshing(bool value) {
    this._isRefreshing = value;
    notifyListeners();
  }

  List<UserTransaction> get txnList => _txnHistoryService.txnList;

  TransactionHistoryService get txnHistoryService => _txnHistoryService;

  getMiniTransactions(InvestmentType investmentType) async {
    _logger.d("Getting mini transactions");
    setState(ViewState.Busy);
    await _txnHistoryService.updateTransactions(investmentType);
    setState(ViewState.Idle);
  }

  viewAllTransaction(InvestmentType investmentType) async {
    Haptic.vibrate();
    AppState.delegate.appState.currentAction = PageAction(
      state: PageState.addWidget,
      page: TransactionsHistoryPageConfig,
      widget: TransactionsHistory(
        investmentType: investmentType,
      ),
    );
  }
}
