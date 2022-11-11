import 'dart:developer';

import 'package:felloapp/ui/animations/welcome_rings/welcome_rings.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/onboarding/onboarding4.0/onboarding_4_vm.dart';
import 'package:felloapp/ui/pages/static/base_animation/base_animation.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

const String COMING_FROM_SPLASH = "fromSplash";
const String COMING_FROM_HOME = "fromHome";

class OnBoardingView extends StatefulWidget {
  final String comingFrom;

  const OnBoardingView({Key key, this.comingFrom = COMING_FROM_SPLASH})
      : super(key: key);

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 6));
    Future.delayed(
      Duration(seconds: 2),
      () {
        WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) {
            controller.animateTo(0.26);
          },
        );
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(milliseconds: 1000), () {
      controller.animateTo(0.53);
    });

    return BaseView<OnboardingViewModel>(
      onModelReady: (model) {
        model.init();
      },
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Color(0xFF032A2E),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Color(0xff0B867C),
            onPressed: () {
              if (model.currentPage == 2)
                model.registerWalkthroughCompletion(widget.comingFrom);
              else
                model.pageController.animateToPage(model.currentPage + 1,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeIn);
            },
            child: Container(
              width: SizeConfig.padding64,
              height: SizeConfig.padding64,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                  color: Color(0xFF009D91),
                  width: 2,
                ),
                shape: BoxShape.circle,
              ),
              child: model.isWalkthroughRegistrationInProgress
                  ? SpinKitThreeBounce(
                      color: Colors.white, size: SizeConfig.padding16)
                  : Icon(Icons.arrow_forward_ios_rounded,
                      size: SizeConfig.padding20, color: Colors.white),
            ),
          ),
          body: GestureDetector(
            onHorizontalDragEnd: (details) {
              bool leftSwipe =
                  model.dragStartPosition > model.dragUpdatePosition;
              double swipeCount =
                  (model.dragStartPosition - model.dragUpdatePosition).abs();
              if (swipeCount >= 40) {
                if (leftSwipe) {
                  if (model.currentPage == 2) {
                    // model.registerWalkthroughCompletion(comingFrom);
                    return;
                  } else {
                    model.pageController.nextPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeIn,
                    );
                  }
                } else {
                  model.pageController.previousPage(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                  );
                }
              }
            },
            onHorizontalDragStart: (details) {
              model.dragStartPosition = details.globalPosition.dx;
            },
            onHorizontalDragUpdate: (details) {
              model.dragUpdatePosition = details.globalPosition.dx;
            },
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF097178).withOpacity(0.2),
                        Color(0xFF0C867C),
                        Color(0xff0B867C),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: SafeArea(
                    child: Transform.translate(
                      offset: Offset(0, -SizeConfig.screenHeight * 0.1),
                      child: Container(
                        // color: Colors.red,
                        child: Lottie.asset("assets/lotties/onboarding.json",
                            width: SizeConfig.screenWidth,
                            // height: SizeConfig.screenWidth,
                            controller: controller,
                            fit: BoxFit.fitWidth),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: SizeConfig.screenWidth,
                    height: SizeConfig.screenHeight * 0.6,
                    decoration: BoxDecoration(
                      // color: Colors.transparent,
                      gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Color(0xff0B867C),
                            Color(0xff0B867C),
                            Color(0xff0B867C),
                            Color(0xff0B867C),
                            Color(0xff0B867C).withOpacity(0.95),
                            Color(0xff0B867C).withOpacity(0.2),
                            Color(0xff0B867C).withOpacity(0.05),
                            Colors.transparent
                          ]),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Color(0xFF0B7D75),
                      //     blurRadius: 60,
                      //     spreadRadius: 30,
                      //     offset: Offset(0, -10),
                      //   ),
                      // ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: SizeConfig.screenWidth * 0.45,
                          width: SizeConfig.screenWidth * 0.8,
                          margin: EdgeInsets.only(bottom: SizeConfig.padding32),
                          child: PageView.builder(
                            controller: model.pageController,
                            // physics: NeverScrollableScrollPhysics(),
                            onPageChanged: (val) {
                              if (val > model.currentPage) {
                                if (val == 2)
                                  controller.animateTo(1);
                                else
                                  controller.animateTo(0.53);
                              } else {
                                if (val == 0) {
                                  controller.reset();
                                  controller.animateTo(0.28);
                                } else if (val == 1)
                                  controller.animateBack(0.53);
                                else
                                  controller.animateBack(0);
                              }
                              model.currentPage = val;
                            },
                            itemCount: 3,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Text(
                                    model.onboardingData[index][0],
                                    style: TextStyles.rajdhaniB.title2,
                                  ),
                                  SizedBox(
                                    height: SizeConfig.padding16,
                                  ),
                                  Text(
                                    model.onboardingData[index][1],
                                    textAlign: TextAlign.center,
                                    style: TextStyles.sourceSans.body2,
                                  ),
                                  SizedBox(
                                    height: SizeConfig.padding16,
                                  ),
                                  model.assetWidgets[index],
                                ],
                              );
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            3,
                            (index) {
                              return Container(
                                width: SizeConfig.padding8,
                                height: SizeConfig.padding8,
                                margin: EdgeInsets.symmetric(horizontal: 3),
                                decoration: BoxDecoration(
                                  color: model.currentPage == index
                                      ? Colors.white
                                      : Colors.transparent,
                                  border: Border.all(color: Colors.white),
                                  shape: BoxShape.circle,
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: SizeConfig.padding40)
                      ],
                    ),
                  ),
                ),
                BaseAnimation(),
                // CircularAnim()
              ],
            ),
          ),
        );
      },
    );
  }
}
