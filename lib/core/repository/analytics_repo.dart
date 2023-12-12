import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/service/api.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';

import 'base_repo.dart';

class AnalyticsRepository extends BaseRepo {
  final Api _api = locator<Api>();
  final ApiPath _apiPaths = locator<ApiPath>();
  // final InternalOpsService? _internalOpsService = locator<InternalOpsService>();
  final _baseUrl = FlavorConfig.isDevelopment()
      ? "https://8ug3cm8yhb.execute-api.ap-south-1.amazonaws.com/dev"
      : "https://d8ssa0evtd.execute-api.ap-south-1.amazonaws.com/prod";

  static const _analytics = 'analytics';

  Future<ApiResponse<Map<String, dynamic>>> setInstallInfo(
      BaseUser baseUser,
      String? installReferrerData,
      String? appSetId,
      String? deviceId,
      String? osVersion,
      String? advertiserId) async {
    try {
      final _body = {
        'uid': baseUser.uid,
        'installReferrer': installReferrerData,
        'asid': appSetId,
        'aifa': advertiserId,
        'version': osVersion,
        'andi': deviceId,
      };

      logger.d('CHECK BODY: $_body');

      final res = await APIService.instance.postData(
        _apiPaths.kSetInstallInfo,
        cBaseUrl: _baseUrl,
        body: _body,
        apiName: '$_analytics/setInstallInfo',
      );
      logger.d(res);
      final responseData = res['data'];
      logger.d(responseData);
      return ApiResponse(
          code: 200, model: {"flag": responseData['flag']}); //TODO
    } catch (e) {
      logger.d(e);
      return ApiResponse.withError(
          e.toString() ?? "Unable to send and set install information", 400);
    }
  }
}
