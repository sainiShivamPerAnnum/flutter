import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class JourneyOnboardingDialog extends StatefulWidget {
  const JourneyOnboardingDialog({Key key}) : super(key: key);

  @override
  State<JourneyOnboardingDialog> createState() =>
      _JourneyOnboardingDialogState();
}

class _JourneyOnboardingDialogState extends State<JourneyOnboardingDialog>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  PageController _pageController;
  int _currentPage = 0;

  double dragStartPosition, dragUpdatePosition;

  final onboardingData = [
    [
      'Save and Invest',
      'In strong, low risk assets with steady growth',
    ],
    [
      'Play games',
      'Earn tambola tickets and Fello tokens for your savings and play weekly games'
    ],
    [
      'Win rewards',
      'Win the daily and weekly games and get rewards and prizes!',
    ],
  ];
  @override
  void initState() {
    _pageController = PageController();
    _currentPage = 0;
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
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: UiConstants.primaryColor,
      child: GestureDetector(
        onHorizontalDragEnd: (details) {
          bool leftSwipe = dragStartPosition > dragUpdatePosition;
          double swipeCount = (dragStartPosition - dragUpdatePosition).abs();
          if (swipeCount >= 40) {
            if (leftSwipe) {
              if (_currentPage == 2) {
                // model.registerWalkthroughCompletion(comingFrom);
                return;
              } else {
                _pageController.nextPage(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeIn,
                );
              }
            } else {
              _pageController.previousPage(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeIn,
              );
            }
          }
        },
        onHorizontalDragStart: (details) {
          dragStartPosition = details.globalPosition.dx;
        },
        onHorizontalDragUpdate: (details) {
          dragUpdatePosition = details.globalPosition.dx;
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(Assets.journeyOnbLottie,
                controller: controller, width: SizeConfig.screenWidth),
            Container(
              margin: EdgeInsets.only(bottom: SizeConfig.padding32),
              height: SizeConfig.screenWidth * 0.28,
              width: SizeConfig.screenWidth * 0.8,
              child: PageView.builder(
                controller: _pageController,
                // physics: NeverScrollableScrollPhysics(),
                onPageChanged: (val) {
                  if (val > _currentPage) {
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
                  _currentPage = val;
                },
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Text(
                        onboardingData[index][0],
                        style: TextStyles.rajdhaniB.title2,
                      ),
                      SizedBox(
                        width: SizeConfig.padding16,
                      ),
                      Text(
                        onboardingData[index][1],
                        textAlign: TextAlign.center,
                        style: TextStyles.sourceSans.body2,
                      ),
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
                      color: _currentPage == index
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
    );
  }
}
