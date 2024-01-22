import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/timestamp_model.dart';
import 'package:felloapp/core/model/user_funt_wallet_model.dart';
import 'package:felloapp/core/model/winners_model.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/feature/tambola/src/ui/animations/dotted_border_animation.dart';
import 'package:felloapp/feature/tambola/src/ui/weekly_results_views/weekly_result.dart';
import 'package:felloapp/feature/tambola/src/ui/widgets/tambola_picks/weekly_picks.dart';
import 'package:felloapp/feature/tambola/tambola.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/elements/page_views/height_adaptive_pageview.dart';
import 'package:felloapp/ui/elements/timer/app_countdown_timer.dart';
import 'package:felloapp/ui/pages/asset_selection.dart';
import 'package:felloapp/ui/pages/root/root_controller.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../../../../../../util/assets.dart';

class TicketsPicksWidget extends StatefulWidget {
  const TicketsPicksWidget({super.key});

  @override
  State<TicketsPicksWidget> createState() => _TicketsPicksWidgetState();
}

class _TicketsPicksWidgetState extends State<TicketsPicksWidget> {
  PageController? controller;
  ValueNotifier<double>? pageValue;
  @override
  void initState() {
    pageValue = ValueNotifier(0);

    controller = PageController()
      ..addListener(() {
        pageValue!.value = controller!.page ?? 0;
      });
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void switchPage() {
    if (controller!.page == 0) {
      controller!.animateToPage(1,
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    } else {
      controller!.animateToPage(0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeConfig.roundness16),
        color: const Color(0xff161d22),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.pageHorizontalMargins,
        vertical: SizeConfig.padding10,
      ),
      child: Column(
        children: [
          const TicketsSundayWinCard(),
          Container(
            width: SizeConfig.screenWidth,
            padding: EdgeInsets.only(
              left: SizeConfig.pageHorizontalMargins,
              top: SizeConfig.pageHorizontalMargins,
              right: SizeConfig.pageHorizontalMargins,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(SizeConfig.roundness16),
                color: UiConstants.kSaveStableFelloCardBg,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 10),
                    blurRadius: 5,
                    spreadRadius: 0,
                  )
                ]),
            child: Column(
              children: [
                HeightAdaptivePageView(
                  controller: controller!,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    KeepAlivePage(child: SlotMachineWidget(
                      onTimerEnd: () {
                        setState(() {});
                      },
                    )),
                    const KeepAlivePage(child: WeeklyPicks()),
                  ],
                ),
                // SizedBox(height: SizeConfig.padding14),
                TextButton(
                  onPressed: switchPage,
                  child: ValueListenableBuilder(
                    valueListenable: pageValue!,
                    builder: (context, value, child) => value <= 0.5
                        ? Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                "Numbers Revealed this Week  ",
                                style: TextStyles.sourceSansSB.body2
                                    .colour(UiConstants.kTealTextColor),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: UiConstants.kTealTextColor,
                                size: SizeConfig.padding16,
                              )
                            ],
                          )
                        : Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: UiConstants.kTealTextColor,
                                size: SizeConfig.padding16,
                              ),
                              Text(
                                "  Today's Numbers",
                                style: TextStyles.sourceSansSB.body2
                                    .colour(UiConstants.kTealTextColor),
                              ),
                            ],
                          ),
                  ),
                ),
                SizedBox(height: SizeConfig.padding12),
              ],
            ),
          ),
          const TicketsTotalWinWidget(),
        ],
      ),
    );
  }
}

