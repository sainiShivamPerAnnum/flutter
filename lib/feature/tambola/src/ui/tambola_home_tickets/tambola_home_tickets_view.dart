import 'package:felloapp/core/enums/faqTypes.dart';
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
import 'package:felloapp/ui/elements/appbar/appbar.dart';
import 'package:felloapp/ui/elements/dev_rel/flavor_banners.dart';
import 'package:felloapp/ui/elements/helpers/tnc_text.dart';
import 'package:felloapp/ui/pages/root/root_controller.dart';
import 'package:felloapp/ui/pages/root/root_view.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/util/constants.dart';
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
  ScrollController? scrollController;

  final GlobalKey<AnimatedBuyTambolaTicketCardState> tambolaBuyTicketCardKey =
      GlobalKey<AnimatedBuyTambolaTicketCardState>();

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: UiConstants.bg,
      body: Stack(
        children: [
          const NewSquareBackground(),
          Column(
            children: [
              const FAppBar(
                 title: "Tambola",
                showHelpButton: true,
                type: FaqsType.tambola,
                showCoinBar: false,
                showAvatar: false,
                leadingPadding: false,
              ),
              BaseView<TambolaHomeTicketsViewModel>(
                  onModelReady: (model) => model.init(),
                  onModelDispose: (model) => model.dispose(),
                  builder: (context, model, child) {
                    return model.state == ViewState.Busy
                        ? const Center(
                            child: FullScreenLoader(),
                          )
                        : Expanded(
                            child: ListView(
                              padding: EdgeInsets.only(
                                top: SizeConfig.padding16,
                                bottom: SizeConfig.navBarHeight,
                              ),
                              controller: RootController.controller,
                              children: const [
                                TambolaRewardLottieStrip(),
                                TicketsPicksWidget(),
                                TicketSection(),
                                NextWeekTicketInfo(),
                                TicketsOffersSection(),
                                TicketMultiplierOptionsWidget(),
                                TicketsRewardSection(),
                                TambolaLeaderboardView(),
                                TermsAndConditions(url: Constants.tambolatnc),
                              ],
                            ),
                          );
                  }),
            ],
          ),
        ],
      ),
    );
  }
}
