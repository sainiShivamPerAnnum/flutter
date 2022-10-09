import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/daily_pick_model.dart';
import 'package:felloapp/core/model/flc_pregame_model.dart';
import 'package:felloapp/core/model/game_model.dart';
import 'package:felloapp/core/model/leaderboard_model.dart';
import 'package:felloapp/core/model/prizes_model.dart';
import 'package:felloapp/core/model/tambola_board_model.dart';
import 'package:felloapp/core/model/winners_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/repository/games_repo.dart';
import 'package:felloapp/core/repository/getters_repo.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/repository/ticket_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/prize_service.dart';
import 'package:felloapp/core/service/notifier_services/tambola_service.dart';
import 'package:felloapp/core/service/notifier_services/user_coin_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/notifier_services/winners_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/elements/tambola-global/tambola_ticket.dart';
import 'package:felloapp/ui/modals_sheets/want_more_tickets_modal_sheet.dart';
import 'package:felloapp/ui/pages/others/games/tambola/weekly_results/weekly_result.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/code_from_freq.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:flutter/rendering.dart';

class TambolaHomeViewModel extends BaseViewModel {
  final _getterRepo = locator<GetterRepository>();
  final _prizeService = locator<PrizeService>();
  final _baseUtil = locator<BaseUtil>();
  final _logger = locator<CustomLogger>();
  final _analyticsService = locator<AnalyticsService>();
  final GameRepo _gamesRepo = locator<GameRepo>();
  final WinnerService _winnerService = locator<WinnerService>();
  final _dbModel = locator<DBModel>();
  final tambolaService = locator<TambolaService>();
  final _coinService = locator<UserCoinService>();
  final _tambolaRepo = locator<TambolaRepo>();
  final _userService = locator<UserService>();

  bool isLeaderboardLoading = false;
  bool isPrizesLoading = false;
  int currentPage = 0;
  PageController pageController = new PageController(initialPage: 0);
  LeaderboardModel _tLeaderBoard;
  ScrollController scrollController;
  double cardOpacity = 1;
  GameModel game;
  List<Winners> _winners = [];
  List<Ticket> _tambolaBoardViews;
  int ticketGenerationTryCount = 0;
  TextEditingController ticketCountController;
  Ticket _currentBoardView;
  TambolaBoard _currentBoard;
  Widget _widget;
  AnimationController animationController;
  PageController ticketPageController;
  int _currentPage = 1;
  List<Ticket> _topFiveTambolaBoards = [];
  List<TambolaBoard> _bestTambolaBoards;
  bool showSummaryCards = true;
  bool ticketBuyInProgress = false;
  bool _weeklyDrawFetched = false;
  int buyTicketCount = 3;
  bool _ticketsBeingGenerated = false;
  bool ticketsLoaded = false;
  int _ticketSavedAmount = 0;
  bool _showWinCard = false;
  Map<String, int> ticketCodeWinIndex = {};
  bool _isEligible = false;
  get isEligible => this._isEligible;

  set isEligible(value) => this._isEligible = value;
  get showWinCard => this._showWinCard;

  set showWinCard(value) {
    this._showWinCard = value;
    notifyListeners();
  }

  //Constant values
  Map<String, IconData> tambolaOdds = {
    "Full House": Icons.apps,
    "Top Row": Icons.border_top,
    "Middle Row": Icons.border_horizontal,
    "Bottom Row": Icons.border_bottom,
    "Corners": Icons.border_outer
  };

  List<String> tabList = [
    "All",
    "Corners",
    "One Row",
    "Two Rows",
    "Full House",
  ];

  String boxHeading = "How to Play";

  List<String> boxTitlles = [
    "Your ticket comprises of 15 randomly placed numbers, refreshed every Monday",
    "3 random numbers are picked everyday from 1 to 90 at 6 pm.",
    "Numbers that match your ticket gets automatically crossed out.",
  ];
  List<String> boxAssets = [
    Assets.howToPlayAsset1Tambola,
    Assets.howToPlayAsset2Tambola,
    Assets.howToPlayAsset3Tambola,
  ];

