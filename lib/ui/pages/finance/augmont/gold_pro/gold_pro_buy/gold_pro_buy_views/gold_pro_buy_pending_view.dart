import 'package:felloapp/core/enums/transaction_state_enum.dart';
import 'package:felloapp/core/service/payments/augmont_transaction_service.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_pro/gold_pro_buy/gold_pro_buy_vm.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class GoldProBuyPendingView extends StatelessWidget {
  const GoldProBuyPendingView(
      {required this.model, required this.txnService, super.key});

  final GoldProBuyViewModel model;
  final AugmontTransactionService txnService;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.screenHeight,
      width: SizeConfig.screenWidth,
      margin: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "GOLD PRO PENDING VIEW",
            style: TextStyles.rajdhaniB.body0.colour(Colors.amber),
          ),
          const SizedBox(height: 30),
          AppPositiveBtn(
              btnText: "SUCCESS VIEW",
              onPressed: () {
                txnService.currentTransactionState = TransactionState.success;
              })
        ],
      ),
    );
  }
}
