import 'dart:math' as math;
import 'dart:developer';
import 'package:felloapp/core/enums/journey_service_enum.dart';
import 'package:felloapp/core/model/journey_models/milestone_model.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/ui/pages/hometabs/journey/Journey%20page%20elements/jAssetPath.dart';
import 'package:felloapp/ui/pages/hometabs/journey/components/source_adaptive_asset/source_adaptive_asset_view.dart';
import 'package:felloapp/ui/pages/hometabs/journey/journey_view.dart';
import 'package:felloapp/ui/pages/hometabs/journey/journey_vm.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

String generateAssetUrl(String name) {
  return "https://journey-assets-x.s3.ap-south-1.amazonaws.com/$name.svg";
}

class Milestones extends StatelessWidget {
  final JourneyPageViewModel model;
  const Milestones({Key key, this.model}) : super(key: key);
  // getMilestoneType(MilestoneModel milestone) {

  //   switch (milestone.animType) {
  //     case "ROTATE":
  //       return ActiveRotatingMilestone(
  //         milestone: milestone,
  //         model: model,
  //       );
  //     case "FLOAT":
  //       return ActiveFloatingMilestone(
  //         milestone: milestone,
  //         model: model,
  //       );
  //     default:
  //       return StaticMilestone(
  //         milestone: milestone,
  //         model: model,
  //       );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<JourneyService, JourneyServiceProperties>(
        properties: [
          JourneyServiceProperties.AvatarPosition,
          JourneyServiceProperties.BaseGlow,
          JourneyServiceProperties.Pages,
        ],
        builder: (context, serviceModel, properties) {
          return SizedBox(
            width: model.pageWidth,
            height: model.currentFullViewHeight,
            child: Stack(
              children: List.generate(model.currentMilestoneList.length, (i) {
                if (model.currentMilestoneList[i].index ==
                    model.avatarActiveMilestoneLevel) {
                  switch (model.currentMilestoneList[i].animType) {
                    case "ROTATE":
                      return ActiveFloatingMilestone(
                        milestone: model.currentMilestoneList[i],
                        model: model,
                      );
                    case "FLOAT":
                      return ActiveFloatingMilestone(
                        milestone: model.currentMilestoneList[i],
                        model: model,
                      );
                    default:
                      return StaticMilestone(
                        milestone: model.currentMilestoneList[i],
                        model: model,
                      );
                  }
                } else
                  return StaticMilestone(
                    milestone: model.currentMilestoneList[i],
                    model: model,
                  );
              }),
            ),
          );
        });
  }
}

//-----------------------------------------------------------------------//
//----------------------------ANIMATED MILESTONES------------------------//
//-----------------------------------------------------------------------//

class ActiveFloatingMilestone extends StatefulWidget {
  final MilestoneModel milestone;
  final JourneyPageViewModel model;

  const ActiveFloatingMilestone({Key key, @required this.milestone, this.model})
      : super(key: key);
  @override
  _ActiveFloatingMilestoneState createState() =>
      _ActiveFloatingMilestoneState();
}

class _ActiveFloatingMilestoneState extends State<ActiveFloatingMilestone>
    with SingleTickerProviderStateMixin {
  AnimationController _floatAnimationController;
  Animation<Offset> _floatAnimation;
  Animation<double> _scaleAnimation;
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
    return Stack(
      children: [
        if (widget.milestone.shadow != null)
          Positioned(
            left: widget.model.pageWidth * widget.milestone.shadow.x,
            bottom:
                widget.model.pageHeight * (widget.milestone.shadow.page - 1) +
                    widget.model.pageHeight * widget.milestone.shadow.y,
            child: ScaleTransition(
              scale: _scaleAnimation,
              alignment: Alignment.center,
              child: Transform(
                alignment: Alignment.center,
                transform:
                    Matrix4.rotationY(widget.milestone.hFlip ? math.pi : 0),
                child: SourceAdaptiveAssetView(
                  asset: widget.milestone.shadow.asset,
                ),
              ),
            ),
          ),
        Positioned(
          left: widget.model.pageWidth * widget.milestone.x,
          bottom: widget.model.pageHeight * (widget.milestone.page - 1) +
              widget.model.pageHeight * widget.milestone.y,
          child: SlideTransition(
            position: _floatAnimation,
            child: GestureDetector(
              // onTap: () {
              //   ScaffoldMessenger.of(context).showSnackBar(
              //     SnackBar(
              //       duration: const Duration(seconds: 2),
              //       content: Text(widget.milestone.steps.first.title),
              //     ),
              //   );
              // },
              onTap: () => widget.model
                  .showMilestoneDetailsModalSheet(widget.milestone, context),
              child: Transform(
                alignment: Alignment.center,
                transform:
                    Matrix4.rotationY(widget.milestone.hFlip ? math.pi : 0),
                child: SourceAdaptiveAssetView(asset: widget.milestone.asset),
              ),
            ),
          ),
        ),
        if (widget.milestone.index != 1)
          Positioned(
            left: widget.model.pageWidth * widget.milestone.x,
            bottom: (widget.model.pageHeight * (widget.milestone.page - 1) +
                    widget.model.pageHeight * widget.milestone.y) +
                widget.model.pageHeight * widget.milestone.asset.height * 1.2,
            child: SafeArea(
              child: GestureDetector(
                  onTap: () => widget.model.showMilestoneDetailsModalSheet(
                      widget.milestone, context),
                  child: Container(
                    decoration: ShapeDecoration(
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
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("${widget.milestone.tooltip}",
                              style: TextStyles.sourceSansSB.body2),
                          Icon(Icons.arrow_forward_ios_rounded,
                              color: Colors.white, size: SizeConfig.iconSize1),
                        ],
                      ),
                    ),
                  )),
            ),
          )
      ],
    );
  }
}