  udpateCardOpacity() {
    cardOpacity = 1 -
        (scrollController.offset / scrollController.position.maxScrollExtent)
            .clamp(0, 1)
            .toDouble();
    notifyListeners();
  }

  LeaderboardModel get tlboard => _tLeaderBoard;
  PrizesModel get tPrizes => _prizeService.tambolaPrizes;
  List<Winners> get winners => _winners;

  int get ticketSavedAmount => _ticketSavedAmount;

  int get dailyPicksCount => tambolaService.dailyPicksCount;

  List<int> get todaysPicks => tambolaService.todaysPicks;

  DailyPick get weeklyDigits => tambolaService.weeklyDigits;

  List<TambolaBoard> get userWeeklyBoards => tambolaService.userWeeklyBoards;

  List<Ticket> get tambolaBoardViews => this._tambolaBoardViews;

  set tambolaBoardViews(List<Ticket> value) {
    this._tambolaBoardViews = value;
  }

  get ticketsBeingGenerated => this._ticketsBeingGenerated;

  set ticketsBeingGenerated(value) {
    this._ticketsBeingGenerated = value;
    notifyListeners();
  }

  get weeklyDrawFetched => this._weeklyDrawFetched;

  set weeklyDrawFetched(value) {
    this._weeklyDrawFetched = value;
    notifyListeners();
  }

  Widget get cardWidget => _widget;

  List<Ticket> get topFiveTambolaBoards => _topFiveTambolaBoards;

  bool get weeklyTicksFetched => tambolaService.weeklyTicksFetched;

  Ticket get currentBoardView => _currentBoardView;

  TambolaBoard get currentBoard => _currentBoard;

  int get ticketPurchaseCost {
    String _tambolaCost = BaseRemoteConfig.remoteConfig
        .getString(BaseRemoteConfig.TAMBOLA_PLAY_COST);
    if (_tambolaCost == null ||
        _tambolaCost.isEmpty ||
        int.tryParse(_tambolaCost) == null) _tambolaCost = '10';

    return int.tryParse(_tambolaCost);
  }

  int get totalActiveTickets => tambolaService.ticketCount;

  viewpage(int index) {
    currentPage = index;
    print(currentPage);
    pageController.animateToPage(currentPage,
        duration: Duration(milliseconds: 200), curve: Curves.decelerate);
    refresh();
  }

  updateTicketSavedAmount(int count) {
    _ticketSavedAmount = 500 * count;
    notifyListeners();
  }

  init() async {
    setState(ViewState.Busy);
    await getGameDetails();
    getLeaderboard();

    fetchWinners();
    if (tPrizes == null) getPrizes();

    //Tambola services
    ticketCountController =
        new TextEditingController(text: buyTicketCount.toString());
    updateTicketSavedAmount(buyTicketCount);

    // Ticket wallet check
    await tambolaService.getTicketCount();

    ///Weekly Picks check
    if (weeklyDigits == null) {
      await tambolaService.fetchWeeklyPicks();
      weeklyDrawFetched = true;
    } else
      weeklyDrawFetched = true;

    ///next get the tambola tickets of this week
    if (!tambolaService.weeklyTicksFetched) {
      _logger.d("Fetching Tambola tickets");
      ticketsLoaded = false;
      final tickets = await _tambolaRepo.getTickets();
      if (tickets.code == 200) {
        List<TambolaBoard> boards = tickets.model.map((e) => e.board).toList();
        tambolaService.weeklyTicksFetched = true;
        tambolaService.userWeeklyBoards = boards;
        _logger.d(boards.length);
        _currentBoard = null;
        _currentBoardView = null;
      } else {
        _logger.d(tickets.errorMessage);
      }

      _examineTicketsForWins();

      notifyListeners();
    }

    ///check whether to show summary cards or not
    DateTime today = DateTime.now();
    if (today.weekday == 7 && today.hour > 18) {
      showSummaryCards = false;
      notifyListeners();
    }

    setState(ViewState.Idle);
  }

