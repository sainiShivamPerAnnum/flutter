import 'dart:developer';

import 'package:felloapp/core/enums/journey_service_enum.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/model/journey_models/journey_level_model.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/pages/static/blur_filter.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class LevelBlurView extends StatelessWidget {
  const LevelBlurView();
  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return PropertyChangeConsumer<JourneyService, JourneyServiceProperties>(
      properties: [JourneyServiceProperties.Pages],
      builder: (context, jModel, properties) {
        return PropertyChangeConsumer<UserService, UserServiceProperties>(
          properties: [UserServiceProperties.myJourneyStats],
          builder: (context, m, properties) {
            final JourneyLevel? levelData = jModel!.getJourneyLevelBlurData();
            log("Current Level Data ${levelData.toString()}");
            return levelData != null &&
                    jModel.pages!.length >= levelData.pageEnd!
                ? Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: BlurFilter(
                          child: Container(
                            color: Colors.transparent,
                            height: jModel.pageHeight! *
                                    (1 - levelData.breakpoint!) +
                                jModel.pageHeight! *
                                    (jModel.pageCount - levelData.pageEnd!),
                            width: jModel.pageWidth,
                            alignment: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      Positioned(
                        top: jModel.pageHeight! * (1 - levelData.breakpoint!) +
                            jModel.pageHeight! *
                                (jModel.pageCount - levelData.pageEnd!) -
                            SizeConfig.avatarRadius,
                        child: Container(
                          width: jModel.pageWidth,
                          child: Row(
                            children: [
                              Expanded(
                                child: CustomPaint(
                                  painter: DottedLinePainter(),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(
                                      SizeConfig.roundness40),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: SizeConfig.padding8,
                                    horizontal: SizeConfig.padding24),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.lock,
                                            size: SizeConfig.iconSize1,
                                            color: Colors.black),
                                        Text(
                                            " " +
                                                locale.jLevel +
                                                " ${levelData.level! + 1}",
                                            style: TextStyles.rajdhaniB.body1
                                                .colour(Colors.black)),
                                      ],
                                    ),
                                    RichText(
                                      text: TextSpan(
                                          style: TextStyles.body4
                                              .colour(Colors.black),
                                          children: [
                                            TextSpan(
                                                text:
                                                    "Win Scratch Card upto ₹${getAmount((levelData.level ?? 0) + 1)}")
                                          ]),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: CustomPaint(
                                  painter: DottedLinePainter(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                : SizedBox();
          },
        );
      },
    );
  }

  getAmount(int level) {
    switch (level) {
      case 2:
        return "100";
      case 3:
        return "200";
      case 4:
        return "500";
      default:
        return "100";
    }
  }
}

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Colors.white
      ..strokeWidth = 1
      ..isAntiAlias = false
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square;
    final path = Path();
    path.moveTo(0, size.height / 2);
    path.lineTo(size.width, size.height / 2);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
