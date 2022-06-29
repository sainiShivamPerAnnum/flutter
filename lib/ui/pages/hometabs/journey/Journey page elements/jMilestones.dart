import 'dart:developer';
import 'dart:math' as math;
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/model/journey_models/milestone_model.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/hometabs/journey/journey_vm.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Milestones extends StatelessWidget {
  final JourneyPageViewModel model;
  const Milestones({Key key, this.model}) : super(key: key);
  getMilestoneType(MilestoneModel milestone) {
    switch (milestone.animType) {
      case "ROTATE":
        return ActiveRotatingMilestone(
          milestone: milestone,
          model: model,
        );
      case "FLOAT":
        return ActiveFloatingMilestone(
          milestone: milestone,
          model: model,
        );
      default:
        return StaticMilestone(
          milestone: milestone,
          model: model,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(
        model.currentMilestoneList.length,
        (i) => getMilestoneType(
          model.currentMilestoneList[i],
        ),
      ),
    );
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
  @override
  void initState() {
    _floatAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

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
            left: widget.model.pageWidth * widget.milestone.shadow.dx,
            bottom:
                widget.model.pageHeight * (widget.milestone.shadow.page - 1) +
                    widget.model.pageHeight * widget.milestone.shadow.dy,
            child: ScaleTransition(
              scale: _floatAnimationController,
              alignment: Alignment.center,
              child: Transform(
                alignment: Alignment.center,
                transform:
                    Matrix4.rotationY(widget.milestone.hFlip ? math.pi : 0),
                child: SvgPicture.asset(
                  widget.milestone.shadow.asset,
                  width: widget.model.pageWidth * widget.milestone.shadow.width,
                  height:
                      widget.model.pageHeight * widget.milestone.shadow.height,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        Positioned(
          left: widget.model.pageWidth * widget.milestone.dx,
          bottom: widget.model.pageHeight * (widget.milestone.page - 1) +
              widget.model.pageHeight * widget.milestone.dy,
          child: SlideTransition(
            position: _floatAnimation,
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 2),
                    content: Text(widget.milestone.description),
                  ),
                );
              },
              child: Transform(
                alignment: Alignment.center,
                transform:
                    Matrix4.rotationY(widget.milestone.hFlip ? math.pi : 0),
                child: SvgPicture.asset(
                  widget.milestone.asset,
                  width: widget.model.pageWidth * widget.milestone.width,
                  height: widget.model.pageHeight * widget.milestone.height,
                  fit: BoxFit.cover,
                ),
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
            left: widget.model.pageWidth * widget.milestone.shadow.dx,
            bottom:
                widget.model.pageHeight * (widget.milestone.shadow.page - 1) +
                    widget.model.pageHeight * widget.milestone.shadow.dy,
            child: Transform(
              alignment: Alignment.center,
              transform:
                  Matrix4.rotationY(widget.milestone.hFlip ? math.pi : 0),
              child: SvgPicture.asset(
                widget.milestone.shadow.asset,
                width: widget.model.pageWidth * widget.milestone.shadow.width,
                height:
                    widget.model.pageHeight * widget.milestone.shadow.height,
                fit: BoxFit.cover,
              ),
            ),
          ),
        Positioned(
          left: widget.model.pageWidth * widget.milestone.dx,
          bottom: widget.model.pageHeight * (widget.milestone.page - 1) +
              widget.model.pageHeight * widget.milestone.dy,
          child: RotationTransition(
            turns: _floatAnimationController,
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 2),
                    content: Text(widget.milestone.description),
                  ),
                );
              },
              child: Transform(
                alignment: Alignment.center,
                transform:
                    Matrix4.rotationY(widget.milestone.hFlip ? math.pi : 0),
                child: SvgPicture.asset(
                  widget.milestone.asset,
                  width: widget.model.pageWidth * widget.milestone.width,
                  height: widget.model.pageHeight * widget.milestone.height,
                  fit: BoxFit.cover,
                ),
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
  const StaticMilestone({Key key, @required this.milestone, this.model})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (milestone.shadow != null)
          Positioned(
            left: model.pageWidth * milestone.shadow.dx,
            bottom: model.pageHeight * (milestone.shadow.page - 1) +
                model.pageHeight * milestone.shadow.dy,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(milestone.hFlip ? math.pi : 0),
              child: SvgPicture.asset(
                milestone.shadow.asset,
                width: model.pageWidth * milestone.shadow.width,
                height: model.pageHeight * milestone.shadow.height,
                fit: BoxFit.cover,
              ),
            ),
          ),
        Positioned(
          left: model.pageWidth * milestone.dx,
          bottom: model.pageHeight * (milestone.page - 1) +
              model.pageHeight * milestone.dy,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(milestone.hFlip ? math.pi : 0),
            child: GestureDetector(
              onTap: () {
                // ScaffoldMessenger.of(context)
                //     .showSnackBar(SnackBar(content: Text(milestone.description)));
                AppState.screenStack.add(ScreenItem.dialog);
                log("Current Screen Stack: ${AppState.screenStack}");
                showModalBottomSheet(
                  // addToScreenStack: true,
                  backgroundColor: Colors.transparent,
                  // hapticVibrate: true,
                  // isBarrierDismissable: true,
                  enableDrag: true,
                  useRootNavigator: true,
                  context: context,
                  builder: (ctx) {
                    return WillPopScope(
                      onWillPop: () async {
                        log("I am closing");
                        return Future.value(true);
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: SizeConfig.pageHorizontalMargins),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight:
                                    Radius.circular(SizeConfig.roundness24),
                                topLeft:
                                    Radius.circular(SizeConfig.roundness24)),
                            color: Colors.black54),
                        padding: EdgeInsets.only(
                            top: SizeConfig.pageHorizontalMargins),
                        child: Column(children: [
                          ListTile(
                            onTap: () {
                              Haptic.vibrate();
                              AppState.backButtonDispatcher.didPopRoute();
                              AppState.delegate
                                  .parseRoute(Uri.parse('editProfile'));
                            },
                            leading: CircleAvatar(
                              backgroundColor: Colors.black,
                              radius: SizeConfig.avatarRadius * 2,
                              child: SvgPicture.asset(
                                milestone.asset,
                                height: SizeConfig.avatarRadius * 2,
                                width: SizeConfig.avatarRadius * 2,
                                fit: BoxFit.contain,
                              ),
                            ),
                            title: Text(
                              "Milestone Details",
                              style: GoogleFonts.rajdhani(
                                  fontSize: SizeConfig.title3,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white),
                            ),
                            subtitle: Text(
                              milestone.description,
                              style: TextStyles.body3.colour(Colors.white),
                            ),
                          )
                        ]),
                      ),
                    );
                  },
                );
              },
              child: Tooltip(
                message: milestone.description,
                triggerMode: TooltipTriggerMode.longPress,
                child: SvgPicture.asset(
                  milestone.asset,
                  width: model.pageWidth * milestone.width,
                  height: model.pageHeight * milestone.height,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
