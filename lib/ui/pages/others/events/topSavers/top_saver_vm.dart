import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/event_model.dart';
import 'package:felloapp/core/model/leaderboard_model.dart';
import 'package:felloapp/core/model/scoreboard_model.dart';
import 'package:felloapp/core/model/top_saver_model.dart';
import 'package:felloapp/core/model/winners_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/repository/campaigns_repo.dart';
import 'package:felloapp/core/repository/getters_repo.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/notifier_services/winners_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/modals_sheets/event_instructions_modal.dart';
import 'package:felloapp/ui/service_elements/leaderboards/web_game_leaderboard.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/code_from_freq.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';

class TopSaverViewModel extends BaseModel {
  final _logger = locator<CustomLogger>();
  final _dbModel = locator<DBModel>();
  final _userService = locator<UserService>();
  final _getterRepo = locator<GetterRepository>();
  final _winnerService = locator<WinnerService>();
  final _campaignRepo = locator<CampaignRepo>();

  // final eventService = EventService();
  //Local variables

  String appbarTitle = "Top Saver";
  String campaignType = Constants.HS_DAILY_SAVER;

  String saverFreq = "daily";

  int _userRank = 0;
  String winnerTitle = "Past Winners";
  EventModel event;
  bool showStandingsAndWinners = true;
  String eventStandingsType = "HIGHEST_SAVER";
  String actionTitle = "Buy Digital Gold";

  List<ScoreBoard> currentParticipants;
  List<PastHighestSaver> _pastWinners;

  List<PastHighestSaver> get pastWinners => _pastWinners;

  displayUsername(username) => _userService.diplayUsername(username);

  set pastWinners(List<PastHighestSaver> value) {
    _pastWinners = value;
    notifyListeners();
  }

  get userRank => this._userRank;

  set userRank(value) {
    this._userRank = value;
    notifyListeners();
  }

  init(String eventType, bool isGameRedirected) async {
    setState(ViewState.Busy);
    event = await getSingleEventDetails(eventType);
    setState(ViewState.Idle);
    campaignType = event.type;
    // eventService.getEventType(event.type);
    _logger
        .d("Top Saver Viewmodel initialised with saver type : ${event.type}");
    setAppbarTitle();
    fetchTopSavers();
    fetchPastWinners();
    // _logger.d(CodeFromFreq.getPastDayCode());
    // _logger.d(CodeFromFreq.getPastWeekCode());
    // _logger.d(CodeFromFreq.getPastMonthCode());
    _logger.d(event.type);
    _logger.d(isGameRedirected);
    if (event.type == "FPL" && isGameRedirected)
      BaseUtil.openModalBottomSheet(
        addToScreenStack: true,
        backgroundColor: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(SizeConfig.roundness32),
          topRight: Radius.circular(SizeConfig.roundness32),
        ),
        isScrollControlled: true,
        hapticVibrate: true,
        isBarrierDismissable: false,
        content: EventInstructionsModal(instructions: event.instructions),
      );
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
      case Constants.GAME_TYPE_FPL:
        {
          appbarTitle = "Fello Premier League";
          saverFreq = "daily";
          eventStandingsType = "FPL";
          actionTitle = "Play Cricket";
          break;
        }
      case Constants.BUG_BOUNTY:
        {
          appbarTitle = "Fello Bug Bounty";
          saverFreq = "monthly";
          eventStandingsType = "BUG_BOUNTY";
          showStandingsAndWinners = false;
          actionTitle = "Review";
          _winnerService.fetchBugBountyWinners();
          break;
        }
      case Constants.NEW_FELLO_UI:
        {
          appbarTitle = "New Fello App";
          saverFreq = "monthly";
          eventStandingsType = "NEW_FELLO";
          showStandingsAndWinners = false;
          actionTitle = "View";
          _winnerService.fetchNewFelloWinners();
          break;
        }
    }
    notifyListeners();
  }

  Future<EventModel> getSingleEventDetails(String eventType) async {
    EventModel event;
    final response = await _campaignRepo.getOngoingEvents();
    if (response.code == 200) {
      List<EventModel> ongoingEvents = response.model;
      // ongoingEvents.sort((a, b) => a.position.compareTo(b.position));
      ongoingEvents.forEach((element) {
        if (element.type == eventType) event = element;
      });
    }
    return event;
  }

  fetchTopSavers() async {
    ApiResponse response = await _getterRepo.getStatisticsByFreqGameTypeAndCode(
      freq: saverFreq,
      type: eventStandingsType,
    );
    if (response.code == 200) {
      currentParticipants = LeaderboardModel.fromMap(response.model).scoreboard;
      getUserRankIfAny();
    } else
      currentParticipants = [];
    notifyListeners();
  }

  fetchPastWinners() async {
    List<WinnersModel> winnerModels = await getPastWinners(
      event.type == "FPL"
          ? Constants.GAME_TYPE_FPL
          : Constants.GAME_TYPE_HIGHEST_SAVER,
      saverFreq,
    );
    if (winnerModels != null && winnerModels.isNotEmpty) {
      pastWinners = [];
      for (int i = 0; i < winnerModels.length; i++) {
        for (int j = 0; j < winnerModels[i].winners.length; j++) {
          pastWinners.add(
            PastHighestSaver.fromMap(
              winnerModels[i].winners[j],
              winnerModels[i].gametype,
              winnerModels[i].code,
            ),
          );
        }
      }
    } else
      pastWinners = [];

    updateWinnersTitle();
  }

  updateWinnersTitle() {
    if (pastWinners.length == 1)
      winnerTitle = winnerTitle.substring(0, winnerTitle.length - 1);
    notifyListeners();
  }

  Future<String> getWinnerDP(int index) async {
    String dpUrl = await _dbModel.getUserDP(pastWinners[index].userid);
    return dpUrl;
  }

  getUserRankIfAny() {
    if (currentParticipants != null && currentParticipants.isNotEmpty) {
      if (currentParticipants.firstWhere(
              (e) => e.userid == _userService.baseUser.uid,
              orElse: () => null) !=
          null) {
        int rank = currentParticipants
            .indexWhere((e) => e.userid == _userService.baseUser.uid);
        userRank = rank + 1;
      }
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

  Future<List<WinnersModel>> getPastWinners(
      String gameType, String freq) async {
    ApiResponse<List<WinnersModel>> response = await _getterRepo.getPastWinners(
      type: gameType,
      freq: freq,
    );
    if (response.code == 200) {
      return response.model;
    } else
      return [];
  }
}

class PastHighestSaver {
  double score;
  int amount;
  bool isMockUser;
  int flc;
  String userid;
  String username;
  String gameType;
  String code;

  PastHighestSaver(
      {this.score,
      this.userid,
      this.username,
      this.gameType,
      this.isMockUser,
      this.amount,
      this.flc,
      this.code});

  factory PastHighestSaver.fromMap(Winners map, String gameType, String code) {
    return PastHighestSaver(
        score: map.score.toDouble(),
        userid: map.userid,
        username: map.username,
        gameType: gameType,
        amount: map.amount,
        flc: map.flc,
        isMockUser: map.isMockUser,
        code: code);
  }

  @override
  String toString() =>
      'Winners(score: $score, userid: $userid, username: $username, gameType: $gameType, amount: $amount, isMockUser: $isMockUser, code: $code)';
}