class ActiveRotatingMilestone extends StatefulWidget {
  final MilestoneModel milestone;
  final JourneyPageViewModel model;
  const ActiveRotatingMilestone({Key key, @required this.milestone, this.model})
      : super(key: key);
  @override
  _ActiveRotatingMilestoneState createState() =>
      _ActiveRotatingMilestoneState();
}

class _ActiveRotatingMilestoneState extends State<ActiveRotatingMilestone>
    with SingleTickerProviderStateMixin {
  AnimationController _floatAnimationController;
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
    return Stack(
      children: [
        if (widget.milestone.shadow != null)
          Positioned(
            left: widget.model.pageWidth * widget.milestone.shadow.x,
            bottom:
                widget.model.pageHeight * (widget.milestone.shadow.page - 1) +
                    widget.model.pageHeight * widget.milestone.shadow.y,
            child: Transform(
                alignment: Alignment.center,
                transform:
                    Matrix4.rotationY(widget.milestone.hFlip ? math.pi : 0),
                child: SourceAdaptiveAssetView(
                  asset: widget.milestone.shadow.asset,
                )),
          ),
        Positioned(
          left: widget.model.pageWidth * widget.milestone.x,
          bottom: widget.model.pageHeight * (widget.milestone.page - 1) +
              widget.model.pageHeight * widget.milestone.y,
          child: RotationTransition(
            turns: _floatAnimationController,
            child: GestureDetector(
              onTap: () => widget.model
                  .showMilestoneDetailsModalSheet(widget.milestone, context),
              //() {
              //   ScaffoldMessenger.of(context).showSnackBar(
              //     SnackBar(
              //       duration: const Duration(seconds: 2),
              //       content: Text(widget.milestone.steps.first.title),
              //     ),
              //   );
              // },
              child: Transform(
                alignment: Alignment.center,
                transform:
                    Matrix4.rotationY(widget.milestone.hFlip ? math.pi : 0),
                child: SourceAdaptiveAssetView(asset: widget.milestone.asset),
              ),
            ),
          ),
        ),
        // if (widget.milestone.isCompleted != null &&
        //     widget.milestone.isCompleted)
        //   Positioned(
        //       left: widget.model.pageWidth * widget.milestone.x,
        //       bottom: (widget.model.pageHeight * (widget.milestone.page - 1) +
        //               widget.model.pageHeight * widget.milestone.y) -
        //           widget.model.pageHeight * 0.02,
        //       child: MileStoneCheck(
        //           model: widget.model, milestone: widget.milestone))
      ],
    );
  }
}

class StaticMilestone extends StatelessWidget {
  final MilestoneModel milestone;
  final JourneyPageViewModel model;
  const StaticMilestone({Key key, @required this.milestone, this.model})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (milestone.shadow != null)
          Positioned(
            left: model.pageWidth * milestone.shadow.x,
            bottom: model.pageHeight * (milestone.shadow.page - 1) +
                model.pageHeight * milestone.shadow.y,
            child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(milestone.hFlip ? math.pi : 0),
                child: SourceAdaptiveAssetView(asset: milestone.shadow.asset)
                // SvgPicture.network(
                //   generateAssetUrl(milestone.shadow.asset.name),
                //   width: model.pageWidth * milestone.shadow.asset.width,
                //   height: model.pageHeight * milestone.shadow.asset.height,
                //   fit: BoxFit.cover,
                // ),
                ),
          ),
        Positioned(
          left: model.pageWidth * milestone.x,
          bottom: model.pageHeight * (milestone.page - 1) +
              model.pageHeight * milestone.y,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(milestone.hFlip ? math.pi : 0),
            child: model.isInComplete(milestone.index)
                ? Tooltip(
                    // message: "Hello World!!",
                    triggerMode: TooltipTriggerMode.tap,
                    showDuration: Duration(seconds: 3),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),

                    richMessage: TextSpan(
                      children: [
                        WidgetSpan(
                          child: Container(
                            decoration: ShapeDecoration(
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
                              padding: EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.lock_rounded,
                                      color: Colors.white,
                                      size: SizeConfig.iconSize1),
                                  Text("${milestone.tooltip}",
                                      style: TextStyles.sourceSansSB.body2),
                                ],
                              ),
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
        ),
        if (milestone.index < model.avatarActiveMilestoneLevel)
          Positioned(
              left: model.pageWidth * milestone.x,
              bottom: ((model.pageHeight * (milestone.page - 1)) +
                      model.pageHeight * milestone.y) -
                  model.pageHeight * 0.02,
              child: MileStoneCheck())
      ],
    );
  }
}

class TooltipShapeBorder extends ShapeBorder {
  final double arrowWidth;
  final double arrowHeight;
  final double arrowArc;
  final double radius;

  TooltipShapeBorder({
    this.radius = 16.0,
    this.arrowWidth = 20.0,
    this.arrowHeight = 10.0,
    this.arrowArc = 0.0,
  }) : assert(arrowArc <= 1.0 && arrowArc >= 0.0);

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.only(bottom: arrowHeight);

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) => null;

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
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
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}
