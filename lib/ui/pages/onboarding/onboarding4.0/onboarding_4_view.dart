import 'dart:developer';

import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/onboarding/onboarding4.0/onboarding_4_vm.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnBoardingView extends StatelessWidget {
  const OnBoardingView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<OnboardingViewModel>(
      onModelReady: (model) {
        model.init();
      },
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Color(0xFF0D4748),
          body: GestureDetector(
            onHorizontalDragEnd: (details) {
              bool leftSwipe =
                  model.dragStartPosition > model.dragUpdatePosition;
              double swipeCount =
                  (model.dragStartPosition - model.dragUpdatePosition).abs();
              if (swipeCount >= 40) {
                if (leftSwipe) {
                  if (model.currentPage == 2) {
                    model.onBoardingCompleted();
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
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: SizeConfig.padding46,
                  right: SizeConfig.padding24,
                  child: GestureDetector(
                    onTap: () {
                      if (model.currentPage == 2) {
                        model.onBoardingCompleted();
                      } else {
                        model.pageController.animateToPage(
                          2,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                        );
                      }
                    },
                    child: Text(
                      model.currentPage == 2 ? "FINISH" : "SKIP",
                      style: TextStyles.rajdhaniSB.body1,
                    ),
                  ),
                ),
                Center(
                  child: SvgPicture.asset(
                    "assets/temp/onboarding-tm.svg",
                    width: 300,
                    height: 400,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: SizeConfig.screenWidth,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF0B7D75),
                          blurRadius: 60,
                          spreadRadius: 30,
                          offset: Offset(0, -10),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 100),
                    height: 90,
                    width: 300,
                    child: PageView.builder(
                      controller: model.pageController,
                      physics: NeverScrollableScrollPhysics(),
                      onPageChanged: (val) {
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
                              width: SizeConfig.padding16,
                            ),
                            Text(
                              model.onboardingData[index][1],
                              textAlign: TextAlign.center,
                              style: TextStyles.sourceSans.body2,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 30,
                    margin: EdgeInsets.only(bottom: 40),
                    child: ListView.builder(
                      itemCount: 3,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
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
                ),
                Positioned(
                  bottom: SizeConfig.padding32,
                  right: SizeConfig.padding32,
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
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
