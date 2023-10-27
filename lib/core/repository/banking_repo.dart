import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/constants/cache_keys.dart';
import 'package:felloapp/core/model/signed_Image_url_model.dart';
import 'package:felloapp/core/model/user_kyc_data_model.dart';
import 'package:felloapp/core/model/verify_pan_response_model.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/service/cache_service.dart';
import 'package:felloapp/core/service/notifier_services/internal_ops_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/app_exceptions.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';
import 'package:image_picker/image_picker.dart';

class BankingRepository extends BaseRepo {
  final CustomLogger _logger = locator<CustomLogger>();
  final ApiPath _apiPaths = locator<ApiPath>();
  final _cacheService = CacheService();
  static const _banking = 'bankingOps';

  final _baseUrl = FlavorConfig.isDevelopment()
      ? "https://6iq5sy5tp8.execute-api.ap-south-1.amazonaws.com/dev"
      : "https://szqrjkwkka.execute-api.ap-south-1.amazonaws.com/prod";

  Future<ApiResponse<VerifyPanResponseModel>> verifyPan(
      {String? uid, String? panName, String? panNumber}) async {
    final Map<String, dynamic> body = {
      "uid": uid,
      "panName": panName,
      "panNumber": panNumber
    };

    try {
      final response = await APIService.instance.postData(
        _apiPaths!.kVerifyPan,
        body: body,
        cBaseUrl: _baseUrl,
        apiName: '$_banking/verifyPan',
      );

      _logger.d(response);
      VerifyPanResponseModel _verifyPanApiResponse =
          VerifyPanResponseModel.fromMap(response["data"]);

      if (_verifyPanApiResponse.flag!) {
        await CacheService.invalidateByKey(CacheKeys.USER);
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

      locator<InternalOpsService>().logFailure(
        userService.baseUser!.uid,
        FailType.UserDataCorrupted,
        {'message': "User data corrupted"},
      );
      return ApiResponse.withError(e.toString() ?? "Unable to verify pan", 400);
    }
  }

  Future<ApiResponse<SignedImageUrlModel>> getSignedImageUrl(
      String filename) async {
    final Map<String, String> body = {'fileName': filename};

    try {
      final response = await APIService.instance.postData(
        ApiPath.kGetSignedImageUrl(userService.baseUser!.uid!),
        body: body,
        cBaseUrl: _baseUrl,
        apiName: '$_banking/uploadImage',
      );
      SignedImageUrlModel responseData =
          SignedImageUrlModel.fromMap(response["data"]);
      return ApiResponse(model: responseData, code: 200);
    } catch (e) {
      _logger.e(e.toString());
      locator<InternalOpsService>().logFailure(
        userService.baseUser!.uid,
        FailType.SignedImageUploadFailed,
        {'message': "Signed Image url upload failed"},
      );
      return ApiResponse.withError(e.toString() ?? "Unable to verify pan", 400);
    }
  }

  Future<ApiResponse<bool>> uploadPanImageFile(
      String uploadUrl, XFile imageFile) async {
    final dio = Dio();
    try {
      await dio.put(
        uploadUrl,
        options: Options(
          headers: {'Content-Type': "image/${imageFile.name.split('.').last}"},
        ),
        data: await File(imageFile.path).readAsBytes(),
      );

      return ApiResponse(model: true, code: 200);
    } catch (e) {
      _logger.e(e.toString());
      await locator<InternalOpsService>().logFailure(
        userService.baseUser!.uid,
        FailType.PanImageUploadFailed,
        {'message': "Pan image upload failed"},
      );
      return ApiResponse.withError(
        e.toString(),
        400,
      );
    }
  }

  Future<ApiResponse<bool>> processForgeryUpload(String key) async {
    final Map<String, dynamic> body = {
      "key": key,
    };

    try {
      final response = await APIService.instance.postData(
        ApiPath.kForgeryUpload(userService.baseUser!.uid!),
        body: body,
        cBaseUrl: _baseUrl,
        apiName: '$_banking/forgeryImage',
      );

      _logger.d(response);
      return ApiResponse(model: true, code: 200);
    } on BadRequestException catch (e) {
      _logger.e(e.toString());
      return ApiResponse.withError(e.toString() ?? "Unable to verify pan", 400);
    } catch (e) {
      _logger.e(e.toString());
      return ApiResponse.withError(e.toString() ?? "Unable to verify pan", 400);
    }
  }

  Future<ApiResponse<UserKycDataModel>> getUserKycInfo() async {
    try {
      final response = await APIService.instance.getData(
        ApiPath.kGetPan(userService.baseUser!.uid!),
        cBaseUrl: _baseUrl,
        apiName: '$_banking/pan',
      );
      final UserKycDataModel panData =
          UserKycDataModel.fromMap(response["data"]);
      return ApiResponse(model: panData, code: 200);
    } catch (e) {
      logger.e(e.toString());
      locator<InternalOpsService>().logFailure(
        userService.baseUser!.uid,
        FailType.PanInfoFetchFailed,
        {'message': "User kyc fetch failed"},
      );
      return ApiResponse.withError(
          "Unable to fetch pan details at the moment", 400);
    }
  }

  Future<ApiResponse<bool>> verifyAugmontKyc() async {
    try {
      await APIService.instance.putData(
        ApiPath.verifyAugmontKyc,
        cBaseUrl: _baseUrl,
        body: {"uid": userService.baseUser!.uid},
        apiName: '$_banking/reVerifyPan',
      );

      return ApiResponse(model: true, code: 200);
    } catch (e) {
      logger.e(e.toString());
      unawaited(locator<InternalOpsService>().logFailure(
        userService.baseUser!.uid,
        FailType.AugmontKycVerificationFailed,
        {'message': "User Augmont kyc verification failed"},
      ));
      return ApiResponse.withError(
          "Unable to fetch pan details at the moment", 400);
    }
  }
}
