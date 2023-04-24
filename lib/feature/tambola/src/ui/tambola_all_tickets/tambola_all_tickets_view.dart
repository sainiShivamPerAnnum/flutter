import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/feature/tambola/src/models/daily_pick_model.dart';
import 'package:felloapp/feature/tambola/src/models/tambola_ticket_model.dart';
import 'package:felloapp/feature/tambola/src/ui/widgets/ticket/tambola_ticket.dart';
import 'package:felloapp/ui/elements/appbar/appbar.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class AllTambolaTickets extends StatefulWidget {
  const AllTambolaTickets({
    required this.ticketList,
    required this.weeklyPicks,
    Key? key,
  }) : super(key: key);

  final List<TambolaTicketModel> ticketList;
  final DailyPick weeklyPicks;

  @override
  State<AllTambolaTickets> createState() => _AllTambolaTicketsState();
}

class _AllTambolaTicketsState extends State<AllTambolaTickets> {
  // List<Widget>? activeTicketList;
  ScrollController? ticketController;
  bool isLoadingTickets = false;
  int? listLength = 0;
  @override
  void initState() {
    ticketController = ScrollController();
    listLength = widget.ticketList.length > 10 ? 10 : widget.ticketList.length;
    ticketController!.addListener(() {
      if (ticketController!.offset >=
          ticketController!.position.maxScrollExtent) {
        if (isLoadingTickets) return;
        if (listLength == widget.ticketList.length) return;
        setState(() {
          isLoadingTickets = true;
        });
        Future.delayed(const Duration(seconds: 3)).then((_) {
          setState(() {
            listLength = widget.ticketList.length - listLength! > 10
                ? listLength! + 10
                : listLength! + (widget.ticketList.length - listLength!);
            isLoadingTickets = false;
          });
          ticketController!.animateTo(ticketController!.offset + 80,
              duration: const Duration(seconds: 1), curve: Curves.easeIn);
        });
      }
    });
    super.initState();
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
      body: Stack(
        children: [
          ListView.builder(
            shrinkWrap: true,
            controller: ticketController,
            scrollDirection: Axis.vertical,
            itemCount: listLength,
            itemBuilder: (ctx, index) {
              return Container(
                margin: EdgeInsets.symmetric(
                    vertical: SizeConfig.pageHorizontalMargins),
                child: TambolaTicket(
                  board: widget.ticketList[index],
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
                    CircularProgressIndicator(
                      color: UiConstants.primaryColor,
                      // size: SizeConfig.padding16,
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
      ),
    );
  }
}
