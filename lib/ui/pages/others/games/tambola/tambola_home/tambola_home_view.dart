import 'dart:io';
import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/enums/connectivity_status_enum.dart';
import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/model/daily_pick_model.dart';
import 'package:felloapp/core/model/tambola_board_model.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/tambola-global/tambola_ticket.dart';
import 'package:felloapp/ui/pages/hometabs/journey/components/help_fab.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_components/play_info_section.dart';
import 'package:felloapp/ui/pages/others/events/info_stories/info_stories_view.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_home/all_tambola_tickets.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_home/tambola_home_vm.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_widgets/picks_card/picks_card_view.dart';
import 'package:felloapp/ui/pages/others/games/tambola/weekly_results/weekly_result.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/game_card.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/ui/widgets/appbar/appbar.dart';
import 'package:felloapp/ui/widgets/default_avatar.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:provider/provider.dart';

class TambolaHomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ConnectivityStatus connectivityStatus =
        Provider.of<ConnectivityStatus>(context);

    return BaseView<TambolaHomeViewModel>(
      onModelReady: (model) {
        model.init();
        model.scrollController = new ScrollController();
        model.scrollController.addListener(() {
          model.udpateCardOpacity();
        });
      },
      builder: (ctx, model, child) {
        return RefreshIndicator(
          color: UiConstants.primaryColor,
          backgroundColor: Colors.black,
          onRefresh: model.refreshTambolaTickets,
          child: Scaffold(
            appBar: FAppBar(
              type: FaqsType.play,
              showAvatar: false,
              showCoinBar: false,
              showHelpButton: false,
              title: "Tambola",
              backgroundColor: UiConstants.kArowButtonBackgroundColor,
            ),
            backgroundColor: UiConstants.kBackgroundColor,
            body: Stack(
              children: [
                NewSquareBackground(),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      //Today and Weekly Picks
                      TodayWeeklyPicksCard(
                        model: model,
                      ),
                      //Win Announcement card
                      if (model.showWinCard)
                        TambolaResultCard(
                          model: model,
                        ),
                      SizedBox(
                        height: SizeConfig.screenWidth * 0.075,
                      ),
                      //Your best tickets
                      connectivityStatus != ConnectivityStatus.Offline
                          ? model.userWeeklyBoards != null
                              ? TicketsView(model: model)
                              : Container(
                                  width: SizeConfig.screenWidth,
                                  padding: EdgeInsets.symmetric(
                                      vertical:
                                          SizeConfig.pageHorizontalMargins),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      FullScreenLoader(),
                                      SizedBox(height: SizeConfig.padding20),
                                      Text(
                                        "Fetching your tambola tickets..",
                                        style: TextStyles.sourceSans.body2
                                            .colour(Colors.white),
                                      ),
                                    ],
                                  ),
                                )
                          : SizedBox.shrink(),
                      (Platform.isIOS)
                          ? Text(
                              'Apple is not associated with Fello Tambola',
                              style: TextStyle(
                                  fontWeight: FontWeight.w100,
                                  fontSize: SizeConfig.mediumTextSize,
                                  color: Colors.white),
                            )
                          : Container(),
                      //How to play
                      InfoComponent2(
                          heading: model.boxHeading,
                          assetList: model.boxAssets,
                          titleList: model.boxTitlles,
                          height: SizeConfig.screenWidth * 0.35),

                      //Tambola Prizes
                      TambolaPrize(
                        model: model,
                      ),
                      //LeaderBoard
                      TambolaLeaderBoard(
                        model: model,
                      ),
                      SizedBox(
                        height: SizeConfig.screenWidth * 0.35,
                      )
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: ButTicketsComponent(
                    model: model,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class TicketsView extends StatelessWidget {
  final TambolaHomeViewModel model;

  TicketsView({this.model});
  @override
  Widget build(BuildContext context) {
    if (!model.weeklyTicksFetched || !model.weeklyDrawFetched) {
      return SizedBox();
    } else if (model.userWeeklyBoards == null ||
        model.activeTambolaCardCount == 0) {
      return Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          width: double.infinity,
          child: Center(
              child: (model.ticketsBeingGenerated)
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: SizeConfig.screenWidth * 0.8,
                          height: 4,
                          decoration: BoxDecoration(
                            color: UiConstants.primaryColor.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: FractionallySizedBox(
                            heightFactor: 1,
                            widthFactor: model
                                        .tambolaService.ticketGenerateCount ==
                                    model.tambolaService
                                        .atomicTicketGenerationLeftCount
                                ? 0.1
                                : (model.tambolaService.ticketGenerateCount -
                                        model.tambolaService
                                            .atomicTicketGenerationLeftCount) /
                                    model.tambolaService.ticketGenerateCount,
                            alignment: Alignment.centerLeft,
                            child: Container(
                              decoration: BoxDecoration(
                                color: UiConstants.primaryColor,
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Generated ${model.tambolaService.ticketGenerateCount - model.tambolaService.atomicTicketGenerationLeftCount} of your ${model.tambolaService.ticketGenerateCount} tickets',
                          style: TextStyles.rajdhani.body2.colour(Colors.white),
                        ),
                      ],
                    )
                  : SizedBox()),
        ),
      );
    } else if (model.activeTambolaCardCount == 1) {
      //One tambola ticket
      model.tambolaBoardViews = [];
      model.tambolaBoardViews.add(Ticket(
        bestBoards: model.refreshBestBoards(),
        dailyPicks: model.weeklyDigits,
        board: model.userWeeklyBoards[0],
        calledDigits: (model.weeklyDrawFetched && model.weeklyDigits != null)
            ? model.weeklyDigits.toList()
            : [],
      ));

      return Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal:
                    SizeConfig.pageHorizontalMargins + SizeConfig.padding2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Your Best tickets",
                  style: TextStyles.rajdhaniSB.body0,
                ),
                Text(
                  "Total tickets: ${model.userWeeklyBoards.length}",
                  style: TextStyles.rajdhaniSB.body3,
                ),
              ],
            ),
          ),
          SizedBox(
            height: SizeConfig.padding16,
          ),
          Container(
            width: SizeConfig.screenWidth,
            child: TabViewGenerator(
              model: model,
              showIndicatorForAll: false,
            ),
          ),
        ],
      );
    } else {
      //Multiple tickets
      if (!model.ticketsLoaded) {
        model.ticketsLoaded = true;
        model.tambolaBoardViews = [];

        model.userWeeklyBoards.forEach((board) {
          model.tambolaBoardViews.add(
            Ticket(
              bestBoards: model.refreshBestBoards(),
              dailyPicks: model.weeklyDigits,
              board: board,
              calledDigits:
                  (model.weeklyDrawFetched && model.weeklyDigits != null)
                      ? model.weeklyDigits.toList()
                      : [],
            ),
          );
        });
      }

      return Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal:
                    SizeConfig.pageHorizontalMargins + SizeConfig.padding2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Your Best tickets",
                  style: TextStyles.rajdhaniSB.body0,
                ),
                TextButton(
                    onPressed: () {
                      AppState.delegate.appState.currentAction = PageAction(
                        state: PageState.addWidget,
                        page: AllTambolaTicketsPageConfig,
                        widget: AllTambolaTickets(
                            ticketList: model.tambolaBoardViews.toList()),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: SizeConfig.padding2,
                          ),
                          child: Text(
                              'View All (${model.userWeeklyBoards.length})',
                              style: TextStyles.rajdhaniSB.body2),
                        ),
                        SvgPicture.asset(Assets.chevRonRightArrow,
                            height: SizeConfig.padding24,
                            width: SizeConfig.padding24,
                            color: UiConstants.primaryColor)
                      ],
                    )
                    // child: Text(
                    //   "View All (${model.userWeeklyBoards.length})",
                    //   style: TextStyles.sourceSansSB.body2
                    //       .colour(UiConstants.kTabBorderColor),
                    // ),
                    )
              ],
            ),
          ),
          SizedBox(
            height: SizeConfig.padding12,
          ),
          Container(
            width: SizeConfig.screenWidth,
            child: Stack(
              children: [
                TabViewGenerator(
                  model: model,
                  showIndicatorForAll: true,
                ),
              ],
            ),
          ),
        ],
      );
    }
  }
}

