// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/gold_pro_models/gold_pro_investment_reponse_model.dart';
import 'package:felloapp/core/repository/payment_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/transaction_history_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_pro/gold_pro_sell/gold_pro_sell_components/gold_pro_sell_card.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';

import '../../../../../../navigator/app_state.dart';

class GoldProSellViewModel extends BaseViewModel {
  final PaymentRepository _paymentRepo = locator<PaymentRepository>();
  List<GoldProInvestmentResponseModel> leasedGoldList = [];
  final _txnHistoryService = locator<TxnHistoryService>();
  final UserService _userService = locator<UserService>();
  final S locale = locator<S>();

  bool _isSellInProgress = false;

  bool get isSellInProgress => _isSellInProgress;

  set isSellInProgress(bool value) {
    _isSellInProgress = value;
    notifyListeners();
  }

  Future<void> init() async {
    await getGoldProTransactions();
  }

  void dump() {
    leasedGoldList.clear();
  }

  void onSellTapped(
      GoldProInvestmentResponseModel data, GoldProSellViewModel model) {
    locator<AnalyticsService>().track(
        eventName: AnalyticsEvents.unleaseOnLeaseCardGoldPro,
        properties: {
          "current gold value": data.amount,
          "current gold weight": data.qty,
          "leased on": data.createdOn.toString(),
          "date of extra returns": data.message
        });
    final bool? isGoldProSellLocked = _userService
        .userBootUp?.data!.banMap?.investments?.withdrawal?.goldPro?.isBanned;
    final String? goldProSellBanNotice = _userService
        .userBootUp?.data?.banMap?.investments?.withdrawal?.goldPro?.reason;

    if (isGoldProSellLocked != null && isGoldProSellLocked) {
      BaseUtil.showNegativeAlert(
          goldProSellBanNotice ?? locale.assetNotAvailable, locale.tryLater);
    } else if (!data.isWithdrawable) {
      BaseUtil.showNegativeAlert(
          data.message_un_lease, "Please try again later");
    } else {
      unawaited(BaseUtil.openModalBottomSheet(
        isBarrierDismissible: false,
        addToScreenStack: true,
        isScrollControlled: true,
        hapticVibrate: true,
        content: GoldProSellConfirmationModalSheet(
          data: data,
          model: model,
        ),
      ));
    }
  }

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

      unawaited(_userService.updatePortFolio());
      unawaited(AppState.backButtonDispatcher!.didPopRoute().then((_) {
        BaseUtil.showPositiveAlert("You successfully un-leased your gold",
            "Check your wallet for gold credit");
        getGoldProTransactions(forced: true);
        unawaited(_userService.getUserFundWalletData().then((_) {
          if ((_userService.userFundWallet?.wAugFdQty ?? 0) == 0) {
            unawaited(AppState.backButtonDispatcher!.didPopRoute());
          }
        }));
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
