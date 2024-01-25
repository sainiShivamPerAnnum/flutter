// ignore_for_file: lines_longer_than_80_chars

import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/feature/tambola/src/models/daily_pick_model.dart';
import 'package:felloapp/feature/tambola/src/models/tambola_best_tickets_model.dart';
import 'package:felloapp/feature/tambola/src/services/tambola_service.dart';
import 'package:felloapp/feature/tambola/src/ui/tambola_all_tickets/tambola_all_tickets_view.dart';
import 'package:felloapp/feature/tambola/src/ui/widgets/ticket/ticket_painter.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/asset_selection.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/walkthrough_video_section.dart';
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
    Key? key,
  }) : super(key: key);

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
          ),
          ((data.item1?.data?.totalTicketCount ?? 0) == 0)
              ? Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                      decoration: BoxDecoration(
                        color: UiConstants.kTambolaMidTextColor,
                        borderRadius:
                            BorderRadius.circular(SizeConfig.roundness16),
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
                            style: TextStyles.rajdhaniB.title5
                                .colour(Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SvgPicture.asset(Assets.floAsset,
                            width: SizeConfig.padding60),
                      ]),
                    ),
                    const TambolaVideosSection(),
                  ],
                )
              : const Column(
                  children: [
                    BestTicketsSection(),
                    TicketMatchesBriefBoxWidget(),
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
      return (model.allBestTickets ?? []).isNotEmpty
          ? Container(
              margin: EdgeInsets.only(
                  top: SizeConfig.padding20, bottom: SizeConfig.padding10),
              height: SizeConfig.screenWidth! * 0.6,
              width: SizeConfig.screenWidth,
              child: ListView.builder(
                itemCount: model.allBestTickets!.length + 1,
                padding: EdgeInsets.symmetric(
                  horizontal:
                      SizeConfig.pageHorizontalMargins - SizeConfig.padding10,
                ),
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => index ==
                        model.allBestTickets!.length
                    ? GestureDetector(
                        onTap: () {
                          if (model.allBestTickets!.length == 1) {
                            AppState.delegate!.appState.currentAction =
                                PageAction(
                              page: AssetSelectionViewConfig,
                              state: PageState.addWidget,
                              widget: const AssetSelectionPage(),
                            );
                          } else {
                            Haptic.vibrate();
                            AppState.delegate!.appState.currentAction =
                                PageAction(
                              state: PageState.addWidget,
                              page: AllTambolaTicketsPageConfig,
                              widget: AllTambolaTickets(
                                weeklyPicks:
                                    locator<TambolaService>().weeklyPicks ??
                                        DailyPick.noPicks(),
                              ),
                            );
                          }
                        },
                        child: model.allBestTickets!.length == 1
                            ? Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.padding10),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CustomPaint(
                                      painter: const TicketPainter(
                                          borderColor: Colors.transparent),
                                      child: Container(
                                        padding: EdgeInsets.only(
                                          left: SizeConfig.padding16,
                                          right: SizeConfig.padding16,
                                          top: SizeConfig.padding16,
                                          bottom: SizeConfig.padding12,
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        decoration: BoxDecoration(
                                          // color: UiConstants.kBuyTicketBg,
                                          borderRadius: BorderRadius.circular(
                                              SizeConfig.roundness5),
                                        ),
                                        child: Center(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Get more tickets",
                                                style: TextStyles.body3
                                                    .colour(Colors.white),
                                              ),
                                              SizedBox(
                                                  height: SizeConfig.padding12),
                                              CircleAvatar(
                                                backgroundColor: Colors.white,
                                                child: Icon(
                                                  Icons.add,
                                                  color: Colors.black,
                                                  size: SizeConfig.iconSize0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox(
                                width: SizeConfig.screenWidth! * 0.5,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor:
                                            UiConstants.darkPrimaryColor,
                                        child: SvgPicture.asset(
                                          Assets.chevRonRightArrow,
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: SizeConfig.padding12),
                                      Text(
                                        "See All Tickets",
                                        style: TextStyles.body3
                                            .colour(Colors.white),
                                      )
                                    ]),
                              ),
                      )
                    : SingleTicket(
                        index: index,
                        weeklyPicks: model.weeklyPicksList,
                        ticket: model.allBestTickets![index],
                      ),
              ),
            )
          : const SizedBox();
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
        if (bestTickets != null) {
          int totalWinningTickets = 0;
          List<TicketsWinBriefChip> matchList = (bestTickets.data!.stats ?? [])
              .where((e) => e.count > 0)
              .map((e) {
            totalWinningTickets += e.count;
            return TicketsWinBriefChip(
              title: e.displayName,
              value: e.count,
              i: (int.tryParse(e.category.split('_').last) ?? 1) - 1,
            );
          }).toList();

          return totalWinningTickets > 0
              ? Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                  ),
                  width: SizeConfig.screenWidth,
                  margin: EdgeInsets.only(top: SizeConfig.padding12),
                  child: Column(
                    children: [
                      SizedBox(height: SizeConfig.padding12),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.pageHorizontalMargins),
                        child: Row(
                          children: [
                            Text(
                              "Tickets Winning this week",
                              style: TextStyles.body1.colour(Colors.white),
                            ),
                            const Spacer(),
                            Text(
                              "$totalWinningTickets",
                              style: TextStyles.sourceSansB.body1
                                  .colour(Colors.white),
                            ),
                            Text(
                              "/${bestTickets.data!.ticketCap}",
                              style: TextStyles.body1.colour(Colors.white),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: SizeConfig.padding6),
                      if (matchList.length == 1)
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: SizeConfig.pageHorizontalMargins,
                            vertical: SizeConfig.padding16,
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.padding16,
                              vertical: SizeConfig.padding12),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: UiConstants.primaryColor, width: 1),
                            borderRadius:
                                BorderRadius.circular(SizeConfig.roundness12),
                            color: UiConstants.kFloContainerColor,
                          ),
                          child: Row(children: [
                            RichText(
                              text: TextSpan(
                                text: matchList[0].title.split(' ').first,
                                style: TextStyles.rajdhaniB.body1
                                    .colour(Colors.white),
                                children: [
                                  WidgetSpan(
                                      child:
                                          SizedBox(width: SizeConfig.padding4)),
                                  TextSpan(
                                    text: matchList[0].title.split(' ').last,
                                    style:
                                        TextStyles.body4.colour(Colors.white38),
                                  )
                                ],
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "${matchList[0].value}",
                              style: TextStyles.rajdhaniB.body1
                                  .colour(Colors.white),
                            ),
                            SizedBox(width: SizeConfig.padding4),
                            Text(
                              "Ticket${matchList[0].value > 1 ? 's' : ''}",
                              style: TextStyles.body4.colour(Colors.white38),
                            ),
                          ]),
                        ),
                      if (matchList.length == 2 || matchList.length == 3)
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: SizeConfig.padding12,
                              horizontal: SizeConfig.padding14),
                          child: Row(
                            children: List.generate(
                              matchList.length,
                              (i) => Expanded(
                                  child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: SizeConfig.padding6),
                                child: matchList[i],
                              )),
                            ),
                          ),
                        ),
                      if (matchList.length >= 4)
                        GridView(
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.padding10,
                            vertical: SizeConfig.padding10,
                          ),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: SizeConfig.padding20,
                            crossAxisSpacing: SizeConfig.padding20,
                            childAspectRatio: 2.4 / 1,
                          ),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: List.generate(
                              bestTickets.data!.stats!.length,
                              (i) => TicketsWinBriefChip(
                                  title:
                                      bestTickets.data!.stats![i].displayName,
                                  value: bestTickets.data!.stats![i].count,
                                  i: i)),
                        ),
                      SizedBox(height: SizeConfig.padding8),
                      Text(
                        "Rewards distributed every Monday",
                        style: TextStyles.body4
                            .colour(UiConstants.kTabBorderColor),
                      ),
                      SizedBox(height: SizeConfig.padding16),
                    ],
                  ),
                )
              : const SizedBox();
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

