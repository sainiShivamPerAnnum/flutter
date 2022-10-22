import 'package:felloapp/ui/pages/others/events/topSavers/top_saver_vm.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CampaignPrizeWidget extends StatelessWidget {
  final TopSaverViewModel model;
  CampaignPrizeWidget({this.model});
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.pageHorizontalMargins * 1.2),
        decoration: BoxDecoration(
          gradient: UiConstants.kCampaignBannerBackgrondGradient,
        ),
        height: SizeConfig.bannerHeight,
        width: SizeConfig.screenWidth,
        child: Row(
          children: [
            Expanded(
              child: Container(
                // height: SizeConfig.bannerHeight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "WIN",
                      style:
                          TextStyles.rajdhaniSB.body0.bold.colour(Colors.white),
                    ),
                    Text(
                      "₹ ${model?.event?.maxWin ?? 250}",
                      style: TextStyles.rajdhaniB.title0.bold
                          .colour(UiConstants.kWinnerPlayerPrimaryColor),
                    ),
                    Text(
                      "Win grand rewards\nas digital gold.",
                      style: TextStyles.body3.colour(Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: SizeConfig.screenWidth * 0.3,
              height: SizeConfig.bannerHeight,
              decoration: BoxDecoration(),
              child: Stack(
                children: [
                  Positioned(
                    bottom: SizeConfig.bannerHeight * 0.15,
                    child: Container(
                      width: SizeConfig.screenWidth * 0.3,
                      height: (SizeConfig.bannerHeight) / 3.9,
                      decoration: BoxDecoration(
                          gradient: UiConstants.kTrophyBackground,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0))),
                    ),
                  ),
                  SvgPicture.asset(
                    "assets/svg/trophy_banner.svg",
                    width: double.maxFinite,
                    fit: BoxFit.fitWidth,
                    height: double.maxFinite,
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
