import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/logger.dart';

import 'base_repo.dart';

class InternalOpsRepository extends BaseRepo {
  final _baseUrl = FlavorConfig.isDevelopment()
      ? 'https://qdp0idzhjc.execute-api.ap-south-1.amazonaws.com/dev'
      : '';

  final Log log = new Log("DBModel");

  Future<ApiResponse<bool>> logFailure(
    String userId,
    String type,
    Map<String, dynamic> dMap,
  ) async {
    try {
      await APIService.instance.postData(
        ApiPath.failureReport,
        body: {
          'type': type,
          'report': dMap,
        },
        cBaseUrl: _baseUrl,
      );
      return ApiResponse<bool>(model: true, code: 200);
    } catch (e) {
      log.error(e.toString());
      return ApiResponse.withError("Logging failure", 400);
    }
  }
}
