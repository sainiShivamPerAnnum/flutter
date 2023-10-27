import 'dart:math';

import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/model/prizes_model.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/feature/tambola/src/ui/animations/dotted_border_animation.dart';
import 'package:felloapp/feature/tambola/src/ui/onboarding/tickets_intro_view.dart';
import 'package:felloapp/feature/tambola/src/ui/onboarding/tickets_tutorial_assets_view.dart';
import 'package:felloapp/feature/tambola/src/ui/widgets/ticket/tambola_ticket.dart';
import 'package:felloapp/feature/tambola/src/ui/widgets/ticket/ticket_painter.dart';
import 'package:felloapp/feature/tambola/tambola.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/extensions/rich_text_extension.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:vibration/vibration.dart';

class TicketsTutorialsSlotMachineView extends StatefulWidget {
  const TicketsTutorialsSlotMachineView({super.key});

  @override
  State<TicketsTutorialsSlotMachineView> createState() =>
      _TicketsTutorialsSlotMachineViewState();
}

class _TicketsTutorialsSlotMachineViewState
    extends State<TicketsTutorialsSlotMachineView>
    with TickerProviderStateMixin {
  int spinCount = 0;
  String _subtitle = "This is a dummy Ticket";
  String _slotMachineTitle = "Reveal Numbers to match with Tickets";

  String get slotMachineTitle => _slotMachineTitle;

  set slotMachineTitle(String value) {
    setState(() {
      _slotMachineTitle = value;
    });
  }

  String get subtitle => _subtitle;

  set subtitle(String value) {
    setState(() {
      _subtitle = value;
    });
  }

  late PageController _controller1, _controller2, _controller3;
  late ScrollController _scrollController;
  late AnimationController _animationController1,
      _animationController2,
      _shakeAnimController,
      _dottedLightsController;

  late Animation<double> _subtitle1Animation,
      _slotMachineAnimation,
      _subtitle2Animation,
      _prizesAnimation,
      _ctaAnimation;

  bool _isSlotMachineVisible = false;
  bool _isSpinning = false;
  double _slotMachineHeight = 0;
  bool _showConfetti = false;

  bool get showConfetti => _showConfetti;

  set showConfetti(bool value) {
    setState(() {
      _showConfetti = value;
    });
  }

  double get slotMachineHeight => _slotMachineHeight;

  set slotMachineHeight(double value) {
    setState(() {
      _slotMachineHeight = value;
    });
  }

  bool get isSlotMachineVisible => _isSlotMachineVisible;

  set isSlotMachineVisible(bool value) {
    setState(() {
      _isSlotMachineVisible = value;
    });
  }

  bool get isSpinning => _isSpinning;

  set isSpinning(bool value) {
    setState(() {
      _isSpinning = value;
    });
  }

  bool _highlightRow = false;
  bool get highlightRow => _highlightRow;

  set highlightRow(bool value) {
    setState(() {
      _highlightRow = value;
    });
  }

  List<int> calledDigits = [];

  List<int> ticketNumbers = [
    79,
    52,
    40,
    32,
    6,
    57,
    1,
    46,
    17,
    63,
    4,
    19,
    28,
    47,
    57
  ];

  @override
  void initState() {
    _controller1 = PageController(viewportFraction: 0.6, initialPage: 1);
    _controller2 = PageController(viewportFraction: 0.6, initialPage: 1);
    _controller3 = PageController(viewportFraction: 0.6, initialPage: 1);
    _scrollController = ScrollController();

    _shakeAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _dottedLightsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

//Animation Controller 1 Kit
    _animationController1 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _slotMachineAnimation = CurvedAnimation(
      parent: _animationController1,
      curve: const Interval(0.0, 0.6, curve: Curves.decelerate),
    );
    _subtitle1Animation = CurvedAnimation(
      parent: _animationController1,
      curve: const Interval(0.7, 1.0, curve: Curves.easeOutExpo),
    );

//Animation Controller 2 Kit
    _animationController2 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _subtitle2Animation = CurvedAnimation(
      parent: _animationController2,
      curve: const Interval(0.0, 0.2, curve: Curves.decelerate),
    );
    _prizesAnimation = CurvedAnimation(
      parent: _animationController2,
      curve: const Interval(0.3, 0.8, curve: Curves.decelerate),
    );
    _ctaAnimation = CurvedAnimation(
      parent: _animationController2,
      curve: const Interval(0.9, 1.0, curve: Curves.decelerate),
    );

//Initial Animation
    Future.delayed(const Duration(milliseconds: 1500), () {
      showConfetti = true;
      Vibration.vibrate(duration: 200);
    }).then(
      (value) => Future.delayed(const Duration(milliseconds: 2000), () {
        showConfetti = false;
        subtitle = "";
        isSlotMachineVisible = true;
        slotMachineHeight = SizeConfig.screenWidth! * 0.8;
      }).then(
        (value) => Future.delayed(
          const Duration(seconds: 1),
          () {
            Vibration.vibrate(pattern: [10, 80, 600, 80]);
            _animationController1
                .forward()
                .then((value) => Future.delayed(const Duration(seconds: 1), () {
                      _shakeAnimController.forward();
                      Haptic.shakeVibrate();
                      subtitle = "Reveal the numbers to match\nwith tickets";
                    }));
          },
        ),
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _animationController1.dispose();
    _animationController2.dispose();
    _shakeAnimController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void spin() {
    _shakeAnimController.stop();
    if (!_isSpinning && spinCount < 2) {
      isSpinning = true;
      AppState.blockNavigation();
      _controller1.jumpToPage(0);
      _controller2.jumpToPage(0);
      _controller3.jumpToPage(0);
      updateAnimationSpeed(300);
      Haptic.vibrate();
      Haptic.slotVibrate();
      if (spinCount == 0) {
        _controller1.animateToPage(45,
            duration: const Duration(seconds: 2), curve: Curves.easeOutExpo);
        _controller2.animateToPage(16,
            duration: const Duration(seconds: 3), curve: Curves.easeOutExpo);
        _controller3.animateToPage(63,
            duration: const Duration(seconds: 4), curve: Curves.easeOutExpo);
      } else {
        _controller1.animateToPage(78,
            duration: const Duration(seconds: 2), curve: Curves.easeOutExpo);
        _controller2.animateToPage(3,
            duration: const Duration(seconds: 3), curve: Curves.easeOutExpo);
        _controller3.animateToPage(20,
            duration: const Duration(seconds: 4), curve: Curves.easeOutExpo);
        _dottedLightsController.stop();
      }

      Future.delayed(const Duration(milliseconds: 3200), () {
        if (spinCount == 0) {
          updateAnimationSpeed(1000);
          calledDigits.addAll([46, 17, 64]);
          slotMachineTitle = "2 numbers matched!!";
          subtitle = "Spin to reveal rewards";
          locator<AnalyticsService>()
              .track(eventName: AnalyticsEvents.spin1InTutorial);
        } else {
          calledDigits.addAll([79, 4, 20]);
          _dottedLightsController.stop();
          subtitle = "";
          slotMachineTitle = "Congratulations! 4 Numbers matched";
          Future.delayed(const Duration(seconds: 1), () {
            _animationController2.forward();
            slotMachineHeight = SizeConfig.screenWidth! * 0.68;
            _scrollController
                .animateTo(_scrollController.position.maxScrollExtent,
                    duration: const Duration(seconds: 2),
                    curve: Curves.easeInExpo)
                .then((value) => Future.delayed(const Duration(seconds: 1), () {
                      highlightRow = true;
                    }));
          });
          locator<AnalyticsService>()
              .track(eventName: AnalyticsEvents.spin2InTutorial);
        }
        spinCount++;
        AppState.unblockNavigation();
        isSpinning = false;
      });
    }
  }

  void updateAnimationSpeed(int speed) {
    _dottedLightsController.stop();
    _dottedLightsController.duration = Duration(milliseconds: speed);
    _dottedLightsController.repeat(reverse: true);
  }

  void updateAnimationCurve(Curve curve) {
    _dottedLightsController.stop();
    _dottedLightsController.reset();
    _dottedLightsController.duration =
        Duration(seconds: _dottedLightsController.duration!.inSeconds);
    _dottedLightsController.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiConstants.kBackgroundColor,
      body: SizedBox(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
        child: Stack(
          children: [
            Positioned(
              top: SizeConfig.screenHeight! * 0.1,
              left: -SizeConfig.screenWidth! / 3,
              child: const RotatingPolkaDotsWidget(),
            ),
            Positioned(
              top: SizeConfig.screenHeight! * 0.1,
              right: -SizeConfig.screenWidth! / 3,
              child: const RotatingPolkaDotsWidget(),
            ),
            if (showConfetti)
              IgnorePointer(
                child: SizedBox(
                  height: SizeConfig.screenHeight,
                  width: SizeConfig.screenWidth,
                  child: Lottie.asset(
                    Assets.gtConfetti,
                    fit: BoxFit.cover,
                    alignment: Alignment.centerLeft,
                  ),
                ),
              ),
            SafeArea(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: kToolbarHeight / 2),
                    CustomStaggeredAnimatedWidget(
                      animation: _subtitle1Animation,
                      child: const Head(),
                    ),
                    SizedBox(height: SizeConfig.padding10),
                    TopInfoWidget(subtitle: subtitle),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 1500),
                      height: slotMachineHeight,
                      curve: Curves.easeOutExpo,
                      child: CustomStaggeredAnimatedWidget(
                        animation: _slotMachineAnimation,
                        child: Container(
                          width: SizeConfig.screenWidth,
                          margin:
                              EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                          padding:
                              EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(SizeConfig.roundness16),
                            color: UiConstants.darkPrimaryColor,
                          ),
                          child: Column(
                            children: [
                              Text(
                                slotMachineTitle,
                                style: TextStyles.sourceSansB.body2
                                    .colour(Colors.white),
                              ),
                              Padding(
                                padding: EdgeInsets.all(SizeConfig.padding16),
                                child: AnimatedDottedRectangle(
                                  controller: _dottedLightsController,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          SizeConfig.roundness16),
                                      color: Colors.black,
                                    ),
                                    margin:
                                        EdgeInsets.all(SizeConfig.padding16),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: PageView.builder(
                                            controller: _controller1,
                                            scrollDirection: Axis.vertical,
                                            itemCount: 90,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemBuilder: (ctx, i) => Container(
                                              alignment: Alignment.center,
                                              height: SizeConfig.title50,
                                              child: Text(
                                                i == 1
                                                    ? "Spin"
                                                    : "${i + 1}"
                                                        .padLeft(2, '0'),
                                                style: TextStyles
                                                    .rajdhaniSB.title1
                                                    .colour(Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: PageView.builder(
                                            controller: _controller2,
                                            scrollDirection: Axis.vertical,
                                            itemCount: 90,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemBuilder: (ctx, i) => Container(
                                              alignment: Alignment.center,
                                              height: SizeConfig.title50,
                                              child: Text(
                                                i == 1
                                                    ? "to"
                                                    : "${i + 1}"
                                                        .padLeft(2, '0'),
                                                style: TextStyles
                                                    .rajdhaniSB.title1
                                                    .colour(Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: PageView.builder(
                                            controller: _controller3,
                                            scrollDirection: Axis.vertical,
                                            itemCount: 90,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemBuilder: (ctx, i) => Container(
                                              alignment: Alignment.center,
                                              height: SizeConfig.title50,
                                              child: Text(
                                                i == 1
                                                    ? "Win"
                                                    : "${i + 1}"
                                                        .padLeft(2, '0'),
                                                style: TextStyles
                                                    .rajdhaniSB.title1
                                                    .colour(Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              AnimatedSwitcher(
                                duration: const Duration(seconds: 1),
                                switchInCurve: Curves.easeOutExpo,
                                switchOutCurve: Curves.easeInExpo,
                                transitionBuilder: (child, animation) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: ScaleTransition(
                                      scale: animation,
                                      child: child,
                                    ),
                                  );
                                },
                                child: spinCount < 2
                                    ? AnimatedBuilder(
                                        animation: _shakeAnimController,
                                        builder: (ctx, child) {
                                          final sineValue = sin(5 *
                                              2 *
                                              pi *
                                              _shakeAnimController.value);
                                          return Transform.translate(
                                            offset: Offset(sineValue * 5, 0),
                                            child: child,
                                          );
                                        },
                                        child: MaterialButton(
                                          height: SizeConfig.padding44,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      SizeConfig.roundness5)),
                                          minWidth:
                                              SizeConfig.screenWidth! * 0.3,
                                          enableFeedback: !isSpinning,
                                          color: isSpinning
                                              ? Colors.grey
                                              : Colors.white,
                                          onPressed: spin,
                                          child: Text(
                                            "SPIN : ${2 - spinCount}",
                                            style: TextStyles.rajdhaniB.body0
                                                .colour(Colors.black),
                                          ),
                                        ),
                                      )
                                    : const SizedBox(),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    WinningTicketWidget(
                      spinCount: spinCount,
                      calledDigits: calledDigits,
                      ticketNumbers: ticketNumbers,
                    ),
                    CustomStaggeredAnimatedWidget(
                      animation: _subtitle2Animation,
                      child: Column(
                        children: [
                          Text(
                            "4 Numbers Matched",
                            style: TextStyles.sourceSansB.body1
                                .colour(Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: SizeConfig.pageHorizontalMargins,
                              vertical: SizeConfig.padding16,
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.padding16,
                                vertical: SizeConfig.padding12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: UiConstants.primaryColor, width: 1),
                              borderRadius:
                                  BorderRadius.circular(SizeConfig.roundness12),
                              color: UiConstants.kFloContainerColor,
                            ),
                            child: Row(children: [
                              Text(
                                "1",
                                style: TextStyles.rajdhaniB.body1
                                    .colour(Colors.white),
                              ),
                              SizedBox(width: SizeConfig.padding4),
                              Text(
                                "Ticket",
                                style: TextStyles.body2.colour(Colors.white54),
                              ),
                              const Spacer(),
                              RichText(
                                text: TextSpan(
                                  text: (AppConfig.getValue(AppConfigKey
                                                  .ticketsCategories)[
                                              'category_1'] ??
                                          "5-7")
                                      .toString()
                                      .split(' ')
                                      .first,
                                  style: TextStyles.rajdhaniB.body1
                                      .colour(Colors.white),
                                  children: [
                                    WidgetSpan(
                                      child:
                                          SizedBox(width: SizeConfig.padding4),
                                    ),
                                    TextSpan(
                                      text: (AppConfig.getValue(AppConfigKey
                                                      .ticketsCategories)[
                                                  'category_1'] ??
                                              "5-7")
                                          .toString()
                                          .split(' ')
                                          .last,
                                      style: TextStyles.sourceSans.body2
                                          .colour(Colors.white54),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                          )
                        ],
                      ),
                    ),
                    CustomStaggeredAnimatedWidget(
                      animation: _prizesAnimation,
                      child: TicketsRewardCategoriesWidget(
                        highlightRow: highlightRow,
                        isOpen: true,
                      ),
                    ),
                    CustomStaggeredAnimatedWidget(
                      animation: _ctaAnimation,
                      child: MaterialButton(
                        height: SizeConfig.padding44,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(SizeConfig.roundness5)),
                        minWidth: SizeConfig.screenWidth! -
                            SizeConfig.pageHorizontalMargins * 2,
                        color: Colors.white,
                        onPressed: () {
                          Haptic.vibrate();
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: const Duration(seconds: 1),
                              pageBuilder: (_, __, ___) =>
                                  const TicketsTutorialsView(),
                            ),
                          );
                          locator<AnalyticsService>().track(
                              eventName: AnalyticsEvents.howTicketsWorkTapped);
                          // AppState.delegate!.appState.currentAction =
                          //     PageAction(
                          //   page: AssetSelectionViewConfig,
                          //   widget:
                          //       const AssetSelectionPage(showOnlyFlo: false),
                          //   state: PageState.replaceWidget,
                          // );
                        },
                        child: Text(
                          "PROCEED",
                          style:
                              TextStyles.rajdhaniB.body0.colour(Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(height: SizeConfig.pageHorizontalMargins)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WinningTicketWidget extends StatelessWidget {
  const WinningTicketWidget({
    required this.spinCount,
    required this.calledDigits,
    required this.ticketNumbers,
    super.key,
  });

  final int spinCount;
  final List<int> calledDigits;
  final List<int> ticketNumbers;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      height: MediaQuery.of(context).size.width * 0.6,
      margin: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            painter: TicketPainter(
                borderColor: spinCount == 2
                    ? UiConstants.primaryColor
                    : Colors.transparent),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.padding16,
                vertical: SizeConfig.padding16,
              ),
              width: MediaQuery.of(context).size.width * 0.7,
              decoration: BoxDecoration(
                // color: UiConstants.kBuyTicketBg,
                borderRadius: BorderRadius.circular(SizeConfig.roundness5),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        '#1234567890',
                        style: TextStyles.sourceSans.body4
                            .colour(UiConstants.kGreyTextColor),
                      ),
                      const Spacer(),
                      AnimatedCrossFade(
                        crossFadeState: calledDigits.length == 6
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        duration: const Duration(seconds: 1),
                        sizeCurve: Curves.easeOutExpo,
                        firstChild: Text(
                          "4 Matches",
                          style: TextStyles.sourceSansB.body3
                              .colour(UiConstants.primaryColor),
                        ),
                        secondChild: Text(
                          calledDigits.length == 3 ? "2 Matches" : "",
                          style: TextStyles.sourceSansB.body4
                              .colour(UiConstants.primaryColor),
                        ),
                      )
                    ],
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: SizeConfig.padding20),
                    alignment: Alignment.center,
                    child: MySeparator(
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                  GridView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: ticketNumbers.length,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 1,
                    ),
                    itemBuilder: (ctx, i) {
                      return AnimatedContainer(
                        duration: const Duration(seconds: 2),
                        curve: Curves.decelerate,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: calledDigits.contains(ticketNumbers[i])
                              ? UiConstants.kSaveDigitalGoldCardBg
                                  .withOpacity(0.7)
                              : Colors.transparent,
                          borderRadius:
                              (calledDigits.contains(ticketNumbers[i]))
                                  ? BorderRadius.circular(100)
                                  : BorderRadius.circular(
                                      SizeConfig.blockSizeHorizontal * 1),
                          border: Border.all(
                              color: (calledDigits.contains(ticketNumbers[i]))
                                  ? const Color(0xff93B5FE)
                                  : Colors.white.withOpacity(
                                      ticketNumbers[i] == 0 ? 0.4 : 0.7),
                              width: calledDigits.contains(ticketNumbers[i])
                                  ? 0.0
                                  : ticketNumbers[i] == 0
                                      ? 0.5
                                      : 0.7),
                        ),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                ticketNumbers[i].toString(),
                                style: TextStyles.rajdhaniB.body2.colour(
                                    calledDigits.contains(ticketNumbers[i])
                                        ? Colors.white
                                        : Colors.white54),
                              ),
                            ),
                            calledDigits.contains(ticketNumbers[i])
                                ? const DigitStrike()
                                : const SizedBox()
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          const Align(
              alignment: Alignment.topCenter, child: TicketTag(tag: "New"))
        ],
      ),
    );
  }
}

class TopInfoWidget extends StatelessWidget {
  final String subtitle;

  const TopInfoWidget({required this.subtitle, super.key});

  @override
  Widget build(BuildContext context) {
    return
        // CustomStaggeredAnimatedWidget(
        //   animation: _subtitle1Animation,
        //   child:
        Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          subtitle,
          style: TextStyles.sourceSansSB.body0.colour(Colors.white),
          textAlign: TextAlign.center,
        ),
        // SizedBox(height: SizeConfig.padding10),
        // Text(
        //   "( Don’t worry, if you forget we will do it for you )",
        //   style:
        //       TextStyles.sourceSansSB.body3.colour(UiConstants.primaryColor),
        //   textAlign: TextAlign.center,
        // ),
      ],
      // ),
    );
  }
}

class Head extends StatelessWidget {
  const Head({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Hero(
          tag: "mainAsset",
          child: SvgPicture.asset(
            Assets.tambolaCardAsset,
            width: SizeConfig.padding70,
          ),
        ),
        Hero(
          tag: "mainTitle",
          child: Material(
            color: Colors.transparent,
            child: Stack(
              children: [
                Text(
                  "Tickets",
                  style: TextStyles.rajdhaniB.title1.colour(Colors.white),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TicketsRewardCategoriesWidget extends StatelessWidget {
  const TicketsRewardCategoriesWidget(
      {required this.highlightRow,
      super.key,
      this.color,
      this.isOpen = false,
      this.hasMargin = true});

  final bool highlightRow;
  final bool hasMargin;
  final Color? color;
  final bool isOpen;

  @override
  Widget build(BuildContext context) {
    // final List<Tuple2<String, String>> categories = [
    //   const Tuple2("5-7 Matches", "₹ 50,000"),
    //   const Tuple2("8-9 Matches", "₹ 70,000"),
    //   const Tuple2("10-13 Matches", "₹ 100,000"),
    //   const Tuple2("14-15 Matches", "iPhone"),
    // ];
    return Container(
      margin: hasMargin
          ? EdgeInsets.symmetric(
              horizontal: SizeConfig.pageHorizontalMargins,
              vertical: SizeConfig.padding16,
            )
          : EdgeInsets.zero,
      padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
      decoration: BoxDecoration(
        color: color ?? UiConstants.kArrowButtonBackgroundColor,
        borderRadius: BorderRadius.circular(SizeConfig.roundness16),
      ),
      child: Selector<TambolaService, Tuple2<PrizesModel?, bool>>(
          selector: (_, tambolaService) =>
              Tuple2(tambolaService.tambolaPrizes, tambolaService.isCollapsed),
          builder: (context, value, child) {
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    locator<TambolaService>().isCollapsed =
                        !locator<TambolaService>().isCollapsed;
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        Assets.tambolaPrizeAsset,
                        width: SizeConfig.padding36,
                      ),
                      SizedBox(width: SizeConfig.padding6),
                      Text(
                        "Reward Categories",
                        style:
                            TextStyles.sourceSansSB.body1.colour(Colors.white),
                      ),
                      const Spacer(),
                      value.item2
                          ? Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Colors.grey,
                              size: SizeConfig.iconSize0,
                            )
                          : Icon(
                              Icons.keyboard_arrow_up_rounded,
                              color: Colors.grey,
                              size: SizeConfig.iconSize0,
                            ),
                    ],
                  ),
                ),
                isOpen
                    ? Column(
                        children: [
                          value.item1 != null
                              ? ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.symmetric(
                                      vertical: SizeConfig.padding14),
                                  itemCount: value.item1!.prizes!.length,
                                  itemBuilder: (ctx, index) => AnimatedSwitcher(
                                    duration: const Duration(seconds: 1),
                                    switchInCurve: Curves.easeOutExpo,
                                    switchOutCurve: Curves.easeOutExpo,
                                    child: ListTile(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: SizeConfig.padding10),
                                        title: Text(
                                          value.item1!.prizes![index]
                                                  .displayName ??
                                              "",
                                          style: TextStyles.rajdhaniB.body1
                                              .colour(index == 0 && highlightRow
                                                  ? UiConstants.primaryColor
                                                  : Colors.white),
                                        ),
                                        subtitle: Text(
                                          "Category",
                                          style: TextStyles.sourceSans.body3
                                              .colour(Colors.white38),
                                        ),
                                        trailing: (value.item1!.prizes![index]
                                                    .displayPrize ??
                                                "")
                                            .beautify(
                                          style: TextStyles.sourceSans.body1
                                              .colour(index == 0 && highlightRow
                                                  ? UiConstants.primaryColor
                                                  : Colors.white),
                                          boldStyle: TextStyles.sourceSans.body1
                                              .colour(index == 0 && highlightRow
                                                  ? UiConstants.primaryColor
                                                  : Colors.white),
                                        )
                                        //  Text(
                                        //   value.item1!.prizes![index]
                                        //           .displayPrize. ??
                                        //       "",
                                        // style: TextStyles.sourceSansB.body1
                                        //     .colour(index == 0 && highlightRow
                                        //         ? UiConstants.primaryColor
                                        //         : Colors.white),
                                        // ),
                                        ),
                                  ),
                                  separatorBuilder: (context, index) =>
                                      index != value.item1!.prizes!.length - 1
                                          ? const Divider(
                                              color: Colors.white10,
                                            )
                                          : const SizedBox(),
                                )
                              : const SizedBox(),
                          Text(
                            "Rewards are distributed every Monday among all the Tickets winning in a category",
                            style: TextStyles.body3.colour(Colors.white30),
                            textAlign: TextAlign.center,
                          )
                        ],
                      )
                    : value.item2
                        ? const SizedBox()
                        : Column(
                            children: [
                              value.item1 != null
                                  ? ListView.separated(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.symmetric(
                                          vertical: SizeConfig.padding14),
                                      itemCount: value.item1!.prizes!.length,
                                      itemBuilder: (ctx, index) =>
                                          AnimatedSwitcher(
                                        duration: const Duration(seconds: 1),
                                        switchInCurve: Curves.easeOutExpo,
                                        switchOutCurve: Curves.easeOutExpo,
                                        child: ListTile(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal:
                                                        SizeConfig.padding10),
                                            title: Text(
                                              value.item1!.prizes![index]
                                                      .displayName ??
                                                  "",
                                              style: TextStyles.rajdhaniB.body1
                                                  .colour(index == 0 &&
                                                          highlightRow
                                                      ? UiConstants.primaryColor
                                                      : Colors.white),
                                            ),
                                            subtitle: Text(
                                              "Category",
                                              style: TextStyles.sourceSans.body3
                                                  .colour(Colors.white38),
                                            ),
                                            trailing: (value
                                                        .item1!
                                                        .prizes![index]
                                                        .displayPrize ??
                                                    "")
                                                .beautify(
                                              style: TextStyles.sourceSans.body1
                                                  .colour(index == 0 &&
                                                          highlightRow
                                                      ? UiConstants.primaryColor
                                                      : Colors.white),
                                              boldStyle: TextStyles
                                                  .sourceSans.body1
                                                  .colour(index == 0 &&
                                                          highlightRow
                                                      ? UiConstants.primaryColor
                                                      : Colors.white),
                                            )
                                            //  Text(
                                            //   value.item1!.prizes![index]
                                            //           .displayPrize. ??
                                            //       "",
                                            // style: TextStyles.sourceSansB.body1
                                            //     .colour(index == 0 && highlightRow
                                            //         ? UiConstants.primaryColor
                                            //         : Colors.white),
                                            // ),
                                            ),
                                      ),
                                      separatorBuilder: (context, index) =>
                                          index !=
                                                  value.item1!.prizes!.length -
                                                      1
                                              ? const Divider(
                                                  color: Colors.white10,
                                                )
                                              : const SizedBox(),
                                    )
                                  : const SizedBox(),
                              Text(
                                "Rewards are distributed every Monday among all the Tickets winning in a category",
                                style: TextStyles.body3.colour(Colors.white30),
                                textAlign: TextAlign.center,
                              )
                            ],
                          )
              ],
            );
          }),
    );
  }
}
