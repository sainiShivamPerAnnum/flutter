import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/daily_pick_model.dart';
import 'package:felloapp/core/model/flc_pregame_model.dart';
import 'package:felloapp/core/model/tambola_board_model.dart';
import 'package:felloapp/core/model/tambola_ticket_generation_model.dart';
import 'package:felloapp/core/model/user_ticket_wallet_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/lcl_db_ops.dart';
import 'package:felloapp/core/repository/flc_actions_repo.dart';
import 'package:felloapp/core/repository/ticket_generation_repo.dart';
import 'package:felloapp/core/service/golden_ticket_service.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/tambola_generation_service.dart';
import 'package:felloapp/core/service/tambola_service.dart';
import 'package:felloapp/core/service/user_coin_service.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/elements/tambola-global/tambola_ticket.dart';
import 'package:felloapp/ui/pages/others/games/tambola/show_all_tickets.dart';
import 'package:felloapp/ui/pages/others/games/tambola/weekly_results/weekly_result.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/core/service/analytics/analytics_events.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:felloapp/util/custom_logger.dart';

class TambolaGameViewModel extends BaseModel {
  TambolaService tambolaService = locator<TambolaService>();
  DBModel _dbModel = locator<DBModel>();

  // tambolaService. _tambolaService. = locator<tambolaService.>();
  UserService _userService = locator<UserService>();
  UserCoinService _coinService = locator<UserCoinService>();
  CustomLogger _logger = locator<CustomLogger>();
  LocalDBModel _localDBModel = locator<LocalDBModel>();
  final _fclActionRepo = locator<FlcActionsRepo>();
  final _ticketGenerationRepo = locator<TicketGenerationRepo>();
  GoldenTicketService _goldenTicketService = GoldenTicketService();
  final _analyticsService = locator<AnalyticsService>();

  int get dailyPicksCount => tambolaService.dailyPicksCount;

  List<int> get todaysPicks => tambolaService.todaysPicks;

  DailyPick get weeklyDigits => tambolaService.weeklyDigits;

  List<TambolaBoard> get userWeeklyBoards => tambolaService.userWeeklyBoards;

  UserTicketWallet get userTicketWallet => tambolaService.userTicketWallet;
  List<Ticket> _tambolaBoardViews;

  TambolaGenerationService _tambolaTicketService;
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

  Widget get cardWidet => _widget;

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

  init() async {
    ticketCountController =
        new TextEditingController(text: buyTicketCount.toString());

    _tambolaTicketService = new TambolaGenerationService();
    // Ticket wallet check
    if (userTicketWallet == null)
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
      List<TambolaBoard> _boards =
          await _dbModel.getWeeksTambolaTickets(_userService.baseUser.uid);
      tambolaService.weeklyTicksFetched = true;
      if (_boards != null) {
        tambolaService.userWeeklyBoards = _boards;
        _logger.d(_boards.length);
        _currentBoard = null;
        _currentBoardView = null;
      }
      notifyListeners();
    }

    //check if new tambola tickets need to be generated
    await checkIfMoreTicketNeedsToBeGenerated();

    ///check whether to show summary cards or not
    DateTime today = DateTime.now();
    if (today.weekday == 7 && today.hour > 18) {
      showSummaryCards = false;
      notifyListeners();
    }

    ///check if tickets need to be deleted
    bool _isDeleted = await _tambolaTicketService
        .processTicketDeletionRequirement(activeTambolaCardCount);
    if (_isDeleted) {
      notifyListeners();
    }

