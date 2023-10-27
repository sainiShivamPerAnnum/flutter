import 'package:collection/collection.dart' show IterableExtension;
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/event_model.dart';
import 'package:felloapp/core/model/leaderboard_model.dart';
import 'package:felloapp/core/model/scoreboard_model.dart';
import 'package:felloapp/core/model/winners_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/repository/campaigns_repo.dart';
import 'package:felloapp/core/repository/getters_repo.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/code_from_freq.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../../core/service/api.dart';
import '../../../../util/assets.dart';

class TopSaverViewModel extends BaseViewModel {
  final CustomLogger _logger = locator<CustomLogger>();
  final DBModel _dbModel = locator<DBModel>();
  final UserService _userService = locator<UserService>();
  final GetterRepository _getterRepo = locator<GetterRepository>();
  // final WinnerService? _winnerService = locator<WinnerService>();
  final CampaignRepo _campaignRepo = locator<CampaignRepo>();
  S locale = locator<S>();

  // final eventService = EventService();
  //Local variables

  String appbarTitle = "Top Saver";
  String campaignType = Constants.HS_DAILY_SAVER;

  String saverFreq = "daily";

  String subTitle = "Be the top saver to win";

  int weekDay = DateTime.now().weekday;

  int _userRank = 0;
  String? _userDisplayAmount = '-';
  String _highestSavingsDisplayAmount = '-';
  String winnerTitle = "Past Winners";
  EventModel? event;
  bool showStandingsAndWinners = true;
  String eventStandingsType = "HIGHEST_SAVER_V2";
  String actionTitle = "Buy Digital Gold";

  bool isStreamLoading = true;

  int _tabNo = 0;
  double _tabPosWidthFactor = SizeConfig.pageHorizontalMargins;
  PageController? _pageController;

  PageController? get pageController => _pageController;

  bool infoBoxOpen = false;

  int get tabNo => _tabNo;
  set tabNo(value) {
    _tabNo = value;
    notifyListeners();
  }

  double get tabPosWidthFactor => _tabPosWidthFactor;
  set tabPosWidthFactor(value) {
    _tabPosWidthFactor = value;
    notifyListeners();
  }

  switchTab(int tab) {
    if (tab == tabNo) return;

    tabPosWidthFactor = tabNo == 0
        ? SizeConfig.screenWidth! / 2 + SizeConfig.pageHorizontalMargins
        : SizeConfig.pageHorizontalMargins;

    _pageController!.animateToPage(
      tab,
      duration: const Duration(milliseconds: 300),
      curve: Curves.linear,
    );
    tabNo = tab;
  }

  //Related to the info box/////////////////
  String boxHeading = "How to participate?";
  List<String> boxAssetsList = [
    Assets.singleStarAsset,
    Assets.singleCoinAsset,
    Assets.singleTmbolaTicket,
  ];
  // List<String> boxTitlles = [
  //   'Choose a product for\nsaving.',
  //   'Enter an amount you\nwant to save. ',
  //   'Play games with tokens\nearned.'
  // ];
  ////////////////////////////////////////////

  List<ScoreBoard>? currentParticipants;
  List<PastHighestSaver>? _pastWinners;

  List<PastHighestSaver>? get pastWinners => _pastWinners;

  displayUsername(username) => _userService!.diplayUsername(username);

  set pastWinners(List<PastHighestSaver>? value) {
    _pastWinners = value;
    notifyListeners();
  }

  get userRank => _userRank;

  set userRank(value) {
    _userRank = value;
    notifyListeners();
  }

  String get highestSavings => _highestSavingsDisplayAmount;

  set highestSavings(value) {
    _highestSavingsDisplayAmount = value;
    notifyListeners();
  }

  String? get userDisplayAmount => _userDisplayAmount;

  set userDisplayAmount(value) {
    _userDisplayAmount = value;
    notifyListeners();
  }

