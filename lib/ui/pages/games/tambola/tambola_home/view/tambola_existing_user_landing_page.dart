import 'dart:math';

import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/tambola_board_model.dart';
import 'package:felloapp/core/repository/ticket_repo.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/elements/appbar/appbar.dart';
import 'package:felloapp/ui/elements/helpers/tnc_text.dart';
import 'package:felloapp/ui/pages/games/tambola/tambola-global/tambola_ticket.dart';
import 'package:felloapp/ui/pages/games/tambola/tambola_home/all_tambola_tickets.dart';
import 'package:felloapp/ui/pages/games/tambola/tambola_home/tambola_home_view.dart';
import 'package:felloapp/ui/pages/games/tambola/tambola_home/tambola_home_vm.dart';
import 'package:felloapp/ui/pages/games/tambola/tambola_home/tambola_new_user_page.dart';
import 'package:felloapp/ui/pages/games/tambola/tambola_home/view/tambola_ticket.dart';
import 'package:felloapp/ui/pages/games/tambola/tambola_home/widgets/tambola_top_banner.dart';
import 'package:felloapp/ui/pages/games/tambola/tambola_home/widgets/ticket_painter.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/ui/pages/static/sticky_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

class TambolaExistingUserScreen extends StatefulWidget {
  const TambolaExistingUserScreen({Key? key, required this.model})
      : super(key: key);

  final TambolaHomeViewModel model;

  @override
  State<TambolaExistingUserScreen> createState() =>
      _TambolaExistingUserScreenState();
}

