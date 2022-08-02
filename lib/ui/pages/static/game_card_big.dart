import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/core/model/game_model.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class BigGameCard extends StatelessWidget {
  final GameModel gameData;
  final bool isGameLoading;
  BigGameCard({this.gameData, this.isGameLoading});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Shimmer(
        enabled: isGameLoading ?? false,
        child: Container(
          width: SizeConfig.screenWidth,
          height: SizeConfig.screenWidth * 0.38,
          margin: EdgeInsets.only(
              right: SizeConfig.pageHorizontalMargins,
              left: SizeConfig.pageHorizontalMargins,
              bottom: SizeConfig.padding16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
                SizeConfig.roundness32 + SizeConfig.padding6),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  offset: Offset(0, 0),
                  spreadRadius: SizeConfig.padding4,
                  blurRadius: SizeConfig.padding6)
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding8),
          child: gameData == null
              ? Container()
              : Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: SizeConfig.screenWidth -
                            SizeConfig.pageHorizontalMargins * 2 -
                            SizeConfig.padding16,
                        height: SizeConfig.screenWidth * 0.35,
                        decoration: BoxDecoration(
                          color: UiConstants.primaryColor,
                          borderRadius:
                              BorderRadius.circular(SizeConfig.roundness32),
                          image: DecorationImage(
                              image:
                                  gameData.thumbnailUri.split('.').last == "jpg"
                                      ? AssetImage(gameData.thumbnailUri)
                                      : CachedNetworkImageProvider(
                                          gameData.thumbnailUri),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 0),
                        padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.padding12,
                            horizontal: SizeConfig.padding16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: UiConstants.textColor.withOpacity(0.2),
                                offset: Offset(0, -16),
                                spreadRadius: 5,
                                blurRadius: 6),
                          ],
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(SizeConfig.roundness24),
                              topRight:
                                  Radius.circular(SizeConfig.roundness24)),
                        ),
                        child: Wrap(
                          //mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text("Entry: ${gameData.playCost ?? 0}   ",
                                style: TextStyles.body3),
                            CircleAvatar(
                              radius: SizeConfig.screenWidth * 0.029,
                              backgroundColor:
                                  UiConstants.tertiarySolid.withOpacity(0.2),
                              child: SvgPicture.asset(
                                Assets.tokens,
                                height: SizeConfig.iconSize3,
                              ),
                            ),
                            SizedBox(
                              width: SizeConfig.screenWidth * 0.05,
                            ),
                            Text("Win: ₹ ${gameData.prizeAmount ?? 0}   ",
                                style: TextStyles.body3),
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
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