class TambolaResultCard extends StatelessWidget {
  final TambolaHomeViewModel model;

  TambolaResultCard({this.model});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AppState.delegate.appState.currentAction = PageAction(
        state: PageState.addWidget,
        page: TWeeklyResultPageConfig,
        widget: WeeklyResult(
          winningsmap: model.ticketCodeWinIndex,
          isEligible: model.isEligible,
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(
            top: SizeConfig.pageHorizontalMargins,
            right: SizeConfig.pageHorizontalMargins,
            left: SizeConfig.pageHorizontalMargins),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SizeConfig.cardBorderRadius),
            color: UiConstants.kSnackBarPositiveContentColor),
        padding: EdgeInsets.symmetric(vertical: SizeConfig.padding16),
        child: ListTile(
          leading: SvgPicture.asset(
            Assets.tambolaCardAsset,
            width: SizeConfig.screenWidth * 0.13,
          ),
          title: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              "Tambola results are out   ",
              style: TextStyles.rajdhaniB.title3,
            ),
          ),
          subtitle: Text(
            "Find out if your tickets won",
            style: TextStyles.sourceSans.body2,
          ),
          trailing: Icon(Icons.arrow_forward_ios_rounded, color: Colors.white),
        ),
      ),
    );
  }
}

class TabViewGenerator extends StatefulWidget {
  const TabViewGenerator({
    Key key,
    @required this.model,
    @required this.showIndicatorForAll,
  }) : super(key: key);

