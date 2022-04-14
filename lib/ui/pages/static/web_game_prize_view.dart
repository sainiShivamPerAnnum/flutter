import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/prizes_model.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/others/events/topSavers/top_saver_view.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PrizesView extends StatelessWidget {
  final PrizesModel model;
  final ScrollController controller;
  final List<Widget> leading;
  final String subtitle;

  PrizesView({this.model, this.leading, this.controller, this.subtitle});
  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollNotification>(
      onNotification: (OverscrollNotification value) {
        if (value.overscroll < 0 && controller.offset + value.overscroll <= 0) {
          if (controller.offset != 0) controller.jumpTo(0);
          return true;
        }
        if (controller.offset + value.overscroll >=
            controller.position.maxScrollExtent) {
          if (controller.offset != controller.position.maxScrollExtent)
            controller.jumpTo(controller.position.maxScrollExtent);
          return true;
        }
        controller.jumpTo(controller.offset + value.overscroll);
        return true;
      },
      child: ListView.builder(
        itemCount: model.prizesA.length + 1,
        padding: EdgeInsets.only(bottom: SizeConfig.navBarHeight),
        itemBuilder: (ctx, i) {
          if (i == 0)
            return Container(
              margin: EdgeInsets.only(top: SizeConfig.padding8),
              decoration: BoxDecoration(
                color: UiConstants.tertiaryLight,
                // image: DecorationImage(
                //   image: AssetImage("assets/images/confetti.png"),
                //   fit: BoxFit.cover,
                //   colorFilter: new ColorFilter.mode(
                //       UiConstants.tertiaryLight.withOpacity(0.1),
                //       BlendMode.dstATop),
                // ),
                borderRadius: BorderRadius.circular(SizeConfig.roundness16),
              ),
              padding: EdgeInsets.all(SizeConfig.padding16),
              child: Stack(
                children: [
                  //Image.asset("assets/images/confetti.png"),
                  GestureDetector(
                    onTap: () {
                      if (subtitle ==
                          BaseRemoteConfig.remoteConfig.getString(
                              BaseRemoteConfig.GAME_CRICKET_FPL_ANNOUNCEMENT)) {
                        AppState.delegate.appState.setCurrentTabIndex = 1;
                        AppState.backButtonDispatcher.didPopRoute();
                        AppState.delegate.parseRoute(Uri.parse("/FPL"));
                      }
                    },
                    child: Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: TextStyles.body3.light,
                    ),
                  ),
                ],
              ),
            );
          else {
            i--;
            return Container(
              width: SizeConfig.screenWidth,
              padding: EdgeInsets.all(SizeConfig.padding12),
              margin: EdgeInsets.symmetric(vertical: SizeConfig.padding8),
              decoration: BoxDecoration(
                color: UiConstants.primaryLight.withOpacity(0.2),
                borderRadius: BorderRadius.circular(SizeConfig.roundness16),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                      radius: SizeConfig.padding24,
                      backgroundColor:
                          UiConstants.primaryColor.withOpacity(0.3),
                      child: leading[i]),
                  SizedBox(width: SizeConfig.padding12),
                  Expanded(
                    child: Text(
                      model.prizesA[i].displayName ?? "Prize ${i + 1}",
                      style: TextStyles.body3.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PrizeChip(
                        color: UiConstants.tertiarySolid,
                        svg: Assets.tokens,
                        text: "${model.prizesA[i].flc}",
                      ),
                      SizedBox(width: SizeConfig.padding16),
                      PrizeChip(
                        color: UiConstants.primaryColor,
                        png: Assets.moneyIcon,
                        text: "₹ ${model.prizesA[i].amt}",
                      )
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class PrizeChip extends StatelessWidget {
  final String svg, png, text;
  final Color color;
  final double opacity;
  final bool svgPaint;

  PrizeChip(
      {this.color,
      this.png,
      this.svg,
      this.text,
      this.opacity = 0.2,
      this.svgPaint = true});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          CircleAvatar(
            radius: SizeConfig.iconSize3,
            backgroundColor: color.withOpacity(opacity),
            child: svg != null
                ? (svgPaint
                    ? SvgPicture.asset(
                        svg,
                        height: SizeConfig.iconSize3,
                        color: color,
                      )
                    : SvgPicture.asset(
                        svg,
                        height: SizeConfig.iconSize3,
                      ))
                : Image.asset(
                    png,
                    height: SizeConfig.iconSize3,
                  ),
          ),
          SizedBox(width: SizeConfig.padding8),
          Text(text, style: TextStyles.body3)
        ],
      ),
    );
  }
}
