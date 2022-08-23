import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/core/service/notifier_services/golden_ticket_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/hometabs/journey/journey_view.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_scratch_dialog/gt_instant_view.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/service_elements/user_service/profile_image.dart';
import 'package:felloapp/ui/service_elements/user_service/user_gold_quantity.dart';
import 'package:felloapp/ui/widgets/coin_bar/coin_bar_view.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class JourneyAppBar extends StatelessWidget {
  JourneyAppBar({Key key}) : super(key: key);
  final _baseUtil = locator<BaseUtil>();
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: SizeConfig.padding6,
      left: SizeConfig.padding10,
      child: SafeArea(
          child: Container(
        width: SizeConfig.screenWidth - SizeConfig.padding20,
        height: SizeConfig.screenWidth * 0.32,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(SizeConfig.roundness12),
              child: BlurFilter(
                  sigmaX: 6,
                  sigmaY: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.24),
                    ),
                  )),
            ),
            Container(
              child: Column(children: [
                Expanded(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: SizeConfig.padding16),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => _baseUtil.openProfileDetailsScreen(),
                          child:
                              ProfileImageSE(radius: SizeConfig.avatarRadius),
                        ),
                        SizedBox(width: SizeConfig.padding12),
                        Expanded(
                          child: PropertyChangeConsumer<UserService,
                              UserServiceProperties>(
                            properties: [
                              UserServiceProperties.myUserName,
                              UserServiceProperties.myJourneyStats
                            ],
                            builder: (context, model, properties) {
                              return GestureDetector(
                                onTap: () =>
                                    _baseUtil.openProfileDetailsScreen(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FittedBox(
                                      child: Text(
                                        "Hi ${model?.myUserName?.split(" ")?.first ?? ''}",
                                        style: TextStyles.rajdhaniSB.title5
                                            .colour(Colors.white),
                                      ),
                                    ),
                                    Text(
                                      "Level ${model.userJourneyStats?.level}",
                                      style: TextStyles.sourceSansM.body3
                                          .colour(Colors.white.withOpacity(0.8))
                                          .setHeight(0.8),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
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
                Expanded(
                  child: Row(
                    children: [
                      JourneyAppBarAssetDetailsTile(
                        asset: Assets.digitalGoldBar,
                        value: UserGoldQuantitySE(
                          style: TextStyles.sourceSansSB.body1
                              .colour(Colors.white),
                        ),
                      ),
                      VerticalDivider(
                        color: Colors.white.withOpacity(0.5),
                        thickness: 0.5,
                      ),
                      JourneyAppBarAssetDetailsTile(
                        asset: Assets.stableFello,
                        value: Text(
                          "₹ 3000",
                          style: TextStyles.sourceSansSB.body1
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
  }
}

class JourneyAppBarAssetDetailsTile extends StatelessWidget {
  final String asset;
  final Widget value;

  JourneyAppBarAssetDetailsTile({@required this.asset, @required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          if (JourneyService.isAvatarAnimationInProgress) return;

          Haptic.vibrate();
          AppState.delegate.appState.currentAction = PageAction(
            state: PageState.addPage,
            page: SaveAssetsViewConfig,
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              asset,
              height: asset == Assets.digitalGoldBar
                  ? SizeConfig.padding38
                  : SizeConfig.padding54,
            ),
            value,
          ],
        ),
      ),
    );
  }
}
