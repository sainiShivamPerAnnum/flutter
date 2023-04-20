// import 'dart:async';
// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:tambola/src/models/daily_pick.dart';
// import 'package:tambola/src/models/prizes_model.dart';
// import 'package:tambola/src/models/tambola_ticket_model.dart';
// import 'package:tambola/src/models/winners_model.dart';
// import 'package:tambola/src/utils/assets.dart';

// class TambolaHomeViewModel extends ChangeNotifier {
//   // final GetterRepository _getterRepo = locator<GetterRepository>();
//   // final PrizeService _prizeService = locator<PrizeService>();
//   // final BaseUtil _baseUtil = locator<BaseUtil>();
//   // final CustomLogger _logger = locator<CustomLogger>();
//   // final AnalyticsService _analyticsService = locator<AnalyticsService>();
//   // final GameRepo _gamesRepo = locator<GameRepo>();
//   // final WinnerService _winnerService = locator<WinnerService>();
//   // final DBModel _dbModel = locator<DBModel>();
//   // final S locale = locator<S>();
//   // final TambolaService? tambolaService = locator<TambolaService>();
//   // final UserCoinService _coinService = locator<UserCoinService>();
//   // final TambolaRepo _tambolaRepo = locator<TambolaRepo>();
//   // final UserService _userService = locator<UserService>();

//   bool isLeaderboardLoading = false;
//   bool isPrizesLoading = false;
//   int? currentPage = 0;
//   PageController pageController = PageController(initialPage: 0);
//   // LeaderboardModel? _tLeaderBoard;
//   late ScrollController scrollController;
//   double cardOpacity = 1;
//   // GameModel? game;
//   List<Winners> _winners = [];
//   List<TambolaTicketModel>? _bestTambolaTickets;
//   int ticketGenerationTryCount = 0;
//   TextEditingController? ticketCountController;

//   // Ticket? _currentBoardView;
//   TambolaTicketModel? _currentBoard;
//   Widget? _widget;
//   late AnimationController animationController;
//   PageController? ticketPageController;
//   int _currentPage = 1;

//   // List<Ticket> _topFiveTambolaTicketModels = [];
//   bool showSummaryCards = true;
//   bool ticketBuyInProgress = false;
//   bool _weeklyDrawFetched = false;
//   int buyTicketCount = 3;
//   bool ticketsLoaded = false;
//   int _ticketSavedAmount = 0;
//   bool _showWinCard = false;
//   Map<String, int> ticketCodeWinIndex = {};
//   bool _isEligible = false;
//   bool _show1CrCard = false;
//   // final itemKey = GlobalKey();

//   bool get show1CrCard => _show1CrCard;

//   set show1CrCard(bool value) {
//     _show1CrCard = value;
//   }

//   bool get isEligible => _isEligible;

//   set isEligible(value) => _isEligible = value;

//   bool get showWinCard => _showWinCard;

//   set showWinCard(value) {
//     _showWinCard = value;
//     notifyListeners();
//   }

//   // TambolaWidgetController? tambolaWidgetController;

//   //Constant values
//   Map<String, IconData> tambolaOdds = {
//     "Full House": Icons.apps,
//     "Top Row": Icons.border_top,
//     "Middle Row": Icons.border_horizontal,
//     "Bottom Row": Icons.border_bottom,
//     "Corners": Icons.border_outer
//   };

//   List<String> tabList = [
//     "All",
//     "Corners",
//     "One Row",
//     "Two Rows",
//     "Full House",
//   ];

//   String boxHeading = "How to Play";

//   List<String> boxTitlles = [
//     "Your ticket comprises of 15 randomly placed numbers, refreshed every Monday",
//     "3 random numbers are picked everyday from 1 to 90 at 6 pm.",
//     "Numbers that match your ticket gets automatically crossed out.",
//   ];
//   List<String> boxAssets = [
//     Assets.howToPlayAsset1Tambola,
//     Assets.howToPlayAsset2Tambola,
//     Assets.howToPlayAsset3Tambola,
//   ];

