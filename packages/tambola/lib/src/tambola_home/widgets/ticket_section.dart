import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tambola/src/models/daily_pick.dart';
import 'package:tambola/src/tambola_home/widgets/ticket_view.dart';
import 'package:tambola/src/utils/assets.dart';
import 'package:tambola/src/utils/styles/styles.dart';

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
    return Column(
      children: [
        TicketHeader(
          activeTambolaCardCount: 0,
          getTicketsTapped: getTicketsTapped,
        ),
        SizedBox(
          height: SizeConfig.padding6,
        ),
        TicketsView(
          tabList: [],
          tickets: [],
          showIndicatorForAll: true,
          weeklyPicks: DailyPick.noPicks(),
        ),
        ViewAllTicketsBar()
      ],
    );
  }
}

class ViewAllTicketsBar extends StatelessWidget {
  // const ViewAllTicketsBar({required this.model, super.key});

  // final TambolaHomeViewModel model;

  @override
  Widget build(BuildContext context) {
    // S locale = S.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeConfig.padding10),
      child: GestureDetector(
        // onTap: () {
        //   AppState.delegate!.appState.currentAction = PageAction(
        //     state: PageState.addWidget,
        //     page: AllTambolaTicketsPageConfig,
        //     widget: AllTambolaTickets(
        //         ticketList: model.userWeeklyBoards),
        //   );
        // },
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
