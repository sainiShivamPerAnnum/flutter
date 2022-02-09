import 'package:felloapp/core/model/event_model.dart';
import 'package:felloapp/core/model/top_saver_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/repository/statistics_repo.dart';
import 'package:felloapp/core/service/events_service.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/others/events/topSavers/daySaver/day_saver_view.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';

class TopSaverViewModel extends BaseModel {
  final _logger = locator<CustomLogger>();
  final _dbModel = locator<DBModel>();
  final _userService = locator<UserService>();
  final _statsRepo = locator<StatisticsRepository>();
  final eventService = EventService();
  //Local variables

  String appbarTitle = "Top Saver";
  SaverType saverType;
  String saverFreq;
  String freqCode;

  List<TopSavers> currentParticipants;

  init(EventModel event) {
    saverType = eventService.getEventType(event.type);
    _logger
        .d("Top Saver Viewmodel initialised with saver type : ${event.type}");
    setAppbarTitle();
    fetchTopSavers();
  }

  setAppbarTitle() {
    switch (saverType) {
      case SaverType.DAILY:
        {
          appbarTitle = "Saver of the Day";
          saverFreq = "daily";
          break;
        }
      case SaverType.WEEKLY:
        {
          appbarTitle = "Saver of the Week";
          saverFreq = "weekly";
          break;
        }
      case SaverType.MONTHLY:
        {
          appbarTitle = "Saver of the Month";
          saverFreq = "monthly";
          break;
        }
    }
    notifyListeners();
  }

  fetchTopSavers() async {
    ApiResponse<TopSaversModel> response =
        await _statsRepo.getTopSavers(saverFreq);
    currentParticipants = response.model.scoreboard;
    freqCode = response.model.code;
    notifyListeners();
  }

  Future<String> getWinnerDP() async {
    String dpUrl = await _dbModel.getUserDP(_userService.baseUser.uid);
    return dpUrl;
  }
}
