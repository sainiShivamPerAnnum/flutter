import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/gold_pro_models/gold_pro_investment_reponse_model.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/service/notifier_services/transaction_history_service.dart';
import 'package:felloapp/core/service/payments/augmont_transaction_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/modalsheets/transaction_details_model_sheet.dart';
import 'package:felloapp/ui/pages/login/login_components/login_support.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GoldProTransactionsDetailsView extends StatelessWidget {
  const GoldProTransactionsDetailsView({required this.txn, super.key});

  final GoldProInvestmentResponseModel txn;

  TxnHistoryService get _txnHistoryService => locator<TxnHistoryService>();

  String get getFormattedDate =>
      DateFormat('dd MMM, yyyy').format(DateTime.fromMillisecondsSinceEpoch(
          txn.createdOn.millisecondsSinceEpoch));

  String get formattedTime =>
      DateFormat('hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(
          txn.createdOn.millisecondsSinceEpoch));

  @override
  Widget build(BuildContext context) {
    final List<TransactionStatusMapItemModel> summary = [];

    if (txn.status == "active") {
      summary.add(TransactionStatusMapItemModel(
        title: "Gold Leased",
        timestamp: txn.createdOn,
        value: "success",
      ));
    } else if (txn.status == "close") {
      summary.addAll([
        TransactionStatusMapItemModel(
          title: "Gold Leased",
          timestamp: txn.createdOn,
          value: "success",
        ),
        TransactionStatusMapItemModel(
          title: "Gold un-Leased",
          timestamp: txn.updatedOn,
          value: "success",
        )
      ]);
    }
    return Scaffold(
      backgroundColor: const Color(0xff151D22),
      appBar: AppBar(
        backgroundColor: const Color(0xff151D22),
        elevation: 0,
        actions: [
          Row(
            children:
                _txnHistoryService.getGoldProStatus(txn.status) == "COMPLETED"
                    ? [const FaqPill(), SizedBox(width: SizeConfig.padding10)]
                    : [],
          )
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      Assets.digitalGoldBar,
                      height: SizeConfig.screenWidth! * 0.12,
                      width: SizeConfig.screenWidth! * 0.12,
                    ),
                    Text(
                      Constants.ASSET_GOLD_STAKE,
                      style: TextStyles.rajdhaniSB.body2,
                    )
                  ],
                ),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: "${txn.qty}",
                      style: TextStyles.rajdhaniB.title50,
                      children: [
                        TextSpan(
                          text: "gms",
                          style: TextStyles.rajdhaniM.title2,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.padding8,
                ),
                Row(
                  children: [
                    SubInfoTile(
                      title: "Enroll Date",
                      subtitle: getFormattedDate,
                    ),
                    const SubInfoTile(
                      title: "Current Tenure",
                      subtitle: "6 Months",
                    ),
                  ],
                ),
                Row(
                  children: [
                    SubInfoTile(
                      title: "Leased to",
                      subtitle: locator<AugmontTransactionService>()
                              .goldProScheme
                              ?.jewellerUserAccountName ??
                          "-",
                    ),
                    SubInfoTile(
                      title: "Interest",
                      subtitle:
                          "${locator<AugmontTransactionService>().goldProScheme?.interestRate ?? '-'}%",
                    ),
                  ],
                ),
                Divider(
                    color: Colors.white10,
                    height: SizeConfig.pageHorizontalMargins),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Status",
                      style: TextStyles.sourceSans.body2.colour(Colors.white38),
                    ),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 4,
                          backgroundColor:
                              _txnHistoryService.getGoldProColor(txn.status),
                        ),
                        Text(
                          "  ${_txnHistoryService.getGoldProStatus(txn.status)}",
                          style: TextStyles.body2.colour(
                              _txnHistoryService.getGoldProColor(txn.status)),
                        )
                      ],
                    )
                  ],
                ),
                TransactionSummary(
                  assetType: InvestmentType.GOLDPRO,
                  txnType: txn.status,
                  summary: summary,
                  createdOn: txn.createdOn,
                )
              ],
            ),
          ),
          if (_txnHistoryService.getGoldProStatus(txn.status) != "COMPLETED")
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                child: AppPositiveBtn(
                  onPressed: () async {
                    Haptic.vibrate();
                    AppState.delegate!.appState.currentAction = PageAction(
                      state: PageState.addPage,
                      page: FreshDeskHelpPageConfig,
                    );
                  },
                  width: SizeConfig.screenWidth!,
                  btnText: "NEED HELP ?",
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class SubInfoTile extends StatelessWidget {
  const SubInfoTile({
    required this.title,
    required this.subtitle,
    super.key,
  });

  final String title, subtitle;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListTile(
        title: Text(
          title,
          style: TextStyles.body2.colour(UiConstants.kFAQsAnswerColor),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyles.body2.colour(Colors.white54),
        ),
      ),
    );
  }
}
