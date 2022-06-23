import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/model/journey_models/milestone_model.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/hometabs/journey/journey_vm.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Milestones extends StatelessWidget {
  const Milestones({Key key}) : super(key: key);
  getMilestoneType(MilestoneModel milestone) {
    switch (milestone.animType) {
      case "ROTATE":
        return ActiveRotatingMilestone(milestone: milestone);
      case "FLOAT":
        return ActiveFloatingMilestone(milestone: milestone);
      default:
        return StaticMilestone(milestone: milestone);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(
        JourneyPageViewModel.currentMilestoneList.length,
        (i) => getMilestoneType(
          JourneyPageViewModel.currentMilestoneList[i],
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
  const ActiveFloatingMilestone({Key key, @required this.milestone})
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
            left: JourneyPageViewModel.pageWidth * widget.milestone.shadow.dx,
            bottom: JourneyPageViewModel.pageHeight *
                    (widget.milestone.shadow.page - 1) +
                JourneyPageViewModel.pageHeight * widget.milestone.shadow.dy,
            child: ScaleTransition(
              scale: _floatAnimationController,
              alignment: Alignment.center,
              child: SvgPicture.asset(
                widget.milestone.shadow.asset,
                width: JourneyPageViewModel.pageWidth *
                    widget.milestone.shadow.width,
                height: JourneyPageViewModel.pageHeight *
                    widget.milestone.shadow.height,
                fit: BoxFit.cover,
              ),
            ),
          ),
        Positioned(
          left: JourneyPageViewModel.pageWidth * widget.milestone.dx,
          bottom:
              JourneyPageViewModel.pageHeight * (widget.milestone.page - 1) +
                  JourneyPageViewModel.pageHeight * widget.milestone.dy,
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
              child: SvgPicture.asset(
                widget.milestone.asset,
                width: JourneyPageViewModel.pageWidth * widget.milestone.width,
                height:
                    JourneyPageViewModel.pageHeight * widget.milestone.height,
                fit: BoxFit.cover,
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
  const ActiveRotatingMilestone({Key key, @required this.milestone})
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
            left: JourneyPageViewModel.pageWidth * widget.milestone.shadow.dx,
            bottom: JourneyPageViewModel.pageHeight *
                    (widget.milestone.shadow.page - 1) +
                JourneyPageViewModel.pageHeight * widget.milestone.shadow.dy,
            child: SvgPicture.asset(
              widget.milestone.shadow.asset,
              width: JourneyPageViewModel.pageWidth *
                  widget.milestone.shadow.width,
              height: JourneyPageViewModel.pageHeight *
                  widget.milestone.shadow.height,
              fit: BoxFit.cover,
            ),
          ),
        Positioned(
          left: JourneyPageViewModel.pageWidth * widget.milestone.dx,
          bottom:
              JourneyPageViewModel.pageHeight * (widget.milestone.page - 1) +
                  JourneyPageViewModel.pageHeight * widget.milestone.dy,
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
              child: SvgPicture.asset(
                widget.milestone.asset,
                width: JourneyPageViewModel.pageWidth * widget.milestone.width,
                height:
                    JourneyPageViewModel.pageHeight * widget.milestone.height,
                fit: BoxFit.cover,
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
  const StaticMilestone({Key key, @required this.milestone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (milestone.shadow != null)
          Positioned(
            left: JourneyPageViewModel.pageWidth * milestone.shadow.dx,
            bottom:
                JourneyPageViewModel.pageHeight * (milestone.shadow.page - 1) +
                    JourneyPageViewModel.pageHeight * milestone.shadow.dy,
            child: SvgPicture.asset(
              milestone.shadow.asset,
              width: JourneyPageViewModel.pageWidth * milestone.shadow.width,
              height: JourneyPageViewModel.pageHeight * milestone.shadow.height,
              fit: BoxFit.cover,
            ),
          ),
        Positioned(
          left: JourneyPageViewModel.pageWidth * milestone.dx,
          bottom: JourneyPageViewModel.pageHeight * (milestone.page - 1) +
              JourneyPageViewModel.pageHeight * milestone.dy,
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
                              topRight: Radius.circular(SizeConfig.roundness24),
                              topLeft: Radius.circular(SizeConfig.roundness24)),
                          color: Colors.black54),
                      padding: EdgeInsets.only(
                          top: SizeConfig.pageHorizontalMargins),
                      child: Column(children: [
                        ListTile(
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
                width: JourneyPageViewModel.pageWidth * milestone.width,
                height: JourneyPageViewModel.pageHeight * milestone.height,
                fit: BoxFit.cover,
              ),
            ),
          ),
        )
      ],
    );
  }
}
