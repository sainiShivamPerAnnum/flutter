import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/transaction_state_enum.dart';
import 'package:felloapp/core/service/payments/augmont_transaction_service.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_buy/widgets/view_breakdown.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_pro/gold_pro_buy/gold_pro_buy_components/gold_balance_rows.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_pro/gold_pro_buy/gold_pro_buy_views/gold_pro_buy_input_view.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_pro/gold_pro_buy/gold_pro_buy_vm.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class GoldProBuyOverView extends StatelessWidget {
  const GoldProBuyOverView(
      {required this.model, required this.txnService, super.key});

  final GoldProBuyViewModel model;
  final AugmontTransactionService txnService;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              if (txnService.isGoldBuyInProgress) return;
              Haptic.vibrate();
              txnService.currentTransactionState = TransactionState.idle;
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Row(
            children: [
              Image.asset(
                Assets.digitalGoldBar,
                width: SizeConfig.padding54,
                height: SizeConfig.padding54,
              ),
              // SizedBox(width: SizeConfig.padding8),
              Text(
                Constants.ASSET_GOLD_STAKE,
                style: TextStyles.rajdhaniSB.title5,
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(
              horizontal: SizeConfig.pageHorizontalMargins),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight! * 0.03),
              Text(
                "You are investing",
                style: TextStyles.rajdhaniM.title4.colour(Colors.grey),
              ),
              SizedBox(height: SizeConfig.screenHeight! * 0.008),
              Text(
                "${model.totalGoldBalance}gms",
                style: TextStyles.rajdhaniB.title1.colour(Colors.white),
              ),
              SizedBox(height: SizeConfig.screenHeight! * 0.04),
              ExpectedGoldProReturnsRow(model: model),
              SizedBox(height: SizeConfig.screenHeight! * 0.02),
              GoldBalanceRow(
                lead: "Current Gold Balance",
                trail: model.currentGoldBalance,
              ),
              SizedBox(height: SizeConfig.screenHeight! * 0.02),
              GoldBalanceRow(
                lead: "Additional Gold to be added",
                trail: model.additionalGoldBalance,
              ),
              SizedBox(height: SizeConfig.screenHeight! * 0.04),
              PriceAdaptiveGoldProOverViewCard(model: model),
              const GoldProLeaseCompanyDetailsStrip(),
            ],
          ),
        ),
        const Spacer(),
        txnService.isGoldBuyInProgress
            ? Padding(
                padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                child: const LinearProgressIndicator(
                  backgroundColor: Colors.black,
                ),
              )
            : Container(
                color: Colors.black,
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.pageHorizontalMargins,
                  vertical: SizeConfig.padding16,
                ),
                width: SizeConfig.screenWidth,
                child: Row(
                  children: [
                    if (model.additionalGoldBalance != 0)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "₹${BaseUtil.digitPrecision(model.totalGoldAmount, 2)} ",
                                  style: TextStyles.sourceSansB.body0
                                      .colour(Colors.white),
                                ),
                                Text(
                                  "In ${Constants.ASSET_GOLD_STAKE}",
                                  style: TextStyles.rajdhaniSB.body2
                                      .colour(UiConstants.kGoldProPrimary),
                                )
                              ],
                            ),
                            SizedBox(height: SizeConfig.padding4),
                            Text(
                              "Inc. (GST)",
                              style: TextStyles.rajdhaniL.body2
                                  .colour(Colors.white),
                            ),
                            SizedBox(height: SizeConfig.padding10),
                            GestureDetector(
                              onTap: () {
                                BaseUtil.openModalBottomSheet(
                                  isBarrierDismissible: true,
                                  backgroundColor: const Color(0xff1A1A1A),
                                  addToScreenStack: true,
                                  isScrollControlled: true,
                                  content: GoldProBreakdownView(
                                    model: model,
                                    showPsp: false,
                                  ),
                                );
                              },
                              child: Text(
                                "View Breakdown",
                                style: TextStyles.body3.underline
                                    .colour(Colors.grey),
                              ),
                            )
                          ],
                        ),
                      ),
                    ReactivePositiveAppButton(
                      btnText: model.additionalGoldBalance != 0
                          ? "SAVE"
                          : "SAVE IN ${Constants.ASSET_GOLD_STAKE.toUpperCase()}",
                      onPressed: () {
                        model.initiateGoldProTransaction();
                      },
                      width: SizeConfig.screenWidth! *
                          (model.additionalGoldBalance != 0 ? 0.3 : 0.88),
                    )
                  ],
                ),
              )
      ],
    );
  }
}
