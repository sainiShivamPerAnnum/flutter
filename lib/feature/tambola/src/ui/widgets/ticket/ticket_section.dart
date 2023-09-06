import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/feature/tambola/src/models/daily_pick_model.dart';
import 'package:felloapp/feature/tambola/src/models/tambola_best_tickets_model.dart';
import 'package:felloapp/feature/tambola/src/services/tambola_service.dart';
import 'package:felloapp/feature/tambola/src/ui/tambola_all_tickets/tambola_all_tickets_view.dart';
import 'package:felloapp/feature/tambola/src/ui/tambola_home_details/tambola_home_details_view.dart';
import 'package:felloapp/feature/tambola/src/ui/widgets/ticket/tambola_ticket.dart';
import 'package:felloapp/feature/tambola/src/ui/widgets/ticket/ticket_painter.dart';
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
    // required this.getTicketsTapped,
    // required this.model,
    Key? key,
  }) : super(key: key);

  // final TambolaHomeViewModel model;
  // final VoidCallback getTicketsTapped;

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
            // getTicketsTapped: getTicketsTapped,
          ),
          ((
                      // data.item1?.data?.totalTicketCount ??
                      0) ==
                  0)
              ? Container(
                  margin: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                  decoration: BoxDecoration(
                    color: UiConstants.kTambolaMidTextColor,
                    borderRadius: BorderRadius.circular(SizeConfig.roundness16),
                  ),
                  padding: EdgeInsets.all(SizeConfig.padding12),
                  child: Row(children: [
                    SvgPicture.asset(Assets.goldAsset,
                        width: SizeConfig.padding60),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Save min ',
                            ),
                            TextSpan(
                              text: '₹500',
                              style: TextStyles.rajdhaniB.title5
                                  .colour(const Color(0xFFFFD979)),
                            ),
                            const TextSpan(
                              text:
                                  ' to get Tickets every week and Earn Rewards',
                            ),
                          ],
                        ),
                        style: TextStyles.rajdhaniB.title5.colour(Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SvgPicture.asset(Assets.floAsset,
                        width: SizeConfig.padding60),
                  ]),
                )
              : Column(
                  children: [
                    const TicketMatchesBriefBoxWidget(),
                    const BestTicketsSection(),
                    ViewallBestTicketsBar(
                      title: "View All Tickets",
                      onPressed: () {
                        Haptic.vibrate();
                        AppState.delegate!.appState.currentAction = PageAction(
                          state: PageState.addWidget,
                          page: AllTambolaTicketsPageConfig,
                          widget: AllTambolaTickets(
                            weeklyPicks:
                                locator<TambolaService>().weeklyPicks ??
                                    DailyPick.noPicks(),
                          ),
                        );
                      },
                    ),
                    ViewallBestTicketsBar(
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
                )
        ],
      ),
    );
  }
}

