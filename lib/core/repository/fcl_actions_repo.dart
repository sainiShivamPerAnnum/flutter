import 'package:felloapp/core/model/flc_pregame_model.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/locator.dart';
import 'package:logger/logger.dart';

class FclActionsRepo {
  final _userService = locator<UserService>();
  final _logger = locator<Logger>();

  Future<ApiResponse<FlcModel>> substractFlc() async {
    const String stage = "dev";
    const String url = "/felloCoins/$stage/api/felloCoin/updateWallet/preGame";
    Map<String, dynamic> _body = {
      "user_id": _userService.baseUser.uid,
      "flcAmount": -10,
      "type": "SUBTRACT",
      "subType": "GM_CRIC2020"
    };
    try {
      final response = await APIService.instance.postData(url, body: _body);
      _logger.d(response.toString());
      return ApiResponse(model: FlcModel.fromMap(response), code: 200);
    } catch (e) {
      _logger.e(e);
      return ApiResponse.withError(e, 400);
    }
  }
}
