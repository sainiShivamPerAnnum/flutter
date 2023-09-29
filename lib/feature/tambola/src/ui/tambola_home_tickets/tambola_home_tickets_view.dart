import 'dart:async';

import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/feature/tambola/src/ui/tambola_home_details/tambola_home_details_view.dart';
import 'package:felloapp/feature/tambola/src/ui/tambola_home_tickets/tambola_home_tickets_vm.dart';
import 'package:felloapp/feature/tambola/src/ui/widgets/buy_ticket_card.dart';
import 'package:felloapp/feature/tambola/src/ui/widgets/next_week_info_card.dart';
import 'package:felloapp/feature/tambola/src/ui/widgets/past_week_winners_section.dart';
import 'package:felloapp/feature/tambola/src/ui/widgets/results_card.dart';
import 'package:felloapp/feature/tambola/src/ui/widgets/tambola_picks/today_weekly_pick_card.dart';
import 'package:felloapp/feature/tambola/src/ui/widgets/ticket/ticket_section.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/asset_selection.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TambolaHomeTicketsView extends StatefulWidget {
  const TambolaHomeTicketsView({
    Key? key,
  }) : super(key: key);

  @override
  State<TambolaHomeTicketsView> createState() => _TambolaHomeTicketsViewState();
}

class _TambolaHomeTicketsViewState extends State<TambolaHomeTicketsView> {
  ScrollController? _scrollController;

  final GlobalKey<AnimatedBuyTambolaTicketCardState> tambolaBuyTicketCardKey =
      GlobalKey<AnimatedBuyTambolaTicketCardState>();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<TambolaHomeTicketsViewModel>(
        onModelReady: (model) => model.init(),
        onModelDispose: (model) => model.dispose(),
        builder: (context, model, child) {
          return Stack(
            children: [
              SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: SizeConfig.padding16),
                    //1 Cr Lottie
                    TambolaRewardLottieStrip(),
                    //Weekly/Daily Picks Card
                    const TodayWeeklyPicksCard(),
                    //Tambola Results Card
                    const TambolaResultCard(),
                    //Tickets Section
                    TicketSection(
                      getTicketsTapped: () {
                        HapticFeedback.vibrate();
                        _scrollController?.animateTo(
                            SizeConfig.screenHeight! * 0.7,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.fastOutSlowIn);
                        tambolaBuyTicketCardKey.currentState?.startAnimation();
                      },
                    ),
                    const NextWeekTicketInfo(),
                    // AnimatedBuyTambolaTicketCard(key: tambolaBuyTicketCardKey),
                    const TambolaLeaderboardView(),
                    // LottieBuilder.network(Assets.bottomBannerLottie),
                    SizedBox(height: SizeConfig.navBarHeight),
                  ],
                ),
              ),
            ],
          );
        });
  }
}

class TambolaRewardLottieStrip extends StatefulWidget {
  TambolaRewardLottieStrip({
    super.key,
  });

  @override
  State<TambolaRewardLottieStrip> createState() =>
      _TambolaRewardLottieStripState();
}

class _TambolaRewardLottieStripState extends State<TambolaRewardLottieStrip> {
  final List<String> _goldMarquee = [
    'Get more tickets now',
    'Know how Tickets work',
    'Know about Ticket Rewards',
  ];

  final List<String> icon = [
    Assets.tambolaCardAsset,
    'assets/svg/trophy_banner.svg',
    'assets/svg/question.svg',
  ];

  void onTap(int index) {
    switch (index) {
      case 0:
        AppState.delegate!.appState.currentAction = PageAction(
          page: AssetSelectionViewConfig,
          state: PageState.addWidget,
          widget: const AssetSelectionPage(
            showOnlyFlo: false,
          ),
        );
        break;
      case 1:
      case 2:
        AppState.delegate!.appState.currentAction = PageAction(
          state: PageState.addWidget,
          page: TambolaNewUser,
          widget: TambolaHomeDetailsView(
            isStandAloneScreen: true,
            showPrizeSection: index == 2,
            showBottomButton: false,
            showDemoImage: false,
          ),
        );
        break;
    }
  }

  late final PageController _controller =
      PageController(viewportFraction: 0.9, initialPage: 0);

  Timer? _timer;
  int _currentPage = 0;

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
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.padding48,
      width: SizeConfig.screenWidth,
      child: PageView.builder(
        controller: _controller,
        itemCount: 3,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              locator<AnalyticsService>().track(
                  eventName: AnalyticsEvents.tambolaCarousel,
                  properties: {
                    'order': index + 1,
                  });
              onTap(index);
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: SizeConfig.padding8),
              height: SizeConfig.padding54,
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.padding14,
                  vertical: SizeConfig.padding12),
              decoration: BoxDecoration(
                color: const Color(0xff01656B),
                borderRadius: BorderRadius.circular(SizeConfig.roundness12),
              ),
              child: Row(
                children: [
                  SizedBox(
                    height: SizeConfig.padding26,
                    width: SizeConfig.padding32,
                    child: SvgPicture.asset(
                      icon[index],
                      height: SizeConfig.padding26,
                      width: SizeConfig.padding32,
                    ),
                  ),
                  SizedBox(width: SizeConfig.padding10),
                  Text(_goldMarquee[index],
                      style: TextStyles.rajdhaniSB.body0.colour(Colors.white)),
                  const Spacer(),
                  SvgPicture.asset(
                    Assets.chevRonRightArrow,
                    color: UiConstants.primaryColor,
                    height: SizeConfig.padding24,
                    width: SizeConfig.padding24,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