class BestTicketsSection extends StatelessWidget {
  const BestTicketsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<TambolaService>(builder: (context, model, child) {
      return Container(
        margin: EdgeInsets.only(
            top: SizeConfig.padding20, bottom: SizeConfig.padding10),
        height: SizeConfig.screenWidth! * 0.6,
        width: SizeConfig.screenWidth,
        child: ListView.builder(
          itemCount: model.allBestTickets!.length,
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.pageHorizontalMargins - SizeConfig.padding10,
          ),
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => Container(
            margin: EdgeInsets.symmetric(horizontal: SizeConfig.padding10),
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  painter: TicketPainter(
                      borderColor: index % 2 == 0
                          ? UiConstants.primaryColor
                          : Colors.transparent),
                  child: Container(
                    padding: EdgeInsets.only(
                      left: SizeConfig.padding16,
                      right: SizeConfig.padding16,
                      top: SizeConfig.padding16,
                      bottom: SizeConfig.padding12,
                    ),
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: MediaQuery.of(context).size.width * 0.6,
                    decoration: BoxDecoration(
                      // color: UiConstants.kBuyTicketBg,
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness5),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              '#${model.allBestTickets![index].getTicketNumber()}',
                              style: TextStyles.sourceSans.body4
                                  .colour(UiConstants.kGreyTextColor),
                            ),
                            const Spacer(),
                            AnimatedCrossFade(
                              crossFadeState: CrossFadeState.showFirst,
                              duration: const Duration(seconds: 1),
                              sizeCurve: Curves.easeOutExpo,
                              firstChild: Text(
                                "5 Matches",
                                style: TextStyles.sourceSansB.body3
                                    .colour(UiConstants.primaryColor),
                              ),
                              secondChild: Text(
                                "",
                                style: TextStyles.sourceSansB.body4
                                    .colour(UiConstants.primaryColor),
                              ),
                            )
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: SizeConfig.padding20),
                          alignment: Alignment.center,
                          child: MySeparator(
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                        GridView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: 15,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            mainAxisSpacing: 2,
                            crossAxisSpacing: 1,
                          ),
                          itemBuilder: (ctx, i) {
                            return AnimatedContainer(
                              duration: const Duration(seconds: 2),
                              curve: Curves.decelerate,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: model.todaysPicks!.contains(model
                                        .allBestTickets![index]
                                        .ticketsNumList[i])
                                    ? UiConstants.kSaveDigitalGoldCardBg
                                        .withOpacity(0.7)
                                    : Colors.transparent,
                                borderRadius: (model.todaysPicks!.contains(model
                                        .allBestTickets![index]
                                        .ticketsNumList[i]))
                                    ? BorderRadius.circular(100)
                                    : BorderRadius.circular(
                                        SizeConfig.blockSizeHorizontal * 1),
                                border: Border.all(
                                    color: (model.todaysPicks!.contains(
                                      model.allBestTickets![index]
                                          .ticketsNumList[i],
                                    ))
                                        ? const Color(0xff93B5FE)
                                        : Colors.white.withOpacity(model
                                                    .allBestTickets![index]
                                                    .ticketsNumList[i] ==
                                                0
                                            ? 0.4
                                            : 0.7),
                                    width: model.todaysPicks!.contains(model
                                            .allBestTickets![index]
                                            .ticketsNumList[i])
                                        ? 0.0
                                        : model.allBestTickets![index]
                                                    .ticketsNumList[i] ==
                                                0
                                            ? 0.5
                                            : 0.7),
                              ),
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      model.allBestTickets![index]
                                          .ticketsNumList[i]
                                          .toString(),
                                      style: TextStyles.rajdhaniB.body2.colour(
                                          model.todaysPicks!.contains(model
                                                  .allBestTickets![index]
                                                  .ticketsNumList[i])
                                              ? Colors.white
                                              : Colors.white54),
                                    ),
                                  ),
                                  model.todaysPicks!.contains(model
                                          .allBestTickets![index]
                                          .ticketsNumList[i])
                                      ? const DigitStrike()
                                      : const SizedBox()
                                ],
                              ),
                            );
                          },
                        ),
                        if (index % 2 == 0)
                          Padding(
                            padding: EdgeInsets.only(top: SizeConfig.padding8),
                            child: Text(
                              "Winning Ticket",
                              style: TextStyles.body3
                                  .colour(UiConstants.primaryColor),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
                const Align(
                    alignment: Alignment.topCenter,
                    child: TicketTag(tag: "New"))
              ],
            ),
          ),
        ),
      );
    });
  }
}

class TicketMatchesBriefBoxWidget extends StatelessWidget {
  const TicketMatchesBriefBoxWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<TambolaService, TambolaBestTicketsModel?>(
      selector: (p0, p1) => p1.bestTickets,
      builder: (context, bestTickets, child) {
        return bestTickets != null
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(SizeConfig.roundness12),
                  color: Colors.black,
                ),
                margin: EdgeInsets.symmetric(
                    horizontal: SizeConfig.pageHorizontalMargins),
                child: Column(
                  children: [
                    SizedBox(height: SizeConfig.padding12),
                    Text(
                      "Tickets Winning this week (3)",
                      style: TextStyles.body1.colour(Colors.white),
                    ),
                    SizedBox(height: SizeConfig.padding6),
                    GridView(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.padding20,
                        vertical: SizeConfig.padding10,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: SizeConfig.padding14,
                        crossAxisSpacing: SizeConfig.padding14,
                        childAspectRatio: 2.2 / 1,
                      ),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: bestTickets.data!.stats!
                          .map((e) => TicketsWinBriefChip(
                              title: e.displayName, value: e.count))
                          .toList(),
                    ),
                    SizedBox(height: SizeConfig.padding8),
                  ],
                ),
              )
            : const SizedBox();
      },
    );
  }
}

class TicketsWinBriefChip extends StatelessWidget {
  const TicketsWinBriefChip({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: UiConstants.primaryColor),
        color: UiConstants.darkPrimaryColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(SizeConfig.padding16),
      ),
      padding: EdgeInsets.all(SizeConfig.padding10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$title ",
                style: TextStyles.rajdhaniB.body3.colour(Colors.white),
              ),
              Text(
                "Matches",
                style: TextStyles.body3.colour(Colors.white38),
              )
            ],
          ),
          SizedBox(height: SizeConfig.padding4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$value ",
                style: TextStyles.rajdhaniB.body2.colour(Colors.white),
              ),
              Text(
                "Ticket${value > 1 ? 's' : ''}",
                style: TextStyles.body3.colour(Colors.white38),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class ViewallBestTicketsBar extends StatelessWidget {
  const ViewallBestTicketsBar(
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
    // required this.getTicketsTapped,
    super.key,
  });

  final int activeTambolaCardCount;
  // final VoidCallback getTicketsTapped;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.padding26,
        vertical: SizeConfig.padding6,
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