  init(String? eventType, bool isGameRedirected) async {
    setState(ViewState.Busy);

    event = await getSingleEventDetails(eventType);
    _pageController = PageController(initialPage: 0);
    infoBoxOpen = false;
    getRealTimeFinanceStream();
    setState(ViewState.Idle);

    campaignType = event!.type;
    // eventService.getEventType(event.type);
    _logger!
        .d("Top Saver Viewmodel initialised with saver type : ${event!.type}");
    setAppbarTitle();
    fetchTopSavers();

    fetchPastWinners();
    // _logger.d(CodeFromFreq.getPastDayCode());
    // _logger.d(CodeFromFreq.getPastWeekCode());
    // _logger.d(CodeFromFreq.getPastMonthCode());
    _logger!.d(event!.type);
    _logger!.d(isGameRedirected);
    // if (event.type == "FPL" && isGameRedirected)
    //   BaseUtil.openModalBottomSheet(
    //     addToScreenStack: true,
    //     backgroundColor: Colors.white,
    //     borderRadius: BorderRadius.only(
    //       topLeft: Radius.circular(SizeConfig.roundness32),
    //       topRight: Radius.circular(SizeConfig.roundness32),
    //     ),
    //     isScrollControlled: true,
    //     hapticVibrate: true,
    //     isBarrierDismissable: false,
    //     content: EventInstructionsModal(instructions: event.instructions),
    //   );
  }

  List<String> getBoxTitles(List<dynamic> infoList) {
    List<String> assetList = [];
    for (int i = 0; i < infoList.length; i++) {
      assetList.add(infoList[i].toString());
    }
    return assetList;
  }

  List<String> getBoxAssets(int count) {
    List<String> assetList = [];
    int i = count;
    int j = 0;
    while (i > 0) {
      assetList.add(boxAssetsList[j++]);
      j = j % boxAssetsList.length;
      i--;
    }

    return assetList;
  }

  setAppbarTitle() {
    switch (campaignType) {
      case Constants.HS_DAILY_SAVER:
        {
          appbarTitle = "Saver of the Day";
          saverFreq = "daily";

          break;
        }
      case Constants.HS_WEEKLY_SAVER:
        {
          appbarTitle = "Saver of the Week";
          saverFreq = "weekly";
          break;
        }
      case Constants.HS_MONTHLY_SAVER:
        {
          appbarTitle = "Saver of the Month";
          saverFreq = "monthly";
          break;
        }
      // case Constants.GAME_TYPE_FPL:
      //   {
      //     appbarTitle = "Fello Premier League";
      //     saverFreq = "daily";
      //     eventStandingsType = "FPL";
      //     actionTitle = "Play Cricket";
      //     break;
      //   }
      // case Constants.BUG_BOUNTY:
      //   {
      //     appbarTitle = "Fello Bug Bounty";
      //     saverFreq = "monthly";
      //     eventStandingsType = "BUG_BOUNTY";
      //     showStandingsAndWinners = false;
      //     actionTitle = "Review";
      //     _winnerService!.fetchBugBountyWinners();
      //     break;
      //   }
      // case Constants.NEW_FELLO_UI:
      //   {
      //     appbarTitle = "New Fello App";
      //     saverFreq = "monthly";
      //     eventStandingsType = "NEW_FELLO";
      //     showStandingsAndWinners = false;
      //     actionTitle = "View";
      //     _winnerService!.fetchNewFelloWinners();
      //     break;
      //   }
    }
    notifyListeners();
  }

  toggleInfoBox() {
    infoBoxOpen = !infoBoxOpen;
    notifyListeners();
  }

  Future<EventModel?> getSingleEventDetails(String? eventType) async {
    EventModel? event;
    _logger!.d(eventType);

    final response = await _campaignRepo!.getOngoingEvents();
    if (response.code == 200) {
      List<EventModel> ongoingEvents = response.model!;
      // ongoingEvents.sort((a, b) => a.position.compareTo(b.position));
      ongoingEvents.forEach((element) {
        if (element.type == eventType) event = element;
      });
    } else {
      BaseUtil.showNegativeAlert(response.errorMessage, locale.tryLater);
    }
    _logger!.d(event.toString());
    return event;
  }

  fetchTopSavers() async {
    ApiResponse response =
        await _getterRepo!.getStatisticsByFreqGameTypeAndCode(
      freq: saverFreq,
      type: eventStandingsType,
    );
    if (response.code == 200) {
      currentParticipants = LeaderboardModel.fromMap(response.model).scoreboard;
      getUserRankIfAny();
    } else {
      currentParticipants = [];
    }
    notifyListeners();
  }

  fetchPastWinners() async {
    List<WinnersModel>? winnerModels = await getPastWinners(
      Constants.GAME_TYPE_HIGHEST_SAVER,
      saverFreq,
    );
    if (winnerModels != null && winnerModels.isNotEmpty) {
      pastWinners = [];
      for (int i = 0; i < winnerModels.length; i++) {
        for (int j = 0; j < winnerModels[i].winners!.length; j++) {
          pastWinners!.add(
            PastHighestSaver.fromMap(
              winnerModels[i].winners![j],
              winnerModels[i].gametype,
              winnerModels[i].code,
            ),
          );
        }
      }

      notifyListeners();
    } else {
      pastWinners = [];
    }

    updateWinnersTitle();
  }

