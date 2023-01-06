import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/ui/widgets/appbar/appbar.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AllTambolaTickets extends StatefulWidget {
  const AllTambolaTickets({Key? key, required this.ticketList})
      : super(key: key);

  final List<Widget> ticketList;

  @override
  State<AllTambolaTickets> createState() => _AllTambolaTicketsState();
}

class _AllTambolaTicketsState extends State<AllTambolaTickets> {
  List<Widget>? activeTicketList;
  ScrollController? ticketController;
  bool isLoadingTickets = false;
  @override
  void initState() {
    ticketController = ScrollController();
    activeTicketList = widget.ticketList.length > 10
        ? widget.ticketList.sublist(0, 10)
        : widget.ticketList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiConstants.kArrowButtonBackgroundColor,
      appBar: FAppBar(
        type: FaqsType.play,
        showAvatar: false,
        showCoinBar: false,
        showHelpButton: false,
        title: "Tickets",
        backgroundColor: UiConstants.kArrowButtonBackgroundColor,
      ),
      body: Stack(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.maxScrollExtent ==
                  scrollInfo.metrics.pixels) {
                if (activeTicketList?.length == widget.ticketList.length)
                  return true;
                setState(() {
                  isLoadingTickets = true;
                });
                Future.delayed(Duration(seconds: 3)).then((_) {
                  setState(() {
                    activeTicketList!.addAll(widget.ticketList.sublist(
                        activeTicketList!.length,
                        widget.ticketList.length - activeTicketList!.length > 10
                            ? activeTicketList!.length + 10
                            : widget.ticketList.length));
                    isLoadingTickets = false;
                  });
                  ticketController!.animateTo(ticketController!.offset + 80,
                      duration: Duration(seconds: 1), curve: Curves.easeIn);
                });
              }

              return true;
            },
            child: ListView.builder(
              shrinkWrap: true,
              controller: ticketController,
              scrollDirection: Axis.vertical,
              itemCount: activeTicketList!.length,
              itemBuilder: (ctx, index) {
                return Container(
                    margin: EdgeInsets.symmetric(
                        vertical: SizeConfig.pageHorizontalMargins),
                    child: activeTicketList![index]);
              },
            ),
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
                      size: SizeConfig.padding16,
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