//   void udpateCardOpacity() {
//     cardOpacity = 1 -
//         (scrollController.offset / scrollController.position.maxScrollExtent)
//             .clamp(0, 1)
//             .toDouble();
//     notifyListeners();
//   }

//   // LeaderboardModel? get tlboard => _tLeaderBoard;

//   // PrizesModel? get tPrizes =>
//   //     _prizeService.gamePrizeMap[Constants.GAME_TYPE_TAMBOLA];

//   List<Winners> get winners => _winners;

//   int get ticketSavedAmount => _ticketSavedAmount;

//   // int? get dailyPicksCount => tambolaService!.dailyPicksCount;

//   // List<int>? get todaysPicks => tambolaService!.todaysPicks;

//   // DailyPick? get weeklyDigits => tambolaService!.weeklyDigits;

//   // List<TambolaTicketModel?>? get userWeeklyBoards =>
//   //     tambolaService!.userWeeklyBoards;

//   List<TambolaTicketModel>? get bestTambolaTickets => _bestTambolaTickets;

//   set bestTambolaTickets(List<TambolaTicketModel>? value) {
//     _bestTambolaTickets = value;
//   }

//   bool get weeklyDrawFetched => _weeklyDrawFetched;

//   set weeklyDrawFetched(value) {
//     _weeklyDrawFetched = value;
//     notifyListeners();
//   }

//   Widget? get cardWidget => _widget;

//   // List<Ticket> get topFiveTambolaTicketModels => _topFiveTambolaTicketModels;

//   // bool get weeklyTicksFetched => tambolaService!.weeklyTicksFetched;

//   // Ticket? get currentBoardView => _currentBoardView;

//   TambolaTicketModel? get currentBoard => _currentBoard;

//   // int? get ticketPurchaseCost {
//   //   String _tambolaCost = BaseRemoteConfig.remoteConfig
//   //       .getString(BaseRemoteConfig.TAMBOLA_PLAY_COST);
//   //   if (_tambolaCost == null ||
//   //       _tambolaCost.isEmpty ||
//   //       int.tryParse(_tambolaCost) == null) _tambolaCost = '10';

//   //   return int.tryParse(_tambolaCost);
//   // }

//   // int? get totalActiveTickets => tambolaService!.ticketCount;

//   void viewpage(int? index) {
//     currentPage = index;
//     debugPrint("$currentPage");
//     pageController.animateToPage(currentPage!,
//         duration: const Duration(milliseconds: 200), curve: Curves.decelerate);
//     // refresh();
//   }

//   void updateTicketSavedAmount(int count) {
//     // _ticketSavedAmount = AppConfig.getValue(AppConfigKey.tambola_cost) * count;
//     notifyListeners();
//   }

//   Future<void> init() async {
//     // setState(ViewState.Busy);
//     final seconds = DateTime.now().second;
//     log("Get Game Details:Message:$seconds");
//     await getGameDetails();
//     log("Get Game Details:${DateTime.now().second}");
//     // getLeaderboard();
//     // tambolaWidgetController ??= TambolaWidgetController();
//     await fetchWinners();
//     // if (tPrizes == null) await getPrizes();

//     //Tambola services
//     ticketCountController =
//         TextEditingController(text: buyTicketCount.toString());
//     updateTicketSavedAmount(buyTicketCount);

//     // Ticket wallet check
//     // await tambolaService!.getTicketCount();

//     ///Weekly Picks check
//     if (weeklyDigits == null) {
//       await tambolaService!.fetchWeeklyPicks();
//       weeklyDrawFetched = true;
//     } else {
//       weeklyDrawFetched = true;
//     }

//     ///next get the tambola tickets of this week

//     await fetchTambola();
//     log("Fetch Tambola:${DateTime.now().second}");
//     tambolaService!.addListener(() {
//       if (tambolaService!.areTicketsUpdated) {
//         refreshTambolaTickets(shouldRefresh: false);
//       }
//     });

//     ///check whether to show summary cards or not
//     DateTime today = DateTime.now();
//     if (today.weekday == 7 && today.hour > 18) {
//       showSummaryCards = false;
//       notifyListeners();
//     }