  updateWinnersTitle() {
    if (pastWinners!.length == 1) {
      winnerTitle = winnerTitle.substring(0, winnerTitle.length - 1);
    }
    notifyListeners();
  }

  Future getProfileDpWithUid(String? uid) async {
    return await _dbModel!.getUserDP(uid);
  }

  getUserRankIfAny() {
    if (currentParticipants != null && currentParticipants!.isNotEmpty) {
      if (currentParticipants!.firstWhereOrNull(
              (e) => e.userid == _userService!.baseUser!.uid) !=
          null) {
        final ScoreBoard curentUserStat = currentParticipants!
            .firstWhere((e) => e.userid == _userService!.baseUser!.uid);
        int rank = currentParticipants!
            .indexWhere((e) => e.userid == _userService!.baseUser!.uid);
        userRank = rank + 1;
        userDisplayAmount = curentUserStat.displayScore; //TODO
      }

      fetchHighestSavings();
    }
  }

  Stream<DatabaseEvent>? getRealTimeFinanceStream() {
    return Api().fetchRealTimeFinanceStats();
  }

  String sortPlayerNumbers(String number) {
    double num = double.parse(number);

    if (num < 1000) {
      return num.toStringAsFixed(0);
    } else {
      num = num / 1000;
      return "${num.toStringAsFixed(1)}K";
    }
  }

  String getPathForRealTimeFinanceStats(String? campaignType) {
    if (campaignType == Constants.HS_DAILY_SAVER) {
      return Constants.DAILY;
    } else if (campaignType == Constants.HS_WEEKLY_SAVER) {
      return Constants.WEEKLY;
    } else if (campaignType == Constants.HS_MONTHLY_SAVER) {
      return Constants.MONTHLY;
    } else {
      return "";
    }
  }

  String getDeafultRealTimeStat(String? value) {
    if (value == Constants.HS_DAILY_SAVER) {
      return "50+";
    } else if (value == Constants.HS_WEEKLY_SAVER) {
      return "100+";
    } else if (value == Constants.HS_MONTHLY_SAVER) {
      return "1K+";
    } else {
      return "-";
    }
  }

  getFormattedDate(String code) {
    switch (campaignType) {
      case Constants.HS_DAILY_SAVER:
        {
          return CodeFromFreq.getDayFromCode(code);
        }
      case Constants.HS_WEEKLY_SAVER:
        {
          return CodeFromFreq.getWeekFromCode(code);
        }
      case Constants.HS_MONTHLY_SAVER:
        {
          return CodeFromFreq.getMonthFromCode(code);
        }
      case Constants.GAME_TYPE_FPL:
        {
          return CodeFromFreq.getDayFromCode(code);
        }
    }
  }

  fetchHighestSavings() {
    highestSavings = currentParticipants![0].displayScore ?? '';
  }

  Future<List<WinnersModel>?> getPastWinners(
      String gameType, String freq) async {
    ApiResponse<List<WinnersModel>> response =
        await _getterRepo!.getPastWinners(
      type: gameType,
      freq: freq,
    );
    if (response.code == 200) {
      return response.model;
    } else {
      BaseUtil.showNegativeAlert("", response.errorMessage);
      return [];
    }
  }
}

class PastHighestSaver {
  double? score;
  int? amount;
  bool? isMockUser;
  int? flc;
  String? userid;
  String? username;
  String? gameType;
  String? code;
  String? displayScore;

  PastHighestSaver(
      {this.score,
      this.userid,
      this.username,
      this.gameType,
      this.isMockUser,
      this.amount,
      this.flc,
      this.code,
      this.displayScore});

  factory PastHighestSaver.fromMap(
      Winners map, String? gameType, String? code) {
    return PastHighestSaver(
        score: map.score!.toDouble(),
        userid: map.userid,
        username: map.username,
        gameType: gameType,
        amount: map.amount,
        flc: map.flc,
        isMockUser: map.isMockUser,
        code: code,
        displayScore: map.displayScore);
  }

  @override
  String toString() =>
      'Winners(score: $score, userid: $userid, username: $username, gameType: $gameType, amount: $amount, isMockUser: $isMockUser, code: $code)';
}
