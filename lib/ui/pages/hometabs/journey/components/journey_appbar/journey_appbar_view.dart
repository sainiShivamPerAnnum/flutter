import 'package:felloapp/base_util.dart';
import 'package:felloapp/ui/pages/hometabs/journey/journey_view.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/service_elements/user_service/profile_image.dart';
import 'package:felloapp/ui/service_elements/user_service/user_gold_quantity.dart';
import 'package:felloapp/ui/widgets/coin_bar/coin_bar_view.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class JourneyAppBar extends StatelessWidget {
  const JourneyAppBar({Key key}) : super(key: key);

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
                        ProfileImageSE(radius: SizeConfig.avatarRadius * 1.1),
                        SizedBox(width: SizeConfig.padding12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Hi Madmaen",
                                style: TextStyles.rajdhaniSB.title5
                                    .colour(Colors.white),
                              ),
                              Text(
                                "Level 1",
                                style: TextStyles.sourceSansM.body3
                                    .colour(Colors.white.withOpacity(0.8))
                                    .setHeight(0.8),
                              ),
                            ],
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
                        asset: Assets.digitalGoldBar,
                        value: UserGoldQuantitySE(
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
          BaseUtil.showPositiveAlert(
              "You tapped on gold balance", "You should go to save view now");
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              asset,
              height: SizeConfig.padding54,
            ),
            value,
          ],
        ),
      ),
    );
  }
}
