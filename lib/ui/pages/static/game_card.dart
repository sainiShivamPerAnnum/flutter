import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/core/model/game_model.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GameCard extends StatelessWidget {
  final GameModel gameData;
  GameCard({this.gameData});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: gameData.tag,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: SizeConfig.screenWidth,
          margin: EdgeInsets.only(
              right: SizeConfig.pageHorizontalMargins,
              left: SizeConfig.pageHorizontalMargins,
              bottom: SizeConfig.padding16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
                SizeConfig.roundness40 + SizeConfig.padding8),
          ),
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.padding8, vertical: SizeConfig.padding6),
          child: Column(
            children: [
              ClipPath(
                clipper: GameThumbnailClipper(),
                child: Container(
                  width: SizeConfig.screenWidth,
                  height: SizeConfig.screenHeight * 0.16,
                  decoration: BoxDecoration(
                    color: UiConstants.primaryColor,
                    image: DecorationImage(
                        image: AssetImage(gameData.thumbnailImage),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // SizedBox(height: SizeConfig.padding4),
                  Text(
                    gameData.gameName,
                    style:
                        TextStyles.title5.bold.colour(UiConstants.primaryColor),
                  ),
                  Padding(
                    padding: EdgeInsets.all(SizeConfig.screenHeight * 0.01),
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text("Entry: ${gameData.playCost ?? 0}   ",
                                    style: TextStyles.body3),
                                CircleAvatar(
                                  radius: SizeConfig.screenWidth * 0.029,
                                  backgroundColor: UiConstants.tertiarySolid
                                      .withOpacity(0.2),
                                  child: SvgPicture.asset(
                                    Assets.tokens,
                                    height: SizeConfig.iconSize3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: SizeConfig.screenWidth * 0.05,
                        ),
                        Expanded(
                            child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Win: ₹ ${gameData.prizeAmount ?? 0}   ",
                                  style: TextStyles.body3),
                              CircleAvatar(
                                radius: SizeConfig.screenWidth * 0.029,
                                backgroundColor:
                                    UiConstants.primaryColor.withOpacity(0.2),
                                child: RotatedBox(
                                  quarterTurns: 1,
                                  child: Image.asset(
                                    Assets.moneyIcon,
                                    height: SizeConfig.iconSize3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ))
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class GameThumbnailClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path_0 = Path();
    path_0.moveTo(0, size.height * 0.4648722);
    path_0.cubicTo(0, size.height * 0.3256462, 0, size.height * 0.2560332,
        size.width * 0.009685714, size.height * 0.2010006);
    path_0.arcToPoint(Offset(size.width * 0.09114286, size.height * 0.02136025),
        radius:
            Radius.elliptical(size.width * 0.1428571, size.height * 0.3150480),
        rotation: 0,
        largeArc: false,
        clockwise: true);
    path_0.cubicTo(size.width * 0.1160971, 0, size.width * 0.1474714, 0,
        size.width * 0.2102171, 0);
    path_0.lineTo(size.width * 0.7897800, 0);
    path_0.cubicTo(size.width * 0.8525286, 0, size.width * 0.8839029, 0,
        size.width * 0.9088486, size.height * 0.02136025);
    path_0.arcToPoint(Offset(size.width * 0.9903143, size.height * 0.2010006),
        radius:
            Radius.elliptical(size.width * 0.1428571, size.height * 0.3150480),
        rotation: 0,
        largeArc: false,
        clockwise: true);
    path_0.cubicTo(size.width, size.height * 0.2560332, size.width,
        size.height * 0.3256462, size.width, size.height * 0.4648722);
    path_0.cubicTo(
        size.width,
        size.height * 0.6350422,
        size.width,
        size.height * 0.7201303,
        size.width * 0.9879086,
        size.height * 0.7847718);
    path_0.arcToPoint(Offset(size.width * 0.8837143, size.height * 0.9896349),
        radius:
            Radius.elliptical(size.width * 0.1600000, size.height * 0.3528537),
        rotation: 0,
        largeArc: false,
        clockwise: true);
    path_0.cubicTo(
        size.width * 0.8532171,
        size.height * 1.008739,
        size.width * 0.8151257,
        size.height * 0.9990864,
        size.width * 0.7389400,
        size.height * 0.9797676);
    path_0.cubicTo(
        size.width * 0.6632771,
        size.height * 0.9605812,
        size.width * 0.6254457,
        size.height * 0.9509848,
        size.width * 0.5875429,
        size.height * 0.9458559);
    path_0.arcToPoint(Offset(size.width * 0.4124457, size.height * 0.9458559),
        radius:
            Radius.elliptical(size.width * 1.428663, size.height * 3.150681),
        rotation: 0,
        largeArc: false,
        clockwise: false);
    path_0.cubicTo(
        size.width * 0.3745429,
        size.height * 0.9509848,
        size.width * 0.3367114,
        size.height * 0.9605812,
        size.width * 0.2610457,
        size.height * 0.9797676);
    path_0.cubicTo(
        size.width * 0.1848629,
        size.height * 0.9990801,
        size.width * 0.1467600,
        size.height * 1.008752,
        size.width * 0.1162714,
        size.height * 0.9896349);
    path_0.arcToPoint(Offset(size.width * 0.01209143, size.height * 0.7847718),
        radius:
            Radius.elliptical(size.width * 0.1600000, size.height * 0.3528537),
        rotation: 0,
        largeArc: false,
        clockwise: true);
    path_0.cubicTo(0, size.height * 0.7201303, 0, size.height * 0.6350422, 0,
        size.height * 0.4648722);
    path_0.close();
    return path_0;
    // Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    // paint_0_fill.color = UiConstants.tertiarySolid.withOpacity(1.0);
    // canvas.drawPath(path_0, paint_0_fill);
    // canvas.drawImage(image, Offset.zero, Paint());
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}