//     if (today.weekday == 1 && (today.hour >= 0 && today.hour < 12)) {
//       show1CrCard = true;
//     }

//     setState(ViewState.Idle);
//   }

//   Future<void> fetchTambola() async {
//     ticketsLoaded = false;
//     if (!tambolaService!.weeklyTicksFetched) {
//       await tambolaService!.getTambolaTickets();
//     }

//     await tambolaService!.completer.future;

//     _currentBoard = null;
//     // _currentBoardView = null;

//     await _examineTicketsForWins();
//   }

//   Future<void> fetchWinners() async {
//     final winnersModel = await _winnerService
//         .fetchWinnersByGameCode(Constants.GAME_TYPE_TAMBOLA);
//     _winners = winnersModel!.winners!;
//     notifyListeners();
//   }

//   Future getProfileDpWithUid(String? uid) async {
//     return _dbModel.getUserDP(uid);
//   }

//   // Future<void> getLeaderboard() async {
//   //   isLeaderboardLoading = true;
//   //   notifyListeners();

//   //   log("GM_TAMBOLA2020");
//   //   ApiResponse temp = await _getterRepo!.getStatisticsByFreqGameTypeAndCode(
//   //     type: "GM_TAMBOLA2020",
//   //     freq: "weekly",
//   //   );
//   //   if (temp.isSuccess()) {
//   //     _logger!.d(temp.code);
//   //     if (temp.model != null && temp.model.isNotEmpty)
//   //       _tLeaderBoard = LeaderboardModel.fromMap(temp.model);
//   //     isLeaderboardLoading = false;
//   //     notifyListeners();
//   //   }
//   // }

//   Future<void> getPrizes() async {
//     isPrizesLoading = true;
//     notifyListeners();
//     await _prizeService!.fetchPrizeByGameType(Constants.GAME_TYPE_TAMBOLA);
//     if (tPrizes == null) {
//       BaseUtil.showNegativeAlert(locale.prizeFetchFailed, locale.tryLater);
//     }
//     isPrizesLoading = false;
//     notifyListeners();
//   }

//   // void openGame() {
//   //   _analyticsService!.track(eventName: AnalyticsEvents.startPlayingTambola);
//   //   // _baseUtil.cacheGameorder('TA');
//   //   BaseUtil().openTambolaGame();
//   // }

//   Future<void> getGameDetails() async {
//     if (game != null) return;
//     final response =
//         await _gamesRepo!.getGameByCode(gameCode: Constants.GAME_TYPE_TAMBOLA);
//     if (response.isSuccess()) {
//       game = response.model;
//     } else {
//       BaseUtil.showNegativeAlert("", response.errorMessage);
//     }
//   }

//   Future<void> refreshTambolaTickets({bool shouldRefresh = true}) async {
//     _logger!.i('Refreshing..');
//     // _topFiveTambolaTicketModels = [];
//     if (shouldRefresh) tambolaService!.weeklyTicksFetched = false;
//     await init();
//     notifyListeners();
//   }

//   int? get activeTambolaCardCount {
//     if (tambolaService == null || tambolaService!.userWeeklyBoards == null) {
//       return 0;
//     }
//     return tambolaService!.userWeeklyBoards!.length;
//   }

//   void updateTicketCount() {
//     buyTicketCount = int.tryParse(ticketCountController!.text) ?? 3;
//     notifyListeners();
//   }

//   void increaseTicketCount() {
//     if (buyTicketCount < 30) {
//       buyTicketCount += 1;
//     } else {
//       BaseUtil.showNegativeAlert(
//           locale.ticketsExceeded, locale.tktsPurchaseLimit);
//     }
//     ticketCountController!.text = buyTicketCount.toString();
//     updateTicketSavedAmount(buyTicketCount);

//     notifyListeners();
//   }

//   void decreaseTicketCount() {
//     if (buyTicketCount > 1) {
//       buyTicketCount -= 1;

