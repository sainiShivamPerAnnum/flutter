import 'package:felloapp/core/model/tambola_board_model.dart';
import 'package:felloapp/ui/pages/games/tambola/tambola_home/view/tambola_home_view.dart';
import 'package:felloapp/ui/pages/games/tambola/tambola_home/view_model/tambola_home_vm.dart';
import 'package:felloapp/ui/pages/games/tambola/tambola_home/widgets/no_ticket_widget.dart';
import 'package:felloapp/ui/pages/games/tambola/tambola_home/widgets/tambola_ticket.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class TicketsView extends StatelessWidget {
  final TambolaHomeViewModel? model;

  const TicketsView({super.key, this.model});

  String getText(S locale) {
    if (model != null) {
      return '${locale.tgenerated} ${model!.tambolaService!.ticketGenerateCount! - model!.tambolaService!.atomicTicketGenerationLeftCount} ${locale.tgeneratedCount(model!.tambolaService!.ticketGenerateCount.toString())}';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    if (model == null ||
        !model!.weeklyTicksFetched ||
        !model!.weeklyDrawFetched) {
      return const SizedBox();
    } else if (model!.userWeeklyBoards == null ||
        model!.activeTambolaCardCount == 0) {
      return Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          width: SizeConfig.screenWidth,
          child: Center(
            child: (model!.ticketsBeingGenerated)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: SizeConfig.screenWidth! * 0.8,
                        height: 4,
                        decoration: BoxDecoration(
                          color: UiConstants.primaryColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: FractionallySizedBox(
                          heightFactor: 1,
                          widthFactor: model!
                                      .tambolaService!.ticketGenerateCount ==
                                  model!.tambolaService!
                                      .atomicTicketGenerationLeftCount
                              ? 0.1
                              : (model!.tambolaService!.ticketGenerateCount! -
                                      model!.tambolaService!
                                          .atomicTicketGenerationLeftCount) /
                                  model!.tambolaService!.ticketGenerateCount!,
                          alignment: Alignment.centerLeft,
                          child: Container(
                            decoration: BoxDecoration(
                              color: UiConstants.primaryColor,
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        getText(locale),
                        style: TextStyles.rajdhani.body2.colour(Colors.white),
                      ),
                    ],
                  )
                : const SizedBox(),
          ),
        ),
      );
    } else if (model!.activeTambolaCardCount == 1) {
      //One tambola ticket
      model!.tambolaBoardViews = [];
      model!.tambolaBoardViews!.add(TambolaTicket(
        bestBoards: model!.refreshBestBoards(),
        dailyPicks: model!.weeklyDigits,
        board: model!.userWeeklyBoards![0],
        calledDigits: (model!.weeklyDrawFetched && model!.weeklyDigits != null)
            ? model!.weeklyDigits!.toList()
            : [],
      ));

      return SizedBox(
        width: SizeConfig.screenWidth,
        child: TabViewGenerator(
          model: model,
          showIndicatorForAll: false,
        ),
      );
    } else {
      //Multiple tickets
      if (!model!.ticketsLoaded) {
        model!.ticketsLoaded = true;
        model!.tambolaBoardViews = [];

        for (final board in model!.userWeeklyBoards!) {
          model!.tambolaBoardViews!.add(
            TambolaTicket(
              bestBoards: model!.refreshBestBoards(),
              dailyPicks: model!.weeklyDigits,
              board: board,
              calledDigits:
                  (model!.weeklyDrawFetched && model!.weeklyDigits != null)
                      ? model!.weeklyDigits!.toList()
                      : [],
            ),
          );
        }
      }

      return Column(
        children: [
          SizedBox(
            width: SizeConfig.screenWidth,
            child: TabViewGenerator(
              model: model,
              showIndicatorForAll: true,
            ),
          ),
        ],
      );
    }
  }
}

class TabViewGenerator extends StatefulWidget {
  const TabViewGenerator({
    Key? key,
    required this.model,
    required this.showIndicatorForAll,
  }) : super(key: key);

  final TambolaHomeViewModel? model;
  final bool showIndicatorForAll;

  @override
  State<TabViewGenerator> createState() => _TabViewGeneratorState();
}

class _TabViewGeneratorState extends State<TabViewGenerator>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  late final List<TambolaBoard?> _bestBoards;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(vsync: this, length: widget.model!.tabList.length);
    _tabController!.addListener(_handleTabSelection);
    _bestBoards = widget.model!.refreshBestBoards() ?? [];
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.model!.tabList.length,
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
                  tabs: widget.model!.tabList.map(
                    (tabName) {
                      final index = widget.model!.tabList.indexOf(tabName);
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
    );
  }

  Widget _buildTabContent() {
    switch (_tabController.index) {
      case 0:
        return PageViewWithIndicator(
          model: widget.model,
          showIndicator: widget.showIndicatorForAll,
        );
      case 1:
      case 2:
      case 3:
      case 4:
        final tabIndex = _tabController.index - 1;
        final board =
            _bestBoards.length > tabIndex ? _bestBoards[tabIndex] : null;
        return widget.model!.userWeeklyBoards != null &&
                widget.model!.userWeeklyBoards!.isNotEmpty
            ? TambolaTicket(
                dailyPicks: widget.model!.weeklyDigits,
                bestBoards: _bestBoards,
                board: board,
                showBestOdds: false,
                calledDigits: widget.model!.weeklyDigits!.toList(),
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