  final TambolaHomeViewModel model;
  final bool showIndicatorForAll;

  @override
  State<TabViewGenerator> createState() => _TabViewGeneratorState();
}

class _TabViewGeneratorState extends State<TabViewGenerator>
    with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        new TabController(vsync: this, length: widget.model.tabList.length);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<TambolaBoard> _bestBoards = widget.model.refreshBestBoards();
    return DefaultTabController(
        length: widget.model.tabList.length,
        child: Column(
          children: [
            TabBar(
                controller: _tabController,
                labelPadding: EdgeInsets.zero,
                indicatorColor: Colors.transparent,
                physics: BouncingScrollPhysics(),
                isScrollable: true,
                tabs: List.generate(
                    widget.model.tabList.length,
                    (index) => Container(
                          margin: EdgeInsets.only(
                            right: index == widget.model.tabList.length - 1
                                ? SizeConfig.pageHorizontalMargins
                                : SizeConfig.padding10,
                            left: index == 0
                                ? SizeConfig.pageHorizontalMargins
                                : 0.0,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.padding10,
                            vertical: SizeConfig.padding16,
                          ),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(SizeConfig.padding8),
                              color: UiConstants.gameCardColor,
                              border: Border.all(
                                  color: _tabController.index == index
                                      ? Colors.white
                                      : Colors.transparent,
                                  width: _tabController.index == index
                                      ? 0.5
                                      : 0.0)),
                          child: Text(widget.model.tabList[index],
                              textAlign: TextAlign.center,
                              style: TextStyles.body4.colour(Colors.white
                                  .withOpacity(_tabController.index == index
                                      ? 1
                                      : 0.5))),
                        ))),
            SizedBox(
              height: SizeConfig.padding16,
            ),
            Container(
              height: SizeConfig.screenWidth * 0.56,
              child: TabBarView(
                controller: _tabController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  //All tickets
                  PageViewWithIndicator(
                    model: widget.model,
                    showIndicator: widget.showIndicatorForAll,
                  ),
                  //Corner
                  widget.model.userWeeklyBoards != null &&
                          widget.model.userWeeklyBoards.length >= 1
                      ? Column(
                          children: [
                            Ticket(
                                dailyPicks: widget.model.weeklyDigits,
                                bestBoards: _bestBoards,
                                board: _bestBoards[0],
                                showBestOdds: false,
                                calledDigits:
                                    widget.model.weeklyDigits.toList()),
                          ],
                        )
                      : NoTicketWidget(),
                  //Top row
                  widget.model.userWeeklyBoards != null &&
                          widget.model.userWeeklyBoards.length >= 1
                      ? Column(
                          children: [
                            Ticket(
                                dailyPicks: widget.model.weeklyDigits,
                                bestBoards: _bestBoards,
                                board: _bestBoards[1],
                                showBestOdds: false,
                                calledDigits:
                                    widget.model.weeklyDigits.toList()),
                          ],
                        )
                      : NoTicketWidget(),
                  widget.model.userWeeklyBoards != null &&
                          widget.model.userWeeklyBoards.length >= 1
                      ? Column(
                          children: [
                            Ticket(
                                dailyPicks: widget.model.weeklyDigits,
                                bestBoards: _bestBoards,
                                board: _bestBoards[2],
                                showBestOdds: false,
                                calledDigits:
                                    widget.model.weeklyDigits.toList()),
                          ],
                        )
                      : NoTicketWidget(),
                  widget.model.userWeeklyBoards != null &&
                          widget.model.userWeeklyBoards.length >= 1
                      ? Column(
                          children: [
                            Ticket(
                                dailyPicks: widget.model.weeklyDigits,
                                bestBoards: _bestBoards,
                                board: _bestBoards[3],
                                showBestOdds: false,
                                calledDigits:
                                    widget.model.weeklyDigits.toList()),
                          ],
                        )
                      : NoTicketWidget(),
                ],
              ),
            )
          ],
        ));
  }
}

