import 'package:felloapp/core/model/event_model.dart';
import 'package:felloapp/core/model/top_saver_model.dart';
import 'package:felloapp/core/model/winners_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/repository/statistics_repo.dart';
import 'package:felloapp/core/repository/winners_repo.dart';
import 'package:felloapp/core/service/events_service.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/api_response.dart';
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
  String winnerTitle = "Past Winners";

  List<TopSavers> currentParticipants;
  List<Winners> _pastWinners;

  List<Winners> get pastWinners => _pastWinners;

  set pastWinners(List<Winners> value) {
    _pastWinners = value;
    notifyListeners();
  }

  init(EventModel event) {
    saverType = eventService.getEventType(event.type);
    _logger
        .d("Top Saver Viewmodel initialised with saver type : ${event.type}");
    setAppbarTitle();
    fetchTopSavers();
    fetchPastWinners();
  }

  setAppbarTitle() {
    switch (saverType) {
      case SaverType.DAILY:
        {
          appbarTitle = "Saver of the Day";
          saverFreq = "daily";
          winnerTitle = "Yesterday's Winners";
          break;
        }
      case SaverType.WEEKLY:
        {
          appbarTitle = "Saver of the Week";
          saverFreq = "weekly";
          winnerTitle = "Last Week's Winners";
          break;
        }
      case SaverType.MONTHLY:
        {
          appbarTitle = "Saver of the Month";
          saverFreq = "monthly";
          winnerTitle = "Last Month's Winners";
          break;
        }
    }
    notifyListeners();
  }

  fetchTopSavers() async {
    ApiResponse<TopSaversModel> response =
        await _statsRepo.getTopSavers(saverFreq);
    if (response != null &&
        response.model != null &&
        response.model.scoreboard != null)
      currentParticipants = response.model.scoreboard;
    freqCode = response.model.code;
    notifyListeners();
  }

  fetchPastWinners() async {
    ApiResponse<WinnersModel> response = await _winnersRepo.getWinners(
        Constants.GAME_TYPE_HIGHEST_SAVER, saverFreq);
    if (response != null &&
        response.model != null &&
        response.model.winners != null) pastWinners = response.model.winners;
  }

  Future<String> getWinnerDP(int index) async {
    //dummy code start----------------------------
    // String uid = _userService.baseUser.uid;
    // switch (pos) {
    //   case 1:
    //     uid = _userService.baseUser.uid;
    //     break;
    //   case 2:
    //     uid = "bztFiwT6yXX4xVPT9qtMV1rhP2q2";
    //     break;
    //   case 3:
    //     uid = "s10wlnUFbYN9VS8BHQeowQ8Murr1";
    //     break;
    //   default:
    //     uid = "";
    // }
    // String dpUrl = await _dbModel.getUserDP(uid);
    //dummy code end ------

    String dpUrl = await _dbModel.getUserDP(pastWinners[index].userid);
    return dpUrl;
  }
}
