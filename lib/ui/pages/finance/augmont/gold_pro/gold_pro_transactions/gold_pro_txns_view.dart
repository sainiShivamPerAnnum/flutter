import 'package:felloapp/core/service/notifier_services/transaction_history_service.dart';
import 'package:felloapp/ui/elements/buttons/nav_buttons/nav_buttons.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_pro/gold_pro_transactions/gold_pro_mini_txn.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class GoldProTxnsView extends StatelessWidget {
  const GoldProTxnsView({super.key});

  TxnHistoryService get _txnHistoryService => locator<TxnHistoryService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: UiConstants.kBackgroundColor,
        elevation: 0,
        leading: const FelloAppBarBackButton(),
        centerTitle: true,
        title: Wrap(
          children: [
            Image.asset(
              Assets.digitalGoldBar,
              width: SizeConfig.padding36,
              height: SizeConfig.padding36,
            ),
            Text(
              "${Constants.ASSET_GOLD_STAKE} History",
              style: TextStyles.rajdhaniSB.title5,
            ),
          ],
        ),
      ),
      backgroundColor: UiConstants.kBackgroundColor,
      body: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(
          vertical: SizeConfig.padding10,
        ),
        itemCount: _txnHistoryService.goldProTxns.length,
        itemBuilder: (ctx, i) => GoldProTxnListTile(
          txn: _txnHistoryService.goldProTxns[i],
        ),
        separatorBuilder: (context, index) =>
            index != _txnHistoryService.goldProTxns.length - 1
                ? const Divider(
                    color: Colors.white24,
                    thickness: 0.2,
                  )
                : const SizedBox(),
      ),
    );
  }
}
