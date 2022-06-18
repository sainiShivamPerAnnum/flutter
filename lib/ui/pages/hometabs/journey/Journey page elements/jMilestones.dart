import 'package:felloapp/core/model/journey_models/milestone_model.dart';
import 'package:felloapp/ui/pages/hometabs/journey/journey_vm.dart';
import 'package:flutter/material.dart';

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
    return Positioned(
      left: JourneyPageViewModel.pageWidth * widget.milestone.dx,
      bottom: JourneyPageViewModel.pageHeight * widget.milestone.dy,
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
          child: Image.asset(
            widget.milestone.asset,
            width: JourneyPageViewModel.pageWidth * widget.milestone.width,
            height: JourneyPageViewModel.pageHeight * widget.milestone.height,
            fit: BoxFit.cover,
          ),
        ),
      ),
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
    return Positioned(
      left: JourneyPageViewModel.pageWidth * widget.milestone.dx,
      bottom: JourneyPageViewModel.pageHeight * widget.milestone.dy,
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
          child: Image.asset(
            widget.milestone.asset,
            width: JourneyPageViewModel.pageWidth * widget.milestone.width,
            height: JourneyPageViewModel.pageHeight * widget.milestone.height,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class StaticMilestone extends StatelessWidget {
  final MilestoneModel milestone;
  const StaticMilestone({Key key, @required this.milestone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: JourneyPageViewModel.pageWidth * milestone.dx,
      bottom: JourneyPageViewModel.pageHeight * milestone.dy,
      child: GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(milestone.description)));
        },
        child: Tooltip(
          message: milestone.description,
          triggerMode: TooltipTriggerMode.longPress,
          child: Image.asset(
            milestone.asset,
            width: JourneyPageViewModel.pageWidth * milestone.width,
            height: JourneyPageViewModel.pageHeight * milestone.height,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
