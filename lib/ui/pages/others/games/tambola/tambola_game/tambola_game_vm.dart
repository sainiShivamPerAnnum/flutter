import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/model/daily_pick_model.dart';
import 'package:felloapp/core/model/flc_pregame_model.dart';
import 'package:felloapp/core/model/tambola_board_model.dart';
import 'package:felloapp/core/model/user_ticket_wallet_model.dart';
import 'package:felloapp/core/repository/ticket_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/tambola_service.dart';
import 'package:felloapp/core/service/notifier_services/user_coin_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/elements/tambola-global/tambola_ticket.dart';
import 'package:felloapp/ui/modals_sheets/want_more_tickets_modal_sheet.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:felloapp/util/custom_logger.dart';

class TambolaGameViewModel extends BaseModel {
  final _logger = locator<CustomLogger>();
  final tambolaService = locator<TambolaService>();
  final _coinService = locator<UserCoinService>();
  final _analyticsService = locator<AnalyticsService>();
  final _tambolaRepo = locator<TambolaRepo>();

  int get dailyPicksCount => tambolaService.dailyPicksCount;

  List<int> get todaysPicks => tambolaService.todaysPicks;

  DailyPick get weeklyDigits => tambolaService.weeklyDigits;

  List<TambolaBoard> get userWeeklyBoards => tambolaService.userWeeklyBoards;

  UserTicketWallet get userTicketWallet => tambolaService.userTicketWallet;
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

  bool _showBuyModal = true;
  int buyTicketCount = 3;
  bool _ticketsBeingGenerated = false;

  List<Ticket> get tambolaBoardViews => this._tambolaBoardViews;

  set tambolaBoardViews(List<Ticket> value) => this._tambolaBoardViews = value;

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

  get showBuyModal => _showBuyModal;

  set showBuyModal(value) {
    _showBuyModal = value;
    notifyListeners();
  }

  int get currentPage => this._currentPage;

  set currentPage(int value) {
    this._currentPage = value;
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

  int get totalActiveTickets =>
      tambolaService.userTicketWallet.getActiveTickets();

  Future<void> init() async {
    ticketCountController =
        new TextEditingController(text: buyTicketCount.toString());

    // Ticket wallet check
    await tambolaService.getUserTicketWalletData();

    ///Weekly Picks check
    if (weeklyDigits == null) {
      await tambolaService.fetchWeeklyPicks();
      weeklyDrawFetched = true;
    } else
      weeklyDrawFetched = true;

    ///next get the tambola tickets of this week
    if (!tambolaService.weeklyTicksFetched) {
      _logger.d("Fetching Tambola tickets");
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

      notifyListeners();
    }

    ///check whether to show summary cards or not
    DateTime today = DateTime.now();
    if (today.weekday == 7 && today.hour > 18) {
      showSummaryCards = false;
      notifyListeners();
    }
  }

  _refreshTambolaTickets() async {
    _logger.i('Refreshing..');
    _topFiveTambolaBoards = [];
    ticketsBeingGenerated = true;
    tambolaService.weeklyTicksFetched = false;
    init();
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
    notifyListeners();
  }

  void decreaseTicketCount() {
    if (buyTicketCount > 0)
      buyTicketCount -= 1;
    else
      BaseUtil.showNegativeAlert("Failed", "Negative counts not supported");
    ticketCountController.text = buyTicketCount.toString();
    notifyListeners();
  }

  Future<void> buyTickets(BuildContext context) async {
    if (ticketBuyInProgress) return;
    if (ticketCountController.text.isEmpty)
      return BaseUtil.showNegativeAlert(
          "No ticket count entered", "Please enter a valid number of tickets");

    int ticketCount = int.tryParse(ticketCountController.text);
    if (ticketCount == 0) {
      return BaseUtil.showNegativeAlert(
          "No ticket count entered", "Please enter a valid number of tickets");
    }
    if (ticketCount > 30) {
      return BaseUtil.showNegativeAlert("Maximum tickets exceeded",
          "You can purchase upto 30 tambola tickets at once");
    }
    if (ticketPurchaseCost * ticketCount > _coinService.flcBalance) {
      return earnMoreTokens();
    }

    ticketBuyInProgress = true;
    tambolaService.ticketGenerateCount = ticketCount;
    notifyListeners();

    _analyticsService.track(eventName: AnalyticsEvents.gamePlayStarted);
    _analyticsService.track(
      eventName: AnalyticsEvents.buyTambolaTickets,
      properties: {'count': ticketCount},
    );

    ApiResponse<FlcModel> _flcResponse =
        await _tambolaRepo.buyTambolaTickets(ticketCount);
    if (_flcResponse.model != null && _flcResponse.code == 200) {
      BaseUtil.showPositiveAlert(
        "Tickets successfully generated 🥳",
        "Your weekly odds are now way better!",
      );

      if (_flcResponse.model.flcBalance > 0) {
        _coinService.setFlcBalance(_flcResponse.model.flcBalance);
      }

      //Need to refresh the userTicketWallet object after API completes
      _refreshTambolaTickets();
    } else {
      return BaseUtil.showNegativeAlert(
        "Operation Failed",
        "Failed to buy tickets at the moment. Please try again later",
      );
    }

    ticketBuyInProgress = false;
    tambolaService.ticketGenerateCount = 0;
    notifyListeners();
  }

  void earnMoreTokens() {
    _analyticsService.track(eventName: AnalyticsEvents.earnMoreTokens);
    BaseUtil.openModalBottomSheet(
      addToScreenStack: true,
      content: WantMoreTicketsModalSheet(
        isInsufficientBalance: true,
      ),
      hapticVibrate: true,
      backgroundColor: Colors.transparent,
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
      _calledDigits = weeklyDigits.getPicksPostDate(board.generatedDayCode);
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
    for (int i = 0; i < 5; i++) {
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
      if (_bestTambolaBoards[4] == null) _bestTambolaBoards[4] = board;

      if (_bestTambolaBoards[0].getRowOdds(0, weeklyDigits.toList()) >
          board.getRowOdds(0, weeklyDigits.toList())) {
        _bestTambolaBoards[0] = board;
      }
      if (_bestTambolaBoards[1].getRowOdds(1, weeklyDigits.toList()) >
          board.getRowOdds(1, weeklyDigits.toList())) {
        _bestTambolaBoards[1] = board;
      }
      if (_bestTambolaBoards[2].getRowOdds(2, weeklyDigits.toList()) >
          board.getRowOdds(2, weeklyDigits.toList())) {
        _bestTambolaBoards[2] = board;
      }
      if (_bestTambolaBoards[3].getCornerOdds(weeklyDigits.toList()) >
          board.getCornerOdds(weeklyDigits.toList())) {
        _bestTambolaBoards[3] = board;
      }
      if (_bestTambolaBoards[4].getFullHouseOdds(weeklyDigits.toList()) >
          board.getFullHouseOdds(weeklyDigits.toList())) {
        _bestTambolaBoards[4] = board;
      }
    });

    return _bestTambolaBoards;
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
