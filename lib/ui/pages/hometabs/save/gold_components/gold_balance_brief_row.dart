import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class GoldBalanceBriefRow extends StatelessWidget {
  const GoldBalanceBriefRow({
    this.isGainInGms = false,
    this.mini = false,
    this.lead,
    this.trail,
    this.percent,
    this.leadTitle,
    this.trailTitle,
    this.leadTitleColor,
    this.trailTitleColor,
    this.leadSubtitleColor,
    this.trailSubtitleColor,
    super.key,
  });

  final double? lead, trail, percent;
  final String? leadTitle, trailTitle;
  final bool mini;
  final bool isGainInGms;
  final Color? leadTitleColor,
      trailTitleColor,
      leadSubtitleColor,
      trailSubtitleColor;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserService>(
      builder: (context, model, child) {
        final goldAmount = model.userPortfolio.augmont.fd.balance;
        final goldGrams = model.userFundWallet?.wAugFdQty ?? 0.0;
        final goldGainsPerc = model.userPortfolio.augmont.fd.percGains;
        final goldGains = model.userPortfolio.augmont.fd.absGains;
        return Row(
          children: [
            Expanded(
              flex: 6,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    leadTitle ?? "${Constants.ASSET_GOLD_STAKE} Amount",
                    style: mini
                        ? TextStyles.rajdhaniM
                            .colour(leadTitleColor ?? Colors.white60)
                        : TextStyles.rajdhaniM.body1.colour(Colors.grey),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: Text(
                          isGainInGms
                              ? "${BaseUtil.digitPrecision(lead ?? goldAmount, 4, true)}gms"
                              : "₹${BaseUtil.digitPrecision(lead ?? goldAmount, 2)}",
                          style: mini
                              ? TextStyles.sourceSansSB.title5.colour(
                                  leadSubtitleColor ??
                                      UiConstants.kGoldProPrimary)
                              : TextStyles.sourceSansSB.title4.colour(
                                  leadSubtitleColor ??
                                      UiConstants.kGoldProPrimary),
                        ),
                      ),
                      Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(width: SizeConfig.padding6),
                              Transform.translate(
                                offset: Offset(0, -SizeConfig.padding4),
                                child: RotatedBox(
                                  quarterTurns:
                                      (percent ?? goldGains) >= 0 ? 0 : 2,
                                  child: SvgPicture.asset(
                                    Assets.arrow,
                                    width: SizeConfig.iconSize2,
                                    color: (percent ?? goldGains) >= 0
                                        ? UiConstants.primaryColor
                                        : Colors.red,
                                  ),
                                ),
                              ),
                              Text(
                                  " ${BaseUtil.digitPrecision(
                                    percent ?? goldGainsPerc,
                                    isGainInGms ? 4 : 2,
                                    false,
                                  )}${isGainInGms ? "gms" : "%"}",
                                  style: TextStyles.sourceSans.body3.colour(
                                      (percent ?? goldGains) >= 0
                                          ? UiConstants.primaryColor
                                          : Colors.red)),
                            ],
                          ),
                          SizedBox(
                            height: mini
                                ? SizeConfig.padding2
                                : SizeConfig.padding4,
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trailTitle ?? "${Constants.ASSET_GOLD_STAKE} Value",
                    style: mini
                        ? TextStyles.rajdhaniM
                            .colour(trailTitleColor ?? Colors.white60)
                        : TextStyles.rajdhaniM.body1.colour(Colors.grey),
                  ),
                  Text(
                    "${BaseUtil.digitPrecision(trail ?? goldGrams, 4, false)}gms",
                    style: mini
                        ? TextStyles.sourceSansSB.title5.colour(
                            trailSubtitleColor ?? UiConstants.kGoldProPrimary)
                        : TextStyles.sourceSansSB.title4.colour(
                            trailSubtitleColor ?? UiConstants.kGoldProPrimary),
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