class _TambolaExistingUserScreenState extends State<TambolaExistingUserScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  late final AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return Scaffold(
      appBar: FAppBar(
        // type: FaqsType.play,
        showAvatar: false,
        showCoinBar: false,
        showHelpButton: false,

        action: Row(
          children: [
            TextButton(
              style: TextButton.styleFrom(
                primary: Colors.white,
                onSurface: Colors.white,
                side: const BorderSide(color: Colors.white, width: 1),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25))),
              ),
              onPressed: () {
                AppState.delegate!.appState.currentAction = PageAction(
                  state: PageState.addWidget,
                  page: TambolaNewUser,
                  widget: TambolaNewUserPage(
                    model: widget.model,
                    showPrizeSection: true,
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Text(
                  "Prizes",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: SizeConfig.body2,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: SizeConfig.padding12,
            ),
            InkWell(
              onTap: () =>
                  AppState.delegate!.appState.currentAction = PageAction(
                state: PageState.addWidget,
                page: TambolaNewUser,
                widget: TambolaNewUserPage(
                  model: widget.model,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xff1a1a1a),
                    border: Border.all(color: Colors.white)),
                padding: const EdgeInsets.all(6),
                child: Icon(
                  Icons.question_mark,
                  color: Colors.white,
                  size: SizeConfig.padding20,
                ),
              ),
            )
          ],
        ),
        title: locale.tTitle,
        backgroundColor: UiConstants.kBackgroundColor,
      ),
      backgroundColor: UiConstants.kBackgroundColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TambolaTopBanner(),
                SizedBox(
                  height: SizeConfig.padding20,
                ),
                if (widget.model.userWeeklyBoards != null) ...[
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.padding26,
                      vertical: SizeConfig.padding16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset('assets/svg/ticket_icon.svg'),
                                SizedBox(
                                  width: SizeConfig.padding8,
                                ),
                                Text(
                                    "Tickets (${widget.model.activeTambolaCardCount})",
                                    style: TextStyles.rajdhaniSB.body1),
                              ],
                            ),
                            // if (TambolaRepo.expiringTicketCount != 0)
                            Row(
                              children: [
                                Text(
                                  "${TambolaRepo.expiringTicketCount} ticket${TambolaRepo.expiringTicketCount > 1 ? 's' : ''} expiring this Sunday. ",
                                  style: TextStyles.sourceSansSB.body4
                                      .colour(UiConstants.kBlogTitleColor),
                                ),
                                Text(
                                  "Know More",
                                  style: TextStyles.sourceSansSB.body4
                                      .colour(UiConstants.kBlogTitleColor)
                                      .copyWith(
                                          decorationStyle:
                                              TextDecorationStyle.solid,
                                          decoration: TextDecoration.underline),
                                ),
                              ],
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.fastOutSlowIn);
                            animationController
                                .forward()
                                .then((value) => animationController.reset());
                          },
                          child: Text(
                            locale.tGetTickets,
                            style: TextStyles.rajdhaniSB.body2
                                .colour(UiConstants.kBlogCardRandomColor2),
                            key: const ValueKey(Constants.GET_TAMBOLA_TICKETS),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.padding6,
                  ),
                  _TicketsView(model: widget.model),
                ] else
                  Container(
                    width: SizeConfig.screenWidth,
                    padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.pageHorizontalMargins),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const FullScreenLoader(),
                        SizedBox(height: SizeConfig.padding20),
                        Text(
                          locale.tFetch,
                          style:
                              TextStyles.sourceSans.body2.colour(Colors.white),
                        ),
                      ],
                    ),
                  ),
                GestureDetector(
                  onTap: () {
                    AppState.delegate!.appState.currentAction = PageAction(
                      state: PageState.addWidget,
                      page: AllTambolaTicketsPageConfig,
                      widget: AllTambolaTickets(
                          ticketList: widget.model.tambolaBoardViews!.toList()),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: SizeConfig.screenWidth! * 0.06),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xff627F8E).withOpacity(0.2),
                      border: Border.all(color: const Color(0xff627F8E)),
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          locale.tViewAllTicks,
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
                SizedBox(
                  height: SizeConfig.padding14,
                ),
                GestureDetector(
                  onTap: () {
                    AppState.delegate!.appState.currentAction = PageAction(
                      state: PageState.addWidget,
                      page: TambolaNewUser,
                      widget: TambolaNewUserPage(
                        model: widget.model,
                        showWinners: true,
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: SizeConfig.screenWidth! * 0.06),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xff627F8E).withOpacity(0.2),
                      border: Border.all(color: const Color(0xff627F8E)),
                      borderRadius:
                          BorderRadius.circular(SizeConfig.roundness12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Last week Winners",
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
                const SizedBox(
                  height: 32,
                ),
                AnimatedBuilder(
                  animation: animationController,
                  builder: (ctx, child) {
                    final sineValue =
                        sin(5 * 2 * pi * animationController.value);
                    return Transform.translate(
                      offset: Offset(sineValue * 5, 0),
                      child: child,
                    );
                  },
                  child: ButTicketsComponent(
                    model: widget.model,
                  ),
                ),
                SizedBox(
                  height: SizeConfig.padding4,
                ),
                // TermsAndConditions(url: Constants.tambolatnc),

                LottieBuilder.network(
                    "https://d37gtxigg82zaw.cloudfront.net/scroll-animation.json"),

                SizedBox(
                  height: SizeConfig.navBarHeight + SizeConfig.padding16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


/// TODO: After refactoring update the original widget with this widget
class _TicketsView extends StatelessWidget {
  final TambolaHomeViewModel? model;

  const _TicketsView({super.key, this.model});

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    if (!model!.weeklyTicksFetched || !model!.weeklyDrawFetched) {
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
                          "${locale.tgenerated} ${model!.tambolaService!.ticketGenerateCount! - model!.tambolaService!.atomicTicketGenerationLeftCount} ${locale.tgeneratedCount(model!.tambolaService!.ticketGenerateCount.toString())}",
                          style: TextStyles.rajdhani.body2.colour(Colors.white),
                        ),
                      ],
                    )
                  : const SizedBox()),
        ),
      );
    } else if (model!.activeTambolaCardCount == 1) {
      //One tambola ticket
      model!.tambolaBoardViews = [];
      model!.tambolaBoardViews!.add(Ticket(
        bestBoards: model!.refreshBestBoards(),
        dailyPicks: model!.weeklyDigits,
        board: model!.userWeeklyBoards![0],
        calledDigits: (model!.weeklyDrawFetched && model!.weeklyDigits != null)
            ? model!.weeklyDigits!.toList()
            : [],
      ));

      return SizedBox(
        width: SizeConfig.screenWidth,
        child: _TabViewGenerator(
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
            Ticket(
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
          // Padding(
          //   padding: EdgeInsets.symmetric(
          //       horizontal:
          //           SizeConfig.pageHorizontalMargins + SizeConfig.padding2),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       // Text(
          //       //   "Your Best tickets",
          //       //   style: TextStyles.rajdhaniSB.body0,
          //       // ),
          //       // TextButton(
          //       //     onPressed: () {
          //       //       AppState.delegate.appState.currentAction = PageAction(
          //       //         state: PageState.addWidget,
          //       //         page: AllTambolaTicketsPageConfig,
          //       //         widget: AllTambolaTickets(
          //       //             ticketList: model.tambolaBoardViews.toList()),
          //       //       );
          //       //     },
          //       //     child: Row(
          //       //       mainAxisAlignment: MainAxisAlignment.center,
          //       //       children: [
          //       //         Padding(
          //       //           padding: EdgeInsets.only(
          //       //             top: SizeConfig.padding2,
          //       //           ),
          //       //           child: Text(
          //       //               'View All (${model.userWeeklyBoards.length})',
          //       //               style: TextStyles.rajdhaniSB.body2),
          //       //         ),
          //       //         SvgPicture.asset(Assets.chevRonRightArrow,
          //       //             height: SizeConfig.padding24,
          //       //             width: SizeConfig.padding24,
          //       //             color: UiConstants.primaryColor)
          //       //       ],
          //       //     )
          //       //     // child: Text(
          //       //     //   "View All (${model.userWeeklyBoards.length})",
          //       //     //   style: TextStyles.sourceSansSB.body2
          //       //     //       .colour(UiConstants.kTabBorderColor),
          //       //     // ),
          //       //     )
          //     ],
          //   ),
          // ),
          // SizedBox(
          //   height: SizeConfig.padding12,
          // ),
          SizedBox(
            width: SizeConfig.screenWidth,
            child: _TabViewGenerator(
              model: model,
              showIndicatorForAll: true,
            ),
          ),
        ],
      );
    }
  }
}

