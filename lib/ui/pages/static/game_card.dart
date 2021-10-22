import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/core/model/game_model.dart';
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
      child: Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenWidth * 0.64,
        margin: EdgeInsets.symmetric(
            vertical: SizeConfig.padding8,
            horizontal: SizeConfig.pageHorizontalMargins),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(SizeConfig.roundness56),
        ),
        padding: EdgeInsets.all(SizeConfig.padding8),
        child: Column(
          children: [
            ClipPath(
              clipper: GameThumbnailClipper(),
              child: Container(
                width: SizeConfig.screenWidth,
                height: SizeConfig.screenWidth * 0.4,
                decoration: BoxDecoration(
                  color: UiConstants.tertiarySolid,
                  image: DecorationImage(
                      image:
                          CachedNetworkImageProvider(gameData.thumbnailImage),
                      fit: BoxFit.fitWidth),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: SizeConfig.padding4),
                Text(
                  gameData.gameName,
                  style:
                      TextStyles.title5.bold.colour(UiConstants.primaryColor),
                ),
                SizedBox(height: SizeConfig.padding4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      icon: CircleAvatar(
                        radius: SizeConfig.screenWidth * 0.029,
                        backgroundColor:
                            UiConstants.tertiarySolid.withOpacity(0.2),
                        child: RotatedBox(
                          quarterTurns: 1,
                          child: SvgPicture.asset(
                            "assets/vectors/icons/tickets.svg",
                            height: SizeConfig.iconSize3,
                          ),
                        ),
                      ),
                      label: Text("10 tokens",
                          style: TextStyles.body3.colour(Colors.black54)),
                      onPressed: () {},
                    ),
                    SizedBox(width: 16),
                    TextButton.icon(
                        icon: CircleAvatar(
                          radius: SizeConfig.screenWidth * 0.029,
                          backgroundColor: UiConstants.primaryLight,
                          child: Image.asset(
                            "assets/images/icons/money.png",
                            height: SizeConfig.iconSize3,
                          ),
                        ),
                        label: Text("Rs 5K",
                            style: TextStyles.body3.colour(Colors.black54)),
                        onPressed: () {}),
                  ],
                ),
              ],
            )
          ],
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
