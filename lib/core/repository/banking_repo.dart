import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/verify_pan_response_model.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';

class BankingRepository extends BaseRepo {
  final _logger = locator<CustomLogger>();
  final _userService = locator<UserService>();
  final _apiPaths = locator<ApiPath>();

  final _baseUrl = FlavorConfig.isDevelopment()
      ? "https://cqfb61p1m2.execute-api.ap-south-1.amazonaws.com/dev"
      : "";

  Future<String> _getBearerToken() async {
    String token = await _userService.firebaseUser.getIdToken();
    _logger.d(token);

    return token;
  }

  Future<ApiResponse<VerifyPanResponseModel>> verifyPan(
      {String uid, String panName, String panNumber}) async {
    final Map<String, dynamic> body = {
      "uid": uid,
      "panName": panName,
      "panNumber": panNumber
    };

    try {
      final String token = await _getBearerToken();

      final response = await APIService.instance.postData(_apiPaths.kVerifyPan,
          body: body, token: token, cBaseUrl: _baseUrl);
      _logger.d(response);
      VerifyPanResponseModel _verifyPanApiResponse =
          VerifyPanResponseModel.fromMap(response["data"]);
      if (_verifyPanApiResponse.flag) {
        return ApiResponse(model: _verifyPanApiResponse, code: 200);
      } else {
        return ApiResponse(
            model: _verifyPanApiResponse,
            code: 400,
            errorMessage: response["message"]);
      }
    } catch (e) {
      _logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }
}
