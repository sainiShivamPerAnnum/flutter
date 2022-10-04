import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/journey_service_enum.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/pages/hometabs/journey/Journey%20page%20elements/milestone_details_modal.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:vector_math/vector_math.dart' as vector;

class FocusRing extends StatefulWidget {
  const FocusRing({Key key}) : super(key: key);

  @override
  State<FocusRing> createState() => _FocusRingState();
}

class _FocusRingState extends State<FocusRing>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  Animation<double> endingAnimation;
  final _userService = locator<UserService>();
  final _journeyService = locator<JourneyService>();

  bool _showButton = false;

  get showButton => this._showButton;

  set showButton(value) {
    setState(() {
      this._showButton = value;
    });
  }

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    endingAnimation = CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0, 1.0, curve: Curves.decelerate));

    super.initState();
  }

  animateRing() {
    if (isAnimationComplete) return;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(Duration(seconds: 2), () {
        _animationController.forward().then((value) => showButton = true);
      });
    });
    isAnimationComplete = true;
  }

  bool isAnimationComplete = false;

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<JourneyService, JourneyServiceProperties>(
        properties: [
          JourneyServiceProperties.Onboarding,
          JourneyServiceProperties.AvatarRemoteMilestoneIndex
        ],
        builder: (context, m, properties) {
          log("Focus Ring build called");
          if (m.avatarRemoteMlIndex == 1 && m.isUserJourneyOnboarded)
            animateRing();
          return m.avatarRemoteMlIndex == 1 && m.isUserJourneyOnboarded
              ? Positioned(
                  bottom: m.pageHeight * 0.22,
                  left: SizeConfig.screenWidth * 0.4,
                  child: Container(
                    height: SizeConfig.screenWidth * 0.52,
                    width: SizeConfig.screenWidth * 0.48,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: IgnorePointer(
                            ignoring: true,
                            child: CustomPaint(
                              foregroundPainter: _DataBackupCompletedPainter(
                                  animation: endingAnimation),
                              child: AnimatedContainer(
                                duration: Duration(seconds: 1),
                                curve: Curves.easeInCubic,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: showButton
                                        ? [
                                            UiConstants.darkPrimaryColor
                                                .withOpacity(0.05),
                                            UiConstants.darkPrimaryColor
                                                .withOpacity(0.08),
                                            UiConstants.darkPrimaryColor
                                                .withOpacity(0.2),
                                            UiConstants.darkPrimaryColor
                                                .withOpacity(0.4),
                                            UiConstants.darkPrimaryColor
                                                .withOpacity(0.5),
                                          ]
                                        : [
                                            Colors.transparent,
                                            Colors.transparent,
                                          ],
                                  ),
                                ),
                                height: SizeConfig.screenWidth * 0.48,
                                width: SizeConfig.screenWidth * 0.48,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: AnimatedScale(
                            scale: showButton ? 1 : 0,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.bounceOut,
                            child: GestureDetector(
                              onTap: () {
                                return BaseUtil.openModalBottomSheet(
                                  backgroundColor: Colors.transparent,
                                  isBarrierDismissable: true,
                                  addToScreenStack: true,
                                  hapticVibrate: true,
                                  isScrollControlled: true,
                                  content: JourneyMilestoneDetailsModalSheet(
                                    milestone: m.currentMilestoneList[0],
                                    status: JOURNEY_MILESTONE_STATUS.ACTIVE,
                                  ),
                                );
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: SizeConfig.padding12,
                                      vertical: SizeConfig.padding8),
                                  child: Wrap(
                                    children: [
                                      Text("Build Profile",
                                          style: TextStyles.sourceSansM.body3),
                                      SvgPicture.asset(
                                        Assets.chevRonRightArrow,
                                        color: Colors.white,
                                        height: SizeConfig.iconSize1,
                                      ),
                                    ],
                                  )),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : SizedBox();
        });
  }
}

class _DataBackupCompletedPainter extends CustomPainter {
  _DataBackupCompletedPainter({this.animation}) : super(repaint: animation);

  Animation<double> animation;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final circlePath = Path();
    circlePath.addArc(
        Rect.fromCenter(
            center: Offset(size.width / 2, size.height / 2),
            width: size.width,
            height: size.height),
        vector.radians(-90.0),
        vector.radians(360.0 * animation.value));

    canvas.save();

    canvas.translate(size.width / 3, size.height / 2);

    canvas.rotate(vector.radians(-45));

    canvas.restore();

    canvas.drawPath(circlePath, paint);

    canvas.drawPath(circlePath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
