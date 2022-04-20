import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/golden_ticket_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:video_player/video_player.dart';

class AutosaveWalkthrough extends StatefulWidget {
  @override
  _AutosaveWalkthroughState createState() => _AutosaveWalkthroughState();
}

class _AutosaveWalkthroughState extends State<AutosaveWalkthrough> {
  PageController _pageController;
  ValueNotifier<double> _pageNotifier;
  bool showLotties = false;
  GoldenTicketService _gtService = GoldenTicketService();
  final _analyticsService = locator<AnalyticsService>();
  VideoPlayerController _controller1, _controller2, _controller3;
  double slidelength1 = 0, slidelength2 = 0, slidelength3 = 0;

  final lottieList = [
    Assets.autosaveSlide1,
    Assets.autosaveSlide2,
    Assets.autosaveSlide3
  ];

  final titleList = ["SAVE", "PLAY", "WIN"];

  final descList = [
    "Save and invest in strong assets and earn tokens 🪙",
    "Use these tokens to play fun and exciting games 🎮",
    "Stand to win exclusive prizes and fun rewards 🎉"
  ];

  @override
  void initState() {
    _pageController = PageController();
    _pageController.addListener(_pageListener);
    _pageNotifier = ValueNotifier(0.0);
    _controller1 = VideoPlayerController.asset(lottieList[0])
      ..initialize().then((_) {
        setState(() {
          _controller1.setLooping(true);
          _controller1.play();
          showLotties = true;
          startTutorial();
        });
      });

    _controller2 = VideoPlayerController.asset(lottieList[1])
      ..initialize().then((_) {
        setState(() {
          _controller2.setLooping(true);
        });
      });

    _controller3 = VideoPlayerController.asset(lottieList[2])
      ..initialize().then((_) {
        setState(() {
          _controller3.setLooping(true);
        });
      });

    _analyticsService.track(eventName: AnalyticsEvents.signupDemo);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.removeListener(_pageListener);
    _pageController.dispose();
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  void _pageListener() {
    print(_pageController.page);
    _pageNotifier.value = _pageController.page;
    if (_pageController.page == 0.0) {
      _controller1.play();
    } else
      _controller1.pause();
    if (_pageController.page == 1.0)
      _controller2.play();
    else
      _controller2.pause();
    if (_pageController.page == 2.0)
      _controller3.play();
    else
      _controller3.pause();
  }

  startTutorial() async {
    if (mounted)
      setState(() {
        slidelength1 = SizeConfig.padding24;
      });
    await Future.delayed(Duration(seconds: 5), () {
      if (mounted) {
        _pageController.animateToPage(1,
            duration: Duration(seconds: 1), curve: Curves.linear);
        setState(() {
          slidelength2 = SizeConfig.padding24;
        });
      }
    });
    await Future.delayed(Duration(seconds: 13), () {
      if (mounted) {
        _pageController.animateToPage(2,
            duration: Duration(seconds: 1), curve: Curves.linear);
        setState(() {
          slidelength3 = SizeConfig.padding24;
        });
      }
    });
    await Future.delayed(Duration(seconds: 10), () {
      if (mounted) AppState.backButtonDispatcher.didPopRoute();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: HomeBackground(
      child: Column(
        children: [
          FelloAppBar(
            leading: FelloAppBarBackButton(),
            title: "Autosave Example",
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.pageHorizontalMargins),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(SizeConfig.padding40),
                  topRight: Radius.circular(SizeConfig.padding40),
                ),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.pageHorizontalMargins),
                  // ValueListenableBuilder(
                  //   valueListenable: _pageNotifier,
                  //   builder: (ctx, value, _) {
                  //     return Text(titleList[value.toInt()],
                  //         style: TextStyles.title1.bold);
                  //   },
                  // ),
                  ValueListenableBuilder(
                    valueListenable: _pageNotifier,
                    builder: (ctx, value, _) {
                      return Text(descList[value.toInt()],
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.clip,
                          style: TextStyles.body1);
                    },
                  ),
                  Spacer(),
                  showLotties
                      ? ValueListenableBuilder(
                          valueListenable: _pageNotifier,
                          builder: (ctx, value, _) {
                            return Container(
                              height: SizeConfig.screenHeight * 0.7,
                              width: SizeConfig.screenWidth,
                              child: PageView(
                                  // physics: NeverScrollableScrollPhysics(),
                                  controller: _pageController,
                                  children: [
                                    _controller1.value.isInitialized
                                        ? Slide(controller: _controller1)
                                        : AnimLoader(),
                                    _controller2.value.isInitialized
                                        ? Slide(controller: _controller2)
                                        : AnimLoader(),
                                    _controller3.value.isInitialized
                                        ? Slide(controller: _controller3)
                                        : AnimLoader(),
                                  ]),
                            );
                          },
                        )
                      : Container(
                          height: SizeConfig.screenWidth,
                          width: SizeConfig.screenWidth,
                          child: SpinKitWave(
                            size: SizeConfig.padding32,
                            color: UiConstants.primaryColor,
                          )),
                  Spacer(),

                  ValueListenableBuilder(
                      valueListenable: _pageNotifier,
                      builder: (ctx, value, _) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomProgressIndicator(slidelength: slidelength1),
                            SizedBox(width: SizeConfig.padding6),
                            CustomProgressIndicator(slidelength: slidelength2),
                            SizedBox(width: SizeConfig.padding6),
                            CustomProgressIndicator(slidelength: slidelength3),
                          ],
                        );
                      }),
                  SizedBox(height: SizeConfig.pageHorizontalMargins),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}

class CustomProgressIndicator extends StatelessWidget {
  const CustomProgressIndicator({
    Key key,
    @required this.slidelength,
  }) : super(key: key);

  final double slidelength;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.padding24,
      height: SizeConfig.padding4,
      decoration: BoxDecoration(
        color: UiConstants.scaffoldColor,
        borderRadius: BorderRadius.circular(SizeConfig.roundness12),
      ),
      alignment: Alignment.centerLeft,
      child: AnimatedContainer(
        decoration: BoxDecoration(
          color: UiConstants.primaryColor,
          borderRadius: BorderRadius.circular(SizeConfig.roundness12),
        ),
        duration: Duration(seconds: 5),
        curve: Curves.linear,
        height: SizeConfig.padding4,
        width: slidelength,
      ),
    );
  }
}

class AnimLoader extends StatelessWidget {
  const AnimLoader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitThreeBounce(
        color: UiConstants.primaryColor,
        size: SizeConfig.padding32,
      ),
    );
  }
}

class Slide extends StatelessWidget {
  Slide({@required this.controller});
  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      alignment: Alignment.center,
      child: AspectRatio(aspectRatio: 1 / 2, child: VideoPlayer(controller)),
    );
  }
}
