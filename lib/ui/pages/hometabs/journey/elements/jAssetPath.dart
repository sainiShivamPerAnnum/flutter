import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:felloapp/core/enums/journey_service_enum.dart';
import 'package:felloapp/core/model/journey_models/milestone_model.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/ui/pages/hometabs/journey/components/source_adaptive_asset/source_adaptive_asset_view.dart';
import 'package:felloapp/ui/pages/hometabs/journey/journey_vm.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class JourneyAssetPath extends StatefulWidget {
  final JourneyPageViewModel? model;
  const JourneyAssetPath({Key? key, this.model}) : super(key: key);
  @override
  State<JourneyAssetPath> createState() => _JourneyAssetPathState();
}

class _JourneyAssetPathState extends State<JourneyAssetPath> {
  @override
  Widget build(BuildContext context) {
    final model = widget.model!;
    final journeyPathItemsList = model.journeyPathItemsList;
    final pageWidth = model.pageWidth!;
    final pageHeight = model.pageHeight!;
    return SizedBox(
      height: widget.model!.currentFullViewHeight,
      width: pageWidth,
      child: Stack(
        children: List.generate(
          journeyPathItemsList.length,
          (i) => Positioned(
            left: pageWidth * journeyPathItemsList[i].x,
            bottom: pageHeight * (journeyPathItemsList[i].page - 1) +
                pageHeight * journeyPathItemsList[i].y,
            child: SourceAdaptiveAssetView(
              asset: journeyPathItemsList[i].asset,
            ),
          ),
        ),
      ),
    );
  }
}

class ActiveMilestoneBackgroundGlow extends StatelessWidget {
  const ActiveMilestoneBackgroundGlow({super.key});
  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<JourneyService, JourneyServiceProperties>(
        properties: const [JourneyServiceProperties.BaseGlow],
        builder: (context, model, properties) {
          final asset = model!.journeyPathItemsList.firstWhere((element) =>
              element.mlIndex == model.avatarRemoteMlIndex && element.isBase);
          return Positioned(
            left: model.pageWidth! * asset.x,
            bottom: model.pageHeight! * (asset.page - 1) +
                model.pageHeight! * asset.y,
            child: AnimatedOpacity(
              opacity: model.baseGlow,
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeInCubic,
              child: Container(
                height: SizeConfig.screenWidth! * asset.asset.width,
                width: SizeConfig.screenWidth! * asset.asset.width,
                decoration: BoxDecoration(
                  shape: BoxShape.circle, //color: Colors.black
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff62E3C4).withOpacity(0.8),
                      spreadRadius: 0,
                      blurRadius: SizeConfig.screenWidth!,
                      offset: const Offset(0, 0),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class ActiveMilestoneBaseGlow extends StatelessWidget {
  const ActiveMilestoneBaseGlow({super.key});
  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<JourneyService, JourneyServiceProperties>(
      properties: const [
        JourneyServiceProperties.BaseGlow,
        JourneyServiceProperties.Pages,
      ],
      builder: (context, model, properties) {
        final base = model!.journeyPathItemsList.firstWhereOrNull(
          (e) => e.mlIndex == model.avatarRemoteMlIndex && e.isBase,
        );
        if (base == null) return const SizedBox.shrink();
        return Positioned(
          left: model.pageWidth! * base.x,
          bottom:
              model.pageHeight! * (base.page - 1) + model.pageHeight! * base.y,
          child: AnimatedOpacity(
            opacity: model.baseGlow,
            curve: Curves.easeInCubic,
            duration: const Duration(milliseconds: 700),
            child: SizedBox(
              width: model.pageWidth! * base.asset.width,
              height: model.pageHeight! * base.asset.height * 2,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: ClipPath(
                      clipper: const BackBeamClipper(),
                      child: Container(
                        width: model.pageWidth! * base.asset.width * 4,
                        height: model.pageHeight! * base.asset.height * 1.5,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                UiConstants.primaryColor.withOpacity(0.01),
                                UiConstants.primaryColor.withOpacity(0.5),
                                UiConstants.primaryColor.withOpacity(0.3),
                                UiConstants.primaryColor.withOpacity(0.1),
                                UiConstants.primaryColor.withOpacity(0.01)
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class BaseRings extends StatelessWidget {
  final double? size;

  const BaseRings({Key? key, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.rotationX(math.pi / 4),
      alignment: Alignment.center,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 6, color: Colors.white),
                    shape: BoxShape.circle),
                height: size! * 0.4,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 3, color: Colors.white.withOpacity(0.8)),
                    shape: BoxShape.circle),
                height: size! * 0.6,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 2, color: Colors.white.withOpacity(0.6)),
                    shape: BoxShape.circle),
                height: size,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MileStoneCheck extends StatelessWidget {
  // final JourneyService model;
  final MilestoneModel? milestone;
  const MileStoneCheck({Key? key, this.milestone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth! * 0.08,
      height: SizeConfig.screenWidth! * 0.08,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: UiConstants.primaryColor, width: 3),
        color: Colors.black,
      ),
      child: Icon(
        Icons.check,
        size: SizeConfig.iconSize2,
        color: UiConstants.primaryColor,
      ),
    );
  }
}

class BackBeamClipper extends CustomClipper<Path> {
  const BackBeamClipper();

  @override
  Path getClip(Size size) {
    return Path()
      ..lineTo(0, 0)
      ..lineTo(size.width * 0.2, size.height)
      ..lineTo(size.width * 0.8, size.height)
      ..lineTo(size.width, 0)
      ..close();
  }

  /// Return false always because we always clip the same area.
  @override
  bool shouldReclip(CustomClipper oldClipper) => false;
}

class FrontBeamClipper extends CustomClipper<Path> {
  const FrontBeamClipper();

  @override
  Path getClip(Size size) {
    return Path()
      ..lineTo(0, 0)
      ..lineTo(size.width * 0.1, size.height)
      ..lineTo(size.width * 0.9, size.height)
      ..lineTo(size.width, 0)
      ..close();
  }

  /// Return false always because we always clip the same area.
  @override
  bool shouldReclip(CustomClipper oldClipper) => false;
}
