import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AutosaveOnboardingView extends StatefulWidget {
  const AutosaveOnboardingView({Key? key}) : super(key: key);

  @override
  State<AutosaveOnboardingView> createState() => _AutosaveOnboardingViewState();
}

class _AutosaveOnboardingViewState extends State<AutosaveOnboardingView> {
  final AnalyticsService? _analyticsService = locator<AnalyticsService>();
  PageController? _controller;
  double dragStartPosition = 0, dragUpdatePosition = 0;

  List<List<String>> storyData = [
    [
      Assets.autosaveBenefitsAssets[0],
      "Power of Compounding",
      "Invest in Autosave and grow it exponentially. The longer your hold, the more it compounds."
    ],
    [
      Assets.autosaveBenefitsAssets[1],
      "Never run out of tokens",
      "Get tokens on every Autosave transaction. Use tokens to play games and win more rewards!"
    ],
    [
      Assets.autosaveBenefitsAssets[2],
      "Automated Investments",
      "Sit back and relax as your savings automatically get invested and you enjoy the returns."
    ],
  ];
  int currentPage = 0;
  @override
  void initState() {
    _controller = PageController()
      ..addListener(() {
        if (_controller!.page! - _controller!.page!.toInt() == 0) {
          currentPage = _controller!.page!.toInt();
          setState(() {});
        }
      });
    // PreferenceHelper.setBool(
    //     PreferenceHelper.CACHE_IS_AUTOSAVE_FIRST_TIME, false);
    _analyticsService!
        .track(eventName: AnalyticsEvents.autosaveDetailsScreenView);
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return Scaffold(
      backgroundColor: Color(0xFF032A2E),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Color(0xff0B867C),
      //   onPressed: () {
      //     if (currentPage == 2)
      //       AppState.delegate!.appState.currentAction = PageAction(
      //         state: PageState.replace,
      //         page: AutosaveProcessViewPageConfig,
      //       );
      //     else
      //       _controller!.animateToPage(currentPage + 1,
      //           duration: Duration(milliseconds: 500), curve: Curves.easeIn);
      //   },
      // child: Container(
      //   width: SizeConfig.padding64,
      //   height: SizeConfig.padding64,
      //   decoration: BoxDecoration(
      //     color: Colors.transparent,
      //     border: Border.all(
      //       color: Color(0xFF009D91),
      //       width: 2,
      //     ),
      //     shape: BoxShape.circle,
      //   ),
      //   child: Icon(Icons.arrow_forward_ios_rounded,
      //       size: SizeConfig.padding20, color: Colors.white),
      // ),
      // ),
      body: Stack(
        children: [
          const NewSquareBackground(),
          Positioned(
            top: 0,
            child: Container(
              width: SizeConfig.screenWidth,
              height: SizeConfig.screenHeight!,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xff0B867C).withOpacity(0.95),
                      Color(0xff0B867C).withOpacity(0.2),
                      Color(0xff0B867C).withOpacity(0.05),
                      Colors.transparent
                    ]),
              ),
            ),
          ),
          Container(
            height: SizeConfig.screenHeight,
            width: SizeConfig.screenWidth,
            child: SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: SizeConfig.screenWidth,
                    width: SizeConfig.screenWidth,
                    child: SvgPicture.asset(
                      storyData[0][0],
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: SizeConfig.pageHorizontalMargins,
                    ),
                    // color: Colors.red,
                    width: SizeConfig.screenWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Introducing Autosave",
                            style: TextStyles.rajdhaniB.title1),
                        ...List.generate(
                          storyData.length,
                          (index) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(
                              Icons.check_circle_outline_rounded,
                              color: UiConstants.primaryColor,
                              // size: SizeConfig.iconSize1,
                            ),
                            title: Text(
                              storyData[index][1],
                              style: TextStyles.sourceSansM.body2,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                    child: AppPositiveBtn(
                      btnText: "Setup",
                      onPressed: () {
                        AppState.delegate!.appState.currentAction = PageAction(
                          state: PageState.replace,
                          page: AutosaveProcessViewPageConfig,
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: SafeArea(
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () {
                  AppState.backButtonDispatcher!.didPopRoute();
                },
              ),
            ),
          )
          // Align(
          //   alignment: Alignment.topCenter,
          //   child: Container(
          //       margin: EdgeInsets.only(top: SizeConfig.fToolBarHeight),
          //       width: SizeConfig.screenWidth,
          //       alignment: Alignment.center,
          //       height: SizeConfig.title1,
          //       child: Text("Autosave", style: TextStyles.rajdhaniB.title1)),
          // ),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: SafeArea(
          //     child: Column(
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         Container(
          //           height: SizeConfig.screenWidth! * 1.5,
          //           child: PageView.builder(
          //             controller: _controller,
          //             // physics: NeverScrollableScrollPhysics(),
          //             onPageChanged: (val) {},
          //             itemCount: 3,
          //             itemBuilder: (context, index) {
          //               return Column(
          //                 children: [
          //                   SvgPicture.asset(
          //                     storyData[index][0],
          //                     width: SizeConfig.screenWidth,
          //                   ),
          //                   Padding(
          //                     padding: EdgeInsets.symmetric(
          //                         horizontal: SizeConfig.pageHorizontalMargins),
          //                     child: Text(
          //                       storyData[index][1],
          //                       textAlign: TextAlign.center,
          //                       style: TextStyles.rajdhaniB.title2,
          //                     ),
          //                   ),
          //                   SizedBox(
          //                     height: SizeConfig.padding16,
          //                   ),
          //                   Padding(
          //                     padding: EdgeInsets.symmetric(
          //                         horizontal: SizeConfig.padding32),
          //                     child: Text(
          //                       storyData[index][2],
          //                       textAlign: TextAlign.center,
          //                       style: TextStyles.sourceSans.body2,
          //                     ),
          //                   ),
          //                   SizedBox(
          //                     height: SizeConfig.padding24,
          //                   ),
          //                 ],
          //               );
          //             },
          //           ),
          //         ),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: List.generate(
          //             3,
          //             (index) {
          //               return Container(
          //                 width: SizeConfig.padding8,
          //                 height: SizeConfig.padding8,
          //                 margin: EdgeInsets.symmetric(horizontal: 3),
          //                 decoration: BoxDecoration(
          //                   color: currentPage == index
          //                       ? Colors.white
          //                       : Colors.transparent,
          //                   border: Border.all(color: Colors.white),
          //                   shape: BoxShape.circle,
          //                 ),
          //               );
          //             },
          //           ),
          //         ),
          //         SizedBox(height: SizeConfig.padding40)
          //       ],
          //     ),
          //   ),
          // ),
          // if (currentPage < 2)
          //   Align(
          //     alignment: Alignment.topRight,
          //     child: SafeArea(
          //       child: GestureDetector(
          //         onTap: () {
          // AppState.delegate!.appState.currentAction = PageAction(
          //   state: PageState.replace,
          //   page: AutosaveProcessViewPageConfig,
          // );
          //         },
          //         child: Container(
          //           margin: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
          //           decoration: BoxDecoration(
          //             borderRadius:
          //                 BorderRadius.circular(SizeConfig.roundness40),
          //             border: Border.all(color: Colors.white, width: 1),
          //             color: UiConstants.darkPrimaryColor,
          //           ),
          //           padding: EdgeInsets.symmetric(
          //               horizontal: SizeConfig.padding12,
          //               vertical: SizeConfig.padding10),
          //           child: Text(
          //             "SKIP",
          //             style: TextStyles.rajdhaniSB.body3,
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }
}
