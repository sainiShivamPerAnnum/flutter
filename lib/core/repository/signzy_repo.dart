import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/transfer_amount_api_model.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/locator.dart';
import 'package:logger/logger.dart';

class SignzyRepository {
  final _logger = locator<Logger>();
  final _userService = locator<UserService>();
  final _apiPaths = locator<ApiPath>();

  Future<String> _getBearerToken() async {
    String token = await _userService.firebaseUser.getIdToken();
    _logger.d(token);

    return token;
  }

  Future<ApiResponse<TransferAmountApiResponseModel>> transferAmount(
      {String accountNo, String ifsc, String name, String mobile}) async {
    final Map<String, dynamic> body = {
      "accountNo": accountNo,
      "name": name,
      "mobile": mobile,
      "ifsc": ifsc
    };

    try {
      final String token = await _getBearerToken();

      final response = await APIService.instance
          .postData(_apiPaths.kAmountTransfer, body: body, token: token);

      TransferAmountApiResponseModel _transferAmountApiResponse =
          TransferAmountApiResponseModel.fromMap(response);

      return ApiResponse(model: _transferAmountApiResponse, code: 200);
    } catch (e) {
      _logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }
}
