import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/feature/tambola/src/models/daily_pick_model.dart';
import 'package:felloapp/feature/tambola/src/models/tambola_ticket_model.dart';
import 'package:felloapp/feature/tambola/src/ui/widgets/ticket/tambola_ticket.dart';
import 'package:felloapp/feature/tambola/tambola.dart';
import 'package:felloapp/ui/elements/appbar/appbar.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
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
                            child: TambolaTicket(
                              board: tickets[index],
                              calledDigits: widget.weeklyPicks.toList(),
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
                                  "Loading more tickets",
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
