import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/others/events/topSavers/daySaver/day_saver_view.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';

class TopSaverViewModel extends BaseModel {
  final _logger = locator<CustomLogger>();

  //Local variables

  String appbarTitle = "Top Saver";
  SaverType saverType;

  init(SaverType type) {
    saverType = type;
    _logger.d(
        "Top Saver Viewmodel initialised with saver type : ${type.toString()}");
    setAppbarTitle();
  }

  setAppbarTitle() {
    switch (saverType) {
      case SaverType.DAILY:
        {
          appbarTitle = "Saver of the Day";
          break;
        }
      case SaverType.WEEKLY:
        {
          appbarTitle = "Saver of the Week";
          break;
        }
      case SaverType.MONTHLY:
        {
          appbarTitle = "Saver of the Month";
          break;
        }
    }
    notifyListeners();
  }
}