class NoTicketWidget extends StatelessWidget {
  const NoTicketWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          Assets.noWinnersAsset,
          width: SizeConfig.screenWidth * 0.2,
        ),
        SizedBox(
          height: SizeConfig.padding14,
        ),
        Text(
          "No eligible tickets",
          style: TextStyles.sourceSans.body4.colour(Colors.white),
        ),
      ],
    );
  }
}

class Odds extends StatelessWidget {
  final DailyPick _digitsObj;
  final TambolaBoard _board;
  final List<TambolaBoard> _bestBoards;
  final bool showBestBoard;
  final int currentIndex;

  Odds(this._digitsObj, this._board, this._bestBoards, this.showBestBoard,
      this.currentIndex);

  @override
  Widget build(BuildContext cx) {
    if (_board == null) return Container();
    List<int> _digits = (_digitsObj != null) ? _digitsObj.toList() : [];
    switch (currentIndex) {
      case 0:
        return _buildRow(
            cx,
            Icons.border_top,
            'Top Row',
            _board.getRowOdds(0, _digits).toString() + ' left',
            _bestBoards[0].getRowOdds(0, _digits).toString() + ' left',
            _bestBoards[0],
            _digits);
      case 1:
        return _buildRow(
            cx,
            Icons.border_horizontal,
            'Middle Row',
            _board.getRowOdds(1, _digits).toString() + ' left',
            _bestBoards[1].getRowOdds(1, _digits).toString() + ' left',
            _bestBoards[1],
            _digits);
      case 2:
        return _buildRow(
            cx,
            Icons.border_bottom,
            'Bottom Row',
            _board.getRowOdds(2, _digits).toString() + ' left',
            _bestBoards[2].getRowOdds(2, _digits).toString() + ' left',
            _bestBoards[2],
            _digits);
      case 3:
        return _buildRow(
            cx,
            Icons.border_outer,
            'Corners',
            _board.getCornerOdds(_digits).toString() + ' left',
            _bestBoards[3].getCornerOdds(_digits).toString() + ' left',
            _bestBoards[3],
            _digits);
      case 4:
        return _buildRow(
            cx,
            Icons.apps,
            'Full House',
            _board.getFullHouseOdds(_digits).toString() + ' left',
            _bestBoards[4].getFullHouseOdds(_digits).toString() + ' left',
            _bestBoards[4],
            _digits);

      default:
        return _buildRow(
            cx,
            Icons.border_top,
            'Top Row',
            _board.getRowOdds(0, _digits).toString() + ' left',
            _bestBoards[0].getRowOdds(0, _digits).toString() + ' left',
            _bestBoards[0],
            _digits);
    }
  }

  Widget _buildBestTicket(
      BuildContext cx, TambolaBoard _bestBoard, List<int> _digits) {
    return Column(
      children: [
        Ticket(
            dailyPicks: _digitsObj,
            bestBoards: _bestBoards,
            board: _bestBoard,
            showBestOdds: false,
            calledDigits: _digits),
      ],
    );
  }

  Widget _buildRow(BuildContext cx, IconData _i, String _title, String _tOdd,
      String _oOdd, TambolaBoard _bestBoard, List<int> _digits) {
    return Column(
      children: [
        Ticket(
            dailyPicks: _digitsObj,
            bestBoards: _bestBoards,
            board: _bestBoard,
            showBestOdds: false,
            calledDigits: _digits),
        // SizedBox(
        //   height: SizeConfig.padding8,
        // ),
        // SizedBox(
        //   height: SizeConfig.padding6,
        // ),
      ],
    );
  }
}

class ButTicketsComponent extends StatelessWidget {
  const ButTicketsComponent({
    Key key,
    @required this.model,
  }) : super(key: key);

