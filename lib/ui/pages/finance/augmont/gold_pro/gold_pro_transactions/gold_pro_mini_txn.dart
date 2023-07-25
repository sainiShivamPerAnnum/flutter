import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/gold_pro_models/gold_pro_investment_reponse_model.dart';
import 'package:felloapp/core/service/notifier_services/transaction_history_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_pro/gold_pro_transactions/gold_pro_txn_details_view.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GoldProMiniTransactions extends StatelessWidget {
  const GoldProMiniTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<TxnHistoryService, List<GoldProInvestmentResponseModel>>(
      builder: (context, goldProTxnList, child) => goldProTxnList.isEmpty
          ? const SizedBox()
          : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const TitleSubtitleContainer(title: "Transactions"),
                    if (goldProTxnList.length > 5)
                      Padding(
                        padding: EdgeInsets.only(
                            right: SizeConfig.pageHorizontalMargins),
                        child: TextButton(
                          onPressed: () {
                            Haptic.vibrate();
                            AppState.delegate!.appState.currentAction =
                                PageAction(
                              state: PageState.addPage,
                              page: GoldProTxnsViewPageConfig,
                            );
                          },
                          child: Text(
                            "See All",
                            style: TextStyles.rajdhaniB.body2
                                .colour(UiConstants.primaryColor),
                          ),
                        ),
                      ),
                  ],
                ),
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.padding10,
                  ),
                  itemCount:
                      goldProTxnList.length > 5 ? 5 : goldProTxnList.length,
                  itemBuilder: (ctx, i) => GoldProTxnListTile(
                    txn: goldProTxnList[i],
                  ),
                  separatorBuilder: (context, index) => index !=
                          (goldProTxnList.length > 5
                              ? 4
                              : goldProTxnList.length - 1)
                      ? const Divider(
                          color: Colors.white24,
                          thickness: 0.2,
                        )
                      : const SizedBox(),
                )
              ],
            ),
      selector: (p0, p1) => p1.goldProTxns,
    );
  }
}

class GoldProTxnListTile extends StatelessWidget {
  const GoldProTxnListTile({required this.txn, super.key});
  final GoldProInvestmentResponseModel txn;

  TxnHistoryService get txnHistoryService => locator<TxnHistoryService>();
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.only(
        left: SizeConfig.padding24,
        right: SizeConfig.padding20,
      ),
      onTap: () {
        Haptic.vibrate();
        AppState.delegate!.appState.currentAction = PageAction(
          state: PageState.addWidget,
          page: GoldProTxnsDetailsViewPageConfig,
          widget: GoldProTransactionsDetailsView(txn: txn),
        );
      },
      dense: true,
      title: Text(
          txnHistoryService.getGoldProTitle(
            txn.status,
          ),
          style: TextStyles.sourceSans.body3.colour(UiConstants.kTextColor)),
      subtitle: Text(
        "${txnHistoryService.getFormattedDate(txn.createdOn)} at ${txnHistoryService.getFormattedTime(txn.createdOn)}",
        style: TextStyles.sourceSans.body4.colour(UiConstants.kTextColor2),
        textAlign: TextAlign.start,
      ),
      trailing: Wrap(
        children: [
          Text('${BaseUtil.digitPrecision(txn.qty, 2)} gms',
              style: TextStyles.sourceSansSB.body2),
          Padding(
            padding: EdgeInsets.all(SizeConfig.padding6),
            child: Icon(
              Icons.arrow_forward_ios,
              size: SizeConfig.iconSize2,
              color: UiConstants.kTextColor,
            ),
          )
        ],
      ),
    );
  }
}