  fetchWinners() async {
    _winnerService.fetchtambolaWinners();
    _winners = _winnerService.winners;

    notifyListeners();
  }

  Future getProfileDpWithUid(String uid) async {
    return await _dbModel.getUserDP(uid) ?? "";
  }

  Future<void> getLeaderboard() async {
    isLeaderboardLoading = true;
    notifyListeners();

    log("GM_TAMBOLA2020");
    ApiResponse temp = await _getterRepo.getStatisticsByFreqGameTypeAndCode(
      type: "GM_TAMBOLA2020",
      freq: "weekly",
    );
    if (temp.isSuccess()) {
      _logger.d(temp.code);
      if (temp.model != null && temp.model.isNotEmpty)
        _tLeaderBoard = temp.model;
      isLeaderboardLoading = false;
      notifyListeners();
    }
  }

  Future<void> getPrizes() async {
    isPrizesLoading = true;
    notifyListeners();
    await _prizeService.fetchTambolaPrizes();
    if (tPrizes == null)
      BaseUtil.showNegativeAlert("This week's prizes could not be fetched",
          "Please try again in sometime");
    isPrizesLoading = false;
    notifyListeners();
  }

  void openGame() {
    _analyticsService.track(eventName: AnalyticsEvents.startPlayingTambola);
    // _baseUtil.cacheGameorder('TA');
    BaseUtil().openTambolaGame();
  }

  getGameDetails() async {
    final response =
        await _gamesRepo.getGameByCode(gameCode: Constants.GAME_TYPE_TAMBOLA);
    if (response.isSuccess()) {
      game = response.model;
    } else {
      BaseUtil.showNegativeAlert("", response.errorMessage);
    }
  }

  Future<void> refreshTambolaTickets() async {
    _logger.i('Refreshing..');
    _topFiveTambolaBoards = [];
    ticketsBeingGenerated = true;
    tambolaService.weeklyTicksFetched = false;
    init();
    notifyListeners();
  }

  int get activeTambolaCardCount {
    if (tambolaService == null || tambolaService.userWeeklyBoards == null)
      return 0;
    return tambolaService.userWeeklyBoards.length;
  }

  void updateTicketCount() {
    buyTicketCount = int.tryParse(ticketCountController.text) ?? 3;
    notifyListeners();
  }

  void increaseTicketCount() {
    if (buyTicketCount < 30)
      buyTicketCount += 1;
    else
      BaseUtil.showNegativeAlert("Maximum tickets exceeded",
          "You can purchase upto 30 tambola tickets at once");
    ticketCountController.text = buyTicketCount.toString();
    updateTicketSavedAmount(buyTicketCount);

    notifyListeners();
  }

  void decreaseTicketCount() {
    if (buyTicketCount > 0)
      buyTicketCount -= 1;
    else
      BaseUtil.showNegativeAlert("Failed", "Negative counts not supported");
    ticketCountController.text = buyTicketCount.toString();
    updateTicketSavedAmount(buyTicketCount);
    notifyListeners();
  }

  // Future<void> buyTickets(BuildContext context) async {
  //   if (ticketBuyInProgress) return;
  //   if (ticketCountController.text.isEmpty)
  //     return BaseUtil.showNegativeAlert(
  //         "No ticket count entered", "Please enter a valid number of tickets");

  //   int ticketCount = int.tryParse(ticketCountController.text);
  //   if (ticketCount == 0) {
  //     return BaseUtil.showNegativeAlert(
  //         "No ticket count entered", "Please enter a valid number of tickets");
  //   }
  //   if (ticketCount > 30) {
  //     return BaseUtil.showNegativeAlert("Maximum tickets exceeded",
  //         "You can purchase upto 30 tambola tickets at once");
  //   }
  //   if (ticketPurchaseCost * ticketCount > _coinService.flcBalance) {
  //     return earnMoreTokens();
  //   }

