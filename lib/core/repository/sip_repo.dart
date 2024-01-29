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

class SipRepository extends BaseRepo {
  final CustomLogger _logger = locator<CustomLogger>();
  final ApiPath _apiPaths = locator<ApiPath>();
  final _cacheService = CacheService();
  // static const _banking = 'sip';

  // final _baseUrl = FlavorConfig.isDevelopment()
  //     ? "https://6iq5sy5tp8.execute-api.ap-south-1.amazonaws.com/dev"
  //     : "https://szqrjkwkka.execute-api.ap-south-1.amazonaws.com/prod";

  Future<ApiResponse<SignedImageUrlModel>> getSignedImageUrl(
      String filename) async {
    final Map<String, String> body = {'fileName': filename};

    try {
      final response = await APIService.instance.postData(
        '',
        // ApiPath.kGetSignedImageUrl(userService.baseUser!.uid!),
        body: body,
        cBaseUrl: '',
        apiName: 'sip/getflowdata',
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
}
