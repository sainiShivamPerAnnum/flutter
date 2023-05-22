import 'dart:math';

import 'package:felloapp/core/model/user_funt_wallet_model.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/pages/static/blur_filter.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../util/styles/styles.dart';

class Cards extends StatefulWidget {
  const Cards({Key? key}) : super(key: key);

  @override
  State<Cards> createState() => _CardsState();
}

class _CardsState extends State<Cards> with SingleTickerProviderStateMixin {
  // double bgWidth = SizeConfig.screenWidth!;
  ScrollController? controller;
  bool isHorizontalView = false;
  bool isVerticalView = false;
  Duration duration = const Duration(milliseconds: 400);
  Curve curve = Curves.decelerate;
  // Animation<double> gradientAnimation;
  double expandedViewHeightRatio = 1.54;

  AnimationController? gradientController;
  @override
  void initState() {
    gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(() {
        setState(() {});
      });

    controller = ScrollController()
      ..addListener(() {
        if (controller!.offset <= controller!.position.minScrollExtent) {
          print("Put cards back together");
          if (isHorizontalView) {
            setState(() {
              isHorizontalView = false;
            });
            Future.delayed(
              duration,
              () {
                gradientController?.reset();
                gradientController?.forward();
              },
            );
          }
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    gradientController?.dispose();
    super.dispose();
  }

  double _previousOffset = 0.0;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration,
      curve: curve,
      height: SizeConfig.screenWidth! *
          (isVerticalView ? expandedViewHeightRatio : 0.8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(SizeConfig.titleSize / 2),
          bottomRight: Radius.circular(SizeConfig.titleSize / 2),
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              offset: Offset(0, 5),
              spreadRadius: 8)
        ],
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (isHorizontalView) {
                  setState(() {
                    isHorizontalView = false;
                  });
                }
                double currentOffset = details.primaryDelta ?? 0;
                if (currentOffset > _previousOffset) {
                  if (!isVerticalView && mounted) {
                    setState(() {
                      isVerticalView = true;
                    });
                  }
                }

                _previousOffset = currentOffset;
              },
              onHorizontalDragEnd: (_) {
                if (isVerticalView) return;
                setState(() {
                  isHorizontalView = true;
                  controller?.jumpTo(0);
                });
              },
              onTap: () {
                // if (isVerticalView) {
                setState(() {
                  isVerticalView = !isVerticalView;
                  // });
                });
              },
              child: AnimatedContainer(
                curve: curve,
                duration: duration,
                width: SizeConfig.screenWidth! * (1),
                height: SizeConfig.screenWidth! *
                    (isVerticalView ? expandedViewHeightRatio : 0.78),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: AnimatedContainer(
                        curve: curve,
                        duration: duration,
                        width: SizeConfig.screenWidth! * (1),
                        height: SizeConfig.screenWidth! *
                            (isVerticalView ? expandedViewHeightRatio : 0.78),
                        decoration: BoxDecoration(
                          color: UiConstants.kBackgroundColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft:
                                Radius.circular(SizeConfig.titleSize / 2),
                            bottomRight:
                                Radius.circular(SizeConfig.titleSize / 2),
                          ),
                        ),
                        child: SingleChildScrollView(
                          controller: controller,
                          physics: isHorizontalView
                              ? const BouncingScrollPhysics()
                              : const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: AnimatedContainer(
                            curve: curve,
                            duration: duration,
                            padding: isVerticalView
                                ? EdgeInsets.symmetric(
                                    vertical: SizeConfig.pageHorizontalMargins,
                                    horizontal:
                                        SizeConfig.pageHorizontalMargins)
                                : EdgeInsets.only(
                                    top: SizeConfig.titleSize / 2,
                                    left: isHorizontalView
                                        ? 0
                                        : SizeConfig.titleSize / 2,
                                    right: SizeConfig.titleSize / 2,
                                    bottom: SizeConfig.titleSize / 2),
                            height: SizeConfig.screenWidth! *
                                (isVerticalView
                                    ? expandedViewHeightRatio
                                    : 0.78),
                            width: SizeConfig.screenWidth! *
                                (isHorizontalView ? 2.4 : 1),
                            child: Stack(
                              children: [
                                AnimatedPositioned(
                                  curve: curve,
                                  duration: duration,
                                  left: isVerticalView
                                      ? 0
                                      : isHorizontalView
                                          ? SizeConfig.screenWidth! * 1.63
                                          : SizeConfig.screenWidth! * 0.075 * 3,
                                  top: SizeConfig.screenWidth! *
                                      (isVerticalView
                                          ? 1.1
                                          : isHorizontalView
                                              ? 0.05
                                              : 0.088),
                                  child: Card(
                                    color: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          SizeConfig.titleSize / 3),
                                    ),
                                    margin: EdgeInsets.zero,
                                    child: AnimatedContainer(
                                      curve: curve,
                                      duration: duration,
                                      decoration: BoxDecoration(
                                        color: (!isVerticalView &&
                                                !isHorizontalView)
                                            ? UiConstants.kRewardColor
                                            : UiConstants.kRewardDarkColor,
                                        borderRadius: BorderRadius.circular(
                                            SizeConfig.titleSize / 3),
                                      ),
                                      height: SizeConfig.screenWidth! * 0.45 -
                                          (SizeConfig.screenWidth! *
                                              0.64 *
                                              0.03 *
                                              (isVerticalView
                                                  ? 7
                                                  : isHorizontalView
                                                      ? 0
                                                      : 2)),
                                      width: isVerticalView
                                          ? (SizeConfig.screenWidth! -
                                              SizeConfig.pageHorizontalMargins *
                                                  2)
                                          : SizeConfig.screenWidth! * 0.8 -
                                              (SizeConfig.screenWidth! *
                                                  0.8 *
                                                  0.04 *
                                                  4),
                                      child: CardContent(
                                        isHorizontalView: isHorizontalView,
                                        isVerticalView: isVerticalView,
                                        curve: curve,
                                        duration: duration,
                                        asset: Assets.dailyAppBonusHero,
                                        title: "Fello Rewards",
                                        infoTitle1: "Unclaimed Balance",
                                        infoTitle2: "Processing Balance",
                                        secondaryColor:
                                            UiConstants.kRewardColor,
                                        subtitle: "Redeem after reaching ₹200",
                                      ),
                                    ),
                                  ),
                                ),
                                AnimatedPositioned(
                                  curve: curve,
                                  duration: duration,
                                  left: isVerticalView
                                      ? 0
                                      : isHorizontalView
                                          ? SizeConfig.screenWidth! * 0.88
                                          : SizeConfig.screenWidth! * 0.078 * 2,
                                  top: SizeConfig.screenWidth! *
                                      (isVerticalView
                                          ? 0.75
                                          : isHorizontalView
                                              ? 0.05
                                              : 0.088),
                                  child: Card(
                                    color: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          SizeConfig.titleSize / 3),
                                    ),
                                    margin: EdgeInsets.zero,
                                    child: AnimatedContainer(
                                      curve: curve,
                                      duration: duration,
                                      decoration: BoxDecoration(
                                        color: (!isVerticalView &&
                                                !isHorizontalView)
                                            ? UiConstants.kGoldContainerColor
                                            : UiConstants.kGoldDarkColor,
                                        borderRadius: BorderRadius.circular(
                                            SizeConfig.titleSize / 3),
                                      ),
                                      height: SizeConfig.screenWidth! * 0.45 -
                                          (SizeConfig.screenWidth! *
                                              0.64 *
                                              0.03 *
                                              (isVerticalView
                                                  ? 7
                                                  : isHorizontalView
                                                      ? 0
                                                      : 2)),
                                      width: isVerticalView
                                          ? (SizeConfig.screenWidth! -
                                              SizeConfig.pageHorizontalMargins *
                                                  2)
                                          : SizeConfig.screenWidth! * 0.8 -
                                              (SizeConfig.screenWidth! *
                                                  0.8 *
                                                  0.04 *
                                                  3),
                                      child: CardContent(
                                        isHorizontalView: isHorizontalView,
                                        isVerticalView: isVerticalView,
                                        curve: curve,
                                        duration: duration,
                                        asset: Assets.goldAsset,
                                        title: "Digital Gold",
                                        infoTitle1: "Gold Value",
                                        infoTitle2: "Gold Amount",
                                        secondaryColor:
                                            UiConstants.kGoldContainerColor,
                                        subtitle:
                                            "Quick Returns • Withdraw anytime",
                                      ),
                                    ),
                                  ),
                                ),
                                AnimatedPositioned(
                                  curve: curve,
                                  duration: duration,
                                  left: isVerticalView
                                      ? 0
                                      : isHorizontalView
                                          ? SizeConfig.screenWidth! * 0.11
                                          : SizeConfig.screenWidth! * 0.09,
                                  top: SizeConfig.screenWidth! *
                                      (isVerticalView
                                          ? 0.4
                                          : isHorizontalView
                                              ? 0.05
                                              : 0.088),
                                  child: Card(
                                    color: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          SizeConfig.titleSize / 3),
                                    ),
                                    margin: EdgeInsets.zero,
                                    child: AnimatedContainer(
                                      curve: curve,
                                      duration: duration,
                                      decoration: BoxDecoration(
                                        color: (!isVerticalView &&
                                                !isHorizontalView)
                                            ? UiConstants.darkPrimaryColor3
                                            : UiConstants.darkPrimaryColor4,
                                        borderRadius: BorderRadius.circular(
                                            SizeConfig.titleSize / 3),
                                      ),
                                      height: SizeConfig.screenWidth! * 0.45 -
                                          (SizeConfig.screenWidth! *
                                              0.64 *
                                              0.03 *
                                              (isVerticalView
                                                  ? 7
                                                  : isHorizontalView
                                                      ? 0
                                                      : 2)),
                                      width: isVerticalView
                                          ? (SizeConfig.screenWidth! -
                                              SizeConfig.pageHorizontalMargins *
                                                  2)
                                          : SizeConfig.screenWidth! * 0.8 -
                                              (SizeConfig.screenWidth! *
                                                  0.8 *
                                                  0.04 *
                                                  2),
                                      child: CardContent(
                                        isHorizontalView: isHorizontalView,
                                        isVerticalView: isVerticalView,
                                        curve: curve,
                                        duration: duration,
                                        asset: Assets.floAsset,
                                        title: "Fello Flo",
                                        infoTitle1: "Flo Balance",
                                        infoTitle2: "Invested",
                                        secondaryColor:
                                            UiConstants.darkPrimaryColor3,
                                        subtitle:
                                            "Quick Returns • Withdraw anytime",
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      curve: curve,
                      duration: duration,
                      left: isVerticalView
                          ? 0
                          : isHorizontalView
                              ? -SizeConfig.screenWidth! * 0.8 * 0.9
                              : SizeConfig.titleSize / 2,
                      top:
                          SizeConfig.screenWidth! * (isVerticalView ? 0 : 0.05),
                      child: Material(
                        color: Colors.transparent,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    isVerticalView
                                        ? 0
                                        : SizeConfig.titleSize / 3),
                                child: BlurFilter(
                                  sigmaX: 10,
                                  sigmaY: 4,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(
                                          isVerticalView ? 0.8 : 0.4),
                                      borderRadius: BorderRadius.circular(
                                          isVerticalView
                                              ? 0
                                              : SizeConfig.titleSize / 3),
                                    ),
                                    height: SizeConfig.screenWidth! *
                                            (isVerticalView ? 0.42 : 0.5) -
                                        1,
                                    width: isVerticalView
                                        ? SizeConfig.screenWidth
                                        : SizeConfig.screenWidth! * 0.8 -
                                            (SizeConfig.screenWidth! *
                                                0.8 *
                                                0.04 *
                                                0) -
                                            1,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: SweepGradient(
                                  colors: const [
                                    Colors.transparent,
                                    Colors.transparent,
                                    Colors.transparent,
                                  ],
                                  // startAngle: 1,
                                  transform: GradientRotation(
                                      gradientController!.value * 6),
                                ),
                                borderRadius: BorderRadius.circular(
                                    isVerticalView
                                        ? 0
                                        : SizeConfig.titleSize / 3),
                              ),
                              height: SizeConfig.screenWidth! *
                                  (isVerticalView ? 0.42 : 0.5),
                              width: isVerticalView
                                  ? SizeConfig.screenWidth
                                  : SizeConfig.screenWidth! * 0.8 -
                                      (SizeConfig.screenWidth! *
                                          0.8 *
                                          0.04 *
                                          0),
                              padding: const EdgeInsets.all(1),
                              child: CustomPaint(
                                painter: GradientBorder(
                                    borderRadius: isVerticalView
                                        ? 0
                                        : SizeConfig.titleSize / 3,
                                    isVerticalView: isVerticalView,
                                    gradientController: gradientController!),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          SizeConfig.pageHorizontalMargins,
                                      vertical:
                                          SizeConfig.pageHorizontalMargins / 2),
                                  decoration: BoxDecoration(
                                    // color: Colors.black.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(
                                        isVerticalView
                                            ? 0
                                            : SizeConfig.titleSize / 3),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: SizeConfig.padding8),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Fello Balance",
                                                style: GoogleFonts.rajdhani(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white,
                                                  fontSize:
                                                      SizeConfig.titleSize *
                                                          0.6,
                                                ),
                                              ),
                                              Text(
                                                "Sum of all your assets on fello",
                                                style: GoogleFonts.sourceSans3(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey,
                                                  fontSize:
                                                      SizeConfig.titleSize *
                                                          0.4,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          isVerticalView
                                              ? OutlinedButton(
                                                  onPressed: () {},
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                    side: const BorderSide(
                                                        width: 1.0,
                                                        color: Colors.white),
                                                  ),
                                                  child: Text(
                                                    "View Breakdown",
                                                    style: TextStyles
                                                        .rajdhaniM.body3
                                                        .colour(Colors.white),
                                                  ),
                                                )
                                              : SvgPicture.asset(
                                                  Assets.chevRonRightArrow,
                                                  color: Colors.white,
                                                  width: SizeConfig.padding32,
                                                )
                                        ],
                                      ),
                                      const Spacer(),
                                      Row(
                                        children: [
                                          Selector<UserService,
                                              UserFundWallet?>(
                                            builder: (_, wallet, child) => Text(
                                              "₹${(wallet?.netWorth ?? 0).toInt()}",
                                              style: GoogleFonts.sourceSans3(
                                                fontWeight: FontWeight.w800,
                                                color: Colors.white,
                                                fontSize:
                                                    SizeConfig.titleSize * 1.2,
                                              ),
                                            ),
                                            selector: (_, userService) =>
                                                userService.userFundWallet,
                                          ),
                                          Icon(
                                            Icons.arrow_drop_up_outlined,
                                            color: Colors.green,
                                            size: SizeConfig.titleSize,
                                          ),
                                          Text(
                                            "0.05%",
                                            style: GoogleFonts.sourceSans3(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.green,
                                              fontSize:
                                                  SizeConfig.titleSize * 0.4,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (!isVerticalView)
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedOpacity(
                opacity: isVerticalView ? 0 : 1,
                curve: curve,
                duration: duration,
                child: Container(
                  margin: EdgeInsets.only(
                      bottom: SizeConfig.pageHorizontalMargins * 1.4),
                  child: MaterialButton(
                    minWidth: SizeConfig.screenWidth! -
                        SizeConfig.pageHorizontalMargins * 2,
                    color: Colors.white,
                    onPressed: () {
                      gradientController?.reset();
                      gradientController?.forward();
                    },
                    child: Text(
                      "SAVE",
                      style: TextStyles.rajdhaniB.body1.colour(Colors.black),
                    ),
                  ),
                ),
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Transform.translate(
              offset: Offset(0, SizeConfig.titleSize / 2.4),
              child: InkWell(
                onTap: () {
                  Haptic.vibrate();
                  if (isVerticalView) {
                    setState(() {
                      isVerticalView = false;
                    });
                    Future.delayed(duration, () {
                      gradientController?.reset();
                      gradientController?.forward();
                    });
                  } else {
                    setState(() {
                      isVerticalView = true;
                    });
                  }
                },
                child: AnimatedContainer(
                  duration: duration,
                  curve: curve,
                  height: SizeConfig.avatarRadius * 2,
                  width: isVerticalView
                      ? SizeConfig.padding90
                      : SizeConfig.avatarRadius * 2,
                  decoration: BoxDecoration(
                    color: UiConstants.kBackgroundColor,
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 15),
                          spreadRadius: 4)
                    ],
                  ),
                  child: Center(
                    child: AnimatedCrossFade(
                        firstChild: Icon(
                          isVerticalView
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          color: Colors.grey,
                        ),
                        secondChild: Text(
                          "CLOSE",
                          style: TextStyles.rajdhani.body3.letterSpace(2),
                        ),
                        crossFadeState: isVerticalView
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: duration),
                  ),
                ),
              ),
            ),
          ),
          if (!isHorizontalView)
            IgnorePointer(
              ignoring:
                  isHorizontalView || (!isHorizontalView && !isVerticalView),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isVerticalView = false;
                  });
                },
                onVerticalDragUpdate: (details) {
                  double currentOffset = details.primaryDelta ?? 0;
                  if (currentOffset < _previousOffset) {
                    // User is scrolling up
                    if (isVerticalView && mounted) {
                      setState(() {
                        isVerticalView = false;
                        print('IsVerticalView true');
                      });
                    }
                  }
                  _previousOffset = currentOffset;
                },
                child: Container(
                  color: Colors.transparent,
                  width: SizeConfig.screenWidth,
                  height: SizeConfig.screenWidth! * expandedViewHeightRatio,
                  child: Stack(
                    children: [
                      Positioned(
                        right: 0,
                        top: SizeConfig.screenWidth! * 0.26,
                        child: Padding(
                          padding: EdgeInsets.only(
                              right: SizeConfig.pageHorizontalMargins,
                              bottom: SizeConfig.pageHorizontalMargins),
                          child: AnimatedRotation(
                            duration: duration,
                            curve: curve,
                            turns: isVerticalView ? 0.25 : 0,
                            // angle: isVerticalView ? 1.55 : 0,
                            child: SvgPicture.asset("assets/vectors/swipeh.svg",
                                width: SizeConfig.titleSize,
                                height: SizeConfig.titleSize),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}

class CardContent extends StatelessWidget {
  const CardContent({
    required this.isHorizontalView,
    required this.isVerticalView,
    required this.curve,
    required this.duration,
    required this.title,
    required this.subtitle,
    required this.infoTitle1,
    required this.infoTitle2,
    this.message,
    required this.asset,
    required this.secondaryColor,
    super.key,
  });

  final bool isHorizontalView;
  final bool isVerticalView;
  final Curve curve;
  final Duration duration;
  final String title, subtitle, asset, infoTitle1, infoTitle2;
  final String? message;
  final Color secondaryColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isHorizontalView || isVerticalView ? 1 : 0,
      curve: curve,
      duration: duration,
      child: Column(
        children: [
          AnimatedContainer(
            curve: curve,
            duration: duration,
            height: (SizeConfig.screenWidth! * 0.45 -
                    (SizeConfig.screenWidth! *
                        0.64 *
                        0.03 *
                        (isVerticalView
                            ? 8
                            : isHorizontalView
                                ? 0
                                : 2))) /
                2,
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(SizeConfig.titleSize / 3),
                topRight: Radius.circular(SizeConfig.titleSize / 3),
              ),
            ),
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.pageHorizontalMargins / 2),
            child: Row(
              children: [
                SvgPicture.asset(
                  asset,
                  width: SizeConfig.padding64,
                ),
                SizedBox(width: SizeConfig.padding14),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyles.rajdhaniM.body0.colour(Colors.white),
                      ),
                      if (isHorizontalView)
                        FittedBox(
                          child: Text(
                            subtitle,
                            style: TextStyles.body3.colour(Colors.white54),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(width: SizeConfig.padding16),
                AnimatedCrossFade(
                  firstChild: MaterialButton(
                    minWidth: SizeConfig.padding40,
                    onPressed: () {},
                    color:
                        title == "Fello Rewards" ? Colors.black : Colors.white,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        title == "Fello Rewards" ? "REDEEM" : "SAVE",
                        style: TextStyles.rajdhaniB.body2.colour(
                          title == "Fello Rewards"
                              ? Colors.white
                              : secondaryColor,
                        ),
                      ),
                    ),
                  ),
                  secondChild: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        Assets.chevRonRightArrow,
                        color: Colors.white,
                        width: SizeConfig.iconSize0,
                      ),
                      SizedBox(
                        height: SizeConfig.padding12,
                      )
                    ],
                  ),
                  crossFadeState: isVerticalView
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  duration: duration,
                ),
                SizedBox(width: SizeConfig.padding8),
              ],
            ),
          ),
          AnimatedContainer(
            curve: curve,
            duration: duration,
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.padding16,
                vertical: SizeConfig.padding6),
            height: (SizeConfig.screenWidth! * 0.45 -
                    (SizeConfig.screenWidth! *
                        0.64 *
                        0.03 *
                        (isVerticalView
                            ? 8
                            : isHorizontalView
                                ? 0
                                : 2))) /
                2,
            child: Row(children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      infoTitle1,
                      style: TextStyles.rajdhaniSB.body3.colour(Colors.grey),
                    ),
                    SizedBox(height: SizeConfig.padding2),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        children: [
                          Selector<UserService, UserFundWallet?>(
                            builder: (_, wallet, child) => Text(
                              getFirstValue(wallet!, title),
                              style: TextStyles.sourceSansB.body0
                                  .colour(Colors.white),
                            ),
                            selector: (_, userService) =>
                                userService.userFundWallet,
                          ),
                          if (title != "Fello Rewards")
                            Row(
                              children: [
                                Icon(
                                  Icons.arrow_drop_up_outlined,
                                  color: Colors.green,
                                  size: SizeConfig.padding20,
                                ),
                                Text(
                                  "0.05%",
                                  style: GoogleFonts.sourceSans3(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.green,
                                    fontSize: SizeConfig.body4,
                                  ),
                                ),
                              ],
                            )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(width: SizeConfig.padding16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      infoTitle2,
                      style: TextStyles.rajdhaniSB.body3.colour(Colors.grey),
                    ),
                    SizedBox(height: SizeConfig.padding2),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Selector<UserService, UserFundWallet?>(
                        builder: (_, wallet, child) => Text(
                          getSecondValue(wallet!, title),
                          style:
                              TextStyles.sourceSansB.body0.colour(Colors.white),
                        ),
                        selector: (_, userService) =>
                            userService.userFundWallet,
                      ),
                    )
                  ],
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }

  String getFirstValue(UserFundWallet wallet, String title) {
    switch (title) {
      case "Fello Flo":
        return "₹${wallet.wLbBalance ?? 0.0}";
      case "Digital Gold":
        return "₹${wallet.augGoldBalance}";
      case "Fello Rewards":
        return "₹${wallet.unclaimedBalance}";
      default:
        return "-";
    }
  }

  String getSecondValue(UserFundWallet wallet, String title) {
    switch (title) {
      case "Fello Flo":
        return "₹${wallet.wLbPrinciple ?? 0.0}";
      case "Digital Gold":
        return "${wallet.augGoldQuantity}g";
      case "Fello Rewards":
        return "₹${wallet.processingRedemptionBalance}";
      default:
        return "-";
    }
  }
}

class GradientBorder extends CustomPainter {
  final AnimationController gradientController;
  final bool isVerticalView;
  final double borderRadius;
  GradientBorder(
      {required this.gradientController,
      required this.isVerticalView,
      required this.borderRadius});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final strokeWidth = 1.0;
    final gradientColors = [
      Colors.black26,
      isVerticalView ? Colors.black26 : Colors.grey,
      Colors.black26,
    ];

    // Draw the container background
    canvas.drawRect(
      rect,
      Paint()..color = Colors.transparent,
    );

    // Draw the outline border with sweep gradient
    final gradient = SweepGradient(
      colors: gradientColors,
      startAngle: 0.0,
      endAngle: pi * 2,
      transform: GradientRotation(gradientController.value * 6),
    );

    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    final outerPath = Path.combine(
      PathOperation.difference,
      Path()
        ..addRRect(
            RRect.fromRectAndRadius(rect, Radius.circular(borderRadius))),
      Path()
        ..addRRect(RRect.fromRectAndRadius(
            rect.deflate(strokeWidth / 2), Radius.circular(borderRadius))),
    );

    borderPaint.shader = gradient.createShader(rect);
    canvas.drawPath(outerPath, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
