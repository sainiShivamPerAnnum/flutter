import 'dart:math';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/daily_pick_model.dart';
import 'package:felloapp/core/model/flc_pregame_model.dart';
import 'package:felloapp/core/model/tambola_board_model.dart';
import 'package:felloapp/core/model/user_ticket_wallet_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/lcl_db_ops.dart';
import 'package:felloapp/core/repository/flc_actions_repo.dart';
import 'package:felloapp/core/service/mixpanel_service.dart';
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
import 'package:felloapp/util/styles/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:logger/logger.dart';

class TambolaGameViewModel extends BaseModel {
  TambolaService tambolaService = locator<TambolaService>();
  DBModel _dbModel = locator<DBModel>();

  // tambolaService. _tambolaService. = locator<tambolaService.>();
  UserService _userService = locator<UserService>();
  UserCoinService _coinService = locator<UserCoinService>();
  Logger _logger = locator<Logger>();
  LocalDBModel _localDBModel = locator<LocalDBModel>();
  final _fclActionRepo = locator<FlcActionsRepo>();
  final _mixpanelService = locator<MixpanelService>();


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

  // set currentBoardView(val) {
  //   _currentBoardView = val;
  //   notifyListeners();
  // }

  // set currentBoard(val) {
  //   _currentBoard = val;
  //   notifyListeners();
  // }

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

    // BaseAnalytics.analytics

    //     .setCurrentScreen(screenName: BaseAnalytics.PAGE_TAMBOLA);
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
      BaseUtil.showNegativeAlert(
          "Failed", "We currently don't support negative counts");
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
    ApiResponse<FlcModel> _flcResponse = await _fclActionRepo.buyTambolaTickets(
        cost: (-1 * ticketPurchaseCost),
        noOfTickets: ticketCount,
        userUid: _userService.baseUser.uid);
    if (_flcResponse.model != null && _flcResponse.code == 200) {
      ticketBuyInProgress = false;
      notifyListeners();
       _mixpanelService.mixpanel.track("Plays Tambola");
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

    // tambolaService.userTicketWallet = await _dbModel.updateInitUserTicketCount(
    //     _userService.baseUser.uid,
    //     tambolaService.userTicketWallet,
    //     ticketCount);
  }

