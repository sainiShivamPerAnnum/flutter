import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/others/events/topSavers/daySaver/day_saver_view.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';

class TopSaverViewModel extends BaseModel {
  final _logger = locator<CustomLogger>();
  init(SaverType type) {
    _logger.d(
        "Top Saver Viewmodel initialised with saver type : ${type.toString()}");
  }
}
