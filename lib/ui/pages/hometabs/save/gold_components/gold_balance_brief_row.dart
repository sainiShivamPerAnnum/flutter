import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/portfolio_model.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class GoldBalanceBriefRow extends StatelessWidget {
  const GoldBalanceBriefRow({
    this.isPro = false,
    this.mini = false,
    this.leftAlign = false,
    this.endAlign = false,
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
  final bool leftAlign;
  final bool endAlign;
  final bool isPro;
  final Color? leadTitleColor,
      trailTitleColor,
      leadSubtitleColor,
      trailSubtitleColor;

  @override
  Widget build(BuildContext context) {
    return Selector<UserService, Portfolio>(
      builder: (context, portfolio, child) => Row(
        children: [
          Expanded(
            flex: 6,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  leadTitle ?? "Gold Amount",
                  style: TextStyles.rajdhaniM
                      .colour(leadTitleColor ?? Colors.white60),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: Text(
                        "₹${BaseUtil.digitPrecision(1000, 2)}",
                        style: mini
                            ? TextStyles.sourceSansSB.body0.colour(
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
                                quarterTurns: 3 >= 0 ? 0 : 2,
                                child: SvgPicture.asset(
                                  Assets.arrow,
                                  width: mini
                                      ? SizeConfig.iconSize3
                                      : SizeConfig.iconSize2,
                                  color: 3 >= 0
                                      ? UiConstants.primaryColor
                                      : Colors.red,
                                ),
                              ),
                            ),
                            Text(
                                " ${BaseUtil.digitPrecision(
                                  3,
                                  2,
                                  false,
                                )}%",
                                style: TextStyles.sourceSans.body3.colour(3 >= 0
                                    ? UiConstants.primaryColor
                                    : Colors.red)),
                          ],
                        ),
                        SizedBox(
                          height:
                              mini ? SizeConfig.padding2 : SizeConfig.padding4,
                        )
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trailTitle ?? "Gold Value",
                  style: TextStyles.rajdhaniM
                      .colour(trailTitleColor ?? Colors.white60),
                ),
                Text(
                  "${BaseUtil.digitPrecision(0.6, 2)}gms",
                  style: mini
                      ? TextStyles.sourceSansSB.body0.colour(
                          trailSubtitleColor ?? UiConstants.kGoldProPrimary)
                      : TextStyles.sourceSansSB.title4.colour(
                          trailSubtitleColor ?? UiConstants.kGoldProPrimary),
                )
              ],
            ),
          )
        ],
      ),
      selector: (p0, p1) => p1.userPortfolio,
    );
  }
}
