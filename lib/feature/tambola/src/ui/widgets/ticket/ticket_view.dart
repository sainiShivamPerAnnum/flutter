import 'package:felloapp/feature/tambola/src/models/daily_pick_model.dart';
import 'package:felloapp/feature/tambola/src/models/tambola_best_tickets_model.dart';
import 'package:felloapp/feature/tambola/src/models/tambola_ticket_model.dart';
import 'package:felloapp/feature/tambola/src/ui/widgets/page_view_with_indicator.dart';
import 'package:felloapp/feature/tambola/src/ui/widgets/ticket/no_ticket_widget.dart';
import 'package:felloapp/feature/tambola/src/ui/widgets/ticket/tambola_ticket.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class TicketsView extends StatefulWidget {
  const TicketsView({
    Key? key,
    this.bestTickets,
    required this.weeklyPicks,
  }) : super(key: key);

  final TambolaBestTicketsModel? bestTickets;
  final DailyPick weeklyPicks;

  @override
  State<TicketsView> createState() => _TicketsViewState();
}

class _TicketsViewState extends State<TicketsView>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  late final PageController controller;
  // late final List<TambolaTicketModel?> _bestBoards;
  final List<String> tabList = const [
    "One Row",
    "Two Rows",
    "Corners",
    "Full House"
  ];
  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: 0);
    _tabController = TabController(vsync: this, length: 4);
    _tabController.addListener(_handleTabSelection);
    // _bestBoards = widget.tickets;
  }

  void _handleTabSelection() {
    controller.jumpToPage(0);
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.screenWidth,
      child: DefaultTabController(
        length: tabList.length,
        child: Column(
          children: [
            Row(
              children: [
                Container(
                    margin: EdgeInsets.only(
                      left: SizeConfig.screenWidth! * 0.06,
                      right: SizeConfig.padding8,
                    ),
                    child: Icon(
                      Icons.tune,
                      color: Colors.white.withOpacity(0.5),
                    )),
                Expanded(
                  child: TabBar(
                    controller: _tabController,
                    labelPadding: EdgeInsets.zero,
                    indicatorColor: Colors.transparent,
                    physics: const BouncingScrollPhysics(),
                    isScrollable: true,
                    splashFactory: NoSplash.splashFactory,
                    tabs: tabList.map(
                      (tabName) {
                        final index = tabList.indexOf(tabName);
                        final isActive = _tabController.index == index;
                        return Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: SizeConfig.padding4),
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.padding10,
                              vertical: SizeConfig.padding10),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(SizeConfig.padding14),
                            color: isActive
                                ? UiConstants.kTambolaTabColor
                                : Colors.transparent,
                          ),
                          child: Text(
                            tabName,
                            textAlign: TextAlign.center,
                            style: TextStyles.body4.colour(
                              isActive
                                  ? UiConstants.kBlogCardRandomColor5
                                  : Colors.white,
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.padding16,
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: _buildTabContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    // Widget buildObject = NoTicketWidget();
    final bestTicketsData = widget.bestTickets?.data;
    if (bestTicketsData == null) return const NoTicketWidget();
    List<TambolaTicketModel> tickets = [];
    switch (_tabController.index) {
      case 0:
        if (bestTicketsData.oneRow != null) {
          tickets.addAll(bestTicketsData.oneRow!);
        }
        break;
      case 1:
        if (bestTicketsData.twoRows != null) {
          tickets.addAll(bestTicketsData.twoRows!);
        }
        break;
      case 2:
        if (bestTicketsData.corners != null) {
          tickets.addAll(bestTicketsData.corners!);
        }
        break;
      case 3:
        if (bestTicketsData.fullHouse != null) {
          tickets.addAll(bestTicketsData.fullHouse!);
        }
        break;
    }
    if (tickets.isNotEmpty) {
      return PageViewWithIndicator(
        showIndicator: tickets.length > 1,
        controller: controller,
        children: tickets
            .map(
              (e) => TambolaTicket(
                board: e,
                calledDigits: widget.weeklyPicks.toList(),
              ),
            )
            .toList(),
      );
    } else {
      return const NoTicketWidget();
    }
  }
}
