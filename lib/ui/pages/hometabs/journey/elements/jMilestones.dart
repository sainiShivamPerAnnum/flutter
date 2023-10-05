import 'dart:math' as math;

import 'package:felloapp/core/enums/journey_service_enum.dart';
import 'package:felloapp/core/model/journey_models/milestone_model.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/ui/pages/hometabs/journey/components/source_adaptive_asset/source_adaptive_asset_view.dart';
import 'package:felloapp/ui/pages/hometabs/journey/elements/jAssetPath.dart';
import 'package:felloapp/ui/pages/hometabs/journey/journey_vm.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class Milestones extends StatelessWidget {
  final JourneyPageViewModel model;

  const Milestones({
    required this.model,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<JourneyService, JourneyServiceProperties>(
      properties: const [
        JourneyServiceProperties.AvatarPosition,
        JourneyServiceProperties.BaseGlow,
        JourneyServiceProperties.Pages,
      ],
      builder: (context, serviceModel, properties) {
        final mileStoneList = model.currentMilestoneList;
        return SizedBox(
          width: model.pageWidth,
          height: model.currentFullViewHeight,
          child: Stack(
            children: List.generate(mileStoneList.length, (i) {
              final milestone = mileStoneList[i];
              if (milestone.asset.uri.isEmpty) {
                return const SizedBox();
              } else if (milestone.index == model.avatarActiveMilestoneLevel) {
                return ActiveFloatingMilestone(
                  milestone: milestone,
                  model: model,
                );
              } else {
                return StaticMilestone(
                  milestone: milestone,
                  model: model,
                );
              }
            }),
          ),
        );
      },
    );
  }
}

//-----------------------------------------------------------------------//
//----------------------------ANIMATED MILESTONES------------------------//
//-----------------------------------------------------------------------//

class ActiveFloatingMilestone extends StatefulWidget {
  final MilestoneModel milestone;
  final JourneyPageViewModel model;

  const ActiveFloatingMilestone({
    required this.milestone,
    required this.model,
    super.key,
  });

  @override
  State<ActiveFloatingMilestone> createState() =>
      _ActiveFloatingMilestoneState();
}