//       ticketCountController!.text = buyTicketCount.toString();
//       updateTicketSavedAmount(buyTicketCount);
//       notifyListeners();
//     }
//   }

//   // Future<void> buyTickets(BuildContext context) async {
//   //   if (ticketBuyInProgress) return;
//   //   if (ticketCountController.text.isEmpty)
//   //     return BaseUtil.showNegativeAlert(
//   //         "No ticket count entered", "Please enter a valid number of tickets");

//   //   int ticketCount = int.tryParse(ticketCountController.text);
//   //   if (ticketCount == 0) {
//   //     return BaseUtil.showNegativeAlert(
//   //         "No ticket count entered", "Please enter a valid number of tickets");
//   //   }
//   //   if (ticketCount > 30) {
//   //     return BaseUtil.showNegativeAlert("Maximum tickets exceeded",
//   //         "You can purchase upto 30 tambola tickets at once");
//   //   }
//   //   if (ticketPurchaseCost * ticketCount > _coinService.flcBalance) {
//   //     return earnMoreTokens();
//   //   }

//   //   ticketBuyInProgress = true;
//   //   tambolaService.ticketGenerateCount = ticketCount;
//   //   notifyListeners();

//   //   _analyticsService.track(eventName: AnalyticsEvents.gamePlayStarted);
//   //   _analyticsService.track(
//   //     eventName: AnalyticsEvents.buyTambolaTickets,
//   //     properties: {'count': ticketCount},
//   //   );

//   //   ApiResponse<FlcModel> _flcResponse =
//   //       await _tambolaRepo.buyTambolaTickets(ticketCount);
//   //   if (_flcResponse.model != null && _flcResponse.code == 200) {
//   //     BaseUtil.showPositiveAlert(
//   //       "Tickets successfully generated 🥳",
//   //       "Your weekly odds are now way better!",
//   //     );

//   //     if (_flcResponse.model.flcBalance > 0) {
//   //       _coinService.setFlcBalance(_flcResponse.model.flcBalance);
//   //     }

//   //     //Need to refresh the userTicketWallet object after API completes
//   //     _refreshTambolaTickets();
//   //   } else {
//   //     return BaseUtil.showNegativeAlert(
//   //       "Operation Failed",
//   //       "Failed to buy tickets at the moment. Please try again later",
//   //     );
//   //   }

//   //   ticketBuyInProgress = false;
//   //   tambolaService.ticketGenerateCount = 0;
//   //   notifyListeners();
//   // }

//   void earnMoreTokens() {
//     _analyticsService!.track(eventName: AnalyticsEvents.earnMoreTokens);
//     BaseUtil.openModalBottomSheet(
//       addToScreenStack: true,
//       backgroundColor: UiConstants.gameCardColor,
//       content: WantMoreTicketsModalSheet(isInsufficientBalance: true),
//       borderRadius: BorderRadius.only(
//         topLeft: Radius.circular(SizeConfig.roundness24),
//         topRight: Radius.circular(SizeConfig.roundness24),
//       ),
//       hapticVibrate: true,
//       isScrollControlled: true,
//       isBarrierDismissible: true,
//     );
//   }

//   // Ticket? buildBoardView(TambolaTicketModel board) {
//   //   if (!board.isValid()) return null;
//   //   List<int> _calledDigits;
//   //   if (!tambolaService!.weeklyDrawFetched ||
//   //       weeklyDigits == null ||
//   //       weeklyDigits!.toList().isEmpty) {
//   //     _calledDigits = [];
//   //   } else {
//   //     _calledDigits = weeklyDigits!.getPicksPostDate(DateTime.monday);
//   //   }
//   //
//   //   return Ticket(
//   //     board: board,
//   //     calledDigits: _calledDigits,
//   //   );
//   // }

//   List<TambolaTicketModel?>? refreshBestBoards() {
//     if (userWeeklyBoards == null || (userWeeklyBoards?.isEmpty ?? false)) {
//       return List<TambolaTicketModel?>.filled(5, null);
//     }

