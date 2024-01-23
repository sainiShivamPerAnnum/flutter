import 'package:felloapp/ui/animations/welcome_rings/welcome_rings.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/onboarding/onboarding_main/onboarding_main_vm.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({Key? key}) : super(key: key);

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  AnimationController? controller;

  static const _entryPoint = 0.26413942732900914;
  static const _secondPoint = 0.5196233785377358;
  static const _thirdPoint = 0.9370692990860865;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 8500),
    );

    Future.delayed(const Duration(seconds: 1)).then((value) {
      controller!.animateTo(_entryPoint);
    });
  }

  @override
  void dispose() {
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
          body: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (n) {
              n.disallowIndicator();
              return false;
            },
            child: GestureDetector(
              onHorizontalDragEnd: (_) {
                bool leftSwipe =
                    model.dragStartPosition > model.dragUpdatePosition;
                double swipeCount =
                    (model.dragStartPosition - model.dragUpdatePosition).abs();
                if (swipeCount >= 40) {
                  if (leftSwipe) {
                    if (model.currentPage == 2) {
                      controller!.forward().then((value) {
                        model.registerWalkthroughCompletion();
                      });
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
                  Align(
                    alignment: Alignment.topCenter,
                    child: Lottie.asset(
                      "assets/lotties/onboarding.json",
                      width: SizeConfig.screenWidth,
                      frameRate: FrameRate(60),
                      controller: controller,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Positioned.fill(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: SizeConfig.screenWidth!,
                          width: SizeConfig.screenWidth!,
                          margin: EdgeInsets.only(bottom: SizeConfig.padding32),
                          child: PageView.builder(
                            controller: model.pageController,
                            onPageChanged: (val) {
                              if (val > model.currentPage) {
                                if (val == 2) {
                                  controller!.animateTo(_thirdPoint).then(
                                        (_) => model.indicatorPosition = 2,
                                      );
                                } else {
                                  controller!
                                      .animateTo(_secondPoint)
                                      .then((_) => model.indicatorPosition = 1);
                                }
                              } else {
                                if (val == 0) {
                                  controller!
                                      .animateTo(_entryPoint)
                                      .then((_) => model.indicatorPosition = 0);
                                } else if (val == 1) {
                                  controller!
                                      .animateBack(_secondPoint)
                                      .then((_) => model.indicatorPosition = 1);
                                } else {
                                  controller!.animateBack(_entryPoint);
                                }
                              }
                              model.currentPage = val;
                            },
                            itemCount: 3,
                            itemBuilder: (_, __) => const SizedBox.shrink(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: SizeConfig.padding20,
                    left: SizeConfig.padding24,
                    right: SizeConfig.padding24,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: List.generate(
                            3,
                            (index) {
                              return Container(
                                width: SizeConfig.padding8,
                                height: SizeConfig.padding8,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 3),
                                decoration: BoxDecoration(
                                  color: index == model.indicatorPosition
                                      ? Colors.white
                                      : Colors.transparent,
                                  border: Border.all(color: Colors.white),
                                  shape: BoxShape.circle,
                                ),
                              );
                            },
                          ),
                        ),
                        _SignUpCTA(
                          onTap: model.registerWalkthroughCompletion,
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    right: SizeConfig.padding16,
                    top: MediaQuery.paddingOf(context).top,
                    child: _SkipButton(
                      onTap: () {
                        if (model.currentPage == 2) {
                          controller?.forward().then(
                              (_) => model.registerWalkthroughCompletion());
                        } else {
                          model.pageController!.animateToPage(
                            model.currentPage + 1,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn,
                          );
                        }
                      },
                    ),
                  ),
                  const CircularAnim()
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SkipButton extends StatelessWidget {
  const _SkipButton({
    this.onTap,
  });

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final locale = locator<S>();
    return TextButton(
      onPressed: onTap,
      child: Text(
        locale.obNext,
        style: TextStyles.rajdhaniB.body1.setHeight(
          1.3,
        ),
      ),
    );
  }
}

class _SignUpCTA extends StatelessWidget {
  const _SignUpCTA({
    this.onTap,
  });

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final locale = locator<S>();
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          SizeConfig.padding16,
          SizeConfig.padding10,
          SizeConfig.padding10,
          SizeConfig.padding10,
        ),
        decoration: BoxDecoration(
          color: const Color(0xff0C0F10),
          borderRadius: BorderRadius.circular(
            SizeConfig.roundness24,
          ),
        ),
        child: Row(
          children: [
            Text(
              locale.signUp,
              style: TextStyles.rajdhaniB.body1.setHeight(
                1.3,
              ),
            ),
            SizedBox(
              width: SizeConfig.padding12,
            ),
            AppImage(
              Assets.chevRonRightArrow,
              height: SizeConfig.padding24,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