  final TambolaHomeViewModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.pageHorizontalMargins,
          vertical: SizeConfig.pageHorizontalMargins),
      decoration: BoxDecoration(
        color: UiConstants.kSecondaryBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(SizeConfig.roundness16),
          topRight: Radius.circular(SizeConfig.roundness16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Text(
                  "Get a Tambola ticket",
                  textAlign: TextAlign.left,
                  style: TextStyles.rajdhaniSB.body1,
                ),
                Text(
                  "Get 1 Ticket for every ₹500 saved",
                  style: TextStyles.sourceSans.body4
                      .colour(UiConstants.kTextColor2),
                ),
              ]),
              InkWell(
                onTap: () {
                  AppState.screenStack.add(ScreenItem.dialog);
                  Navigator.of(AppState.delegate.navigatorKey.currentContext)
                      .push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, anotherAnimation) {
                        return InfoStories(
                          topic: 'tambola',
                        );
                      },
                      transitionDuration: Duration(milliseconds: 500),
                      transitionsBuilder:
                          (context, animation, anotherAnimation, child) {
                        animation = CurvedAnimation(
                            curve: Curves.easeInCubic, parent: animation);
                        return Align(
                          child: SizeTransition(
                            sizeFactor: animation,
                            child: child,
                            axisAlignment: 0.0,
                          ),
                        );
                      },
                    ),
                  );
                },
                child: Icon(
                  Icons.info_outline,
                  color: Colors.white,
                ),
              )
            ],
          ),
          SizedBox(
            height: SizeConfig.padding16,
          ),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: UiConstants.kArowButtonBackgroundColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(SizeConfig.roundness8),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      iconSize: SizeConfig.padding16,
                      color: Colors.white,
                      onPressed: model.decreaseTicketCount,
                    ),
                    Container(
                      width: SizeConfig.screenHeight * 0.03,
                      height: SizeConfig.padding54,
                      child: TextField(
                        style: TextStyles.sourceSans.body2.setHeight(2),
                        textAlign: TextAlign.center,
                        controller: model.ticketCountController,
                        enableInteractiveSelection: false,
                        enabled: false,
                        keyboardType:
                            TextInputType.numberWithOptions(signed: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (String text) {
                          model.updateTicketCount();
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      iconSize: SizeConfig.padding16,
                      color: Colors.white,
                      onPressed: model.increaseTicketCount,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: SizeConfig.padding10,
              ),
              Text(
                "= ₹ ${model.ticketSavedAmount.toString()}",
                style: TextStyles.sourceSansB.body2.colour(Colors.white),
              ),
              Spacer(),
              AppPositiveBtn(
                  height: SizeConfig.padding54,
                  width: SizeConfig.screenWidth * 0.34,
                  onPressed: () {
                    BaseUtil().openDepositOptionsModalSheet(
                        amount: model.ticketSavedAmount);
                  },
                  btnText: 'SAVE')
            ],
          ),
        ],
      ),
    );
  }
}

class PageViewWithIndicator extends StatefulWidget {
  const PageViewWithIndicator(
      {Key key, @required this.model, @required this.showIndicator})
      : super(key: key);

  final TambolaHomeViewModel model;
  final bool showIndicator;

  @override
  State<PageViewWithIndicator> createState() => _PageViewWithIndicatorState();
}

class _PageViewWithIndicatorState extends State<PageViewWithIndicator> {
  final _currentPageNotifier = ValueNotifier<int>(0);
  int ticketsCount = 0;

  @override
  void initState() {
    ticketsCount = widget.model.tambolaBoardViews.length > 5
        ? 5
        : widget.model.tambolaBoardViews.length;
    super.initState();
  }

  _buildCircleIndicator() {
    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 0.0,
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.padding4),
        child: CirclePageIndicator(
          itemCount: ticketsCount,
          currentPageNotifier: _currentPageNotifier,
          selectedDotColor: UiConstants.kSelectedDotColor,
          dotColor: Colors.white.withOpacity(0.5),
          selectedSize: SizeConfig.padding8,
          size: SizeConfig.padding6,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: SizeConfig.screenWidth * 0.48,
          child: PageView(
            physics: BouncingScrollPhysics(),
            controller: widget.model.ticketPageController,
            scrollDirection: Axis.horizontal,
            children: widget.model.tambolaBoardViews.sublist(0, ticketsCount),
            onPageChanged: (int index) {
              _currentPageNotifier.value = index;
            },
          ),
        ),
        SizedBox(
          height: SizeConfig.padding8,
        ),
        if (widget.showIndicator) _buildCircleIndicator(),
      ],
    );
  }
}