  checkIfMoreTicketNeedsToBeGenerated() async {
    bool _isGenerating = await _tambolaTicketService
        .processTicketGenerationRequirement(activeTambolaCardCount);
    if (_isGenerating) {
      ticketsBeingGenerated = true;
      _tambolaTicketService.setTambolaTicketGenerationResultListener((flag) {
        ticketsBeingGenerated = false;
        if (flag == TambolaGenerationService.GENERATION_COMPLETE) {
          //new tickets have arrived
          _refreshTambolaTickets();
          BaseUtil.showPositiveAlert('Tickets successfully generated 🥳',
              'Your weekly odds are now way better!');
        } else if (flag ==
            TambolaGenerationService.GENERATION_PARTIALLY_COMPLETE) {
          _refreshTambolaTickets();
          BaseUtil.showPositiveAlert('Tickets partially generated',
              'The remaining tickets shall soon be credited');
        } else {
          BaseUtil.showNegativeAlert(
            'Tickets generation failed',
            'The issue has been noted and your tickets will soon be credited',
          );
        }
      });
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
    TambolaTicketColorPalette ticketColor =
        FelloColorPalette.tambolaTicketColorPalettes()[Random().nextInt(
                FelloColorPalette.tambolaTicketColorPalettes().length - 1) +
            1];
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
    bool _isEligible =
        (totalInvestedPrinciple >= BaseRemoteConfig.UNLOCK_REFERRAL_AMT);

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

  // List<TicketSummaryCardModel> getTambolaTicketsSummary() {
  //   List<TicketSummaryCardModel> summary = [];

  //   List<Ticket> bestCornerBoard = [];
  //   List<Ticket> bestTopRowBoard = [];
  //   List<Ticket> bestMiddleRowBoard = [];
  //   List<Ticket> bestBottomRowBoard = [];
  //   List<Ticket> bestFullHouseBoard = [];
  //   List<Ticket> completedCornersBoard = [];
  //   List<Ticket> completedTopRowBoard = [];
  //   List<Ticket> completedBottomRowBoard = [];
  //   List<Ticket> completedMiddleRowBoard = [];
  //   List<Ticket> completedFullHouseBoard = [];
  //   List<BestTambolaTicketsSumm> completedBoardCardItems = [];
  //   List<BestTambolaTicketsSumm> bestRowsBoardCardItems = [];
  //   List<BestTambolaTicketsSumm> bestCornersBoardCardItems = [];
  //   List<BestTambolaTicketsSumm> fullHouseBoardCardItems = [];

  //   if (userWeeklyBoards == null ||
  //       userWeeklyBoards.isEmpty) {
  //     return summary;
  //   }

  //   if (weeklyDigits == null ||
  //       weeklyDigits.toList().isEmpty) {
  //     return summary;
  //   }

  //   userWeeklyBoards.forEach((board) {
  //     // CORNERS CHECK
  //     // Checking for any completed corner borads
  //     if (board.getCornerOdds(weeklyDigits
  //             .getPicksPostDate(board.generatedDayCode)) ==
  //         0) completedCornersBoard.add(_buildBoardView(board));
  //     // Checking for best Chances
  //     if (board.getCornerOdds(weeklyDigits
  //                 .getPicksPostDate(board.generatedDayCode)) <
  //             2 &&
  //         board.getCornerOdds(weeklyDigits
  //                 .getPicksPostDate(board.generatedDayCode)) >
  //             0) bestCornerBoard.add(_buildBoardView(board));

  //     // ROWS CHECK
  //     // TOP ROW
  //     if (board.getRowOdds(
  //                 0,
  //                 weeklyDigits
  //                     .getPicksPostDate(board.generatedDayCode)) <
  //             3 &&
  //         board.getRowOdds(
  //                 0,
  //                 weeklyDigits
  //                     .getPicksPostDate(board.generatedDayCode)) >
  //             0) bestTopRowBoard.add(_buildBoardView(board));

  //     if (board.getRowOdds(
  //             0,
  //             weeklyDigits
  //                 .getPicksPostDate(board.generatedDayCode)) ==
  //         0) completedTopRowBoard.add(_buildBoardView(board));

  //     // MIDDLE ROW
  //     if (board.getRowOdds(
  //                 1,
  //                 weeklyDigits
  //                     .getPicksPostDate(board.generatedDayCode)) <
  //             3 &&
  //         board.getRowOdds(
  //                 1,
  //                 weeklyDigits
  //                     .getPicksPostDate(board.generatedDayCode)) >
  //             0) bestMiddleRowBoard.add(_buildBoardView(board));

  //     if (board.getRowOdds(
  //             1,
  //             weeklyDigits
  //                 .getPicksPostDate(board.generatedDayCode)) ==
  //         0) completedMiddleRowBoard.add(_buildBoardView(board));

  //     // BOTTOM ROW
  //     if (board.getRowOdds(
  //                 2,
  //                 weeklyDigits
  //                     .getPicksPostDate(board.generatedDayCode)) <
  //             3 &&
  //         board.getRowOdds(
  //                 2,
  //                 weeklyDigits
  //                     .getPicksPostDate(board.generatedDayCode)) >
  //             0) bestBottomRowBoard.add(_buildBoardView(board));

  //     if (board.getRowOdds(
  //             2,
  //             weeklyDigits
  //                 .getPicksPostDate(board.generatedDayCode)) ==
  //         0) completedBottomRowBoard.add(_buildBoardView(board));

  //     // FULL HOUSE CHECK

  //     // Checking for completed Full House Boards
  //     if (board.getFullHouseOdds(weeklyDigits
  //             .getPicksPostDate(board.generatedDayCode)) ==
  //         0) completedFullHouseBoard.add(_buildBoardView(board));
  //     // Checking for best Chances of a Full House Board
  //     if (board.getFullHouseOdds(weeklyDigits
  //                 .getPicksPostDate(board.generatedDayCode)) <
  //             5 &&
  //         board.getFullHouseOdds(weeklyDigits
  //                 .getPicksPostDate(board.generatedDayCode)) >
  //             0) bestFullHouseBoard.add(_buildBoardView(board));
  //   });

  //   // ADDING COMPLETED CATEGORIES TO FORM A LIST OF TILE DATA FOR THE CARD
  //   if (completedFullHouseBoard.isNotEmpty)
  //     completedBoardCardItems.add(BestTambolaTicketsSumm(
  //         boards: completedFullHouseBoard,
  //         title: getBoardTileTitle("Full House", completedFullHouseBoard.length,
  //             false, completedFullHouseBoard[0])));
  //   if (completedTopRowBoard.isNotEmpty)
  //     completedBoardCardItems.add(BestTambolaTicketsSumm(
  //         boards: completedTopRowBoard,
  //         title: getBoardTileTitle("Top Row", completedTopRowBoard.length,
  //             false, completedTopRowBoard[0])));
  //   if (completedMiddleRowBoard.isNotEmpty)
  //     completedBoardCardItems.add(BestTambolaTicketsSumm(
  //         boards: completedMiddleRowBoard,
  //         title: getBoardTileTitle("Middle Row", completedMiddleRowBoard.length,
  //             false, completedMiddleRowBoard[0])));
  //   if (completedBottomRowBoard.isNotEmpty)
  //     completedBoardCardItems.add(BestTambolaTicketsSumm(
  //         boards: completedBottomRowBoard,
  //         title: getBoardTileTitle("Bottom Row", completedBottomRowBoard.length,
  //             false, completedBottomRowBoard[0])));
  //   if (completedCornersBoard.isNotEmpty)
  //     completedBoardCardItems.add(BestTambolaTicketsSumm(
  //         boards: completedCornersBoard,
  //         title: getBoardTileTitle("Corners", completedCornersBoard.length,
  //             false, completedCornersBoard[0])));

  //   // ADDING BEST CHANCES CATEGORIES TO FORM A LIST OF TILE DATA FOR THE CARD
  //   if (bestCornerBoard.isNotEmpty)
  //     bestCornersBoardCardItems.add(BestTambolaTicketsSumm(
  //         boards: bestCornerBoard,
  //         title: getBoardTileTitle(
  //             "Corners", bestCornerBoard.length, true, bestCornerBoard[0])));
  //   if (bestTopRowBoard.isNotEmpty)
  //     bestRowsBoardCardItems.add(BestTambolaTicketsSumm(
  //         boards: bestTopRowBoard,
  //         title: getBoardTileTitle(
  //             "Top Row", bestTopRowBoard.length, true, bestTopRowBoard[0])));
  //   if (bestMiddleRowBoard.isNotEmpty)
  //     bestRowsBoardCardItems.add(BestTambolaTicketsSumm(
  //         boards: bestMiddleRowBoard,
  //         title: getBoardTileTitle("Middle Row", bestMiddleRowBoard.length,
  //             true, bestMiddleRowBoard[0])));
  //   if (bestBottomRowBoard.isNotEmpty)
  //     bestRowsBoardCardItems.add(BestTambolaTicketsSumm(
  //         boards: bestBottomRowBoard,
  //         title: getBoardTileTitle("Bottom Row", bestBottomRowBoard.length,
  //             true, bestBottomRowBoard[0])));

  //   // ADDING THE BEST CHANCES OFF FULL HOUSE -SINGLE ITEM
  //   if (bestFullHouseBoard.isNotEmpty)
  //     fullHouseBoardCardItems.add(BestTambolaTicketsSumm(
  //         boards: bestFullHouseBoard,
  //         title: getBoardTileTitle("Full House", bestFullHouseBoard.length,
  //             true, bestFullHouseBoard[0])));

  //   //CREATING CARDS FOR EACH CARD ITEMS
  //   if (fullHouseBoardCardItems.isNotEmpty)
  //     summary.add(TicketSummaryCardModel(
  //         data: fullHouseBoardCardItems,
  //         color: Color(0xff810000),
  //         cardType: "Jackpot",
  //         bgAsset:
  //             "https://img.freepik.com/free-vector/realistic-casino-background_52683-7264.jpg?size=626&ext=jpg&uid=P35674521"));

  //   if (completedBoardCardItems.isNotEmpty)
  //     summary.add(TicketSummaryCardModel(
  //         data: completedBoardCardItems,
  //         color: Colors.blue,
  //         cardType: "Completed",
  //         bgAsset:
  //             "https://img.freepik.com/free-vector/blue-halftone-memphis-background-with-yellow-lines-circles-shapes_1017-31954.jpg?size=626&ext=jpg&uid=P35674521"));
  //   if (bestCornersBoardCardItems.isNotEmpty)
  //     summary.add(TicketSummaryCardModel(
  //         data: bestCornersBoardCardItems,
  //         color: Color(0xff511281),
  //         cardType: "Best Corners",
  //         bgAsset:
  //             "https://img.freepik.com/free-vector/gradient-liquid-abstract-background_52683-60469.jpg?size=626&ext=jpg&uid=P35674521"));
  //   if (bestRowsBoardCardItems.isNotEmpty)
  //     summary.add(TicketSummaryCardModel(
  //         data: bestRowsBoardCardItems,
  //         color: Color(0xffFFA41B),
  //         cardType: "Best Rows",
  //         bgAsset:
  //             "https://img.freepik.com/free-vector/abstract-low-poly-orange-yellow-background_1017-32111.jpg?size=626&ext=jpg&uid=P35674521"));

  //   _isTicketSummaryLoaded = true;
  //   return summary;
  // }

  // getBoardTileTitle(
  //     String category, int length, bool bestCards, Ticket firstCard) {
  //   String output;

  //   if (bestCards) {
  //     if (category == "Corners") {
  //       if (length == 1)
  //         output =
  //             "Ticket #${firstCard.board.getTicketNumber()} is just 1 number away from completing its $category!";
  //       else
  //         output =
  //             "$length of your tickets are just 1 number away from completing their $category!";
  //     } else if (category == "Full House") {
  //       if (length == 1)
  //         output =
  //             "Ticket #${firstCard.board.getTicketNumber()} is just less than 5 numbers away from winning the $category!";
  //       else
  //         output =
  //             "$length of your tickets are less than 5 numbers away from winning the $category!";
  //     } else {
  //       if (length == 1)
  //         output =
  //             "Ticket #${firstCard.board.getTicketNumber()} is just 2 numbers away from completing its $category!";
  //       else
  //         output =
  //             "$length of your tickets are just 2 numbers away from completing its $category.";
  //     }
  //   } else {
  //     if (length == 1)
  //       output =
  //           "Ticket #${firstCard.board.getTicketNumber()} has completed its $category!";
  //     else
  //       output = "$length of your tickets have completed their $category!";
  //   }

  //   return output;
  // }

  // List<TambolaBoard> refreshBestBoards() {
  //   List<TambolaBoard> _bestTambolaBoards = [];

  //   // If boards are empty
  //   if (userWeeklyBoards == null || userWeeklyBoards.isEmpty) {
  //     return _bestTambolaBoards;
  //   }
  //   // If number of boards are less than 5, return all the boards
  //   if (userWeeklyBoards.length <= 5) {
  //     _bestTambolaBoards = [];
  //     userWeeklyBoards.forEach((e) {
  //       _bestTambolaBoards.add(e);
  //     });
  //     return _bestTambolaBoards;
  //   }
  //   // If numbers of boards are more than 5

  //   //initialise bestboards with first 5 board
  //   // _bestTambolaBoards = List.filled(5, userWeeklyBoards[0]);
  //   for (int i = 0; i < 5; i++) {
  //     _bestTambolaBoards.add(userWeeklyBoards[i]);
  //   }

  //   // If weekly digits are not announced yet, simply return first 5 tickets
  //   if (weeklyDigits == null || weeklyDigits.toList().isEmpty) {
  //     return _bestTambolaBoards;
  //   }

  //   for (int i = 5; i < userWeeklyBoards.length; i++) {
  //     final board = userWeeklyBoards[i];
  //     if (_bestTambolaBoards[0].getRowOdds(
  //                 0,
  //                 weeklyDigits.getPicksPostDate(
  //                     _bestTambolaBoards[0].generatedDayCode)) >
  //             board.getRowOdds(
  //                 0, weeklyDigits.getPicksPostDate(board.generatedDayCode)) &&
  //         !_bestTambolaBoards.contains(board)) {
  //       _bestTambolaBoards[0] = board;
  //     }
  //     if (_bestTambolaBoards[1].getRowOdds(
  //                 1,
  //                 weeklyDigits.getPicksPostDate(
  //                     _bestTambolaBoards[1].generatedDayCode)) >
  //             board.getRowOdds(
  //                 1, weeklyDigits.getPicksPostDate(board.generatedDayCode)) &&
  //         !_bestTambolaBoards.contains(board)) {
  //       _bestTambolaBoards[1] = board;
  //     }
  //     if (_bestTambolaBoards[2].getRowOdds(
  //                 2,
  //                 weeklyDigits.getPicksPostDate(
  //                     _bestTambolaBoards[2].generatedDayCode)) >
  //             board.getRowOdds(
  //                 2, weeklyDigits.getPicksPostDate(board.generatedDayCode)) &&
  //         !_bestTambolaBoards.contains(board)) {
  //       _bestTambolaBoards[2] = board;
  //     }
  //     if (_bestTambolaBoards[3].getCornerOdds(weeklyDigits
  //                 .getPicksPostDate(_bestTambolaBoards[3].generatedDayCode)) >
  //             board.getCornerOdds(
  //                 weeklyDigits.getPicksPostDate(board.generatedDayCode)) &&
  //         !_bestTambolaBoards.contains(board)) {
  //       _bestTambolaBoards[3] = board;
  //     }
  //     if (_bestTambolaBoards[4].getFullHouseOdds(weeklyDigits
  //                 .getPicksPostDate(_bestTambolaBoards[4].generatedDayCode)) >
  //             board.getFullHouseOdds(
  //                 weeklyDigits.getPicksPostDate(board.generatedDayCode)) &&
  //         !_bestTambolaBoards.contains(board)) {
  //       _bestTambolaBoards[4] = board;
  //     }
  //   }

  //   return _bestTambolaBoards;
  // }

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