  //   ticketBuyInProgress = true;
  //   tambolaService.ticketGenerateCount = ticketCount;
  //   notifyListeners();

  //   _analyticsService.track(eventName: AnalyticsEvents.gamePlayStarted);
  //   _analyticsService.track(
  //     eventName: AnalyticsEvents.buyTambolaTickets,
  //     properties: {'count': ticketCount},
  //   );

  //   ApiResponse<FlcModel> _flcResponse =
  //       await _tambolaRepo.buyTambolaTickets(ticketCount);
  //   if (_flcResponse.model != null && _flcResponse.code == 200) {
  //     BaseUtil.showPositiveAlert(
  //       "Tickets successfully generated 🥳",
  //       "Your weekly odds are now way better!",
  //     );

  //     if (_flcResponse.model.flcBalance > 0) {
  //       _coinService.setFlcBalance(_flcResponse.model.flcBalance);
  //     }

  //     //Need to refresh the userTicketWallet object after API completes
  //     _refreshTambolaTickets();
  //   } else {
  //     return BaseUtil.showNegativeAlert(
  //       "Operation Failed",
  //       "Failed to buy tickets at the moment. Please try again later",
  //     );
  //   }

  //   ticketBuyInProgress = false;
  //   tambolaService.ticketGenerateCount = 0;
  //   notifyListeners();
  // }

