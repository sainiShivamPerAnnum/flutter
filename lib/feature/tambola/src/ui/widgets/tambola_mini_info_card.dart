import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/model/user_funt_wallet_model.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class TambolaMiniInfoCard extends StatelessWidget {
  const TambolaMiniInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<UserService, UserFundWallet?>(
        builder: (context, wallet, child) => GestureDetector(
              onTap: () {
                Haptic.vibrate();
                AppState.delegate!.parseRoute(Uri.parse("tambolaHome"));
                locator<AnalyticsService>().track(
                    eventName: AnalyticsEvents.saveOnAssetBannerTapped,
                    properties: {
                      'ticket_count': wallet?.tickets ?? 0,
                    });
              },
              child: Card(
                  margin: EdgeInsets.symmetric(
                      horizontal: SizeConfig.pageHorizontalMargins,
                      vertical: SizeConfig.padding14),
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness12)),
                  color: UiConstants.darkPrimaryColor4,
                  child: (wallet?.tickets?["total"] ?? 0) > 0
                      ? Padding(
                          padding: EdgeInsets.only(
                              top: SizeConfig.padding12,
                              bottom: SizeConfig.padding12,
                              left: SizeConfig.pageHorizontalMargins,
                              right: SizeConfig.pageHorizontalMargins / 2),
                          child: Row(children: [
                            Transform.scale(
                              scale: 1.5,
                              child: SvgPicture.asset(
                                Assets.tambolaCardAsset,
                                width: SizeConfig.padding40,
                              ),
                            ),
                            SizedBox(width: SizeConfig.padding10),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          "Your Tickets",
                                          style: TextStyles.rajdhaniM.body0
                                              .colour(Colors.white),
                                          maxLines: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                    width: SizeConfig.pageHorizontalMargins),
                                Text(
                                  (wallet?.tickets?["total"] ?? 0).toString(),
                                  style: TextStyles.rajdhaniB.title3
                                      .colour(Colors.white),
                                ),
                                SizedBox(width: SizeConfig.padding12),
                                SvgPicture.asset(
                                  Assets.chevRonRightArrow,
                                  color: Colors.white,
                                )
                              ],
                            )
                          ]),
                        )
                      : ClipRRect(
                          borderRadius:
                              BorderRadius.circular(SizeConfig.roundness8),
                          child:
                              Lottie.asset(Assets.tambolaTopBannerTharLottie))),
            ),
        selector: (p0, p1) => p1.userFundWallet);
  }
}
