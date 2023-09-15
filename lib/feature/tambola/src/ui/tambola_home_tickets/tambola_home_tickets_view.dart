import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/feature/tambola/src/ui/tambola_home_tickets/components/tickets_banners_section.dart';
import 'package:felloapp/feature/tambola/src/ui/tambola_home_tickets/components/tickets_mulitplier_section.dart';
import 'package:felloapp/feature/tambola/src/ui/tambola_home_tickets/components/tickets_picks_widget.dart';
import 'package:felloapp/feature/tambola/src/ui/tambola_home_tickets/tambola_home_tickets_vm.dart';
import 'package:felloapp/feature/tambola/src/ui/widgets/buy_ticket_card.dart';
import 'package:felloapp/feature/tambola/src/ui/widgets/next_week_info_card.dart';
import 'package:felloapp/feature/tambola/src/ui/widgets/past_week_winners_section.dart';
import 'package:felloapp/feature/tambola/src/ui/widgets/ticket/ticket_section.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

import 'components/tickets_offers_section.dart';
import 'components/tickets_rewards_section.dart';

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
          return model.state == ViewState.Busy
              ? const Center(
                  child: FullScreenLoader(),
                )
              : Stack(
                  children: [
                    ListView(
                      padding: EdgeInsets.only(
                        top: SizeConfig.padding16,
                        bottom: SizeConfig.navBarHeight,
                      ),
                      controller: _scrollController,
                      children: const [
                        TambolaRewardLottieStrip(),
                        TicketsPicksWidget(),
                        TicketSection(),
                        NextWeekTicketInfo(),
                        TicketsOffersSection(),
                        TicketMultiplierOptionsWidget(),
                        TicketsRewardSection(),
                        TambolaLeaderboardView(),
                      ],
                    ),
                  ],
                );
        });
  }
}
