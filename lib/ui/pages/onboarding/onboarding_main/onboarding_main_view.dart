import 'package:felloapp/ui/animations/welcome_rings/welcome_rings.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/onboarding/onboarding_main/onboarding_main_vm.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({Key? key}) : super(key: key);

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  PageController? pageController;
  double? pageValue;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        pageValue = pageController?.page;
      });
    });
  }

  @override
  void dispose() {
    pageController?.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BaseView<OnboardingViewModel>(
      onModelReady: (model) {
        model.init();
        pageController?.addListener(() {
          if (pageController!.page != null && pageController!.page! >= 2.2) {
            model.registerWalkthroughCompletion();
          }
        });
      },
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: UiConstants.onboardingBackgroundColor,
          body: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (n) {
              n.disallowIndicator();
              return false;
            },
            child: Stack(
              children: [
                Positioned.fill(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.padding70,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            3,
                            (index) {
                              return Container(
                                width: SizeConfig.padding22,
                                height: SizeConfig.padding2,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 3),
                                decoration: BoxDecoration(
                                  color: index <= model.indicatorPosition
                                      ? Colors.white
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: index <= model.indicatorPosition
                                        ? Colors.white
                                        : UiConstants.greyVarient,
                                  ),
                                  shape: BoxShape.rectangle,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: PageView.builder(
                          controller: pageController,
                          physics: const BouncingScrollPhysics(),
                          onPageChanged: (val) {
                            if (val > 2) {
                              model.registerWalkthroughCompletion();
                            } else if (val > model.currentPage) {
                              if (val == 2) {
                                model.indicatorPosition = 2;
                              } else {
                                model.indicatorPosition = 1;
                              }
                            } else {
                              if (val == 0) {
                                model.indicatorPosition = 0;
                              } else if (val == 1) {
                                model.indicatorPosition = 1;
                              } else {
                                model.indicatorPosition = 0;
                              }
                            }
                            model.currentPage = val;
                          },
                          itemCount: 4,
                          itemBuilder: (_, __) {
                            return AnimatedBuilder(
                              animation: pageController!,
                              builder: (context, child) {
                                if (pageValue == null || __ == 3) {
                                  return const SizedBox.shrink();
                                }
                                double scale = 1 -
                                    (pageController!.page! - __).abs() * 0.1;
                                return Transform.scale(
                                  scale: scale,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width: SizeConfig.padding325,
                                        child: Text(
                                          model.onboardingData![__].first,
                                          style: TextStyles.sourceSansB.title3,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        height: SizeConfig.padding14,
                                      ),
                                      SizedBox(
                                        width: SizeConfig.padding325,
                                        child: Text(
                                          model.onboardingData![__][1],
                                          style: TextStyles.sourceSans.body2
                                              .colour(
                                            UiConstants.kTextColor5,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        height: SizeConfig.padding35,
                                      ),
                                      SizedBox(
                                        width: SizeConfig.padding300,
                                        child: AppImage(
                                          model.onboardingData![__][2],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: const SizedBox.shrink(),
                            );
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _SignUpCTA(
                            onTap: model.registerWalkthroughCompletion,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.padding44,
                      ),
                    ],
                  ),
                ),
                const CircularAnim(),
              ],
            ),
          ),
        );
      },
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
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(SizeConfig.padding325, SizeConfig.padding48),
        backgroundColor: UiConstants.kTextColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SizeConfig.roundness8),
        ),
      ),
      child: Text(
        'Get Started',
        style: TextStyles.sourceSansSB.body3.colour(UiConstants.kTextColor4),
      ),
    );
  }
}
