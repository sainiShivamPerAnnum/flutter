import 'dart:io';
import 'dart:typed_data';
import 'package:felloapp/core/model/user_kyc_data_model.dart';
import 'package:felloapp/core/service/payments/bank_and_pan_service.dart';
import 'package:felloapp/util/app_exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/constants/cache_keys.dart';
import 'package:felloapp/core/model/signed_Image_url_model.dart';
import 'package:felloapp/core/model/verify_pan_response_model.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/service/cache_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';
import 'package:http_parser/http_parser.dart';

class BankingRepository extends BaseRepo {
  final _logger = locator<CustomLogger>();
  final _apiPaths = locator<ApiPath>();
  final _cacheService = new CacheService();
  final _bankAndPanService = locator<BankAndPanService>();

  final _baseUrl = FlavorConfig.isDevelopment()
      ? "https://cqfb61p1m2.execute-api.ap-south-1.amazonaws.com/dev"
      : "https://szqrjkwkka.execute-api.ap-south-1.amazonaws.com/prod";

  Future<ApiResponse<VerifyPanResponseModel>> verifyPan(
      {String uid, String panName, String panNumber}) async {
    final Map<String, dynamic> body = {
      "uid": uid,
      "panName": panName,
      "panNumber": panNumber
    };

    try {
      final String token = await getBearerToken();
      final response = await APIService.instance.postData(
        _apiPaths.kVerifyPan,
        body: body,
        token: token,
        cBaseUrl: _baseUrl,
      );

      _logger.d(response);
      VerifyPanResponseModel _verifyPanApiResponse =
          VerifyPanResponseModel.fromMap(response["data"]);

      if (_verifyPanApiResponse.flag) {
        await _cacheService.invalidateByKey(CacheKeys.USER);
        return ApiResponse(model: _verifyPanApiResponse, code: 200);
      } else {
        return ApiResponse(
          model: _verifyPanApiResponse,
          code: 400,
          errorMessage: response["message"],
        );
      }
    } catch (e) {
      _logger.e(e.toString());
      return ApiResponse.withError(
          e?.toString() ?? "Unable to verify pan", 400);
    }
  }

  Future<ApiResponse<SignedImageUrlModel>> getSignedImageUrl(
      String filename) async {
    final Map<String, String> body = {'fileName': filename};

    try {
      final String token = await getBearerToken();
      final response = await APIService.instance.postData(
        ApiPath.kGetSignedImageUrl(userService.baseUser.uid),
        body: body,
        token: token,
        cBaseUrl: _baseUrl,
      );
      SignedImageUrlModel responseData =
          SignedImageUrlModel.fromMap(response["data"]);
      return ApiResponse(model: responseData, code: 200);
    } catch (e) {
      _logger.e(e.toString());
      return ApiResponse.withError(
          e?.toString() ?? "Unable to verify pan", 400);
    }
  }

  Future<ApiResponse<bool>> uploadPanImageFile(
      String uploadUrl, XFile imageFile) async {
    try {
      var response = await http.put(Uri.parse(uploadUrl),
          body: await File(imageFile.path).readAsBytes(),
          headers: {'Content-Type': "image/${imageFile.name.split('.').last}"});
      if (response.statusCode == 200) {
        return ApiResponse(model: true, code: 200);
      }
      return ApiResponse.withError(response.body.toString(), 400);
    } catch (e) {
      _logger.e(e.toString());
      return ApiResponse.withError(
          e?.toString() ?? "Unable to verify pan", 400);
    }
  }

  Future<ApiResponse<bool>> processForgeryUpload(String key) async {
    final Map<String, dynamic> body = {
      "key": key,
    };

    try {
      final String token = await getBearerToken();
      final response = await APIService.instance.postData(
        ApiPath.kForgeryUpload(userService.baseUser.uid),
        body: body,
        token: token,
        cBaseUrl: _baseUrl,
      );

      _logger.d(response);
      return ApiResponse(model: true, code: 200);
    } on BadRequestException catch (e) {
      _logger.e(e.toString());
      return ApiResponse.withError(
          e?.toString() ?? "Unable to verify pan", 400);
    } catch (e) {
      _logger.e(e.toString());
      return ApiResponse.withError(
          e?.toString() ?? "Unable to verify pan", 400);
    }
  }

  Future<ApiResponse<UserKycDataModel>> getUserKycInfo() async {
    if (_bankAndPanService.userKycData != null)
      return ApiResponse(model: _bankAndPanService.userKycData, code: 200);
    try {
      final String token = await getBearerToken();
      final response = await APIService.instance.getData(
        ApiPath.kGetPan(userService.baseUser.uid),
        token: token,
        cBaseUrl: _baseUrl,
      );
      final UserKycDataModel panData =
          UserKycDataModel.fromMap(response["data"]);
      if (panData.ocrVerified != null && panData.ocrVerified) {
        _bankAndPanService.userPan = panData.pan;
        _bankAndPanService.userKycData = panData;
        userService.setMyUserName(panData.name);
      }
      _logger.d(response);

      return ApiResponse(model: panData, code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(
          "Unable to fetch pan details at the moment", 400);
    }
  }
}
