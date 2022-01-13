import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';

class GoldenMilestonesViewModel extends BaseModel {
  final _dbModel = locator<DBModel>();
  final _logger = locator<CustomLogger>();

  init() {
    fetchMilestones();
  }

  fetchMilestones() async {
    var response = await _dbModel.getMilestonesList();
    _logger.d(response);
  }
}
