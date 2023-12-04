import 'package:felloapp/core/model/referral_details_model.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class RewardTrack extends StatelessWidget {
  const RewardTrack({required this.revampedInfo, super.key});

  final RevampedInfo revampedInfo;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.padding72,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.only(
                left: SizeConfig.padding38,
                // right: SizeConfig.padding50,
                bottom: SizeConfig.padding6,
              ),
              height: 1.2,
              width: revampedInfo.stages!.length > 2
                  ? SizeConfig.padding82
                  : SizeConfig.screenWidth! * 0.56,
              color: const Color(0xFF61E3C4),
            ),
          ),
          if (revampedInfo.stages!.length > 2)
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.only(
                  // right: SizeConfig.padding40,
                  bottom: SizeConfig.padding6,
                  left: SizeConfig.padding90,
                ),
                height: 1.2,
                width: SizeConfig.screenWidth! * 0.258,
                color: (revampedInfo.stages![1].isComplete ?? false)
                    ? const Color(0xFF61E3C4)
                    : const Color(0xFF868686),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RewardInfoBlock(
                title: revampedInfo.stages![0].title!,
                isComplete: revampedInfo.stages![0].isComplete ?? false,
                tooltipContent: revampedInfo.stages![0].tooltipContent,
              ),
              // SizedBox(
              //   width: SizeConfig.padding52,
              // ),

              RewardInfoBlock(
                  title: revampedInfo.stages![1].title!,
                  isComplete: revampedInfo.stages![1].isComplete ?? false,
                  tooltipContent: revampedInfo.stages![1].tooltipContent),

              if (revampedInfo.stages!.length > 2)
                RewardInfoBlock(
                  title: revampedInfo.stages![2].title!,
                  isComplete: revampedInfo.stages![2].isComplete ?? false,
                  tooltipContent: revampedInfo.stages![2].tooltipContent,
                  isPreviousTaskCompleted:
                      revampedInfo.stages![1].isComplete ?? false,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class RewardInfoBlock extends StatelessWidget {
  const RewardInfoBlock(
      {required this.title,
      required this.isComplete,
      super.key,
      this.tooltipContent,
      this.isPreviousTaskCompleted = true});

  final String title;
  final bool isComplete;
  final String? tooltipContent;
  final bool isPreviousTaskCompleted;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            width: SizeConfig.padding32,
            height: (tooltipContent?.isNotEmpty ?? false)
                ? null
                : SizeConfig.padding25,
            child: (tooltipContent?.isNotEmpty ?? false)
                ? Stack(
                    children: [
                      CustomPaint(
                        size: Size(SizeConfig.padding34,
                            (SizeConfig.padding34 * 0.7).toDouble()),
                        painter: ToolTipCustomPainter(isComplete
                            ? const Color(0xff62E3C4).withOpacity(1.0)
                            : const Color(0xffB9B9B9)),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          tooltipContent ?? '',
                          style: TextStyles.sourceSans.body4.colour(isComplete
                              ? const Color(0xFF00E6C3)
                              : const Color(0xFFB8B8B8)),
                        ),
                      ),
                    ],
                  )
                : const SizedBox()),
        Container(
          width: SizeConfig.padding16,
          height: SizeConfig.padding16,
          decoration: BoxDecoration(
              color: isComplete ? const Color(0xFF61E3C4) : null,
              shape: BoxShape.circle,
              border: Border.all(
                  width: 0.50,
                  color: isPreviousTaskCompleted
                      ? const Color(0xFF61E3C4)
                      : const Color(0xFF868686).withOpacity(0.8))),
          child: isComplete
              ? Icon(
                  Icons.check,
                  color: Colors.black,
                  size: SizeConfig.padding14,
                  weight: 700,
                  grade: 200,
                  opticalSize: 48,
                )
              : null,
        ),
        SizedBox(
          height: SizeConfig.padding6,
        ),
        Text(
          title,
          style: TextStyles.sourceSans.body4.colour(Colors.white),
        ),
      ],
    );
  }
}

class ToolTipCustomPainter extends CustomPainter {
  final Color color;

  ToolTipCustomPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.004032258, size.height * 0.09106542);
    path_0.cubicTo(
        size.width * 0.004032258,
        size.height * 0.04364792,
        size.width * 0.03379194,
        size.height * 0.005208333,
        size.width * 0.07050226,
        size.height * 0.005208333);
    path_0.lineTo(size.width * 0.9294968, size.height * 0.005208333);
    path_0.cubicTo(
        size.width * 0.9662065,
        size.height * 0.005208333,
        size.width * 0.9959677,
        size.height * 0.04364792,
        size.width * 0.9959677,
        size.height * 0.09106542);
    path_0.lineTo(size.width * 0.9959677, size.height * 0.5828458);
    path_0.cubicTo(
        size.width * 0.9959677,
        size.height * 0.6302667,
        size.width * 0.9662097,
        size.height * 0.6687042,
        size.width * 0.9294968,
        size.height * 0.6687042);
    path_0.lineTo(size.width * 0.7140290, size.height * 0.6687042);
    path_0.cubicTo(
        size.width * 0.6904452,
        size.height * 0.6687042,
        size.width * 0.6682548,
        size.height * 0.6831208,
        size.width * 0.6541935,
        size.height * 0.7075750);
    path_0.lineTo(size.width * 0.5116258, size.height * 0.9555167);
    path_0.cubicTo(
        size.width * 0.5016774,
        size.height * 0.9728208,
        size.width * 0.4814677,
        size.height * 0.9722042,
        size.width * 0.4721645,
        size.height * 0.9543167);
    path_0.lineTo(size.width * 0.3457258, size.height * 0.7112833);
    path_0.cubicTo(
        size.width * 0.3318806,
        size.height * 0.6846667,
        size.width * 0.3086871,
        size.height * 0.6687042,
        size.width * 0.2838629,
        size.height * 0.6687042);
    path_0.lineTo(size.width * 0.07050226, size.height * 0.6687042);
    path_0.cubicTo(
        size.width * 0.03379194,
        size.height * 0.6687042,
        size.width * 0.004032258,
        size.height * 0.6302667,
        size.width * 0.004032258,
        size.height * 0.5828458);
    path_0.lineTo(size.width * 0.004032258, size.height * 0.09106542);
    path_0.close();

    Paint paint0Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.013096774;
    paint0Stroke.color = color;
    canvas.drawPath(path_0, paint0Stroke);

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = const Color(0xff000000).withOpacity(1.0);
    canvas.drawPath(path_0, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