class ListLoader extends StatelessWidget {
  final bool bottomPadding;
  const ListLoader({Key key, this.bottomPadding = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: SizeConfig.screenHeight * 0.1),
        FullScreenLoader(size: SizeConfig.padding80),
        if (bottomPadding) SizedBox(height: SizeConfig.screenHeight * 0.1),
      ],
    );
  }
}

class GameChips extends StatelessWidget {
  final TambolaHomeViewModel model;
  final String text;
  final int page;
  GameChips({this.model, this.text, this.page});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => model.viewpage(page),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.padding24, vertical: SizeConfig.padding12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: model.currentPage == page
              ? UiConstants.primaryColor
              : UiConstants.primaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(text,
            style: model.currentPage == page
                ? TextStyles.body3.bold.colour(Colors.white)
                : TextStyles.body3.colour(UiConstants.primaryColor)),
      ),
    );
  }
}

class TodayWeeklyPicksCard extends StatelessWidget {
  const TodayWeeklyPicksCard({
    Key key,
    @required this.model,
  }) : super(key: key);

  final TambolaHomeViewModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: SizeConfig.pageHorizontalMargins,
        bottom: SizeConfig.pageHorizontalMargins + SizeConfig.padding16,
      ),
      decoration: BoxDecoration(
        color: UiConstants.kArowButtonBackgroundColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(
            SizeConfig.roundness32,
          ),
          bottomRight: Radius.circular(
            SizeConfig.roundness32,
          ),
        ),
      ),
      child: PicksCardView(),
    );
  }
}

class TambolaLeaderBoard extends StatelessWidget {
  const TambolaLeaderBoard({
    Key key,
    @required this.model,
  }) : super(key: key);

  final TambolaHomeViewModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: SizeConfig.pageHorizontalMargins + SizeConfig.padding12,
          ),
          Text(
            "Last week winners",
            style: TextStyles.rajdhaniSB.body0,
          ),
          SizedBox(
            height: SizeConfig.pageHorizontalMargins,
          ),
          model.winners == null
              ? Center(
                  child: Column(
                    children: [
                      FullScreenLoader(size: SizeConfig.padding80),
                      SizedBox(
                        height: SizeConfig.padding16,
                      ),
                      Text(
                        "Fetching last week winners.",
                        style: TextStyles.rajdhaniB.body2.colour(Colors.white),
                      ),
                    ],
                  ),
                )
              : (model.winners.isEmpty
                  ? Container(
                      margin:
                          EdgeInsets.symmetric(vertical: SizeConfig.padding24),
                      color: Colors.transparent,
                      alignment: Alignment.center,
                      width: SizeConfig.screenWidth,
                      child: NoRecordDisplayWidget(
                        topPadding: false,
                        assetSvg: Assets.noWinnersAsset,
                        text: "Leaderboard will be updated soon",
                      ),
                    )
                  : Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "#",
                              style: TextStyles.sourceSans.body3
                                  .colour(UiConstants.kTextColor2),
                            ),
                            SizedBox(width: SizeConfig.padding12),
                            SizedBox(width: SizeConfig.padding12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Names",
                                      style: TextStyles.sourceSans.body3
                                          .colour(UiConstants.kTextColor2)),
                                  SizedBox(height: SizeConfig.padding4),
                                ],
                              ),
                            ),
                            Text(
                              "Cashprize",
                              style: TextStyles.sourceSans.body3
                                  .colour(UiConstants.kTextColor2),
                            )
                          ],
                        ),
                        Column(
                          children: List.generate(
                            model.winners.length,
                            (i) {
                              return Column(
                                children: [
                                  Container(
                                    width: SizeConfig.screenWidth,
                                    padding: EdgeInsets.symmetric(
                                        vertical: SizeConfig.padding12),
                                    margin: EdgeInsets.symmetric(
                                      vertical: SizeConfig.padding4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(
                                          SizeConfig.roundness16),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${i + 1}",
                                          style: TextStyles.sourceSans.body2
                                              .colour(Colors.white),
                                        ),
                                        SizedBox(width: SizeConfig.padding12),
                                        FutureBuilder(
                                          future: model.getProfileDpWithUid(
                                              model.winners[i].userid),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                    ConnectionState.waiting ||
                                                !snapshot.hasData) {
                                              return DefaultAvatar();
                                            }

                                            String imageUrl =
                                                snapshot.data as String;

                                            return ClipOval(
                                              child: CachedNetworkImage(
                                                imageUrl: imageUrl,
                                                fit: BoxFit.cover,
                                                width: SizeConfig.iconSize5,
                                                height: SizeConfig.iconSize5,
                                                placeholder: (context, url) =>
                                                    Container(
                                                  width: SizeConfig.iconSize5,
                                                  height: SizeConfig.iconSize5,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                                errorWidget: (a, b, c) {
                                                  return DefaultAvatar();
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                        SizedBox(width: SizeConfig.padding12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                  //"avc",
                                                  model.winners[i].username
                                                          .replaceAll(
                                                              '@', '.') ??
                                                      "username",
                                                  style: TextStyles
                                                      .sourceSans.body2
                                                      .colour(Colors.white)),
                                              SizedBox(
                                                  height: SizeConfig.padding4),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          "₹ ${model.winners[i].amount.toInt() ?? "00"}",
                                          style: TextStyles.sourceSans.body2
                                              .colour(Colors.white),
                                        )
                                      ],
                                    ),
                                  ),
                                  if (i + 1 < model.winners.length)
                                    Divider(
                                      color: Colors.white,
                                      thickness: 0.2,
                                    )
                                ],
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.padding16,
                        ),
                      ],
                    )),
        ],
      ),
    );
  }
}

