import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/transfer_amount_api_model.dart';
import 'package:felloapp/core/model/verify_amount_api_response_model.dart';
import 'package:felloapp/core/model/verify_pan_response_model.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';

class SignzyRepository extends BaseRepo {
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
        return ApiResponse(model: _verifyPanApiResponse, code: 400);
      }
    } catch (e) {
      _logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<TransferAmountApiResponseModel>> transferAmount(
      {String uid,
      String accountNo,
      String ifsc,
      String name,
      String mobile}) async {
    final Map<String, dynamic> body = {
      "accountNo": accountNo,
      "name": name,
      "mobile": mobile,
      "ifsc": ifsc
    };

    try {
      final String token = await _getBearerToken();

      final response = await APIService.instance.postData(
          _apiPaths.kAmountTransfer,
          body: body,
          token: token,
          cBaseUrl: _baseUrl);

      TransferAmountApiResponseModel _transferAmountApiResponse =
          TransferAmountApiResponseModel.fromMap(response['data']);
      if (_transferAmountApiResponse.flag) {
        return ApiResponse(model: _transferAmountApiResponse, code: 200);
      } else {
        return ApiResponse(model: _transferAmountApiResponse, code: 400);
      }
    } catch (e) {
      _logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<bool>> verifyAmount({String uid, String signzyId}) async {
    final Map<String, dynamic> body = {"amount": 1.01, "signzyId": signzyId};

    try {
      final String token = await _getBearerToken();

      final response = await APIService.instance.postData(
          _apiPaths.kVerifyTransfer,
          body: body,
          token: token,
          cBaseUrl: _baseUrl);
      return ApiResponse(model: true, code: 200);
      // VerifyAmountApiResponseModel _verifyAmountApiResponse =
      //     VerifyAmountApiResponseModel.fromMap(response['data']);
      // if (_verifyAmountApiResponse.flag) {
      //   return ApiResponse(model: _verifyAmountApiResponse, code: 200);
      // } else {
      //   return ApiResponse(model: _verifyAmountApiResponse, code: 400);
      // }
    } catch (e) {
      _logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future updateBankDetails(
      {String bankAccno, String bankIfsc, String bankAccHolderName}) async {
    final Map<String, dynamic> body = {
      "aAccNo": bankAccno,
      "aBankHolderName": bankAccHolderName,
      "aIfsc": bankIfsc
    };

    try {
      final String token = await getBearerToken();

      final response = await APIService.instance.postData(
          ApiPath.kUpdateBankDetails(userService.baseUser.uid),
          body: body,
          token: token,
          cBaseUrl: _baseUrl);
      _logger.d(response);
    } catch (e) {
      _logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }
}