class TicketsTotalWinWidget extends StatelessWidget {
  const TicketsTotalWinWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<TambolaService, Tuple2<Winners?, bool>>(
      selector: (_, service) => Tuple2(
        service.winnerData,
        service.isEligible,
      ),
      builder: (context, value, child) => !(value.item1 != null && value.item2)
          ? Container(
              padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.padding10,
                  horizontal: SizeConfig.pageHorizontalMargins),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Total Won from Tickets",
                        style: TextStyles.rajdhani.body2,
                      ),
                      const Spacer(),
                      Selector<UserService, UserFundWallet?>(
                        selector: (p0, p1) => p1.userFundWallet,
                        builder: (context, value, child) => Text(
                          "₹${value?.wTmbLifetimeWin ?? 0}",
                          style: TextStyles.rajdhaniSB.body0
                              .colour(UiConstants.kGoldProPrimary),
                        ),
                      ),
                    ],
                  ),
                  Selector<TambolaService, Tuple2<Winners?, bool>>(
                    builder: (context, value, child) => value.item2
                        ? Column(
                            children: [
                              SizedBox(height: SizeConfig.padding8),
                              InkWell(
                                onTap: () {
                                  Haptic.strongVibrate();
                                  AppState.delegate!.appState.currentAction =
                                      PageAction(
                                    state: PageState.addWidget,
                                    page: TWeeklyResultPageConfig,
                                    widget: WeeklyResult(
                                      winner: value.item1!,
                                      isEligible: true,
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "See what you won last week",
                                      style: TextStyles.sourceSans.body3
                                          .colour(UiConstants.kFAQsAnswerColor),
                                    ),
                                    const Spacer(),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: SizeConfig.iconSize4,
                                      color: UiConstants.kFAQsAnswerColor,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                        : const SizedBox(),
                    selector: (p0, p1) =>
                        Tuple2(p1.pastWinnerData, p1.showPastWeekWinStrip),
                  ),
                  SizedBox(height: SizeConfig.padding4),
                ],
              ),
            )
          : const SizedBox(),
    );
  }
}

class TicketsSundayWinCard extends StatelessWidget {
  const TicketsSundayWinCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<TambolaService, Tuple2<Winners?, bool>>(
        selector: (_, service) => Tuple2(
              service.winnerData,
              service.isEligible,
            ),
        builder: (context, value, child) => value.item1 != null && value.item2
            ? GestureDetector(
                onTap: () =>
                    AppState.delegate!.appState.currentAction = PageAction(
                  state: PageState.addWidget,
                  page: TWeeklyResultPageConfig,
                  widget: WeeklyResult(
                    winner: value.item1!,
                    isEligible: value.item2,
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.padding14,
                      horizontal: SizeConfig.pageHorizontalMargins),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            Assets.tambolaPrizeAsset,
                            width: SizeConfig.padding40,
                          ),
                          Text(
                            "  Congratulations!  ",
                            style: TextStyles.sourceSansB.title4,
                          ),
                          SvgPicture.asset(
                            Assets.tambolaPrizeAsset,
                            width: SizeConfig.padding40,
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(SizeConfig.padding8),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              "View Winning Categories  ",
                              style: TextStyles.sourceSansSB.body3
                                  .colour(UiConstants.kFAQsAnswerColor),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: UiConstants.kFAQsAnswerColor,
                              size: SizeConfig.padding12,
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: SizeConfig.padding12,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: SizeConfig.screenWidth! * 0.36,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Your Net Reward",
                                    style: TextStyles.rajdhaniM.body2.colour(
                                        UiConstants.kTextFieldTextColor),
                                  ),
                                  SizedBox(height: SizeConfig.padding6),
                                  Text(
                                    "₹${(locator<UserService>().userFundWallet?.wTmbLifetimeWin ?? 0) + (value.item1?.amount ?? 0)}",
                                    style: TextStyles.sourceSansSB.title4,
                                  )
                                ],
                              ),
                            ),
                            const Spacer(),
                            SizedBox(
                              width: SizeConfig.screenWidth! * 0.32,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "This week Reward",
                                    style: TextStyles.rajdhaniM.body2.colour(
                                        UiConstants.kTextFieldTextColor),
                                  ),
                                  SizedBox(height: SizeConfig.padding6),
                                  Text(
                                    "₹${value.item1!.amount}",
                                    style: TextStyles.sourceSansSB.title4
                                        .colour(UiConstants.kGoldProPrimary),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            : const SizedBox());
  }
}

class SlotMachineWidget extends StatefulWidget {
  const SlotMachineWidget({required this.onTimerEnd, super.key});

  final VoidCallback onTimerEnd;

  @override
  State<SlotMachineWidget> createState() => _SlotMachineWidgetState();
}