class _ActiveFloatingMilestoneState extends State<ActiveFloatingMilestone>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatAnimationController;
  late Animation<Offset> _floatAnimation;
  late Animation<double> _scaleAnimation;
  @override
  void initState() {
    _floatAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation =
        Tween<double>(begin: 0.5, end: 0.8).animate(_floatAnimationController)
          ..addListener(() {
            if (_scaleAnimation.status == AnimationStatus.completed) {
              _floatAnimationController.reverse();
            } else if (_scaleAnimation.status == AnimationStatus.dismissed) {
              _floatAnimationController.forward();
            }
          });
    _floatAnimation =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0.0, -0.2))
            .animate(_floatAnimationController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _floatAnimationController.reverse();
            } else if (status == AnimationStatus.dismissed) {
              _floatAnimationController.forward();
            }
          });
    _floatAnimationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _floatAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    final milestone = widget.milestone;
    final pageHeight = model.pageHeight;
    final pageWidth = model.pageWidth;
    return Stack(
      children: [
        if (widget.milestone.shadow != null)
          Positioned(
            left: pageWidth! * milestone.shadow!.x!,
            bottom: pageHeight! * (milestone.shadow!.page - 1) +
                pageHeight * milestone.shadow!.y!,
            child: ScaleTransition(
              scale: _scaleAnimation,
              alignment: Alignment.center,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(milestone.hFlip! ? math.pi : 0),
                child: SourceAdaptiveAssetView(
                  asset: milestone.shadow!.asset,
                ),
              ),
            ),
          ),
        Positioned(
          left: pageWidth! * milestone.x!,
          bottom:
              pageHeight! * (milestone.page - 1) + pageHeight * milestone.y!,
          child: SlideTransition(
            position: _floatAnimation,
            child: GestureDetector(
              onTap: () =>
                  model.showMilestoneDetailsModalSheet(milestone, context),
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(milestone.hFlip! ? math.pi : 0),
                child: SourceAdaptiveAssetView(asset: milestone.asset),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ActiveRotatingMilestone extends StatefulWidget {
  final MilestoneModel milestone;
  final JourneyPageViewModel? model;
  const ActiveRotatingMilestone({required this.milestone, Key? key, this.model})
      : super(key: key);
  @override
  State<ActiveRotatingMilestone> createState() =>
      _ActiveRotatingMilestoneState();
}

class _ActiveRotatingMilestoneState extends State<ActiveRotatingMilestone>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatAnimationController;
  // Animation<Offset> _floatAnimation;
  @override
  void initState() {
    _floatAnimationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _floatAnimationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _floatAnimationController.forward();
        }
      })
      ..forward();
    super.initState();
  }

  @override
  void dispose() {
    _floatAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.model!;
    final milestone = widget.milestone;
    final pageWidth = model.pageWidth!;
    final pageHeight = model.pageHeight!;

    return Stack(
      children: [
        if (milestone.shadow != null)
          Positioned(
            left: pageWidth * milestone.shadow!.x!,
            bottom: pageHeight * (milestone.shadow!.page - 1) +
                pageHeight * milestone.shadow!.y!,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(milestone.hFlip! ? math.pi : 0),
              child: SourceAdaptiveAssetView(
                asset: milestone.shadow!.asset,
              ),
            ),
          ),
        Positioned(
          left: pageWidth * milestone.x!,
          bottom: pageHeight * (milestone.page - 1) + pageHeight * milestone.y!,
          child: RotationTransition(
            turns: _floatAnimationController,
            child: GestureDetector(
              onTap: () =>
                  model.showMilestoneDetailsModalSheet(milestone, context),
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(milestone.hFlip! ? math.pi : 0),
                child: SourceAdaptiveAssetView(asset: milestone.asset),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class StaticMilestone extends StatelessWidget {
  final MilestoneModel milestone;
  final JourneyPageViewModel model;

  const StaticMilestone({
    required this.milestone,
    required this.model,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final pageWidth = model.pageWidth!;
    final pageHeight = model.pageHeight!;

    return Stack(
      children: [
        if (milestone.shadow != null)
          Positioned(
            left: pageWidth * milestone.shadow!.x!,
            bottom: pageHeight * (milestone.shadow!.page - 1) +
                pageHeight * milestone.shadow!.y!,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(milestone.hFlip! ? math.pi : 0),
              child: SourceAdaptiveAssetView(asset: milestone.shadow!.asset),
            ),
          ),
        if (milestone.tooltip != null && milestone.tooltip!.isNotEmpty)
          Positioned(
            left: pageWidth * milestone.x!,
            bottom:
                pageHeight * (milestone.page - 1) + pageHeight * milestone.y!,
            child: model.isInComplete(milestone.index)
                ? Tooltip(
                    triggerMode: TooltipTriggerMode.tap,
                    showDuration: const Duration(seconds: 3),
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    richMessage: TextSpan(
                      children: [
                        WidgetSpan(
                          child: Container(
                            padding: EdgeInsets.all(SizeConfig.padding12),
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
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.lock_rounded,
                                    color: Colors.white,
                                    size: SizeConfig.iconSize0),
                                SizedBox(width: SizeConfig.padding8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${milestone.tooltip}",
                                        style: TextStyles.sourceSansSB.body3),
                                    Text(
                                      "Win Scratch Card",
                                      style: TextStyles.sourceSansSB.body5
                                          .colour(UiConstants.kTextColor3),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    enableFeedback: true,
                    margin: EdgeInsets.only(bottom: milestone.asset.height * 2),
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.padding10,
                      vertical: SizeConfig.padding12,
                    ),
                    preferBelow: false,
                    child: SourceAdaptiveAssetView(asset: milestone.asset),
                  )
                : GestureDetector(
                    onTap: () => model.showMilestoneDetailsModalSheet(
                        milestone, context),
                    child: SourceAdaptiveAssetView(asset: milestone.asset),
                  ),
          ),
        if (milestone.index! < model.avatarActiveMilestoneLevel!)
          Positioned(
              left: pageWidth * milestone.x!,
              bottom: ((pageHeight * (milestone.page - 1)) +
                      pageHeight * milestone.y!) -
                  model.pageHeight! * 0.02,
              child: const MileStoneCheck())
      ],
    );
  }
}

class TooltipShapeBorder extends ShapeBorder {
  final double arrowWidth;
  final double arrowHeight;
  final double arrowArc;
  final double radius;

  const TooltipShapeBorder({
    this.radius = 16.0,
    this.arrowWidth = 20.0,
    this.arrowHeight = 10.0,
    this.arrowArc = 0.0,
  }) : assert(arrowArc <= 1.0 && arrowArc >= 0.0);

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.only(bottom: arrowHeight);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    rect = Rect.fromPoints(
        rect.topLeft, rect.bottomRight - Offset(0, arrowHeight));
    double x = arrowWidth, y = arrowHeight, r = 1 - arrowArc;
    return Path()
      ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)))
      ..moveTo(rect.bottomCenter.dx + x / 2, rect.bottomCenter.dy)
      ..relativeLineTo(-x / 2 * r, y * r)
      ..relativeQuadraticBezierTo(
          -x / 2 * (1 - r), y * (1 - r), -x * (1 - r), 0)
      ..relativeLineTo(-x / 2 * r, -y * r);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    throw UnimplementedError();
  }
}
