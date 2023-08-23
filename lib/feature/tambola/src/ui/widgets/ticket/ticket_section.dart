import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/feature/tambola/src/models/daily_pick_model.dart';
import 'package:felloapp/feature/tambola/src/models/tambola_best_tickets_model.dart';
import 'package:felloapp/feature/tambola/src/services/tambola_service.dart';
import 'package:felloapp/feature/tambola/src/ui/tambola_all_tickets/tambola_all_tickets_view.dart';
import 'package:felloapp/feature/tambola/src/ui/tambola_home_details/tambola_home_details_view.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/asset_selection.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

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
          // SizedBox(
          //   height: SizeConfig.padding6,
          // ),
          // TicketsView(
          //   bestTickets: data.item1,
          //   weeklyPicks: data.item2 ?? DailyPick.noPicks(),
          // ),
          TicketMatchesBriefBoxWidget(),
          ViewAllTicketsBar(
            title: "View All Tickets",
            onPressed: () {
              Haptic.vibrate();
              AppState.delegate!.appState.currentAction = PageAction(
                state: PageState.addWidget,
                page: AllTambolaTicketsPageConfig,
                widget: AllTambolaTickets(
                  weeklyPicks: locator<TambolaService>().weeklyPicks ??
                      DailyPick.noPicks(),
                ),
              );
            },
          ),
          ViewAllTicketsBar(
            title: "Reward Categories",
            onPressed: () {
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
          )
        ],
      ),
    );
  }
}

class TicketMatchesBriefBoxWidget extends StatelessWidget {
  const TicketMatchesBriefBoxWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeConfig.roundness12),
      ),
    );
  }
}

class ViewAllTicketsBar extends StatelessWidget {
  const ViewAllTicketsBar(
      {super.key, required this.title, required this.onPressed});

  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeConfig.padding10),
      child: GestureDetector(
        onTap: onPressed,
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
                title,
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
              Selector<TambolaService, int>(
                selector: (_, tambolaService) =>
                    tambolaService.expiringTicketsCount,
                builder: (_, expiringTicketCount, child) {
                  if (expiringTicketCount > 0) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: SizeConfig.padding4,
                        ),
                        Text(
                          "${expiringTicketCount} ticket${expiringTicketCount > 1 ? 's' : ''} expiring this Sunday",
                          style: TextStyles.sourceSansSB.body4
                              .colour(UiConstants.kBlogTitleColor),
                          maxLines: 2,
                          textAlign: TextAlign.start,
                        ),
                        // GestureDetector(
                        //   onTap: () {
                        //     // AppState.delegate!.appState.currentAction =
                        //     //     PageAction(
                        //     //   state: PageState.addWidget,
                        //     //   page: FaqPageConfig,
                        //     //   widget: const FAQPage(
                        //     //     type: FaqsType.play,
                        //     //   ),
                        //     // );
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
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              )
            ],
          ),
          MaterialButton(
            onPressed: () {
              AppState.delegate!.appState.currentAction = PageAction(
                page: AssetSelectionViewConfig,
                state: PageState.addWidget,
                widget: const AssetSelectionPage(
                  showOnlyFlo: false,
                ),
              );
              // AppState.delegate!.parseRoute(Uri.parse('assetBuy'));
            },
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "+ Get Tickets",
              style: TextStyles.rajdhaniB.body2.colour(Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