class _TabViewGenerator extends StatefulWidget {
  const _TabViewGenerator({
    Key? key,
    required this.model,
    required this.showIndicatorForAll,
  }) : super(key: key);

  final TambolaHomeViewModel? model;
  final bool showIndicatorForAll;

  @override
  State<_TabViewGenerator> createState() => _TabViewGeneratorState();
}

class _TabViewGeneratorState extends State<_TabViewGenerator>
    with TickerProviderStateMixin {
  TabController? _tabController;
  List<TambolaBoard?>? _bestBoards;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(vsync: this, length: widget.model!.tabList.length);
    _tabController!.addListener(_handleTabSelection);
    _bestBoards = widget.model!.refreshBestBoards();
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
                      color: Colors.white.withOpacity(0.7),
                    )),
                Expanded(
                  child: TabBar(
                    controller: _tabController,
                    labelPadding: EdgeInsets.zero,
                    indicatorColor: Colors.transparent,
                    physics: const BouncingScrollPhysics(),
                    isScrollable: true,
                    tabs: List.generate(
                      widget.model!.tabList.length,
                      (index) => Container(
                        margin: EdgeInsets.only(
                          right: index == widget.model!.tabList.length - 1
                              ? SizeConfig.pageHorizontalMargins
                              : SizeConfig.padding10,
                          left: 0.0,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.padding10,
                          vertical: SizeConfig.padding16,
                        ),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(SizeConfig.padding24),
                          color: _tabController!.index == index
                              ? UiConstants.kTambolaTabColor
                              : Colors.transparent,
                        ),
                        child: Text(
                          widget.model!.tabList[index],
                          textAlign: TextAlign.center,
                          style: TextStyles.body4.colour(
                            _tabController!.index == index
                                ? UiConstants.kBlogCardRandomColor5
                                : Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.padding16,
            ),
            SizedBox(
              height: SizeConfig.screenWidth! * 0.56,
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  ///All tickets
                  PageViewWithIndicator(
                    model: widget.model,
                    showIndicator: widget.showIndicatorForAll,
                  ),

                  ///Corner
                  widget.model!.userWeeklyBoards != null &&
                          widget.model!.userWeeklyBoards!.isNotEmpty
                      ? Column(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: SizeConfig.pageHorizontalMargins,
                              ),
                              child: TambolaTicket(
                                child: Container(),
                              )
                            ),

                            // Ticket(
                            //     dailyPicks: widget.model!.weeklyDigits,
                            //     bestBoards: _bestBoards,
                            //     board: _bestBoards![0],
                            //     showBestOdds: false,
                            //     calledDigits:
                            //         widget.model!.weeklyDigits!.toList()),
                          ],
                        )
                      : const NoTicketWidget(),

                  ///Top row
                  widget.model!.userWeeklyBoards != null &&
                          widget.model!.userWeeklyBoards!.isNotEmpty
                      ? Column(
                          children: [
                            Ticket(
                                dailyPicks: widget.model!.weeklyDigits,
                                bestBoards: _bestBoards,
                                board: _bestBoards![1],
                                showBestOdds: false,
                                calledDigits:
                                    widget.model!.weeklyDigits!.toList()),
                          ],
                        )
                      : const NoTicketWidget(),

                  /// Mid Row
                  widget.model!.userWeeklyBoards != null &&
                          widget.model!.userWeeklyBoards!.isNotEmpty
                      ? Column(
                          children: [
                            Ticket(
                                dailyPicks: widget.model!.weeklyDigits,
                                bestBoards: _bestBoards,
                                board: _bestBoards![2],
                                showBestOdds: false,
                                calledDigits:
                                    widget.model!.weeklyDigits!.toList()),
                          ],
                        )
                      : const NoTicketWidget(),

                  /// Last Row
                  widget.model!.userWeeklyBoards != null &&
                          widget.model!.userWeeklyBoards!.isNotEmpty
                      ? Column(
                          children: [
                            Ticket(
                                dailyPicks: widget.model!.weeklyDigits,
                                bestBoards: _bestBoards,
                                board: _bestBoards![3],
                                showBestOdds: false,
                                calledDigits:
                                    widget.model!.weeklyDigits!.toList()),
                          ],
                        )
                      : const NoTicketWidget(),

                  /// Corner
                  const NoTicketWidget(),
                ],
              ),
            )
          ],
        ));
  }
}

class MySeparator extends StatelessWidget {
  const MySeparator({Key? key, this.height = 1, this.color = Colors.black})
      : super(key: key);
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 8.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }
}