class TicketsWinBriefChip extends StatelessWidget {
  const TicketsWinBriefChip({
    required this.title,
    required this.value,
    required this.i,
    super.key,
  });

  final String title;
  final int value;
  final int i;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: UiConstants.primaryColor),
        color: UiConstants.darkPrimaryColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(SizeConfig.padding12),
      ),
      padding: EdgeInsets.all(SizeConfig.padding10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RichText(
            text: TextSpan(
              text: title.split(' ').first,
              style: TextStyles.rajdhaniB.body2.colour(Colors.white),
              children: [
                WidgetSpan(child: SizedBox(width: SizeConfig.padding4)),
                TextSpan(
                  text: title.split(' ').last,
                  style: TextStyles.body4.colour(Colors.white38),
                )
              ],
            ),
            textAlign: TextAlign.center,
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
      {required this.title, required this.onPressed, super.key});

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
        horizontal: SizeConfig.pageHorizontalMargins,
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
                  Text(" Your Tickets ($activeTambolaCardCount)",
                      style: TextStyles.sourceSansSB.title5),
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
                          "$expiringTicketCount ticket${expiringTicketCount > 1 ? 's' : ''} expiring this Sunday",
                          style: TextStyles.sourceSansSB.body4
                              .colour(UiConstants.kBlogTitleColor),
                          maxLines: 2,
                          textAlign: TextAlign.start,
                        ),
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
              Haptic.vibrate();
              AppState.delegate!.appState.currentAction = PageAction(
                page: AssetSelectionViewConfig,
                state: PageState.addWidget,
                widget: const AssetSelectionPage(),
              );
              locator<AnalyticsService>()
                  .track(eventName: AnalyticsEvents.getTicketsTapped);
            },
            height: SizeConfig.padding40,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(SizeConfig.roundness5),
            ),
            child: Text(
              "GET TICKETS",
              style: TextStyles.rajdhaniB.body1.colour(Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
