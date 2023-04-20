import 'package:flutter/material.dart';
import 'package:tambola/src/models/daily_pick.dart';
import 'package:tambola/src/models/tambola_ticket_model.dart';
import 'package:tambola/src/tambola_home/widgets/no_ticket_widget.dart';
import 'package:tambola/src/tambola_home/widgets/page_view_with_indicator.dart';
import 'package:tambola/src/tambola_home/widgets/tambola_ticket.dart';
import 'package:tambola/src/utils/styles/styles.dart';

// class TicketsView extends StatelessWidget {
//   // final TambolaHomeViewModel? model;

//   final List<TambolaTicketModel> tickets;
//   final DailyPick dailyPicks;
//   final List<String> tabList;

//   const TicketsView({
//     super.key,
//     required this.tickets,
//     required this.dailyPicks,
//     required this.tabList,
//   });

//   // String getText() {
//   //   if (model != null) {
//   //     return '${locale.tgenerated} ${model!.tambolaService!.ticketGenerateCount! - model!.tambolaService!.atomicTicketGenerationLeftCount} ${locale.tgeneratedCount(model!.tambolaService!.ticketGenerateCount.toString())}';
//   //   }
//   //   return '';
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         SizedBox(
//           width: SizeConfig.screenWidth,
//           child: TicketsView(
//             showIndicatorForAll: true,
//           ),
//         ),
//       ],
//     );
//   }
// }

class TicketsView extends StatefulWidget {
  const TicketsView({
    Key? key,
    required this.tickets,
    required this.weeklyPicks,
    required this.tabList,
    // required this.model,
    required this.showIndicatorForAll,
  }) : super(key: key);

  // final TambolaHomeViewModel? model;
  final bool showIndicatorForAll;
  final List<TambolaTicketModel> tickets;
  final DailyPick weeklyPicks;
  final List<String> tabList;

  @override
  State<TicketsView> createState() => _TicketsViewState();
}

class _TicketsViewState extends State<TicketsView>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  late final List<TambolaTicketModel?> _bestBoards;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 5);
    _tabController.addListener(_handleTabSelection);
    _bestBoards = widget.tickets;
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: SizeConfig.screenWidth,
      child: DefaultTabController(
        length: 5,
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
                    tabs: widget.tabList.map(
                      (tabName) {
                        final index = widget.tabList.indexOf(tabName);
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
    switch (_tabController.index) {
      case 0:
        return PageViewWithIndicator(
          showIndicator: widget.showIndicatorForAll,
          children: widget.tickets
              .map(
                (e) => TambolaTicket(
                  board: e,
                  calledDigits: widget.weeklyPicks.toList(),
                ),
              )
              .toList(),
        );
      case 1:
      case 2:
      case 3:
      case 4:
        final tabIndex = _tabController.index - 1;
        final board =
            _bestBoards.length > tabIndex ? _bestBoards[tabIndex] : null;
        return widget.tickets.isNotEmpty
            ? TambolaTicket(
                board: board,
                calledDigits: widget.weeklyPicks.toList(),
              )
            : const NoTicketWidget();
      default:
        return const NoTicketWidget();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
