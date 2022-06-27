import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/core/model/game_model.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'dart:math' as math;

class GameCard extends StatelessWidget {
  final GameModel gameData;
  final int index;
  GameCard({this.gameData, this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: index == 0 ? SizeConfig.pageHorizontalMargins : 0,
        right: SizeConfig.padding16,
      ),
      child: Column(
        children: [
          Container(
            height: SizeConfig.screenWidth * 0.4,
            width: SizeConfig.screenWidth * 0.4,
            // margin: EdgeInsets.only(bottom: SizeConfig.padding16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                  SizeConfig.roundness24 + SizeConfig.padding4),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    offset: Offset(0, 0),
                    spreadRadius: SizeConfig.padding2,
                    blurRadius: SizeConfig.padding2)
              ],
            ),
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.padding4, vertical: SizeConfig.padding4),
            child: Container(
              decoration: BoxDecoration(
                color: UiConstants.primaryColor,
                borderRadius: BorderRadius.circular(SizeConfig.roundness24),
                image: DecorationImage(
                    image: gameData.thumbnailUri.split('.').last == "jpg"
                        ? AssetImage(gameData.thumbnailUri)
                        : CachedNetworkImageProvider(gameData.thumbnailUri),
                    fit: BoxFit.cover),
              ),
            ),
          ),
          Container(
              height: SizeConfig.screenWidth * 0.2,
              width: SizeConfig.screenWidth * 0.4,
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.padding12,
                    horizontal: SizeConfig.padding16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Text("Win: ₹ ${gameData.prizeAmount ?? 0}   ",
                            style: TextStyles.body1.bold),
                        CircleAvatar(
                          radius: SizeConfig.screenWidth * 0.029,
                          backgroundColor:
                              UiConstants.primaryColor.withOpacity(0.2),
                          child: Image.asset(
                            Assets.moneyIcon,
                            height: SizeConfig.iconSize3,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Entry: ${gameData.playCost ?? 0}   ",
                            style: TextStyles.body3
                                .colour(Colors.black.withOpacity(0.5))),
                        CircleAvatar(
                          radius: SizeConfig.screenWidth * 0.02,
                          backgroundColor:
                              UiConstants.tertiarySolid.withOpacity(0.2),
                          child: SvgPicture.asset(
                            Assets.tokens,
                            height: SizeConfig.iconSize4,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}

class NoRecordDisplayWidget extends StatelessWidget {
  final String asset;
  final String assetSvg;
  final String assetLottie;
  final String text;
  final bool topPadding;
  final bool bottomPadding;

  NoRecordDisplayWidget({
    this.asset,
    this.text,
    this.assetSvg,
    this.assetLottie,
    this.topPadding = true,
    this.bottomPadding = false,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (topPadding) SizedBox(height: SizeConfig.screenHeight * 0.1),
        if (asset != null)
          Image.asset(
            asset,
            height: SizeConfig.screenHeight * 0.16,
          ),
        if (assetSvg != null)
          SvgPicture.asset(
            assetSvg,
            height: SizeConfig.screenHeight * 0.16,
          ),
        if (assetLottie != null)
          Lottie.asset(
            assetLottie,
            repeat: false,
            height: SizeConfig.screenHeight * 0.26,
          ),
        SizedBox(
          height: SizeConfig.padding16,
        ),
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyles.body2.bold,
        ),
        if (bottomPadding) SizedBox(height: SizeConfig.padding16),
      ],
    );
  }
}
