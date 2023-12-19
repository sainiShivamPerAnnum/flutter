import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/model/app_config_model.dart';
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
        margin: EdgeInsets.symmetric(
          horizontal: SizeConfig.pageHorizontalMargins,
          vertical: SizeConfig.padding16,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SizeConfig.roundness16),
          border: Border.all(width: 1, color: Colors.white),
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xff1F2C65),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(SizeConfig.roundness16),
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
                        style: TextStyles.rajdhaniSB.body2.copyWith(
                          color: UiConstants.kTextFieldTextColor,
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.padding4,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "₹${BaseUtil.digitPrecision(model.userPortfolio.augmont.gold.balance, 2)}",
                            textAlign: TextAlign.center,
                            style: TextStyles.sourceSansSB.title5.copyWith(
                              color: Colors.white,
                              height: 1.27,
                            ),
                          ),
                          SizedBox(width: SizeConfig.padding6),
                          if ((model.userFundWallet?.augGoldQuantity ?? 0.0) >
                              0.001)
                            Transform.translate(
                              offset: Offset(0, -SizeConfig.padding4),
                              child: RotatedBox(
                                quarterTurns: model.userPortfolio.augmont.gold
                                            .percGains >=
                                        0
                                    ? 0
                                    : 2,
                                child: SvgPicture.asset(
                                  Assets.arrow,
                                  width: SizeConfig.iconSize3,
                                  color: model.userPortfolio.augmont.gold
                                              .percGains >=
                                          0
                                      ? UiConstants.primaryColor
                                      : Colors.red,
                                ),
                              ),
                            ),
                          if ((model.userFundWallet?.augGoldQuantity ?? 0.0) >
                              0.001)
                            Text(
                                " ${BaseUtil.digitPrecision(
                                  model.userPortfolio.augmont.gold.percGains,
                                  2,
                                  false,
                                )}%",
                                style: TextStyles.sourceSans.body3.colour(model
                                            .userPortfolio
                                            .augmont
                                            .gold
                                            .percGains >=
                                        0
                                    ? UiConstants.primaryColor
                                    : Colors.red)),
                        ],
                      ),
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
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: (model.userFundWallet?.augGoldQuantity ?? 0)
                                  .toString(),
                              style: TextStyles.sourceSansSB.title5.copyWith(
                                color: Colors.white,
                                height: 1.27,
                              ),
                            ),
                            TextSpan(
                              text: " gms",
                              style: TextStyles.sourceSansSB.body1.copyWith(
                                color: Colors.white,
                                height: 1.27,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Haptic.vibrate();

                final UserService userService = locator<UserService>();
                if ((userService.userFundWallet?.augGoldQuantity ?? 0) > 0 &&
                    (userService.userFundWallet?.augGoldQuantity ?? 0) < 2 &&
                    (userService.userFundWallet?.wAugFdQty ?? 0.0) == 0) {
                  BaseUtil().openRechargeModalSheet(
                    investmentType: InvestmentType.AUGGOLD99,
                    gms: BaseUtil.digitPrecision(
                        AppConfig.getValue(
                                AppConfigKey.goldProInvestmentChips)[0] -
                            (userService.userFundWallet?.augGoldQuantity ?? 0),
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
                        (userService.userFundWallet?.augGoldQuantity ?? 0) > 2
                            ? "YES"
                            : (userService.userFundWallet?.augGoldQuantity ??
                                    0) /
                                2,
                    "existing lease amount":
                        userService.userPortfolio.augmont.fd.balance,
                    "existing lease grams":
                        userService.userFundWallet?.wAugFdQty ?? 0
                  },
                );
              },
              child: DecoratedBox(
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
