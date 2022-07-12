import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/top_winners_model.dart';
import 'package:felloapp/core/service/api.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';

class WinnersRepository {
  final _userService = locator<UserService>();
  final _api = locator<Api>();
  final _logger = locator<CustomLogger>();
  final _apiPaths = locator<ApiPath>();

  Future<String> _getBearerToken() async {
    String token = await _userService.firebaseUser.getIdToken();
    _logger.d(token);

    return token;
  }

  Future<ApiResponse<List<String>>> getTopWinners() async {
    try {
      final String _bearer = await _getBearerToken();
      final _apiResponse = await APIService.instance
          .getData(_apiPaths.kTopWinners, token: _bearer);
      TopWinnersModel _topWinnersModel = TopWinnersModel.fromMap(_apiResponse);

      return ApiResponse(model: _topWinnersModel.currentTopWinners, code: 200);
    } catch (e) {
      _logger.e(e);
      return ApiResponse.withError(e.toString(), 400);
    }
  }
}
