import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/model/gold_pro_models/gold_pro_investment_reponse_model.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/finance/augmont/gold_pro/gold_pro_sell/gold_pro_sell_vm.dart';
import 'package:felloapp/ui/pages/finance/augmont/shared/shared.dart';
import 'package:felloapp/ui/pages/hometabs/save/gold_components/gold_pro_card.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GoldProSellCard extends StatelessWidget {
  const GoldProSellCard({
    required this.data,
    required this.model,
    super.key,
  });

  final GoldProInvestmentResponseModel data;
  final GoldProSellViewModel model;

  @override
  Widget build(BuildContext context) {
    final invested = BaseUtil.digitPrecision(data.qty, 4, false);
    final interest = BaseUtil.digitPrecision(data.interest_collected, 4, false);
    final total = BaseUtil.digitPrecision(invested + interest, 4, false);
    final dateOfInvestment = DateFormat('dd MMM, yyyy').format(
      DateTime.fromMillisecondsSinceEpoch(
        data.createdOn.millisecondsSinceEpoch,
      ),
    );

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.pageHorizontalMargins,
        vertical: SizeConfig.padding14,
      ),
      padding: EdgeInsets.all(
        SizeConfig.pageHorizontalMargins,
      ),
      decoration: BoxDecoration(
        color: UiConstants.grey5,
        borderRadius: BorderRadius.circular(SizeConfig.roundness16),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 4),
            blurRadius: 4,
            color: Colors.black.withOpacity(.25),
          )
        ],
      ),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _AmountLabelledText(
              title: 'Gold Leased',
              subTitle: '$invested gms',
            ),
            _AmountLabelledText(
              title: 'Current Value',
              subTitle: '$total gms',
            ),
          ],
        ),
        SizedBox(
          height: SizeConfig.padding12,
        ),
        InterestGainLabel(interest: interest),
        Divider(
          height: SizeConfig.padding24,
          color: Colors.white.withOpacity(.1),
          thickness: 1,
        ),
        Row(
          children: [
            Text(
              "Leased On",
              style: TextStyles.sourceSans.body3.colour(UiConstants.grey1),
            ),
            const Spacer(),
            Text(
              dateOfInvestment,
              style: TextStyles.sourceSansSB.body2.colour(Colors.white),
            )
          ],
        ),
        SizedBox(height: SizeConfig.padding12),
        Row(
          children: [
            Expanded(
              child: Text(
                data.message,
                style: TextStyles.body3.copyWith(
                  color: UiConstants.yellow3,
                  height: 1.3,
                ),
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
                  style: TextStyles.rajdhaniB.body3.colour(
                    Colors.white,
                  ),
                ),
              ),
            )
          ],
        )
      ]),
    );
  }
}

class _AmountLabelledText extends StatelessWidget {
  final String title;
  final String subTitle;

  const _AmountLabelledText({
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyles.rajdhaniSB.body2.colour(
            UiConstants.textGray70,
          ),
        ),
        Text(
          subTitle,
          style: TextStyles.sourceSansSB.body1.colour(
            UiConstants.yellow3,
          ),
        ),
      ],
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
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyles.sourceSansB.title3.colour(Colors.white),
                      children: [
                        TextSpan(
                            text:
                                "${BaseUtil.digitPrecision(widget.data.qty * 0.045)}g"),
                        TextSpan(
                          text:
                              " (${AppConfig.getValue(AppConfigKey.goldProInterest).toDouble()}%) ",
                          style:
                              TextStyles.sourceSans.body1.colour(Colors.white),
                        ),
                        TextSpan(
                          text: "of gold",
                          style: TextStyles.sourceSansSB.title5
                              .colour(Colors.white),
                        ),
                      ],
                    ),
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
                                locator<AnalyticsService>().track(
                                    eventName: AnalyticsEvents
                                        .unleaseConfirmationGoldPro,
                                    properties: {
                                      "cta tapped": "DO NOT UN_LEASE"
                                    });
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
                                locator<AnalyticsService>().track(
                                    eventName: AnalyticsEvents
                                        .unleaseConfirmationGoldPro,
                                    properties: {
                                      "cta tapped": "UN_LEASE TO GOLD"
                                    });
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
