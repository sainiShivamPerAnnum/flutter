import 'dart:developer';
import 'dart:math' as math;
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/model/journey_models/milestone_model.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/hometabs/journey/Journey%20page%20elements/jAssetPath.dart';
import 'package:felloapp/ui/pages/hometabs/journey/components/source_adaptive_asset/source_adaptive_asset_view.dart';
import 'package:felloapp/ui/pages/hometabs/journey/journey_vm.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

String generateAssetUrl(String name) {
  return "https://journey-assets-x.s3.ap-south-1.amazonaws.com/$name.svg";
}

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
    print("milestone build called");
    return SizedBox(
      width: model.pageWidth,
      height: model.pageHeight * 2,
      child: Stack(
        children: List.generate(
          model.currentMilestoneList.length,
          (i) => getMilestoneType(
            model.currentMilestoneList[i],
          ),
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
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 2),
                    content: Text(widget.milestone.steps.first.title),
                  ),
                );
              },
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
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 2),
                    content: Text(widget.milestone.steps.first.title),
                  ),
                );
              },
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
                                milestone.asset.uri,
                                height: SizeConfig.avatarRadius * 2,
                                width: SizeConfig.avatarRadius * 2,
                                fit: BoxFit.contain,
                              ),
                            ),
                            title: Text(
                              milestone.steps.first.title,
                              style: GoogleFonts.rajdhani(
                                  fontSize: SizeConfig.title3,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white),
                            ),
                            subtitle: Text(
                              milestone.steps.first.subtitle,
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
                  message: milestone.tooltip ?? "Hello World!!",
                  triggerMode: TooltipTriggerMode.longPress,
                  child: SourceAdaptiveAssetView(asset: milestone.asset)
                  // SvgPicture.network(
                  //   generateAssetUrl(milestone.asset.name),
                  //   width: model.pageWidth * milestone.asset.width,
                  //   height: model.pageHeight * milestone.asset.height,
                  //   fit: BoxFit.cover,
                  // ),
                  ),
            ),
          ),
        ),
        // if (milestone.isCompleted != null && milestone.isCompleted)
        //   Positioned(
        //       left: model.pageWidth * milestone.x,
        //       bottom: (model.pageHeight * (milestone.page - 1) +
        //               model.pageHeight * milestone.y) -
        //           model.pageHeight * 0.02,
        //       child: MileStoneCheck(model: model, milestone: milestone))
      ],
    );
  }
}
