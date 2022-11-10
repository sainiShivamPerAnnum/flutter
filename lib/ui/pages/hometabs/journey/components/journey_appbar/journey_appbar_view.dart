import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/journey_service_enum.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/hometabs/journey/journey_view.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/service_elements/user_service/life_time_wins.dart';
import 'package:felloapp/ui/service_elements/user_service/net_worth_value.dart';
import 'package:felloapp/ui/service_elements/user_service/profile_image.dart';
import 'package:felloapp/ui/widgets/coin_bar/coin_bar_view.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class JourneyAppBar extends StatelessWidget {
  JourneyAppBar({Key key}) : super(key: key);
  final _baseUtil = locator<BaseUtil>();
  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<JourneyService, JourneyServiceProperties>(
      properties: [JourneyServiceProperties.AvatarRemoteMilestoneIndex],
      builder: (context, m, properties) {
        return Positioned(
          top: 0,
          left: SizeConfig.padding10,
          child: SafeArea(
              child: Container(
            width: SizeConfig.screenWidth - SizeConfig.padding20,
            height: SizeConfig.screenWidth * 0.30,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(SizeConfig.roundness12),
                  child: BlurFilter(
                    sigmaX: 30,
                    sigmaY: 30,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Column(children: [
                    Container(
                      height: SizeConfig.screenWidth * 0.14,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.padding16),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              padding: EdgeInsets.all(SizeConfig.padding2),
                              child: ProfileImageSE(
                                  radius: SizeConfig.avatarRadius),
                            ),
                            SizedBox(width: SizeConfig.padding12),
                            Expanded(
                              child: PropertyChangeConsumer<UserService,
                                  UserServiceProperties>(
                                properties: [
                                  UserServiceProperties.myJourneyStats
                                ],
                                builder: (context, model, properties) {
                                  return GestureDetector(
                                    onTap: () =>
                                        _baseUtil.openProfileDetailsScreen(),
                                    child: Text(
                                      "Level ${model.userJourneyStats?.level}",
                                      style: TextStyles.rajdhaniSB.title5
                                          .colour(UiConstants.kTextColor),
                                    ),
                                  );
                                },
                              ),
                            ),
                            // IconButton(
                            //     onPressed: () {
                            //       AppState.delegate
                            //           .parseRoute(Uri.parse('/augSell'));
                            //     },
                            //     icon: Icon(Icons.navigation)),
                            FelloCoinBar(),
                            NotificationButton()
                          ],
                        ),
                      ),
                    ),
                    Divider(
                        color: Colors.white.withOpacity(0.5),
                        thickness: 0.5,
                        height: 0.5),
                    Container(
                      height: SizeConfig.screenWidth * 0.14,
                      child: Row(
                        children: [
                          JourneyAppBarAssetDetailsTile(
                            actionUri: '/save',
                            title: "Total Savings",
                            value: NetWorthValue(
                              style: TextStyles.rajdhaniSB.body0
                                  .colour(Colors.white),
                            ),
                          ),
                          VerticalDivider(
                            color: Colors.white.withOpacity(0.5),
                            thickness: 0.5,
                          ),
                          JourneyAppBarAssetDetailsTile(
                            actionUri: '/win',
                            title: "Total Winnings",
                            value: LifeTimeWin(
                              style: TextStyles.rajdhaniSB.body0
                                  .colour(Colors.white),
                            ),
                          )
                        ],
                      ),
                    )
                  ]),
                ),
              ],
            ),
          )),
        );
      },
    );
  }
}

class JourneyAppBarAssetDetailsTile extends StatelessWidget {
  final String title;
  final Widget value;
  final String actionUri;
  JourneyAppBarAssetDetailsTile({
    @required this.title,
    @required this.value,
    @required this.actionUri,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          if (JourneyService.isAvatarAnimationInProgress) return;

          Haptic.vibrate();
          AppState.delegate.parseRoute(Uri.parse(actionUri));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            value,
            Text(
              title,
              style:
                  TextStyles.sourceSans.body4.colour(UiConstants.kTextColor3),
            )
          ],
        ),
      ),
    );
  }
}
