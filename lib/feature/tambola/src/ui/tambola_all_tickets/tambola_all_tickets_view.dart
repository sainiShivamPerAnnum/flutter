import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/feature/tambola/src/models/daily_pick_model.dart';
import 'package:felloapp/feature/tambola/src/models/tambola_ticket_model.dart';
import 'package:felloapp/feature/tambola/src/ui/widgets/ticket/tambola_ticket.dart';
import 'package:felloapp/feature/tambola/src/ui/widgets/ticket/ticket_painter.dart';
import 'package:felloapp/feature/tambola/tambola.dart';
import 'package:felloapp/ui/elements/appbar/appbar.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class AllTambolaTickets extends StatefulWidget {
  const AllTambolaTickets({
    // required this.ticketList,
    required this.weeklyPicks,
    Key? key,
  }) : super(key: key);

  // final List<TambolaTicketModel> ticketList;
  final DailyPick weeklyPicks;

  @override
  State<AllTambolaTickets> createState() => _AllTambolaTicketsState();
}

class _AllTambolaTicketsState extends State<AllTambolaTickets> {
  // List<Widget>? activeTicketList;
  TambolaService? tambolaService;
  ScrollController? ticketController;
  bool _isLoadingTickets = false;

  bool get isLoadingTickets => _isLoadingTickets;

  set isLoadingTickets(bool value) {
    _isLoadingTickets = value;
    if (mounted) setState(() {});
  }

  int? listLength = 0;
  @override
  void initState() {
    ticketController = ScrollController();
    tambolaService = locator<TambolaService>();
    tambolaService!.noMoreTickets = false;
    tambolaService!.allTickets.clear();
    if (tambolaService!.allTickets.isEmpty) {
      _isLoadingTickets = true;
      tambolaService!
          .getTambolaTickets()
          .then((value) => isLoadingTickets = false);
    }

    ticketController!.addListener(() async {
      if (ticketController!.offset >=
          ticketController!.position.maxScrollExtent) {
        if (isLoadingTickets || tambolaService!.noMoreTickets) return;
        isLoadingTickets = true;
        await tambolaService!.getTambolaTickets();
        isLoadingTickets = false;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    ticketController?.dispose();
    tambolaService = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = locator<S>();
    return Scaffold(
        backgroundColor: UiConstants.kArrowButtonBackgroundColor,
        appBar: const FAppBar(
          type: FaqsType.play,
          showAvatar: false,
          showCoinBar: false,
          showHelpButton: false,
          title: "Tickets",
          backgroundColor: UiConstants.kArrowButtonBackgroundColor,
        ),
        body: Selector<TambolaService, List<TambolaTicketModel>>(
          selector: (_, tambolaService) => tambolaService.allTickets,
          builder: (ctx, tickets, child) {
            return isLoadingTickets && tickets.isEmpty
                ? child!
                : Stack(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        controller: ticketController,
                        scrollDirection: Axis.vertical,
                        itemCount: tickets.length,
                        itemBuilder: (ctx, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(
                                vertical: SizeConfig.pageHorizontalMargins),
                            child: SingleTicket(
                              ticket: tickets[index],
                              weeklyPicks: widget.weeklyPicks.toList(),
                              index: index,
                            ),
                          );
                        },
                      ),
                      if (isLoadingTickets)
                        Positioned(
                          bottom: 0,
                          child: Container(
                            color: UiConstants.kBackgroundColor3,
                            width: SizeConfig.screenWidth,
                            padding: EdgeInsets.all(SizeConfig.padding12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SpinKitWave(
                                  color: UiConstants.primaryColor,
                                  size: SizeConfig.padding24,
                                ),
                                SizedBox(height: SizeConfig.padding4),
                                Text(
                                  locale.loadingScratchCards,
                                  style: TextStyles.body4.colour(Colors.grey),
                                )
                              ],
                            ),
                          ),
                        )
                    ],
                  );
          },
          child: const FullScreenLoader(),
        ));
  }
}

class SingleTicket extends StatelessWidget {
  const SingleTicket({
    required this.index,
    required this.weeklyPicks,
    required this.ticket,
    super.key,
  });
  final int index;
  final List<int> weeklyPicks;
  final TambolaTicketModel ticket;

  @override
  Widget build(BuildContext context) {
    final int matchCount =
        ticket.ticketsNumList.where(weeklyPicks.contains).toList().length;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: SizeConfig.padding10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            painter: TicketPainter(
                borderColor: matchCount >=
                        (int.tryParse(AppConfig.getValue(AppConfigKey
                                    .ticketsCategories)['category_1']
                                .toString()
                                .characters
                                .first) ??
                            5)
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
                borderRadius: BorderRadius.circular(SizeConfig.roundness5),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Transform.translate(
                    offset: Offset(0, SizeConfig.padding6),
                    child: Row(
                      children: [
                        Text(
                          '#${ticket.getTicketNumber()}',
                          style: TextStyles.sourceSans.body4
                              .colour(UiConstants.kGreyTextColor),
                        ),
                        const Spacer(),
                        AnimatedCrossFade(
                          crossFadeState: matchCount > 0
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          duration: const Duration(seconds: 1),
                          sizeCurve: Curves.easeOutExpo,
                          firstChild: Text(
                            "$matchCount Matches",
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
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: SizeConfig.padding20),
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
                          color: weeklyPicks.contains(ticket.ticketsNumList[i])
                              ? UiConstants.kSaveDigitalGoldCardBg
                                  .withOpacity(0.7)
                              : Colors.transparent,
                          borderRadius:
                              (weeklyPicks.contains(ticket.ticketsNumList[i]))
                                  ? BorderRadius.circular(100)
                                  : BorderRadius.circular(
                                      SizeConfig.blockSizeHorizontal * 1),
                          border: Border.all(
                              color: (weeklyPicks.contains(
                                ticket.ticketsNumList[i],
                              ))
                                  ? const Color(0xff93B5FE)
                                  : Colors.white.withOpacity(
                                      ticket.ticketsNumList[i] == 0
                                          ? 0.4
                                          : 0.7),
                              width:
                                  weeklyPicks.contains(ticket.ticketsNumList[i])
                                      ? 0.0
                                      : ticket.ticketsNumList[i] == 0
                                          ? 0.5
                                          : 0.7),
                        ),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                ticket.ticketsNumList[i].toString(),
                                style: TextStyles.rajdhaniB.body2.colour(
                                    weeklyPicks
                                            .contains(ticket.ticketsNumList[i])
                                        ? Colors.white
                                        : Colors.white54),
                              ),
                            ),
                            weeklyPicks.contains(ticket.ticketsNumList[i])
                                ? const DigitStrike()
                                : const SizedBox()
                          ],
                        ),
                      );
                    },
                  ),
                  if (matchCount >= 5)
                    Padding(
                      padding: EdgeInsets.only(top: SizeConfig.padding8),
                      child: Text(
                        "Winning Ticket",
                        style:
                            TextStyles.body3.colour(UiConstants.primaryColor),
                      ),
                    )
                ],
              ),
            ),
          ),
          const Positioned(top: 0, child: TicketTag(tag: "New"))
        ],
      ),
    );
  }
}
