import 'dart:developer';

import 'package:felloapp/ui/animations/welcome_rings/welcome_rings.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/onboarding/onboarding_main/onboarding_main_vm.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({Key? key}) : super(key: key);

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  AnimationController? controller;

  @override
  void initState() {
    log("BUILD: Init called for onboarding view");
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 6));
    Future.delayed(
      const Duration(seconds: 2),
      () => controller!.animateTo(0.26),
    );
    super.initState();
  }

  @override
  void dispose() {
    log("BUILD: Dispose called for onboarding view");
    controller?.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BaseView<OnboardingViewModel>(
      onModelReady: (model) => model.init(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: const Color(0xFF032A2E),
          floatingActionButton: FloatingActionButton(
            backgroundColor: const Color(0xff0B867C),
            onPressed: () {
              if (model.currentPage == 2) {
                model.registerWalkthroughCompletion();
              } else {
                model.pageController!.animateToPage(model.currentPage + 1,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn);
              }
            },
            child: Container(
              width: SizeConfig.padding64,
              height: SizeConfig.padding64,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                  color: const Color(0xFF009D91),
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
                    model.registerWalkthroughCompletion();
                    return;
                  } else {
                    model.pageController!.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeIn,
                    );
                  }
                } else {
                  model.pageController!.previousPage(
                    duration: const Duration(milliseconds: 500),
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
                        const Color(0xFF097178).withOpacity(0.2),
                        const Color(0xFF0C867C),
                        const Color(0xff0B867C),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: SafeArea(
                    child: Transform.translate(
                      offset: Offset(0, -SizeConfig.screenHeight! * 0.1),
                      child: Lottie.asset("assets/lotties/onboarding.json",
                          width: SizeConfig.screenWidth,
                          frameRate: FrameRate(60),
                          controller: controller,
                          fit: BoxFit.fitWidth),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: SizeConfig.screenWidth,
                    height: SizeConfig.screenHeight! * 0.6,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            const Color(0xff0B867C),
                            const Color(0xff0B867C),
                            const Color(0xff0B867C),
                            const Color(0xff0B867C),
                            const Color(0xff0B867C).withOpacity(0.95),
                            const Color(0xff0B867C).withOpacity(0.2),
                            const Color(0xff0B867C).withOpacity(0.05),
                            Colors.transparent
                          ]),
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
                          height: SizeConfig.screenWidth! * 0.45,
                          width: SizeConfig.screenWidth! * 0.8,
                          margin: EdgeInsets.only(bottom: SizeConfig.padding32),
                          child: PageView.builder(
                            controller: model.pageController,
                            // physics: NeverScrollableScrollPhysics(),
                            onPageChanged: (val) {
                              if (val > model.currentPage) {
                                if (val == 2) {
                                  controller!.animateTo(1);
                                } else {
                                  controller!.animateTo(0.53);
                                }
                              } else {
                                if (val == 0) {
                                  controller!.reset();
                                  controller!.animateTo(0.28);
                                } else if (val == 1) {
                                  controller!.animateBack(0.53);
                                } else {
                                  controller!.animateBack(0);
                                }
                              }
                              model.currentPage = val;
                            },
                            itemCount: 3,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      model.onboardingData![index][0],
                                      style: TextStyles.rajdhaniB.title3,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.padding16,
                                  ),
                                  Text(
                                    model.onboardingData![index][1],
                                    textAlign: TextAlign.center,
                                    style: TextStyles.sourceSans.body2,
                                  ),
                                  SizedBox(
                                    height: SizeConfig.padding20,
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
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 3),
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
                // BaseAnimation(),
                const CircularAnim()
              ],
            ),
          ),
        );
      },
    );
  }
}
