import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/event_model.dart';
import 'package:felloapp/core/model/top_saver_model.dart';
import 'package:felloapp/core/model/winners_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/repository/statistics_repo.dart';
import 'package:felloapp/core/repository/winners_repo.dart';
import 'package:felloapp/core/service/events_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/code_from_freq.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';

class TopSaverViewModel extends BaseModel {
  final _logger = locator<CustomLogger>();
  final _dbModel = locator<DBModel>();
  final _userService = locator<UserService>();
  final _statsRepo = locator<StatisticsRepository>();
  final _winnersRepo = locator<WinnersRepository>();

  final eventService = EventService();
  //Local variables

  String appbarTitle = "Top Saver";
  SaverType saverType = SaverType.DAILY;
  String saverFreq = "daily";
  String freqCode;
  int _userRank = 0;
  String winnerTitle = "Past Winners";
  EventModel event;

  List<TopSavers> currentParticipants;
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

  init(String eventType) async {
    setState(ViewState.Busy);
    event = await _dbModel.getSingleEventDetails(eventType);
    setState(ViewState.Idle);
    saverType = eventService.getEventType(event.type);
    _logger
        .d("Top Saver Viewmodel initialised with saver type : ${event.type}");
    setAppbarTitle();
    fetchTopSavers();
    fetchPastWinners();
    // _logger.d(CodeFromFreq.getPastDayCode());
    // _logger.d(CodeFromFreq.getPastWeekCode());
    // _logger.d(CodeFromFreq.getPastMonthCode());
  }

  setAppbarTitle() {
    switch (saverType) {
      case SaverType.DAILY:
        {
          appbarTitle = "Saver of the Day";
          saverFreq = "daily";
          // winnerTitle = "Yesterday's Winners";
          break;
        }
      case SaverType.WEEKLY:
        {
          appbarTitle = "Saver of the Week";
          saverFreq = "weekly";
          // winnerTitle = "Last Week's Winners";
          break;
        }
      case SaverType.MONTHLY:
        {
          appbarTitle = "Saver of the Month";
          saverFreq = "monthly";
          // winnerTitle = "Last Month's Winners";
          break;
        }
      case SaverType.FPL:
        {
          appbarTitle = "Fello Premier League";
          saverFreq = "daily";
          // winnerTitle = "Last Month's Winners";
          break;
        }
    }
    notifyListeners();
  }

  fetchTopSavers() async {
    ApiResponse<TopSaversModel> response = await _statsRepo.getTopSavers(
        saverFreq,
        type: event.type == "FPL" ? "FPL" : "HIGHEST_SAVER");
    if (response != null &&
        response.model != null &&
        response.model.scoreboard != null) {
      currentParticipants = response.model.scoreboard;
      freqCode = response.model.code;
      getUserRankIfAny();
    } else
      currentParticipants = [];
    notifyListeners();
  }

  fetchPastWinners() async {
    ApiResponse<List<WinnersModel>> response =
        await _winnersRepo.getPastWinners(
            event.type == "FPL"
                ? Constants.GAME_TYPE_FPL
                : Constants.GAME_TYPE_HIGHEST_SAVER,
            saverFreq);
    if (response != null &&
        response.model != null &&
        response.model.isNotEmpty) {
      pastWinners = [];
      for (int i = 0; i < response.model.length; i++) {
        for (int j = 0; j < response.model[i].winners.length; j++) {
          pastWinners.add(PastHighestSaver.fromMap(response.model[i].winners[j],
              response.model[i].gametype, response.model[i].code));
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
    switch (saverType) {
      case SaverType.DAILY:
        {
          return CodeFromFreq.getDayFromCode(code);
        }
      case SaverType.WEEKLY:
        {
          return CodeFromFreq.getWeekFromCode(code);
        }
      case SaverType.MONTHLY:
        {
          return CodeFromFreq.getMonthFromCode(code);
        }
      case SaverType.FPL:
        {
          return CodeFromFreq.getDayFromCode(code);
        }
    }
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
