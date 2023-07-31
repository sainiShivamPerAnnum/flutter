import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/model/portfolio_model.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/hometabs/save/gold_components/gold_pro_hero_card.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class GoldInfoWidget extends StatelessWidget {
  const GoldInfoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<UserService>(builder: (context, model, child) {
      return Container(
        margin:
            EdgeInsets.symmetric(horizontal: SizeConfig.pageHorizontalMargins),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SizeConfig.roundness16),
          border: Border.all(width: 1, color: Colors.white),
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xff1F2C65),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(SizeConfig.roundness16),
                  topRight: Radius.circular(SizeConfig.roundness16),
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.padding20,
                vertical: SizeConfig.padding12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Gold Amount",
                        style: TextStyles.rajdhaniSB.body2
                            .colour(Colors.white.withOpacity(0.7)),
                      ),
                      SizedBox(
                        height: SizeConfig.padding4,
                      ),
                      Selector<UserService, Portfolio>(
                          selector: (p0, p1) => p1.userPortfolio,
                          builder: (context, value, child) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "₹${BaseUtil.digitPrecision(value.gold.balance ?? 0, 2)}",
                                  textAlign: TextAlign.center,
                                  style: TextStyles.sourceSansSB.title5.colour(
                                    Colors.white.withOpacity(0.8),
                                  ),
                                ),
                                SizedBox(width: SizeConfig.padding6),
                                Transform.translate(
                                  offset: Offset(0, -SizeConfig.padding4),
                                  child: RotatedBox(
                                    quarterTurns:
                                        value.gold.percGains >= 0 ? 0 : 2,
                                    child: SvgPicture.asset(
                                      Assets.arrow,
                                      width: SizeConfig.iconSize3,
                                      color: value.gold.percGains >= 0
                                          ? UiConstants.primaryColor
                                          : Colors.red,
                                    ),
                                  ),
                                ),
                                Text(
                                    " ${BaseUtil.digitPrecision(
                                      value.gold.percGains,
                                      2,
                                      false,
                                    )}%",
                                    style: TextStyles.sourceSans.body3.colour(
                                        value.gold.percGains >= 0
                                            ? UiConstants.primaryColor
                                            : Colors.red)),
                              ],
                            );
                          }),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Gold Value",
                        style: TextStyles.rajdhaniSB.body2
                            .colour(Colors.white.withOpacity(0.7)),
                      ),
                      SizedBox(
                        height: SizeConfig.padding4,
                      ),
                      Text(
                        "${(model.userFundWallet?.augGoldQuantity ?? 0).toString()} gms",
                        style: TextStyles.sourceSansSB.title5.colour(
                          Colors.white.withOpacity(0.8),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Haptic.vibrate();

                final UserService _userService = locator<UserService>();
                if ((_userService.userFundWallet?.augGoldQuantity ?? 0) > 0 &&
                    (_userService.userFundWallet?.augGoldQuantity ?? 0) < 0.5) {
                  BaseUtil().openRechargeModalSheet(
                    investmentType: InvestmentType.AUGGOLD99,
                    gms: BaseUtil.digitPrecision(
                        0.5 -
                            (_userService.userFundWallet?.augGoldQuantity ?? 0),
                        4,
                        false),
                  );
                } else {
                  AppState.delegate!.parseRoute(Uri.parse('goldProDetails'));
                }
                locator<AnalyticsService>().track(
                  eventName: AnalyticsEvents.goldProEntryBelowBalanceTapped,
                  properties: {
                    'progress_bar_completed':
                        (_userService.userFundWallet?.augGoldQuantity ?? 0) >
                                0.5
                            ? "YES"
                            : (_userService.userFundWallet?.augGoldQuantity ??
                                    0) /
                                0.5,
                    "existing lease amount":
                        _userService.userPortfolio.goldPro.balance,
                    "existing lease grams":
                        _userService.userFundWallet?.wAugFdQty ?? 0
                  },
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.padding20,
                  vertical: SizeConfig.padding12,
                ),
                width: SizeConfig.screenWidth,
                decoration: BoxDecoration(
                  color: UiConstants.kGoldProBgColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(SizeConfig.roundness16),
                    bottomRight: Radius.circular(SizeConfig.roundness16),
                  ),
                ),
                child: const GoldProHero(),
              ),
            )
          ],
        ),
      );
    });
  }
}
