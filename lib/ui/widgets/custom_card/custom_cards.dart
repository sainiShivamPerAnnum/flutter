import 'dart:ui' as ui;

import 'package:felloapp/ui/service_elements/user_service/user_gold_quantity.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class SaveCustomCard extends StatelessWidget {
  final String title;
  final Function() onCardTap;
  final Color cardBgColor;
  final String cardAssetName;
  final Function() onTap;
  final double investedAmount;
  final bool isGoldAssets;

  const SaveCustomCard(
      {Key key,
      this.title,
      this.cardBgColor,
      this.cardAssetName,
      this.onTap,
      this.investedAmount = 0,
      this.onCardTap,
      this.isGoldAssets = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    S locale = S();
    return Padding(
      padding: EdgeInsets.only(
        right: SizeConfig.padding16,
        top: SizeConfig.padding20,
        bottom: SizeConfig.padding20,
      ),
      child: GestureDetector(
        onTap: onCardTap,
        child: Container(
          height: SizeConfig.screenWidth * 0.351,
          width: SizeConfig.screenWidth,
          child: Stack(
            fit: StackFit.loose,
            children: [
              Padding(
                padding: EdgeInsets.only(left: SizeConfig.padding16),
                child: CustomPaint(
                  size: Size(
                    SizeConfig.screenWidth,
                    SizeConfig.screenWidth * 0.351,
                  ),
                  painter: CustomSaveCardPainter(cardBgColor),
                ),
              ),
              Container(
                height: SizeConfig.screenWidth * 0.351,
                width: SizeConfig.screenWidth,
                decoration: BoxDecoration(color: Colors.transparent),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Image.asset(
                      cardAssetName,
                      height: SizeConfig.screenWidth * 0.28,
                      width: SizeConfig.screenWidth * 0.28,
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: SizeConfig.padding20,
                            bottom: SizeConfig.padding16,
                            right: SizeConfig.padding20),
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
                                      "Balance",
                                      style: TextStyles.sourceSansM.body4,
                                    ),
                                    isGoldAssets
                                        ? UserGoldQuantitySE(
                                            style:
                                                TextStyles.sourceSansSB.title4,
                                          )
                                        : Text(
                                            investedAmount.toString() ??
                                                0.toString(),
                                            style:
                                                TextStyles.sourceSansSB.title4,
                                          ),
                                  ],
                                ),
                                title == "Fello Flo"
                                    ? Icon(Icons.lock,
                                        size: SizeConfig.padding34,
                                        color: Colors.black.withOpacity(0.5))
                                    : CustomSaveButton(
                                        onTap: onTap,
                                        title: 'Save',
                                        isFullScreen: false,
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
            ],
          ),
        ),
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
    path_0.moveTo(size.width * 0.1605924, size.height * 0.08818722);
    path_0.cubicTo(
        size.width * 0.1703051,
        size.height * 0.03811271,
        size.width * 0.1897462,
        size.height * 0.006641383,
        size.width * 0.2109660,
        size.height * 0.006641414);
    path_0.lineTo(size.width * 0.9614646, size.height * 0.006642571);
    path_0.cubicTo(
        size.width * 0.9818017,
        size.height * 0.006642602,
        size.width * 0.9982918,
        size.height * 0.05040421,
        size.width * 0.9982918,
        size.height * 0.1043872);
    path_0.lineTo(size.width * 0.9982918, size.height * 0.9001729);
    path_0.cubicTo(
        size.width * 0.9982918,
        size.height * 0.9541579,
        size.width * 0.9818017,
        size.height * 0.9979173,
        size.width * 0.9614646,
        size.height * 0.9979173);
    path_0.lineTo(size.width * 0.02593598, size.height * 0.9979173);
    path_0.cubicTo(
        size.width * 0.006851416,
        size.height * 0.9979173,
        size.width * -0.005467592,
        size.height * 0.9443083,
        size.width * 0.003267819,
        size.height * 0.8992707);
    path_0.lineTo(size.width * 0.1605924, size.height * 0.08818722);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = containerColor;
    canvas.drawPath(path_0, paint0Fill);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.2109660, size.height * 0.01040083);
    path_1.lineTo(size.width * 0.9614646, size.height * 0.01040195);
    path_1.cubicTo(
        size.width * 0.9810198,
        size.height * 0.01040203,
        size.width * 0.9968754,
        size.height * 0.05248053,
        size.width * 0.9968754,
        size.height * 0.1043872);
    path_1.lineTo(size.width * 0.9968754, size.height * 0.9001729);
    path_1.cubicTo(
        size.width * 0.9968754,
        size.height * 0.9520752,
        size.width * 0.9810198,
        size.height * 0.9941579,
        size.width * 0.9614646,
        size.height * 0.9941579);
    path_1.lineTo(size.width * 0.02593598, size.height * 0.9941579);
    path_1.cubicTo(
        size.width * 0.007911671,
        size.height * 0.9941579,
        size.width * -0.003722946,
        size.height * 0.9435263,
        size.width * 0.004527167,
        size.height * 0.9009925);
    path_1.lineTo(size.width * 0.1618516, size.height * 0.08990752);
    path_1.cubicTo(
        size.width * 0.1713215,
        size.height * 0.04108534,
        size.width * 0.1902768,
        size.height * 0.01040075,
        size.width * 0.2109660,
        size.height * 0.01040083);
    path_1.close();

    Paint paint1Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint1Stroke.shader = ui.Gradient.linear(
        Offset(size.width * 0.7922805, size.height * -30.27406),
        Offset(size.width * 0.3126969, size.height * 1.280421),
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

class CustomSaveButton extends StatelessWidget {
  final Function() onTap;
  final String title;
  final bool isFullScreen;
  final double width;

  const CustomSaveButton(
      {Key key, this.onTap, this.title, this.isFullScreen = false, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SizeConfig.roundness5),
        ),
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.padding2),
          child: Container(
            height: SizeConfig.screenWidth * 0.1,
            width: isFullScreen ? width : SizeConfig.screenWidth * 0.2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(SizeConfig.roundness5),
              color: UiConstants.kBackgroundDividerColor.withAlpha(200),
            ),
            child: Center(
              child: Text(
                title,
                style: TextStyles.rajdhaniB.body1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
