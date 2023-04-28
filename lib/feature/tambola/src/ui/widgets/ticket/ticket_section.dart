import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/feature/tambola/src/models/daily_pick_model.dart';
import 'package:felloapp/feature/tambola/src/models/tambola_best_tickets_model.dart';
import 'package:felloapp/feature/tambola/src/services/tambola_service.dart';
import 'package:felloapp/feature/tambola/src/ui/tambola_all_tickets/tambola_all_tickets_view.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import 'ticket_view.dart';

class TicketSection extends StatelessWidget {
  const TicketSection({
    required this.getTicketsTapped,
    // required this.model,
    Key? key,
  }) : super(key: key);

  // final TambolaHomeViewModel model;
  final VoidCallback getTicketsTapped;

  @override
  Widget build(BuildContext context) {
    return Selector<TambolaService,
        Tuple2<TambolaBestTicketsModel?, DailyPick?>>(
      selector: (_, tambolaService) => Tuple2(
        tambolaService.bestTickets,
        tambolaService.weeklyPicks,
      ),
      builder: (ctx, data, child) => Column(
        children: [
          TicketHeader(
            activeTambolaCardCount: data.item1?.data?.totalTicketCount ?? 0,
            getTicketsTapped: getTicketsTapped,
          ),
          SizedBox(
            height: SizeConfig.padding6,
          ),
          TicketsView(
            bestTickets: data.item1,
            // showIndicatorForAll: true,
            weeklyPicks: data.item2 ?? DailyPick.noPicks(),
          ),
          const ViewAllTicketsBar()
        ],
      ),
    );
  }
}

class ViewAllTicketsBar extends StatelessWidget {
  const ViewAllTicketsBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeConfig.padding10),
      child: GestureDetector(
        onTap: () {
          AppState.delegate!.appState.currentAction = PageAction(
            state: PageState.addWidget,
            page: AllTambolaTicketsPageConfig,
            widget: AllTambolaTickets(
              ticketList:
                  locator<TambolaService>().bestTickets?.data?.allTickets() ??
                      [],
              weeklyPicks:
                  locator<TambolaService>().weeklyPicks ?? DailyPick.noPicks(),
            ),
          );
        },
        child: Container(
          margin:
              EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth! * 0.06),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: UiConstants.kModalSheetSecondaryBackgroundColor
                .withOpacity(0.2),
            border: Border.all(
                color: UiConstants.kModalSheetSecondaryBackgroundColor),
            borderRadius: BorderRadius.circular(SizeConfig.roundness12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "View All Tickets",
                style: TextStyles.rajdhaniSB.body1,
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: SizeConfig.padding16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TicketHeader extends StatelessWidget {
  const TicketHeader({
    required this.activeTambolaCardCount,
    required this.getTicketsTapped,
    super.key,
  });

  final int activeTambolaCardCount;
  final VoidCallback getTicketsTapped;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.padding26,
        vertical: SizeConfig.padding16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  SvgPicture.asset(Assets.ticket_icon),
                  SizedBox(
                    width: SizeConfig.padding8,
                  ),
                  Text("Tickets ($activeTambolaCardCount)",
                      style: TextStyles.rajdhaniSB.body1),
                ],
              ),
              // if (TambolaRepo.expiringTicketCount != 0)
              // if (TambolaRepo.expiringTicketCount > 1)
              //   SizedBox(
              //     height: SizeConfig.padding4,
              //   ),
              // if (TambolaRepo.expiringTicketCount > 1)
              Row(
                children: [
                  // Text(
                  //   "${TambolaRepo.expiringTicketCount} ticket${TambolaRepo.expiringTicketCount > 1 ? 's' : ''} expiring this Sunday. ",
                  //   style: TextStyles.sourceSansSB.body4
                  //       .colour(UiConstants.kBlogTitleColor),
                  // ),
                  // GestureDetector(
                  //   onTap: () {
                  //     AppState.delegate!.appState.currentAction = PageAction(
                  //       state: PageState.addWidget,
                  //       page: FaqPageConfig,
                  //       widget: const FAQPage(
                  //         type: FaqsType.play,
                  //       ),
                  //     );
                  //   },
                  //   child: Text(
                  //     "Know More",
                  //     style: TextStyles.sourceSansSB.body4
                  //         .colour(UiConstants.kBlogTitleColor)
                  //         .copyWith(
                  //             decorationStyle: TextDecorationStyle.solid,
                  //             decoration: TextDecoration.underline),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: getTicketsTapped,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.padding12,
                vertical: SizeConfig.padding6,
              ),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(SizeConfig.roundness40),
              ),
              child: Text(
                "Get Tickets",
                style: TextStyles.rajdhaniSB.body4.colour(Colors.white),
                key: const ValueKey("getTambolaTickets"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
