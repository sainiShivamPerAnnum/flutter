import 'package:felloapp/core/model/top_saver_model.dart';
import 'package:felloapp/core/repository/statistics_repo.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/others/events/topSavers/daySaver/day_saver_view.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';

class TopSaverViewModel extends BaseModel {
  final _logger = locator<CustomLogger>();
  final _statsRepo = locator<StatisticsRepository>();

  //Local variables

  String appbarTitle = "Top Saver";
  SaverType saverType;
  String saverFreq;

  List<TopSavers> currentParticipants;

  init(SaverType type) {
    saverType = type;
    _logger.d(
        "Top Saver Viewmodel initialised with saver type : ${type.toString()}");
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
    notifyListeners();
  }
}
