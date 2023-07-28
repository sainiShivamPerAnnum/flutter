// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/gold_pro_models/gold_pro_investment_reponse_model.dart';
import 'package:felloapp/core/repository/payment_repo.dart';
import 'package:felloapp/core/service/notifier_services/transaction_history_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/locator.dart';

import '../../../../../../navigator/app_state.dart';

class GoldProSellViewModel extends BaseViewModel {
  final PaymentRepository _paymentRepo = locator<PaymentRepository>();
  List<GoldProInvestmentResponseModel> leasedGoldList = [];
  final _txnHistoryService = locator<TxnHistoryService>();
  final UserService _userService = locator<UserService>();

  bool _isSellInProgress = false;

  bool get isSellInProgress => _isSellInProgress;

  set isSellInProgress(bool value) {
    _isSellInProgress = value;
    notifyListeners();
  }

  Future<void> init() async {
    await getGoldProTransactions();
  }

  void dump() {}

  Future<void> getGoldProTransactions({bool forced = false}) async {
    setState(ViewState.Busy);
    await _txnHistoryService.getGoldProTransactions(forced: forced);
    leasedGoldList = (_txnHistoryService.goldProTxns)
        .where((e) => e.status == Constants.GOLD_PRO_TXN_STATUS_ACTIVE)
        .toList();
    setState(ViewState.Idle);
  }

  Future<void> preSellGoldProInvestment(
      GoldProInvestmentResponseModel data) async {
    isSellInProgress = true;
    AppState.blockNavigation();
    final ApiResponse<bool> res =
        await _paymentRepo.preCloseGoldProInvestment(data.id);
    if (res.isSuccess()) {
      isSellInProgress = false;
      AppState.unblockNavigation();
      unawaited(_userService.getUserFundWalletData());
      unawaited(_userService.updatePortFolio());
      unawaited(AppState.backButtonDispatcher!.didPopRoute().then((_) {
        BaseUtil.showPositiveAlert("You successfully un-leased your gold",
            "Check your wallet for gold credit");
        getGoldProTransactions(forced: true);
        _txnHistoryService.updateTransactions(InvestmentType.AUGGOLD99);
      }));
    } else {
      isSellInProgress = false;
      AppState.unblockNavigation();
      BaseUtil.showNegativeAlert(
          res.errorMessage, "Please try again after sometime");
    }
  }
}
