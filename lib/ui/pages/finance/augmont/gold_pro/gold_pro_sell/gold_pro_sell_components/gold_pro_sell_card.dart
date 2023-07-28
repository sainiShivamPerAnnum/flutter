import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/gold_pro_models/gold_pro_investment_reponse_model.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_pro/gold_pro_sell/gold_pro_sell_vm.dart';
import 'package:felloapp/ui/pages/hometabs/save/gold_components/gold_balance_brief_row.dart';
import 'package:felloapp/ui/pages/hometabs/save/gold_components/gold_pro_card.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GoldProSellCard extends StatelessWidget {
  const GoldProSellCard({required this.data, required this.model, super.key});

  final GoldProInvestmentResponseModel data;
  final GoldProSellViewModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: SizeConfig.pageHorizontalMargins,
          vertical: SizeConfig.padding14),
      decoration: BoxDecoration(
        color: UiConstants.kArrowButtonBackgroundColor,
        borderRadius: BorderRadius.circular(SizeConfig.roundness16),
      ),
      padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
      child: Column(children: [
        GoldBalanceBriefRow(
          leadTitle: "Current Gold Value",
          leadTitleColor: Colors.grey,
          lead: BaseUtil.digitPrecision(data.qty + data.interest, 4),
          leadSubtitleColor: UiConstants.kGoldProPrimary,
          trailTitle: "Gold Leased",
          trail: data.qty,
          trailSubtitleColor: UiConstants.kGoldProPrimary,
          trailTitleColor: Colors.grey,
          percent: data.interest,
          isPro: true,
          isGainInGms: true,
        ),
        SizedBox(height: SizeConfig.padding12),
        Row(
          children: [
            Text(
              "Leased On",
              style: TextStyles.sourceSans.body2
                  .colour(UiConstants.kFAQDividerColor),
            ),
            const Spacer(),
            Text(
              DateFormat('dd MMM, yyyy').format(
                  DateTime.fromMillisecondsSinceEpoch(
                      data.createdOn.millisecondsSinceEpoch)),
              style: TextStyles.sourceSansSB.body2.colour(Colors.white),
            )
          ],
        ),
        SizedBox(height: SizeConfig.padding12),
        Row(
          children: [
            // RichText(
            //   text: TextSpan(
            //     text: "will gain extra ",
            // style: TextStyles.body3
            //     .colour(UiConstants.KGoldProPrimaryDark)
            //     .setHeight(1.3),
            //     children: [
            //       TextSpan(
            //           text: "${data.interest}g gold",
            //           style:
            //               TextStyles.sourceSans.body2.colour(Colors.white)),
            //       TextSpan(
            //         text: "\non ${DateFormat('dd MMM, yyyy').format(
            //           DateTime.fromMillisecondsSinceEpoch(data.createdOn
            //               .toDate()
            //               .add(
            //                 Duration(days: data.days),
            //               )
            //               .millisecondsSinceEpoch),
            //         )}",
            //       )
            //     ],
            //   ),
            // ),
            Expanded(
              child: Text(
                "${data.message}",
                style: TextStyles.body3
                    .colour(UiConstants.KGoldProPrimaryDark)
                    .setHeight(1.3),
              ),
            ),
            SizedBox(width: SizeConfig.pageHorizontalMargins),
            Opacity(
              opacity: data.isWithdrawable ? 1 : 0.4,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(width: 1.0, color: Colors.white),
                ),
                onPressed: () {
                  model.onSellTapped(data, model);
                },
                child: Text(
                  "UN-LEASE",
                  style: TextStyles.rajdhaniSB.body2.colour(Colors.white),
                ),
              ),
            )
          ],
        )
      ]),
    );
  }
}

class GoldProSellConfirmationModalSheet extends StatefulWidget {
  const GoldProSellConfirmationModalSheet({
    required this.data,
    required this.model,
    super.key,
  });

  final GoldProInvestmentResponseModel data;
  final GoldProSellViewModel model;

  @override
  State<GoldProSellConfirmationModalSheet> createState() =>
      _GoldProSellConfirmationModalSheetState();
}

class _GoldProSellConfirmationModalSheetState
    extends State<GoldProSellConfirmationModalSheet> {
  bool _isGoldSellInProgress = false;

  bool get isGoldSellInProgress => _isGoldSellInProgress;

  set isGoldSellInProgress(bool value) {
    _isGoldSellInProgress = value;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.02,
      child: Container(
        height: SizeConfig.screenWidth! * 0.8,
        decoration: BoxDecoration(
          border: Border.all(
            color: UiConstants.KGoldProPrimaryDark,
            width: 2,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(SizeConfig.roundness24),
            topRight: Radius.circular(SizeConfig.roundness24),
          ),
          color: UiConstants.kGoldProBgColor,
        ),
        child: Stack(
          children: [
            const Opacity(
              opacity: 0.5,
              child: GoldShimmerWidget(size: ShimmerSizeEnum.large),
            ),
            Container(
              width: SizeConfig.screenWidth,
              margin: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Are you sure you want to un-lease your Gold?",
                    style: TextStyles.rajdhaniM.body2.colour(Colors.white),
                  ),
                  SizedBox(height: SizeConfig.padding18),
                  Text(
                    "You will miss out on",
                    style: TextStyles.rajdhaniM.title3
                        .colour(UiConstants.kGoldProPrimary),
                  ),
                  SizedBox(height: SizeConfig.padding8),
                  Text(
                    "${widget.data.qty}g gold",
                    style: TextStyles.sourceSansSB.title3.colour(Colors.white),
                  ),
                  SizedBox(height: SizeConfig.padding4),
                  Text(
                    "to be credited in your account on ${DateFormat('dd MMM, yyyy').format(
                      DateTime.fromMillisecondsSinceEpoch(widget.data.createdOn
                          .toDate()
                          .add(
                            Duration(days: widget.data.days),
                          )
                          .millisecondsSinceEpoch),
                    )}",
                    style: TextStyles.sourceSans.body3.colour(Colors.white70),
                  ),
                  SizedBox(height: SizeConfig.pageHorizontalMargins),
                  isGoldSellInProgress
                      ? Padding(
                          padding:
                              EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                          child: const LinearProgressIndicator(
                              backgroundColor: Colors.black,
                              color: Colors.white),
                        )
                      : Column(
                          children: [
                            MaterialButton(
                              onPressed: () {
                                Haptic.vibrate();
                                AppState.backButtonDispatcher!.didPopRoute();
                              },
                              color: Colors.white,
                              height: SizeConfig.padding44,
                              minWidth: SizeConfig.screenWidth,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    SizeConfig.roundness12),
                              ),
                              child: Text(
                                "DO NOT UN-LEASE",
                                style: TextStyles.rajdhaniB.body1
                                    .colour(Colors.black),
                              ),
                            ),
                            SizedBox(height: SizeConfig.padding12),
                            TextButton(
                              onPressed: () async {
                                Haptic.vibrate();
                                isGoldSellInProgress = true;
                                await widget.model
                                    .preSellGoldProInvestment(widget.data);
                                isGoldSellInProgress = false;
                              },
                              child: Text(
                                "UN-LEASE TO GOLD",
                                style: TextStyles.rajdhaniB.body1
                                    .colour(Colors.white),
                              ),
                            )
                          ],
                        )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
