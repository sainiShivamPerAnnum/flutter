import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/games/tambola/tambola_home/tambola_home.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class AutosaveOnboardingView extends StatefulWidget {
  const AutosaveOnboardingView({Key? key}) : super(key: key);

  @override
  State<AutosaveOnboardingView> createState() => _AutosaveOnboardingViewState();
}

class _AutosaveOnboardingViewState extends State<AutosaveOnboardingView> {
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
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
      backgroundColor: UiConstants.kBackgroundColor,
      body: Stack(
        children: [
          Row(
            children: [
              Container(
                width: SizeConfig.screenWidth! / 2,
                height: SizeConfig.fToolBarHeight,
                color: Color(0xff025155),
              ),
              Container(
                width: SizeConfig.screenWidth! / 2,
                height: SizeConfig.fToolBarHeight,
                color: const Color(0xff01646B),
              )
            ],
          ),
          SizedBox(
            height: SizeConfig.screenHeight,
            width: SizeConfig.screenWidth,
            child: SafeArea(
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.padding12),
                  const TambolaVideoPlayer(
                      link:
                          "https://d37gtxigg82zaw.cloudfront.net/sip-pros.mp4"),
                  Transform.translate(
                    offset: Offset(0, -SizeConfig.padding16),
                    child: Container(
                      padding: EdgeInsets.all(
                        SizeConfig.pageHorizontalMargins,
                      ),
                      decoration: BoxDecoration(
                        color: UiConstants.kBackgroundColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(SizeConfig.roundness12),
                            topRight: Radius.circular(SizeConfig.roundness12)),
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
                        _analyticsService.track(
                            eventName: AnalyticsEvents.asBenefitsTapped);
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
        ],
      ),
    );
  }
}

class LottieClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);

    var controlPoint = Offset(size.width / 2, size.height / 1.3);

    var secondEndPoint = Offset(size.width, size.height);
    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
