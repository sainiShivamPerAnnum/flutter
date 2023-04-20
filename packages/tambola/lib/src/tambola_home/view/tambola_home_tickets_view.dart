import 'package:flutter/material.dart';
import 'package:tambola/src/tambola_home/widgets/buy_ticket_card.dart';
import 'package:tambola/src/tambola_home/widgets/how_it_works_section.dart';
import 'package:tambola/src/tambola_home/widgets/next_week_info_card.dart';
import 'package:tambola/src/tambola_home/widgets/past_week_winners_section.dart';
import 'package:tambola/src/tambola_home/widgets/results_card.dart';
import 'package:tambola/src/tambola_home/widgets/ticket_section.dart';
import 'package:tambola/src/tambola_home/widgets/today_weekly_pick_card.dart';
import 'package:tambola/src/utils/styles/styles.dart';

class TambolaHomeTicketsView extends StatefulWidget {
  const TambolaHomeTicketsView({
    Key? key,
  }) : super(key: key);

  // final TambolaHomeViewModel model;

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
    // S locale = S.of(context);
    return Stack(
      children: [
        SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //1 Cr Lottie
              const TambolaRewardLottieStrip(),
              //Weekly/Daily Picks Card
              const TodayWeeklyPicksCard(showBanner: true),
              //Tambola Results Card
              TambolaResultCard(showCard: false),
              //Tickets Section
              TicketSection(
                getTicketsTapped: () {
                  _scrollController?.animateTo(SizeConfig.screenHeight! * 0.7,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.fastOutSlowIn);
                  tambolaBuyTicketCardKey.currentState?.startAnimation();
                },
              ),
              const NextWeekTicketInfo(),
              AnimatedBuyTambolaTicketCard(
                key: tambolaBuyTicketCardKey,
              ),
              TambolaLeaderBoard(winners: []),
              HowTambolaWorks(),
              // LottieBuilder.network(Assets.bottomBannerLottie),
              SizedBox(height: SizeConfig.navBarHeight),
            ],
          ),
        ),
      ],
    );
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
        // child: Lottie.asset(Assets.tambolaTopBannerLottie),
      ),
    );
  }
}
