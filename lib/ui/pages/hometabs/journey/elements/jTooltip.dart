import 'package:felloapp/core/enums/journey_service_enum.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/ui/pages/hometabs/journey/elements/jMilestones.dart';
import 'package:felloapp/ui/pages/hometabs/journey/journey_vm.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class MilestoneTooltip extends StatelessWidget {
  final JourneyPageViewModel? model;
  const MilestoneTooltip({Key? key, this.model}) : super(key: key);

  @override
  build(BuildContext context) {
    return PropertyChangeConsumer<JourneyService, JourneyServiceProperties>(
        properties: const [
          JourneyServiceProperties.AvatarPosition,
          JourneyServiceProperties.BaseGlow,
          JourneyServiceProperties.Pages,
        ],
        builder: (context, serviceModel, properties) {
          List<int> levelChangePrev = [6, 10, 15, 20, 22];
          return SizedBox(
            width: model!.pageWidth,
            height: model!.currentFullViewHeight,
            child: Stack(
              children: List.generate(model!.currentMilestoneList.length, (i) {
                if (model!.currentMilestoneList[i].index ==
                        model!.avatarActiveMilestoneLevel &&
                    model!.currentMilestoneList[i].index != 1 &&
                    model!.currentMilestoneList[i].tooltip != null &&
                    model!.currentMilestoneList[i].tooltip!.isNotEmpty) {
                  final milestone = model!.currentMilestoneList[i];
                  bool isMilestoneOnLeft = (model!.pageWidth! * milestone.x!) <
                      model!.pageWidth! * 0.45;
                  return levelChangePrev.contains(milestone.index)
                      ? Positioned(
                          left: model!.pageWidth! *
                              milestone.x! *
                              (isMilestoneOnLeft ? 2 : 0.15),
                          bottom: (model!.pageHeight! * (milestone.page - 1) +
                                  model!.pageHeight! * milestone.y!) +
                              (model!.pageHeight! * milestone.asset.height) *
                                  0.2,
                          child: SafeArea(
                            child: GestureDetector(
                                onTap: () => model!
                                    .showMilestoneDetailsModalSheet(
                                        milestone, context),
                                child: RotatedBox(
                                  quarterTurns: isMilestoneOnLeft ? 0 : 2,
                                  child: CustomPaint(
                                    painter: RPSCustomPainter(),
                                    child: Container(
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                            SizeConfig.padding12),
                                        child: RotatedBox(
                                          quarterTurns:
                                              isMilestoneOnLeft ? 0 : 2,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                  width: SizeConfig.padding10),
                                              SvgPicture.asset(
                                                  Assets
                                                      .unredemmedScratchCardBG,
                                                  height: SizeConfig.iconSize1),
                                              SizedBox(
                                                  width: SizeConfig.padding8),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text("${milestone.tooltip}",
                                                      style: TextStyles
                                                          .sourceSansSB.body3),
                                                  Text(
                                                    "Win a Scratch Card",
                                                    style: TextStyles
                                                        .sourceSansSB.body5
                                                        .colour(UiConstants
                                                            .kTextColor3),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                  width: SizeConfig.padding8),
                                              Icon(
                                                  Icons
                                                      .arrow_forward_ios_rounded,
                                                  color: Colors.white,
                                                  size: SizeConfig.iconSize2),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )),
                          ),
                        )
                      : Positioned(
                          left: model!.pageWidth! * milestone.x! * 0.6,
                          bottom: (model!.pageHeight! * (milestone.page - 1) +
                                  model!.pageHeight! * milestone.y!) +
                              model!.pageHeight! * milestone.asset.height * 1.2,
                          child: SafeArea(
                            child: GestureDetector(
                                onTap: () => model!
                                    .showMilestoneDetailsModalSheet(
                                        milestone, context),
                                child: Container(
                                  decoration: const ShapeDecoration(
                                    color: Colors.black,
                                    shape: TooltipShapeBorder(arrowArc: 0.5),
                                    shadows: [
                                      BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 4.0,
                                          offset: Offset(2, 2))
                                    ],
                                  ),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.all(SizeConfig.padding12),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SvgPicture.asset(
                                            Assets.unredemmedScratchCardBG,
                                            height: SizeConfig.iconSize1),
                                        SizedBox(width: SizeConfig.padding8),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("${milestone.tooltip}",
                                                style: TextStyles
                                                    .sourceSansSB.body3),
                                            Text(
                                              "Win a Scratch Card",
                                              style: TextStyles
                                                  .sourceSansSB.body5
                                                  .colour(
                                                      UiConstants.kTextColor3),
                                            ),
                                          ],
                                        ),
                                        SizedBox(width: SizeConfig.padding8),
                                        Icon(Icons.arrow_forward_ios_rounded,
                                            color: Colors.white,
                                            size: SizeConfig.iconSize2),
                                      ],
                                    ),
                                  ),
                                )),
                          ),
                        );
                } else {
                  return const SizedBox();
                }
              }),
            ),
          );
        });
  }
}

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.09749333, size.height * 0.06036688);
    path_0.cubicTo(size.width * 0.1075902, size.height * 0.02188711,
        size.width * 0.1218033, 0, size.width * 0.1366947, 0);
    path_0.lineTo(size.width * 0.9466667, 0);
    path_0.cubicTo(size.width * 0.9761222, 0, size.width,
        size.height * 0.08394688, size.width, size.height * 0.1875000);
    path_0.lineTo(size.width, size.height * 0.8125000);
    path_0.cubicTo(size.width, size.height * 0.9160547, size.width * 0.9761222,
        size.height, size.width * 0.9466667, size.height);
    path_0.lineTo(size.width * 0.1364473, size.height);
    path_0.cubicTo(
        size.width * 0.1217007,
        size.height,
        size.width * 0.1076122,
        size.height * 0.9785312,
        size.width * 0.09752911,
        size.height * 0.9407031);
    path_0.lineTo(size.width * 0.01501487, size.height * 0.6311117);
    path_0.cubicTo(
        size.width * -0.004095867,
        size.height * 0.5594094,
        size.width * -0.004219378,
        size.height * 0.4480000,
        size.width * 0.01473187,
        size.height * 0.3757758);
    path_0.lineTo(size.width * 0.09749333, size.height * 0.06036688);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = Colors.black.withOpacity(1.0);
    canvas.drawPath(path_0, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
