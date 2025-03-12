import 'package:felloapp/ui/animations/welcome_rings/welcome_rings.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/onboarding/onboarding_main/onboarding_main_vm.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

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
          backgroundColor: UiConstants.bg,
          body: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (n) {
              n.disallowIndicator();
              return false;
            },
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      height: 65.h,
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
                        itemBuilder: (_, index) {
                          return AnimatedBuilder(
                            animation: pageController!,
                            builder: (context, child) {
                              if (pageValue == null || index == 3) {
                                return const SizedBox.shrink();
                              }
                              double scale = 1 -
                                  (pageController!.page! - index).abs() * 0.1;
                              return Transform.scale(
                                scale: scale,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: 1.sw,
                                      height: 390.h,
                                      child: AppImage(
                                        model.onboardingData![index].image,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    const Spacer(),
                                    SizedBox(
                                      width: 335.w,
                                      child: Text(
                                        model.onboardingData![index].title,
                                        style: GoogleFonts.sourceSans3(
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.w600,
                                          color: UiConstants.kTextColor,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 12.h,
                                    ),
                                    SizedBox(
                                      width: 335.w,
                                      child: Text(
                                        model.onboardingData![index].subtitle,
                                        style: GoogleFonts.sourceSans3(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w400,
                                          color: UiConstants.kTextColor5,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 35.h,
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
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 40.h,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          3,
                          (index) {
                            return Container(
                              width: 22.w,
                              height: 2.h,
                              margin: EdgeInsets.symmetric(horizontal: 3.w),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _SignUpCTA(
                          onTap: model.registerWalkthroughCompletion,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                  ],
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
        minimumSize: Size(325.w, 48.h),
        backgroundColor: UiConstants.kTextColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      child: Text(
        'Get Started',
        style: TextStyles.sourceSansSB.body3.colour(UiConstants.kTextColor4),
      ),
    );
  }
}