class TambolaPrize extends StatelessWidget {
  const TambolaPrize({
    Key key,
    @required this.model,
  }) : super(key: key);

  final TambolaHomeViewModel model;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: EdgeInsets.only(top: SizeConfig.screenWidth * 0.15),
          decoration: BoxDecoration(
            color: UiConstants.kTambolaMidTextColor,
          ),
          child: Column(
            children: [
              SizedBox(
                height: SizeConfig.screenWidth * 0.17,
              ),
              Text(
                "Tambola Prizes",
                style: TextStyles.rajdhaniB.title4.colour(Colors.white),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: SizeConfig.padding54),
                child: Text(
                  BaseRemoteConfig.remoteConfig.getString(
                          BaseRemoteConfig.GAME_TAMBOLA_ANNOUNCEMENT) ??
                      "Winners are announced every Sunday at midnight, Complete a Full House and win 1Crore!",
                  textAlign: TextAlign.center,
                  style: TextStyles.sourceSans.body4.colour(
                    Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                child: model.tPrizes == null
                    ? Center(
                        child: Column(
                          children: [
                            FullScreenLoader(
                              size: SizeConfig.padding80,
                            ),
                            SizedBox(
                              height: SizeConfig.padding16,
                            ),
                            Text(
                              "Fetching Tambola prizes, please wait.",
                              style: TextStyles.rajdhaniB.body2
                                  .colour(Colors.white),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: model.tPrizes.prizesA.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(
                                vertical: SizeConfig.padding16),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  Assets.tambolaPrizeAssets[index],
                                  color: Colors.grey,
                                  height: SizeConfig.padding44,
                                  width: SizeConfig.padding44,
                                ),
                                SizedBox(
                                  width: SizeConfig.padding10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      model.tPrizes.prizesA[index].displayName,
                                      style: TextStyles.rajdhaniB.body2
                                          .colour(Colors.white),
                                    ),
                                    Text(
                                      "Complete ${model.tPrizes.prizesA[index].displayName} to get",
                                      style: TextStyles.sourceSans.body4.colour(
                                          Colors.white.withOpacity(0.5)),
                                    )
                                  ],
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          model.tPrizes.prizesA[index]
                                                  .displayAmount ??
                                              "",
                                          style: TextStyles.sourceSans.body3
                                              .colour(Colors.white),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            SvgPicture.asset(
                                              Assets.token,
                                              width: SizeConfig.padding12,
                                            ),
                                            SizedBox(
                                              width: SizeConfig.padding10,
                                            ),
                                            Text(
                                              "${model.tPrizes.prizesA[index].flc}",
                                              style: TextStyles.sourceSans.body4
                                                  .colour(Colors.white
                                                      .withOpacity(0.5)),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding6),
          width: SizeConfig.screenWidth * 0.3,
          height: SizeConfig.screenWidth * 0.3,
          decoration: BoxDecoration(
            color: UiConstants.kTambolaMidTextColor,
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(
            "assets/svg/tambola_prize_asset.svg",
            width: double.maxFinite,
            height: double.maxFinite,
          ),
        ),
      ],
    );
  }
}