    checkSundayResultsProcessing();
  }

  _refreshTambolaTickets() async {
    _logger.i('Refreshing..');
    _topFiveTambolaBoards = [];
    ticketsBeingGenerated = true;
    tambolaService.weeklyTicksFetched = false;
    init();
    //notifyListeners();
  }

  int get activeTambolaCardCount {
    if (tambolaService == null || tambolaService.userWeeklyBoards == null)
      return 0;
    return tambolaService.userWeeklyBoards.length;
  }

  increaseTicketCount() {
    if (buyTicketCount < 30)
      buyTicketCount += 1;
    else
      BaseUtil.showNegativeAlert("Maximum tickets exceeded",
          "You can purchase upto 30 tambola tickets at once");
    ticketCountController.text = buyTicketCount.toString();
    notifyListeners();
  }

  decreaseTicketCount() {
    if (buyTicketCount > 0)
      buyTicketCount -= 1;
    else
      BaseUtil.showNegativeAlert("Failed", "Negative counts not supported");
    ticketCountController.text = buyTicketCount.toString();
    notifyListeners();
  }

  void buyTickets() async {
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
      return BaseUtil.showNegativeAlert("Insufficient tokens",
          "You do not have enough tokens to buy Tambola tickets");
    }

    ticketBuyInProgress = true;
    notifyListeners();
    _analyticsService.track(
      eventName: AnalyticsEvents.buyTambolaTickets,
      properties: {'count': ticketCount},
    );
    ApiResponse<FlcModel> _flcResponse = await _fclActionRepo.buyTambolaTickets(
        cost: (-1 * ticketPurchaseCost),
        noOfTickets: ticketCount,
        userUid: _userService.baseUser.uid);
    if (_flcResponse.model != null && _flcResponse.code == 200) {
      ticketBuyInProgress = false;
      notifyListeners();
      BaseUtil.showPositiveAlert(
          "Request is now processing", "Generating your tickets, please wait");

      if (_flcResponse.model.flcBalance > 0) {
        _coinService.setFlcBalance(_flcResponse.model.flcBalance);
      }

      //Need to refresh the userTicketWallet object after API completes
      tambolaService.userTicketWallet =
          await _dbModel.getUserTicketWallet(_userService.baseUser.uid);
      if (tambolaService.userTicketWallet != null) _refreshTambolaTickets();
    } else {
      ticketBuyInProgress = false;
      notifyListeners();
      return BaseUtil.showNegativeAlert("Operation Failed",
          "Failed to buy tickets at the moment. Please try again later");
    }
  }

  checkIfMoreTicketNeedsToBeGenerated() async {
    tambolaService.ticketGenerateCount = 0;

    if (activeTambolaCardCount != null &&
        tambolaService.userTicketWallet.getActiveTickets() > 0) {
      if (activeTambolaCardCount <
          tambolaService.userTicketWallet.getActiveTickets()) {
        _logger
            .d('Currently generated ticket count is less than needed tickets');
        tambolaService.ticketGenerateCount =
            tambolaService.userTicketWallet.getActiveTickets() -
                activeTambolaCardCount;
      }
    }

    if (tambolaService.ticketGenerateCount > 0) {
      //Call Generation API
      ApiResponse<TambolaTicketGenerationModel> _response =
          await _ticketGenerationRepo.generateTickets(
              userId: _userService.baseUser.uid,
              numberOfTickets: tambolaService.ticketGenerateCount);
      if (_response.code == 200) {
        if (_response.model.flag) {
          _refreshTambolaTickets();
          BaseUtil.showPositiveAlert('Tickets successfully generated 🥳',
              'Your weekly odds are now way better!');
        } else {
          BaseUtil.showNegativeAlert(
            'Tickets generation failed',
            'Please try again after sometime',
          );
        }
      } else {
        _logger.d("Api failed");
        BaseUtil.showNegativeAlert(
          'Tickets generation failed',
          'Please try again after sometime',
        );
      }
    } else {
      _logger.d("No tickets to generate");
    }
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

  showAllBoards() {
    if (BaseUtil.showNoInternetAlert()) return;
    _tambolaBoardViews = [];
    tambolaService.userWeeklyBoards.forEach((board) {
      _tambolaBoardViews.add(buildBoardView(board));
    });
    if (_tambolaBoardViews.isNotEmpty)
      AppState.delegate.appState.currentAction = PageAction(
        state: PageState.addWidget,
        page: TShowAllTicketsPageConfig,
        widget: ShowAllTickets(
          tambolaBoardView: _tambolaBoardViews,
        ),
      );
    else
      BaseUtil.showNegativeAlert(
          "No Tickets to show", "Currently there are no tickets available");
  }

  checkSundayResultsProcessing() {
    if (userWeeklyBoards == null ||
        userWeeklyBoards.isEmpty ||
        weeklyDigits == null ||
        weeklyDigits.toList().isEmpty ||
        _localDBModel == null) {
      _logger.d('Testing is not ready yet');
      return false;
    }
    DateTime date = DateTime.now();
    if (date.weekday == DateTime.sunday) {
      if (weeklyDigits.toList().length == 7 * dailyPicksCount) {
        _localDBModel.isTambolaResultProcessingDone().then((flag) {
          if (flag == 0) {
            _logger.i('Ticket results not yet displayed. Displaying: ');
            _examineTicketsForWins();

            ///save the status that results have been saved
            _localDBModel.saveTambolaResultProcessingStatus(true);
          }

          ///also delete all the old tickets while we're at it
          //no need to await
          _dbModel.deleteExpiredUserTickets(_userService.baseUser.uid);
        });
      }
    } else {
      _localDBModel.isTambolaResultProcessingDone().then((flag) {
        if (flag == 1) _localDBModel.saveTambolaResultProcessingStatus(false);
      });
    }
  }

  ///check if any of the tickets aced any of the categories.
  ///also check if the user is eligible for a prize
  ///if any did, add it to a list and submit the list as a win claim
  _examineTicketsForWins() {
    if (userWeeklyBoards == null ||
        userWeeklyBoards.isEmpty ||
        weeklyDigits == null ||
        weeklyDigits.toList().isEmpty) {
      _logger.i('Testing is not ready yet');
      return false;
    }
    Map<String, int> ticketCodeWinIndex = {};
    userWeeklyBoards.forEach((boardObj) {
      if (boardObj.getCornerOdds(
              weeklyDigits.getPicksPostDate(boardObj.generatedDayCode)) ==
          0) {
        if (boardObj.getTicketNumber() != 'NA')
          ticketCodeWinIndex[boardObj.getTicketNumber()] =
              Constants.CORNERS_COMPLETED;
      }
      if (boardObj.getRowOdds(
              0, weeklyDigits.getPicksPostDate(boardObj.generatedDayCode)) ==
          0) {
        if (boardObj.getTicketNumber() != 'NA')
          ticketCodeWinIndex[boardObj.getTicketNumber()] =
              Constants.ROW_ONE_COMPLETED;
      }
      if (boardObj.getRowOdds(
              1, weeklyDigits.getPicksPostDate(boardObj.generatedDayCode)) ==
          0) {
        if (boardObj.getTicketNumber() != 'NA')
          ticketCodeWinIndex[boardObj.getTicketNumber()] =
              Constants.ROW_TWO_COMPLETED;
      }
      if (boardObj.getRowOdds(
              2, weeklyDigits.getPicksPostDate(boardObj.generatedDayCode)) ==
          0) {
        if (boardObj.getTicketNumber() != 'NA')
          ticketCodeWinIndex[boardObj.getTicketNumber()] =
              Constants.ROW_THREE_COMPLETED;
      }
      if (boardObj.getFullHouseOdds(
              weeklyDigits.getPicksPostDate(boardObj.generatedDayCode)) ==
          0) {
        if (boardObj.getTicketNumber() != 'NA')
          ticketCodeWinIndex[boardObj.getTicketNumber()] =
              Constants.FULL_HOUSE_COMPLETED;
      }
    });

    double totalInvestedPrinciple =
        _userService.userFundWallet.augGoldPrinciple +
            _userService.userFundWallet.iciciPrinciple;
    bool _isEligible = (totalInvestedPrinciple >=
        BaseUtil.toInt(BaseRemoteConfig.remoteConfig
            .getString(BaseRemoteConfig.UNLOCK_REFERRAL_AMT)));

    _logger.i('Resultant wins: ${ticketCodeWinIndex.toString()}');

    if (!tambolaService.winnerDialogCalled)
      AppState.delegate.appState.currentAction = PageAction(
        state: PageState.addWidget,
        page: TWeeklyResultPageConfig,
        widget: WeeklyResult(
          winningsmap: ticketCodeWinIndex,
          isEligible: _isEligible,
        ),
      );
    tambolaService.winnerDialogCalled = true;

    if (ticketCodeWinIndex.length > 0) {
      _dbModel
          .addWinClaim(
              _userService.baseUser.uid,
              _userService.baseUser.username,
              _userService.baseUser.name,
              _userService.baseUser.mobile,
              tambolaService.userTicketWallet.getActiveTickets(),
              _isEligible,
              ticketCodeWinIndex)
          .then((flag) {
        BaseUtil.showPositiveAlert('Congratulations 🎉',
            'Your tickets have been submitted for processing your prizes!');
      });
    }
  }

  List<TambolaBoard> refreshBestBoards() {
    if (userWeeklyBoards == null || userWeeklyBoards.isEmpty) {
      return new List<TambolaBoard>(5);
    }
    _bestTambolaBoards = [];
    for (int i = 0; i < 5; i++) {
      _bestTambolaBoards.add(userWeeklyBoards[0]);
    }
    //initialise
    _bestTambolaBoards[0] = userWeeklyBoards[0];
    _bestTambolaBoards[1] = userWeeklyBoards[0];
    _bestTambolaBoards[2] = userWeeklyBoards[0];
    _bestTambolaBoards[3] = userWeeklyBoards[0];
    _bestTambolaBoards[4] = userWeeklyBoards[0];

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