//     _bestTambolaTickets = [
//       userWeeklyBoards![0]!,
//       userWeeklyBoards![0]!,
//       userWeeklyBoards![0]!,
//       userWeeklyBoards![0]!,
//     ];

//     if (weeklyDigits == null || weeklyDigits!.toList().isEmpty) {
//       return _bestTambolaTickets;
//     }

//     final weeklyDigitsList = weeklyDigits?.toList() ?? [];

//     for (final board in userWeeklyBoards!) {
//       final cornerOdds = getCornerOdds(board!, weeklyDigitsList);
//       final oneRowOdds = getOneRowOdds(board, weeklyDigitsList);
//       final twoRowOdds = getTwoRowOdds(board, weeklyDigitsList);
//       final fullHouseOdds = getFullHouseOdds(board, weeklyDigitsList);

//       if (getCornerOdds(_bestTambolaTickets![0], weeklyDigitsList) >
//           cornerOdds) {
//         _bestTambolaTickets![0] = board;
//       }
//       if (getOneRowOdds(_bestTambolaTickets![1], weeklyDigitsList) >
//           oneRowOdds) {
//         _bestTambolaTickets![1] = board;
//       }
//       if (getTwoRowOdds(_bestTambolaTickets![2], weeklyDigitsList) >
//           twoRowOdds) {
//         _bestTambolaTickets![2] = board;
//       }
//       if (getFullHouseOdds(_bestTambolaTickets![3], weeklyDigitsList) >
//           fullHouseOdds) {
//         _bestTambolaTickets![3] = board;
//       }
//     }

//     return _bestTambolaTickets;
//   }

//   Future<void> _examineTicketsForWins() async {
//     if (userWeeklyBoards == null ||
//         userWeeklyBoards!.isEmpty ||
//         weeklyDigits == null ||
//         weeklyDigits!.toList().length != 7 * (dailyPicksCount ?? 3) ||
//         weeklyDigits!.toList().contains(-1)) {
//       _logger.i('Today is not the day');
//       return;
//     }

//     for (final boardObj in userWeeklyBoards!) {
//       if (getCornerOdds(
//               boardObj!, weeklyDigits!.getPicksPostDate(DateTime.monday)) ==
//           0) {
//         if (boardObj.getTicketNumber() != 'NA') {
//           ticketCodeWinIndex[boardObj.getTicketNumber()] =
//               Constants.CORNERS_COMPLETED;
//         }
//       }
//       if (getOneRowOdds(
//               boardObj, weeklyDigits!.getPicksPostDate(DateTime.monday)) ==
//           0) {
//         if (boardObj.getTicketNumber() != 'NA') {
//           ticketCodeWinIndex[boardObj.getTicketNumber()] =
//               Constants.ONE_ROW_COMPLETED;
//         }
//       }
//       if (getTwoRowOdds(
//               boardObj, weeklyDigits!.getPicksPostDate(DateTime.monday)) ==
//           0) {
//         if (boardObj.getTicketNumber() != 'NA') {
//           ticketCodeWinIndex[boardObj.getTicketNumber()] =
//               Constants.TWO_ROWS_COMPLETED;
//         }
//       }
//       if (getFullHouseOdds(
//               boardObj, weeklyDigits!.getPicksPostDate(DateTime.monday)) ==
//           0) {
//         if (boardObj.getTicketNumber() != 'NA') {
//           ticketCodeWinIndex[boardObj.getTicketNumber()] =
//               Constants.FULL_HOUSE_COMPLETED;
//         }
//       }
//     }

//     if (DateTime.now().weekday == DateTime.sunday &&
//         DateTime.now().hour >= 18) {
//       showWinCard = true;
//       notifyListeners();
//     }

//     isEligible = true;

//     if (ticketCodeWinIndex.isNotEmpty) {
//       BaseUtil.showPositiveAlert(
//         locale.tambolaTicketWinAlert1,
//         locale.tambolaTicketWinAlert2,
//       );
//     }

//     unawaited(PreferenceHelper.setBool(
//         PreferenceHelper.SHOW_TAMBOLA_PROCESSING, false));
//   }
// }
