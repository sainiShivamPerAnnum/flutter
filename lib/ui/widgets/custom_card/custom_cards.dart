import 'dart:ui' as ui;

import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SaveCustomCard extends StatelessWidget {
  final String title;
  final Color cardBgColor;
  final String cardAssetName;
  final Function() onTap;

  const SaveCustomCard(
      {Key key, this.title, this.cardBgColor, this.cardAssetName, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    S locale = S();
    return Container(
      height: SizeConfig.screenHeight * 0.215,
      width: SizeConfig.screenWidth,
      child: Stack(
        fit: StackFit.loose,
        children: [
          CustomPaint(
            size: Size(SizeConfig.screenWidth, SizeConfig.cardHeight),
            painter: CustomSaveCardPainter(cardBgColor),
          ),
          Container(
            height: SizeConfig.cardHeight,
            width: SizeConfig.screenWidth,
            decoration: BoxDecoration(color: Colors.transparent),
            child: Padding(
              padding: EdgeInsets.only(bottom: SizeConfig.padding32),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SvgPicture.asset(cardAssetName,
                      allowDrawingOutsideViewBox: true),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: SizeConfig.padding28,
                          bottom: SizeConfig.padding24,
                          right: SizeConfig.padding28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                title,
                                style: TextStyles.rajdhaniSB.title5,
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.white,
                                size: SizeConfig.padding16,
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    locale.investedText,
                                    style: TextStyles.sourceSansM.body4,
                                  ),
                                  //TODO make amount dynamic
                                  Text(
                                    '\u20b9 2094',
                                    style: TextStyles.sourceSansSB.title4,
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: onTap,
                                child: Container(
                                  height: SizeConfig.screenHeight * 0.05,
                                  width: SizeConfig.screenWidth * 0.2,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.white,
                                          style: BorderStyle.solid),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Center(
                                    child: Text(
                                      'SAVE',
                                      style: TextStyles.rajdhaniB.body1,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomSaveCardPainter extends CustomPainter {
  final Color containerColor;

  CustomSaveCardPainter(this.containerColor);

  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.1831709, size.height * 0.1024792);
    path_0.cubicTo(
        size.width * 0.1923139,
        size.height * 0.06398266,
        size.width * 0.2106144,
        size.height * 0.03978786,
        size.width * 0.2305893,
        size.height * 0.03978792);
    path_0.lineTo(size.width * 0.9370587, size.height * 0.03978879);
    path_0.cubicTo(
        size.width * 0.9562027,
        size.height * 0.03978884,
        size.width * 0.9717253,
        size.height * 0.07343237,
        size.width * 0.9717253,
        size.height * 0.1149335);
    path_0.lineTo(size.width * 0.9717253, size.height * 0.7267225);
    path_0.cubicTo(
        size.width * 0.9717253,
        size.height * 0.7682254,
        size.width * 0.9562027,
        size.height * 0.8018671,
        size.width * 0.9370587,
        size.height * 0.8018671);
    path_0.lineTo(size.width * 0.05641440, size.height * 0.8018671);
    path_0.cubicTo(
        size.width * 0.03844960,
        size.height * 0.8018671,
        size.width * 0.02685307,
        size.height * 0.7606532,
        size.width * 0.03507600,
        size.height * 0.7260289);
    path_0.lineTo(size.width * 0.1831709, size.height * 0.1024792);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = containerColor;
    canvas.drawPath(path_0, paint0Fill);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.1843563, size.height * 0.1038017);
    path_1.cubicTo(
        size.width * 0.1932707,
        size.height * 0.06626763,
        size.width * 0.2111139,
        size.height * 0.04267803,
        size.width * 0.2305893,
        size.height * 0.04267809);
    path_1.lineTo(size.width * 0.9370587, size.height * 0.04267896);
    path_1.cubicTo(
        size.width * 0.9554667,
        size.height * 0.04267902,
        size.width * 0.9703920,
        size.height * 0.07502832,
        size.width * 0.9703920,
        size.height * 0.1149335);
    path_1.lineTo(size.width * 0.9703920, size.height * 0.7267225);
    path_1.cubicTo(
        size.width * 0.9703920,
        size.height * 0.7666243,
        size.width * 0.9554667,
        size.height * 0.7989769,
        size.width * 0.9370587,
        size.height * 0.7989769);
    path_1.lineTo(size.width * 0.05641440, size.height * 0.7989769);
    path_1.cubicTo(
        size.width * 0.03944747,
        size.height * 0.7989769,
        size.width * 0.02849547,
        size.height * 0.7600520,
        size.width * 0.03626160,
        size.height * 0.7273526);
    path_1.lineTo(size.width * 0.1843563, size.height * 0.1038017);
    path_1.close();

    Paint paint1Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint1Stroke.shader = ui.Gradient.linear(
        Offset(size.width * 0.7778000, size.height * -19.80607),
        Offset(size.width * 0.3263520, size.height * 1.019052),
        [Color(0xffFFF9F9).withOpacity(1), Color(0xffFFF9F9).withOpacity(0)],
        [0, 1]);
    canvas.drawPath(path_1, paint1Stroke);

    Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.color = containerColor;
    canvas.drawPath(path_1, paint1Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
