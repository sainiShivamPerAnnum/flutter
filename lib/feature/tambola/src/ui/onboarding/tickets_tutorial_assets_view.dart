import 'dart:async';

import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/repository/user_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/feature/tambola/src/ui/onboarding/tickets_intro_view.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/elements/default_avatar.dart';
import 'package:felloapp/ui/pages/asset_selection.dart';
import 'package:felloapp/ui/pages/root/root_controller.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tuple/tuple.dart';
import 'package:vibration/vibration.dart';

class TicketsTutorialsView extends StatefulWidget {
  const TicketsTutorialsView({super.key});

  @override
  State<TicketsTutorialsView> createState() => _TicketsTutorialsViewState();
}

class _TicketsTutorialsViewState extends State<TicketsTutorialsView>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late CurvedAnimation _animation1;
  late CurvedAnimation _animation2;
  late CurvedAnimation _animation3;
  late CurvedAnimation _animation4;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
      reverseDuration: const Duration(seconds: 1),
    );

    _animation1 = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.2),
    );
    _animation2 = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 0.5, curve: Curves.easeInOutCirc),
    );
    _animation3 = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 0.8, curve: Curves.easeInOutCirc),
    );
    _animation4 = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.9, 1.0),
    );

    Future.delayed(const Duration(seconds: 1), () {
      _controller.forward();
      Vibration.vibrate(pattern: [150, 80, 300, 80, 500, 80, 600, 100]);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiConstants.kBackgroundColor,
      body: SizedBox(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
        child: Stack(
          children: [
            Positioned(
              top: SizeConfig.screenHeight! * 0.1,
              left: -SizeConfig.screenWidth! / 3,
              child: const RotatingPolkaDotsWidget(),
            ),
            Positioned(
              top: SizeConfig.screenHeight! * 0.1,
              right: -SizeConfig.screenWidth! / 3,
              child: const RotatingPolkaDotsWidget(),
            ),
            SafeArea(
              child: SizedBox(
                width: SizeConfig.screenWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: kToolbarHeight / 2),
                    // const Head(),
                    Text(
                      "How to win Rewards\nwith Tickets",
                      style: TextStyles.rajdhaniB.title2.colour(Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: SizeConfig.padding10),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomStaggeredAnimatedWidget(
                          animation: _animation1,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                SizeConfig.roundness16,
                              ),
                              color: const Color(0xffA5E4FF),
                              boxShadow: const [
                                BoxShadow(
                                    color: Color(0xff495DB2),
                                    offset: Offset(10, 10),
                                    blurRadius: 0,
                                    spreadRadius: 0)
                              ],
                            ),
                            margin: EdgeInsets.symmetric(
                                horizontal: SizeConfig.pageHorizontalMargins,
                                vertical: SizeConfig.padding10),
                            child: Padding(
                              padding: EdgeInsets.all(
                                  SizeConfig.pageHorizontalMargins),
                              child: Row(children: [
                                SvgPicture.asset(Assets.goldAsset,
                                    width: SizeConfig.padding60),
                                Expanded(
                                    child: Column(
                                  children: [
                                    Text(
                                      "Get Tickets every week by saving ₹500",
                                      style: TextStyles.sourceSansSB.body2
                                          .colour(Colors.black),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: SizeConfig.padding12),
                                    Text(
                                      "In any of the Fello assets",
                                      style:
                                          TextStyles.body4.colour(Colors.black),
                                    )
                                  ],
                                )),
                                SvgPicture.asset(Assets.floAsset,
                                    width: SizeConfig.padding60),
                              ]),
                            ),
                          ),
                        ),
                        SizedBox(height: SizeConfig.screenHeight! * 0.028),
                        CustomStaggeredAnimatedWidget(
                          animation: _animation2,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                SizeConfig.roundness16,
                              ),
                              color: const Color(0xffF79780),
                              boxShadow: const [
                                BoxShadow(
                                    color: Color(0xffC34B29),
                                    offset: Offset(10, 10),
                                    blurRadius: 0,
                                    spreadRadius: 0)
                              ],
                            ),
                            margin: EdgeInsets.symmetric(
                                horizontal: SizeConfig.pageHorizontalMargins,
                                vertical: SizeConfig.padding10),
                            child: Padding(
                              padding: EdgeInsets.all(
                                  SizeConfig.pageHorizontalMargins),
                              child: Column(
                                children: [
                                  Text(
                                    "Spin everyday to match numbers",
                                    style: TextStyles.sourceSansSB.body2
                                        .colour(Colors.black),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: SizeConfig.padding12),
                                  Text(
                                    "Numbers will be automatically matched with your Tickets, even if you forget to spin",
                                    style:
                                        TextStyles.body4.colour(Colors.black),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: SizeConfig.screenHeight! * 0.028),
                        CustomStaggeredAnimatedWidget(
                          animation: _animation3,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                SizeConfig.roundness16,
                              ),
                              color: const Color(0xffFFD979),
                              boxShadow: const [
                                BoxShadow(
                                    color: Color(0xffB17518),
                                    offset: Offset(10, 10),
                                    blurRadius: 0,
                                    spreadRadius: 0)
                              ],
                            ),
                            margin: EdgeInsets.symmetric(
                                horizontal: SizeConfig.pageHorizontalMargins,
                                vertical: SizeConfig.padding10),
                            child: Padding(
                              padding: EdgeInsets.all(
                                  SizeConfig.pageHorizontalMargins),
                              child: Row(children: [
                                SvgPicture.asset(
                                  Assets.trophySvg,
                                  width: SizeConfig.padding60,
                                  height: SizeConfig.padding60,
                                ),
                                Expanded(
                                    child: Column(
                                  children: [
                                    Text(
                                      "Rewards distributed every Monday",
                                      style: TextStyles.sourceSansSB.body2
                                          .colour(Colors.black),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: SizeConfig.padding12),
                                    Text(
                                      "Rewards are distributed for your top 10 winning tickets in a week",
                                      style:
                                          TextStyles.body4.colour(Colors.black),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                )),
                                SvgPicture.asset(Assets.dailyAppBonusHero,
                                    width: SizeConfig.padding60),
                              ]),
                            ),
                          ),
                        ),
                      ],
                    )),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomStaggeredAnimatedWidget(
                animation: _animation4,
                child: Container(
                  color: UiConstants.kSaveStableFelloCardBg,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const TicketsWinnersSlider(),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.pageHorizontalMargins),
                        child: MaterialButton(
                          height: SizeConfig.padding44,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(SizeConfig.roundness5)),
                          minWidth: SizeConfig.screenWidth! -
                              SizeConfig.pageHorizontalMargins * 2,
                          color: Colors.white,
                          onPressed: () {
                            Haptic.vibrate();
                            Vibration.vibrate(
                              pattern: [10, 80, 150, 80, 200, 50, 300, 50],
                            );
                            _controller.reverse().then((value) {
                              final userService = locator<UserService>();
                              final userRepo = locator<UserRepository>();
                              if (userService.baseUser!.userPreferences
                                      .getPreference(
                                          Preferences.TAMBOLAONBOARDING) !=
                                  1) {
                                userRepo.updateUser(
                                  uid: userService.baseUser!.uid,
                                  dMap: {
                                    'mUserPrefsAl': userService
                                            .baseUser!.userPreferences
                                            .getPreference(
                                          Preferences.APPLOCK,
                                        ) ==
                                        1,
                                    'mUserPrefsTn': userService
                                            .baseUser!.userPreferences
                                            .getPreference(
                                          Preferences.TAMBOLANOTIFICATIONS,
                                        ) ==
                                        1,
                                    'mUserPrefsEr': userService
                                            .baseUser!.userPreferences
                                            .getPreference(
                                          Preferences.FLOINVOICEMAIL,
                                        ) ==
                                        1,
                                    'mUserPrefsTo': true
                                  },
                                ).then((value) {
                                  userService.setBaseUser();
                                  const Log("Preferences updated");
                                });
                              }
                              AppState.delegate!.appState.currentAction =
                                  PageAction(
                                page: AssetSelectionViewConfig,
                                widget: const AssetSelectionPage(
                                    isTicketsFlow: true, showOnlyFlo: false),
                                state: PageState.replaceWidget,
                              );
                              locator<AnalyticsService>().track(
                                  eventName:
                                      AnalyticsEvents.completeTutorialTapped);
                              AppState.delegate!.onSilentTapItem(
                                  RootController.tambolaNavBar);
                            });
                          },
                          child: Text(
                            (locator<UserService>()
                                            .userFundWallet
                                            ?.tickets?["total"] ??
                                        0) >
                                    0
                                ? "CONTINUE"
                                : "GET YOUR 1ST TICKET",
                            style:
                                TextStyles.rajdhaniB.body0.colour(Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(height: SizeConfig.padding16)
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomStaggeredAnimatedWidget extends AnimatedWidget {
  final Animation<double> animation;
  final Widget child;
  const CustomStaggeredAnimatedWidget({
    required this.animation,
    required this.child,
    super.key,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: animation.value,
      child: Transform.scale(scale: animation.value, child: child),
    );
  }
}

class DummyAssetCard extends StatelessWidget {
  const DummyAssetCard({
    required this.bgColor,
    required this.asset,
    required this.title,
    required this.subtitle,
    required this.variations,
    super.key,
  });

  final Color bgColor;
  final String asset;
  final String title;
  final String subtitle;
  final List<Tuple2<String, String>> variations;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(SizeConfig.pageHorizontalMargins / 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SizeConfig.roundness12),
      ),
      color: bgColor,
      child: Container(
        width: SizeConfig.screenWidth! * 0.68,
        padding: EdgeInsets.all(SizeConfig.padding10),
        child: Column(
          children: [
            SvgPicture.asset(
              asset,
              height: SizeConfig.screenHeight! * 0.08,
            ),
            Text(
              title,
              style: TextStyles.rajdhaniSB.title4,
            ),
            SizedBox(height: SizeConfig.padding4),
            Text(
              subtitle,
              style: TextStyles.sourceSans.body4
                  .colour(Colors.white.withOpacity(0.8)),
            ),
            SizedBox(height: SizeConfig.padding16),
            Row(
              children: List.generate(
                variations.length,
                (i) => Expanded(
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: SizeConfig.padding4),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness12),
                      color: Colors.white12,
                    ),
                    child: Container(
                      margin: EdgeInsets.all(SizeConfig.padding10),
                      child: Column(children: [
                        Text(
                          variations[i].item1,
                          style:
                              TextStyles.sourceSansB.body3.colour(Colors.white),
                        ),
                        Text(
                          variations[i].item2,
                          style: TextStyles.bodyFont.colour(Colors.white60),
                        )
                      ]),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: SizeConfig.padding10)
          ],
        ),
      ),
    );
  }
}

class TicketsWinnersSlider extends StatefulWidget {
  const TicketsWinnersSlider({super.key});

  @override
  State<TicketsWinnersSlider> createState() => _TicketsWinnersSliderState();
}

class _TicketsWinnersSliderState extends State<TicketsWinnersSlider> {
  late final PageController _controller = PageController(initialPage: 0);

  Timer? _timer;
  int _currentPage = 0;

  final List<Tuple2<String, String>> winnersData = [
    const Tuple2('Manvendra S. Rathore', "27,821"),
    const Tuple2('Aryan Arora', "14,404"),
    const Tuple2('Sachin Tyagi', "14,103"),
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
        if (_currentPage < 3) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        if (_controller.hasClients) {
          _controller.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeIn,
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.padding60,
      width: SizeConfig.screenWidth,
      child: PageView.builder(
        controller: _controller,
        itemCount: 3,
        itemBuilder: (context, i) {
          return ListTile(
            leading: DefaultAvatar(),
            title: Text(
              winnersData[i].item1,
              style: TextStyles.sourceSansB.body2.colour(Colors.white),
            ),
            trailing: RichText(
              textAlign: TextAlign.end,
              text: TextSpan(
                text: "Earned ",
                style: TextStyles.rajdhaniSB.body3.colour(Colors.white),
                children: [
                  TextSpan(
                    text: "₹ ${winnersData[i].item2}\n",
                    style: TextStyles.rajdhaniSB.body3.colour(
                      const Color(0xffF6CC60),
                    ),
                  ),
                  TextSpan(
                    text: "from tickets last year",
                    style: TextStyles.rajdhaniSB.body3.colour(Colors.white),
                  )
                ],
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: SizeConfig.padding4,
              horizontal: SizeConfig.pageHorizontalMargins,
            ),
          );
        },
      ),
    );
  }
}
