// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:felloapp/core/enums/transaction_state_enum.dart';
import 'package:felloapp/core/service/payments/augmont_transaction_service.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_pro/gold_pro_buy/gold_pro_buy_views/gold_pro_buy_input_view.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_pro/gold_pro_buy/gold_pro_buy_views/gold_pro_buy_over_view.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_pro/gold_pro_buy/gold_pro_buy_views/gold_pro_buy_pending_view.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_pro/gold_pro_buy/gold_pro_buy_views/gold_pro_buy_success_view.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_pro/gold_pro_buy/gold_pro_buy_vm.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GoldProBuyView extends StatefulWidget {
  const GoldProBuyView({super.key});

  @override
  State<GoldProBuyView> createState() => _GoldProBuyViewState();
}

class _GoldProBuyViewState extends State<GoldProBuyView> {
  @override
  Widget build(BuildContext context) {
    return BaseView<GoldProBuyViewModel>(
      onModelReady: (model) => model.init(),
      onModelDispose: (model) => model.dump(),
      builder: (context, model, child) => Consumer<AugmontTransactionService>(
          builder: (transactionContext, txnService, _) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: UiConstants.darkPrimaryColor2,
          body: getView(txnService, model),
        );
      }),
    );
  }

  Widget getView(
      AugmontTransactionService txnService, GoldProBuyViewModel model) {
    switch (txnService.currentTxnState) {
      case TransactionState.idle:
        return GoldProBuyInputView(model: model, txnService: txnService);
      case TransactionState.overView:
        return GoldProBuyOverView(model: model, txnService: txnService);
      case TransactionState.ongoing:
        return GoldProBuyPendingView(model: model, txnService: txnService);
      case TransactionState.success:
        return GoldProBuySuccessView(model: model, txnService: txnService);
    }
  }
}
