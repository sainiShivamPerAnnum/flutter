import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/golden_ticket_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/api.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';

class GoldenTicketsViewModel extends BaseModel {
  final _userService = locator<UserService>();
  // final _api = locator<Api>();
  final _logger = locator<CustomLogger>();
  final _apiPaths = locator<ApiPath>();
  final _dbModel = locator<DBModel>();
  List<GoldenTicket> _goldenTicketList;
  List<GoldenTicket> _arrangedGoldenTicketList;

  List<GoldenTicket> get arrangedGoldenTicketList =>
      this._arrangedGoldenTicketList;

  List<GoldenTicket> get goldenTicketList => this._goldenTicketList;

  set goldenTicketList(List<GoldenTicket> value) {
    this._goldenTicketList = value;
    notifyListeners();
  }

  set arrangedGoldenTicketList(List<GoldenTicket> value) {
    this._arrangedGoldenTicketList = value;
    notifyListeners();
  }

  void init() {
    getGoldenTickets();
  }

  Future<void> getGoldenTickets() async {
    goldenTicketList =
        await _dbModel.getGoldenTickets(_userService.baseUser.uid);
    arrangeGoldenTickets();
    notifyListeners();
  }

  Future<String> _getBearerToken() async {
    String token = await _userService.firebaseUser.getIdToken();
    _logger.d(token);

    return token;
  }

  arrangeGoldenTickets() {
    arrangedGoldenTicketList = [];
    goldenTicketList.sort((a, b) => b.createdOn.compareTo(a.createdOn));
    goldenTicketList.forEach((e) {
      if (e.redeemedTimestamp == null) {
        arrangedGoldenTicketList.add(e);
      }
    });
    goldenTicketList.forEach((e) {
      if (e.redeemedTimestamp != null &&
          e.rewards != null &&
          e.rewards.isNotEmpty) {
        arrangedGoldenTicketList.add(e);
      }
    });
  }

  redeemTicket(String gtId) async {
    Map<String, dynamic> _body = {
      "uid": _userService.baseUser.uid,
      "gtId": gtId
    };
    try {
      final String _bearer = await _getBearerToken();
      final _apiResponse = await APIService.instance
          .postData(_apiPaths.kRedeemGtReward, token: _bearer, body: _body);
      _logger.d(_apiResponse.toString());
      await getGoldenTickets();
    } catch (e) {
      _logger.e(e);
    }
  }
}