  void earnMoreTokens() {
    _analyticsService.track(eventName: AnalyticsEvents.earnMoreTokens);
    BaseUtil.openModalBottomSheet(
      addToScreenStack: true,
      backgroundColor: UiConstants.gameCardColor,
      content: WantMoreTicketsModalSheet(isInsufficientBalance: true),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(SizeConfig.roundness24),
        topRight: Radius.circular(SizeConfig.roundness24),
      ),
      hapticVibrate: true,
      isScrollControlled: true,
      isBarrierDismissable: true,
    );
  }

  Ticket buildBoardView(TambolaBoard board) {
    if (board == null || !board.isValid()) return null;
    List<int> _calledDigits;
    if (!tambolaService.weeklyDrawFetched ||
        weeklyDigits == null ||
        weeklyDigits.toList().isEmpty)
      _calledDigits = [];
    else {
      _calledDigits = weeklyDigits.getPicksPostDate(DateTime.monday);
    }

    return Ticket(
      board: board,
      calledDigits: _calledDigits,
    );
  }

  List<TambolaBoard> refreshBestBoards() {
    if (userWeeklyBoards == null || userWeeklyBoards.isEmpty) {
      return new List<TambolaBoard>.filled(5, null);
    }
    _bestTambolaBoards = [];
    for (int i = 0; i < 4; i++) {
      _bestTambolaBoards.add(userWeeklyBoards[0]);
    }

    if (weeklyDigits == null || weeklyDigits.toList().isEmpty) {
      return _bestTambolaBoards;
    }

    userWeeklyBoards.forEach((board) {
      if (_bestTambolaBoards[0] == null) _bestTambolaBoards[0] = board;
      if (_bestTambolaBoards[1] == null) _bestTambolaBoards[1] = board;
      if (_bestTambolaBoards[2] == null) _bestTambolaBoards[2] = board;
      if (_bestTambolaBoards[3] == null) _bestTambolaBoards[3] = board;

      if (_bestTambolaBoards[0].getCornerOdds(weeklyDigits.toList()) >
          board.getCornerOdds(weeklyDigits.toList())) {
        _bestTambolaBoards[0] = board;
      }
      if (_bestTambolaBoards[1].getOneRowOdds(weeklyDigits.toList()) >
          board.getOneRowOdds(weeklyDigits.toList())) {
        _bestTambolaBoards[1] = board;
      }
      if (_bestTambolaBoards[2].getTwoRowOdds(weeklyDigits.toList()) >
          board.getTwoRowOdds(weeklyDigits.toList())) {
        _bestTambolaBoards[2] = board;
      }
      if (_bestTambolaBoards[3].getFullHouseOdds(weeklyDigits.toList()) >
          board.getFullHouseOdds(weeklyDigits.toList())) {
        _bestTambolaBoards[3] = board;
      }
    });

    return _bestTambolaBoards;
  }

  Future<void> _examineTicketsForWins() async {
    if (userWeeklyBoards == null ||
        userWeeklyBoards.isEmpty ||
        weeklyDigits == null ||
        weeklyDigits.toList().length != 7 * dailyPicksCount ||
        weeklyDigits.toList().contains(-1)) {
      _logger.i('Testing is not ready yet');
      return;
    }

    userWeeklyBoards.forEach((boardObj) {
      if (boardObj
              .getCornerOdds(weeklyDigits.getPicksPostDate(DateTime.monday)) ==
          0) {
        if (boardObj.getTicketNumber() != 'NA')
          ticketCodeWinIndex[boardObj.getTicketNumber()] =
              Constants.CORNERS_COMPLETED;
      }
      if (boardObj
              .getOneRowOdds(weeklyDigits.getPicksPostDate(DateTime.monday)) ==
          0) {
        if (boardObj.getTicketNumber() != 'NA')
          ticketCodeWinIndex[boardObj.getTicketNumber()] =
              Constants.ONE_ROW_COMPLETED;
      }
      if (boardObj
              .getTwoRowOdds(weeklyDigits.getPicksPostDate(DateTime.monday)) ==
          0) {
        if (boardObj.getTicketNumber() != 'NA')
          ticketCodeWinIndex[boardObj.getTicketNumber()] =
              Constants.TWO_ROWS_COMPLETED;
      }
      if (boardObj.getFullHouseOdds(
              weeklyDigits.getPicksPostDate(DateTime.monday)) ==
          0) {
        if (boardObj.getTicketNumber() != 'NA')
          ticketCodeWinIndex[boardObj.getTicketNumber()] =
              Constants.FULL_HOUSE_COMPLETED;
      }
    });

    // double totalInvestedPrinciple =
    //     _userService.userFundWallet.augGoldPrinciple;
    // isEligible = (totalInvestedPrinciple >=
    //     BaseUtil.toInt(BaseRemoteConfig.remoteConfig
    //         .getString(BaseRemoteConfig.UNLOCK_REFERRAL_AMT)));

    isEligible = true;
    _logger.i('Resultant wins: ${ticketCodeWinIndex.toString()}');

    showWinCard = true;
    // if (!tambolaService.winnerDialogCalled)
    //   AppState.delegate.appState.currentAction = PageAction(
    //     state: PageState.addWidget,
    //     page: TWeeklyResultPageConfig,
    //     widget: WeeklyResult(
    //       winningsmap: ticketCodeWinIndex,
    //       isEligible: _isEligible,
    //     ),
    //   );
    // tambolaService.winnerDialogCalled = true;

    if (ticketCodeWinIndex.length > 0) {
      BaseUtil.showPositiveAlert(
        'Congratulations 🎉',
        'Your tickets have been submitted for processing your prizes!',
      );
    }

    PreferenceHelper.setBool(PreferenceHelper.SHOW_TAMBOLA_PROCESSING, false);
  }

  bool handleScrollNotification(ScrollNotification notification) {
    if (notification.depth == 0) {
      if (notification is UserScrollNotification) {
        final UserScrollNotification userScroll = notification;
        switch (userScroll.direction) {
          case ScrollDirection.forward:
            //showBuyModal = true;
            animationController.forward();
            break;
          case ScrollDirection.reverse:
            //showBuyModal = false;
            animationController.reverse();
            break;
          case ScrollDirection.idle:
            break;
        }
      }
    }
    return false;
  }
}
