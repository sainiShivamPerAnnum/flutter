import 'dart:ui';

import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WalkThroughPage extends StatefulWidget {
  @override
  _WalkThroughPageState createState() => _WalkThroughPageState();
}

class _WalkThroughPageState extends State<WalkThroughPage> {
  PageController _pageController;
  ValueNotifier<double> _pageNotifier;
  bool showLotties = false;

  List<String> lottieList = [Assets.onb1, Assets.onb2, Assets.onb3];
  List<String> titleList = ["SAVE", "PLAY", "WIN"];
  List<String> descList = [
    "Save and invest in strong assets and earn tokens 🪙",
    "Use these tokens to play fun and exciting games 🎮",
    "Stand to win exclusive prizes and fun rewards 🎉"
  ];
  @override
  void initState() {
    _pageController = PageController();
    _pageController.addListener(_pageListener);
    _pageNotifier = ValueNotifier(0.0);
    Future.delayed(Duration(milliseconds: 800), () {
      setState(() {
        showLotties = true;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.removeListener(_pageListener);
    _pageController.dispose();
    super.dispose();
  }

  void _pageListener() {
    print(_pageController.page);
    _pageNotifier.value = _pageController.page;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: HomeBackground(
      child: SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: SizeConfig.screenHeight * 0.04),
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
              Spacer(),
              ValueListenableBuilder(
                valueListenable: _pageNotifier,
                builder: (ctx, value, _) {
                  return Text(titleList[value.toInt()],
                      style: TextStyles.title1.bold);
                },
              ),
              Spacer(),
              Container(
                height: SizeConfig.screenHeight * 0.38,
                width: SizeConfig.screenHeight * 0.38,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: CustomPaint(
                        painter: LottieBackground(),
                        size: Size(
                            SizeConfig.screenHeight * 0.4,
                            (SizeConfig.screenHeight * 0.4 * 0.9779874213836478)
                                .toDouble()),
                      ),
                    ),
                    showLotties
                        ? ValueListenableBuilder(
                            valueListenable: _pageNotifier,
                            builder: (ctx, value, _) {
                              return Positioned(
                                child: Container(
                                  height: SizeConfig.screenWidth,
                                  width: SizeConfig.screenWidth,
                                  child: PageView(
                                    controller: _pageController,
                                    children: [
                                      Transform.scale(
                                        scale: 1.2,
                                        child: Lottie.asset(
                                          Assets.onb1,
                                          animate: value != 0.0 ? false : true,
                                          height: SizeConfig.screenWidth,
                                          width: SizeConfig.screenWidth,
                                        ),
                                      ),
                                      Transform.scale(
                                        scale: 1.1,
                                        child: Lottie.asset(
                                          Assets.onb2,
                                          animate: value != 1.0 ? false : true,
                                          height: SizeConfig.screenWidth,
                                          width: SizeConfig.screenWidth,
                                        ),
                                      ),
                                      Lottie.asset(
                                        Assets.onb3,
                                        animate: value != 2.0 ? false : true,
                                        height: SizeConfig.screenWidth,
                                        width: SizeConfig.screenWidth,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : Positioned(
                            child: Container(
                              height: SizeConfig.screenWidth,
                              width: SizeConfig.screenWidth,
                              child: PageView(
                                controller: _pageController,
                                children: [
                                  Transform.scale(
                                    scale: 1.2,
                                    child: Lottie.asset(
                                      Assets.onb1,
                                      height: SizeConfig.screenWidth,
                                      animate: false,
                                      width: SizeConfig.screenWidth,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(
                  SizeConfig.screenHeight * 0.03,
                ),
                child: ValueListenableBuilder(
                  valueListenable: _pageNotifier,
                  builder: (ctx, value, _) {
                    return Text(descList[value.toInt()],
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.clip,
                        style: TextStyles.body1);
                  },
                ),
              ),
              ValueListenableBuilder(
                  valueListenable: _pageNotifier,
                  builder: (ctx, value, _) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TabPageSelectorIndicator(
                            backgroundColor: value.toInt() == 0
                                ? UiConstants.primaryColor
                                : Colors.grey[400],
                            borderColor: value.toInt() == 0
                                ? UiConstants.primaryColor
                                : Colors.grey[400],
                            size: 10),
                        TabPageSelectorIndicator(
                            backgroundColor: value.toInt() == 1
                                ? UiConstants.primaryColor
                                : Colors.grey[400],
                            borderColor: value.toInt() == 1
                                ? UiConstants.primaryColor
                                : Colors.grey[400],
                            size: 10),
                        TabPageSelectorIndicator(
                            backgroundColor: value.toInt() == 2
                                ? UiConstants.primaryColor
                                : Colors.grey[400],
                            borderColor: value.toInt() == 2
                                ? UiConstants.primaryColor
                                : Colors.grey[400],
                            size: 10),
                      ],
                    );
                  }),
              Spacer(),
              Container(
                width: SizeConfig.screenWidth,
                child: ValueListenableBuilder(
                  valueListenable: _pageNotifier,
                  builder: (ctx, value, _) {
                    return FelloButtonLg(
                      child: Text(
                        value.toInt() == 2 ? "FINISH" : "NEXT",
                        style: TextStyles.body2.bold.colour(Colors.white),
                      ),
                      onPressed: () {
                        value.toInt() == 2
                            ? AppState.backButtonDispatcher.didPopRoute()
                            : _pageController.nextPage(
                                duration: Duration(milliseconds: 400),
                                curve: Curves.easeIn);
                      },
                    );
                  },
                ),
              ),
              TextButton(
                onPressed: () {
                  AppState.backButtonDispatcher.didPopRoute();
                },
                child: Text(
                  "Skip",
                  style: TextStyles.body3.colour(Colors.grey),
                ),
              ),
              SizedBox(
                height: kToolbarHeight / 2,
              )
            ],
          ),
        ),
      ),
    ));
  }
}

class LottieBackground extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(0, size.height * 0.2885122);
    path_0.cubicTo(
        0,
        size.height * 0.2062489,
        size.width * 0.04534874,
        size.height * 0.1310103,
        size.width * 0.1172173,
        size.height * 0.09403633);
    path_0.cubicTo(
        size.width * 0.3580252,
        size.height * -0.02985167,
        size.width * 0.6419748,
        size.height * -0.02985167,
        size.width * 0.8827830,
        size.height * 0.09403633);
    path_0.cubicTo(size.width * 0.9546509, size.height * 0.1310103, size.width,
        size.height * 0.2062489, size.width, size.height * 0.2885122);
    path_0.lineTo(size.width, size.height * 0.7643151);
    path_0.cubicTo(
        size.width,
        size.height * 0.8137460,
        size.width,
        size.height * 0.8384598,
        size.width * 0.9956069,
        size.height * 0.8581929);
    path_0.cubicTo(
        size.width * 0.9787799,
        size.height * 0.9337588,
        size.width * 0.9165566,
        size.height * 0.9898424,
        size.width * 0.8411258,
        size.height * 0.9974212);
    path_0.cubicTo(
        size.width * 0.8214277,
        size.height * 0.9994019,
        size.width * 0.7974465,
        size.height * 0.9962990,
        size.width * 0.7494906,
        size.height * 0.9900932);
    path_0.cubicTo(
        size.width * 0.6974906,
        size.height * 0.9833633,
        size.width * 0.6714937,
        size.height * 0.9800000,
        size.width * 0.6454906,
        size.height * 0.9775305);
    path_0.cubicTo(
        size.width * 0.5487044,
        size.height * 0.9683312,
        size.width * 0.4512956,
        size.height * 0.9683312,
        size.width * 0.3545094,
        size.height * 0.9775305);
    path_0.cubicTo(
        size.width * 0.3285063,
        size.height * 0.9800000,
        size.width * 0.3025085,
        size.height * 0.9833633,
        size.width * 0.2505107,
        size.height * 0.9900932);
    path_0.cubicTo(
        size.width * 0.2025525,
        size.height * 0.9962990,
        size.width * 0.1785736,
        size.height * 0.9994019,
        size.width * 0.1588758,
        size.height * 0.9974212);
    path_0.cubicTo(
        size.width * 0.08344434,
        size.height * 0.9898424,
        size.width * 0.02121890,
        size.height * 0.9337588,
        size.width * 0.004393679,
        size.height * 0.8581929);
    path_0.cubicTo(0, size.height * 0.8384598, 0, size.height * 0.8137460, 0,
        size.height * 0.7643151);
    path_0.lineTo(0, size.height * 0.2885122);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Color(0xffF1F6FF).withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