class _SlotMachineWidgetState extends State<SlotMachineWidget>
    with SingleTickerProviderStateMixin {
  late PageController _controller1, _controller2, _controller3;
  final _tambolaService = locator<TambolaService>();
  bool _isSpinning = false;

  bool get isSpinning => _isSpinning;

  set isSpinning(bool value) {
    setState(() {
      _isSpinning = value;
    });
  }

  @override
  void initState() {
    super.initState();
    _tambolaService.ticketsDotLightsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    String lastSpinTimeInIsoString = PreferenceHelper.getString(
        PreferenceHelper.CACHE_TICKETS_LAST_SPIN_TIMESTAMP);
    if (lastSpinTimeInIsoString.isNotEmpty) {
      TimestampModel lastSpinTime =
          TimestampModel.fromIsoString(lastSpinTimeInIsoString);

      if (lastSpinTime.toDate().day == DateTime.now().day &&
          lastSpinTime.toDate().month == DateTime.now().month) {
        _controller1 = PageController(
            viewportFraction: 0.6,
            initialPage: _tambolaService.todaysPicks![0]);
        _controller2 = PageController(
            viewportFraction: 0.6,
            initialPage: _tambolaService.todaysPicks![1]);
        _controller3 = PageController(
            viewportFraction: 0.6,
            initialPage: _tambolaService.todaysPicks![2]);
        _tambolaService.setSlotMachineTitle();
        _tambolaService.ticketsDotLightsController!.stop();
      } else {
        _controller1 = PageController(viewportFraction: 0.6, initialPage: 0);
        _controller2 = PageController(viewportFraction: 0.6, initialPage: 0);
        _controller3 = PageController(viewportFraction: 0.6, initialPage: 0);
      }
    } else {
      _controller1 = PageController(viewportFraction: 0.6, initialPage: 0);
      _controller2 = PageController(viewportFraction: 0.6, initialPage: 0);
      _controller3 = PageController(viewportFraction: 0.6, initialPage: 0);
    }
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  void spin() {
    if (isSpinning) return;
    isSpinning = true;
    Haptic.vibrate();
    _tambolaService.ticketsDotLightsController!.stop();
    _tambolaService.ticketsDotLightsController!.duration =
        const Duration(milliseconds: 200);
    _tambolaService.ticketsDotLightsController!.repeat(reverse: true);
    _controller1.jumpToPage(0);
    _controller2.jumpToPage(0);
    _controller3.jumpToPage(0);
    Haptic.slotVibrate();
    _controller1.animateToPage(_tambolaService.todaysPicks![0],
        duration: const Duration(seconds: 2), curve: Curves.easeOutExpo);
    _controller2.animateToPage(_tambolaService.todaysPicks![1],
        duration: const Duration(seconds: 3), curve: Curves.easeOutExpo);
    _controller3.animateToPage(_tambolaService.todaysPicks![2],
        duration: const Duration(seconds: 4), curve: Curves.easeOutExpo);
    Future.delayed(const Duration(seconds: 4), () {
      _tambolaService.ticketsDotLightsController!.stop();
      isSpinning = false;
      RootController.controller.animateTo(
        SizeConfig.screenWidth! * 0.8,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInCirc,
      );
      _tambolaService.postSlotSpin();
      Future.delayed(const Duration(seconds: 1), () {
        widget.onTimerEnd();
      });
    });
    locator<AnalyticsService>()
        .track(eventName: AnalyticsEvents.ticketSpinTapped);
  }

  bool showButton = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Selector<TambolaService, String>(
          builder: (context, value, child) => Text(
            value,
            style: TextStyles.rajdhaniSB.body1.colour(Colors.white),
            textAlign: TextAlign.center,
          ),
          selector: (p0, p1) => p1.slotMachineTitle,
        ),
        Selector<TambolaService, List<int>?>(
          builder: (context, value, child) => Padding(
            padding: EdgeInsets.all(SizeConfig.padding16),
            child: AnimatedDottedRectangle(
              controller: _tambolaService.ticketsDotLightsController!,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(SizeConfig.roundness16),
                  color: Colors.black,
                ),
                margin: EdgeInsets.all(SizeConfig.padding16),
                child: Row(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        controller: _controller1,
                        scrollDirection: Axis.vertical,
                        itemCount: 91,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (ctx, i) => Container(
                          alignment: Alignment.center,
                          height: SizeConfig.title50,
                          child: Text(
                            i == 0 ? "Spin" : "$i".padLeft(2, '0'),
                            style: TextStyles.rajdhaniSB.title1
                                .colour(Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: PageView.builder(
                        controller: _controller2,
                        scrollDirection: Axis.vertical,
                        itemCount: 91,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (ctx, i) => Container(
                          alignment: Alignment.center,
                          height: SizeConfig.title50,
                          child: Text(
                            i == 0
                                ? (value!.contains(-1) ? "at" : "to")
                                : "$i".padLeft(2, '0'),
                            style: TextStyles.rajdhaniSB.title1
                                .colour(Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: PageView.builder(
                        controller: _controller3,
                        scrollDirection: Axis.vertical,
                        itemCount: 91,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (ctx, i) => Container(
                          alignment: Alignment.center,
                          height: SizeConfig.title50,
                          child: Text(
                            i == 0
                                ? (value!.contains(-1) ? "6pm" : "Win")
                                : "$i".padLeft(2, '0'),
                            style: TextStyles.rajdhaniSB.title1
                                .colour(Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          selector: (p0, p1) => p1.todaysPicks,
        ),
        Consumer<TambolaService>(
          builder: (context, tService, child) => AnimatedSwitcher(
            duration: const Duration(seconds: 1),
            switchInCurve: Curves.easeOutExpo,
            switchOutCurve: Curves.easeInExpo,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: animation,
                  child: child,
                ),
              );
            },
            child: tService.todaysPicks!.contains(-1)
                ? ((tService.bestTickets?.data?.totalTicketCount ?? 0) > 0
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Next Spin in ",
                            style: TextStyles.sourceSansB.body1,
                          ),
                          AppCountdownTimer(
                            style: TextStyles.sourceSansB.body1,
                            endTime: TimestampModel.fromIsoString(
                              DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day,
                                18,
                                0,
                                10,
                              ).toIso8601String(),
                            ),
                            onTimerEnd: () async {
                              await tService.refreshTickets();
                              setState(() {});
                              widget.onTimerEnd();
                            },
                          )
                        ],
                      )
                    : MaterialButton(
                        height: SizeConfig.padding44,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(SizeConfig.roundness5)),
                        minWidth: SizeConfig.screenWidth! * 0.8,
                        color: isSpinning ? Colors.grey : Colors.white,
                        onPressed: () {
                          AppState.delegate!.appState.currentAction =
                              PageAction(
                            page: AssetSelectionViewConfig,
                            widget: const AssetSelectionPage(
                              isTicketsFlow: true,
                            ),
                            state: PageState.addWidget,
                          );
                        },
                        child: Text(
                          "GET YOUR FIRST TICKET",
                          style:
                              TextStyles.rajdhaniB.body0.colour(Colors.black),
                        ),
                      ))
                : tService.showSpinButton
                    ? MaterialButton(
                        height: SizeConfig.padding44,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(SizeConfig.roundness5)),
                        minWidth: SizeConfig.screenWidth! * 0.3,
                        color: isSpinning ? Colors.grey : Colors.white,
                        onPressed: spin,
                        enableFeedback: !isSpinning,
                        child: Text(
                          "SPIN",
                          style:
                              TextStyles.rajdhaniB.body0.colour(Colors.black),
                        ),
                      )
                    : Text(
                        "Next Spin at 6 PM tomorrow",
                        style: TextStyles.sourceSansB.body1,
                      ),
          ),
        ),
      ],
    );
  }
}

class KeepAlivePage extends StatefulWidget {
  const KeepAlivePage({
    required this.child,
    Key? key,
  }) : super(key: key);

  final Widget child;

  @override
  _KeepAlivePageState createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<KeepAlivePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    /// Dont't forget this
    super.build(context);

    return widget.child;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
