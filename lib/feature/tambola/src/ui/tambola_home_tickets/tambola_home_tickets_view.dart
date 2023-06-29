import 'package:felloapp/core/enums/page_state_enum.dart';
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
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

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
                    const TambolaRewardLottieStrip(),
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

class TambolaRewardLottieStrip extends StatelessWidget {
  const TambolaRewardLottieStrip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.pageHorizontalMargins,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(SizeConfig.roundness12),
        child: (DateTime.now().weekday == 1 && DateTime.now().hour < 16)
            ? const SizedBox()
            : InkWell(
                onTap: () {
                  Haptic.vibrate();
                  AppState.delegate!.appState.currentAction = PageAction(
                    state: PageState.addWidget,
                    page: TambolaNewUser,
                    widget: const TambolaHomeDetailsView(
                      isStandAloneScreen: true,
                      showPrizeSection: true,
                      showBottomButton: false,
                      showDemoImage: false,
                    ),
                  );
                },
                child: Lottie.asset(Assets.tambolaTopBannerTharLottie)),
      ),
    );
  }
}
