import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/widgets/custom_card/custom_cards.dart';
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

  get currentPage => this._currentPage;

  set currentPage(value) {
    setState(() {
      this._currentPage = value;
    });
  }

  double dragStartPosition, dragUpdatePosition;

  final onboardingData = [
    [
      "Welcome to Fello",
      "Presenting a new way of saving and winning rewards",
    ],
    [
      "Complete Milestones",
      "Finish milestones to progress in your journey and unlock new levels",
    ],
    [
      "Win Rewards",
      "Earn tokens and cashbacks on completing each milestone",
    ],
  ];
  @override
  void initState() {
    _pageController = PageController();
    currentPage = 0;
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
    _pageController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SizeConfig.roundness8),
      ),
      backgroundColor: UiConstants.primarySemiLight,
      child: GestureDetector(
        onHorizontalDragEnd: (details) {
          bool leftSwipe = dragStartPosition > dragUpdatePosition;
          double swipeCount = (dragStartPosition - dragUpdatePosition).abs();
          if (swipeCount >= 40) {
            if (leftSwipe) {
              _pageController.nextPage(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeIn,
              );
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
            Lottie.asset(
              Assets.journeyOnbLottie,
              controller: controller,
              width: SizeConfig.screenWidth,
              height: SizeConfig.screenHeight * 0.5,
            ),
            SizedBox(height: SizeConfig.padding16),
            Container(
              margin: EdgeInsets.symmetric(
                  vertical: SizeConfig.padding4,
                  horizontal: SizeConfig.pageHorizontalMargins),
              height: SizeConfig.screenWidth * 0.24,
              width: SizeConfig.screenWidth * 0.8,
              child: PageView.builder(
                controller: _pageController,
                // physics: NeverScrollableScrollPhysics(),
                onPageChanged: (val) {
                  if (val > currentPage) {
                    if (val == 2)
                      controller.animateTo(1);
                    else
                      controller.animateTo(0.53);
                  } else {
                    if (val == 0) {
                      controller.reset();
                      controller.animateTo(0.18);
                    } else if (val == 1)
                      controller.animateBack(0.53);
                    else
                      controller.animateBack(0);
                  }
                  currentPage = val;
                },
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          onboardingData[index][0],
                          style: TextStyles.rajdhaniB.title2,
                        ),
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
                      color: currentPage == index
                          ? Colors.white
                          : Colors.transparent,
                      border: Border.all(color: Colors.white),
                      shape: BoxShape.circle,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: SizeConfig.padding16),
            CustomSaveButton(
                title: currentPage == 2 ? 'Done' : 'Next',
                width: SizeConfig.screenWidth * 0.5,
                onTap: () {
                  if (currentPage == 2)
                    AppState.backButtonDispatcher.didPopRoute();
                  else {
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeIn,
                    );
                  }
                }),
            SizedBox(height: SizeConfig.padding40)
          ],
        ),
      ),
    );
  }
}
