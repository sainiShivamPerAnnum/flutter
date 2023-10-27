// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class GoldProChoiceChipsModel {
  final double value;
  final bool isBest;
  bool isSelected;

  GoldProChoiceChipsModel({
    required this.value,
    required this.isBest,
    required this.isSelected,
  });
}

class GoldProChoiceChip extends StatelessWidget {
  const GoldProChoiceChip({
    required this.isSelected,
    required this.onTap,
    required this.chipValue,
    required this.isBest,
    required this.index,
    super.key,
  });

  final bool isSelected;
  final Function onTap;
  final String chipValue;
  final bool isBest;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        // margin: index == 1
        //     ? EdgeInsets.only(right: SizeConfig.padding14)
        //     : index == 2 || index == 3
        //         ? EdgeInsets.only(
        //             right: SizeConfig.padding10,
        //           )
        //         : EdgeInsets.zero,
        width: SizeConfig.padding54,
        child: Column(
          children: [
            if (isBest)
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.padding2,
                    horizontal: SizeConfig.padding8),
                decoration: BoxDecoration(
                    color: isSelected
                        ? UiConstants.kGoldProPrimary
                        : UiConstants.primaryColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(SizeConfig.roundness5),
                        topRight: Radius.circular(SizeConfig.roundness5))),
                child: Text(
                  "Best",
                  style: TextStyles.sourceSansSB.body4.colour(Colors.black),
                ),
              ),
            SizedBox(
              height: (SizeConfig.padding54 * 0.8214285714285714).toDouble(),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: CustomPaint(
                      size: Size(
                          SizeConfig.padding54,
                          (SizeConfig.padding54 * 0.8214285714285714)
                              .toDouble()),
                      painter: OutlinedTooltipBorder(
                        width: isSelected ? 1.5 : 1,
                        color: isSelected
                            ? UiConstants.kGoldProPrimary
                            : UiConstants.kGoldProBorder,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: SizeConfig.padding14),
                      child: Text(
                        chipValue,
                        style: TextStyles.sourceSansM.body3.colour(isSelected
                            ? UiConstants.kGoldProPrimary
                            : Colors.white),
                      ),
                    ),
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

class OutlinedTooltipBorder extends CustomPainter {
  final Color color;
  final double width;

  OutlinedTooltipBorder({
    required this.color,
    required this.width,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.08928571, size.height * 0.01948878);
    path_0.lineTo(size.width * 0.9107143, size.height * 0.01948878);
    path_0.cubicTo(
        size.width * 0.9575607,
        size.height * 0.01948878,
        size.width * 0.9955357,
        size.height * 0.06572022,
        size.width * 0.9955357,
        size.height * 0.1227496);
    path_0.lineTo(size.width * 0.9955357, size.height * 0.5792717);
    path_0.cubicTo(
        size.width * 0.9955357,
        size.height * 0.6363000,
        size.width * 0.9575607,
        size.height * 0.6825326,
        size.width * 0.9107143,
        size.height * 0.6825326);
    path_0.lineTo(size.width * 0.7250589, size.height * 0.6825326);
    path_0.cubicTo(
        size.width * 0.6944661,
        size.height * 0.6825326,
        size.width * 0.6657982,
        size.height * 0.7007022,
        size.width * 0.6482554,
        size.height * 0.7312130);
    path_0.lineTo(size.width * 0.5181589, size.height * 0.9574674);
    path_0.cubicTo(
        size.width * 0.5053661,
        size.height * 0.9797174,
        size.width * 0.4780946,
        size.height * 0.9789500,
        size.width * 0.4661571,
        size.height * 0.9560065);
    path_0.lineTo(size.width * 0.3514911, size.height * 0.7355978);
    path_0.cubicTo(
        size.width * 0.3343036,
        size.height * 0.7025565,
        size.width * 0.3044143,
        size.height * 0.6825326,
        size.width * 0.2722893,
        size.height * 0.6825326);
    path_0.lineTo(size.width * 0.08928571, size.height * 0.6825326);
    path_0.cubicTo(
        size.width * 0.04244018,
        size.height * 0.6825326,
        size.width * 0.004464286,
        size.height * 0.6363000,
        size.width * 0.004464286,
        size.height * 0.5792717);
    path_0.lineTo(size.width * 0.004464286, size.height * 0.1227498);
    path_0.cubicTo(
        size.width * 0.004464286,
        size.height * 0.06572022,
        size.width * 0.04244018,
        size.height * 0.01948878,
        size.width * 0.08928571,
        size.height * 0.01948878);
    path_0.close();

    Paint paint0Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    paint0Stroke.color = color;
    canvas.drawPath(path_0, paint0Stroke);

    // Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    // paint_0_fill.color = Color(0xff000000).withOpacity(1.0);
    // canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
