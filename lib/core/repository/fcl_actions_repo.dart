import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/flc_pregame_model.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/locator.dart';
import 'package:logger/logger.dart';

class FlcActionsRepo {
  final _userService = locator<UserService>();
  final _apiPaths = locator<ApiPath>();
  final _logger = locator<Logger>();

  Future<ApiResponse<FlcModel>> getCoinBalance() async {
    try {
      final response = await APIService.instance.getData(
          _apiPaths.kGetCoinBalance,
          queryParams: {'user_id': _userService.baseUser.uid});

      _logger.d(response.toString());

      return ApiResponse(model: FlcModel.fromMap(response), code: 200);
    } catch (e) {
      _logger.e(e);
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<FlcModel>> substractFlc() async {
    Map<String, dynamic> _body = {
      "user_id": _userService.baseUser.uid,
      "flcAmount": -10,
      "type": "SUBTRACT",
      "subType": "GM_CRIC2020"
    };

    try {
      final response = await APIService.instance
          .postData(_apiPaths.kSubstractFlcPreGameApi, body: _body);
      _logger.d(response.toString());
      return ApiResponse(model: FlcModel.fromMap(response), code: 200);
    } catch (e) {
      _logger.e(e);
      return ApiResponse.withError(e, 400);
    }
  }
}
