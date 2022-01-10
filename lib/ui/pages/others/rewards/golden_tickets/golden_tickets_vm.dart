import 'package:felloapp/core/model/golden_ticket_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/locator.dart';

class GoldenTicketsViewModel extends BaseModel {
  final _userService = locator<UserService>();
  final _dbModel = locator<DBModel>();
  List<GoldenTicket> _goldenTicketList;
  List<GoldenTicket> get goldenTicketList => this._goldenTicketList;

  set goldenTicketList(List<GoldenTicket> value) {
    this._goldenTicketList = value;
    notifyListeners();
  }

  void init() {
    getGoldenTickets();
  }

  void getGoldenTickets() async {
    goldenTicketList =
        await _dbModel.getGoldenTickets(_userService.baseUser.uid);
  }
}
