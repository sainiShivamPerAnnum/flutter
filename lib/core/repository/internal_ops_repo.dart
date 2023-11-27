import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/logger.dart';

import 'base_repo.dart';

class InternalOpsRepository extends BaseRepo {
  final _baseUrl = FlavorConfig.isDevelopment()
      ? 'https://zul9m5q4t9.execute-api.ap-south-1.amazonaws.com/dev'
      : 'https://4ch7btxcuj.execute-api.ap-south-1.amazonaws.com/prod';

  final Log log = const Log("DBModel");
  static const _internalOps = 'internalOPS';

  Future<ApiResponse<bool>> logFailure(
    String? userId,
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
        headers: {
          'authKey':
              '.c;a/>12-1-x[/2130x0821x/0-=0.-x02348x042n23x9023[4np0823wacxlonluco3q8',
        },
        apiName: '$_internalOps/logFailure',
      );
      return ApiResponse<bool>(model: true, code: 200);
    } catch (e) {
      log.error(e.toString());
      return ApiResponse.withError("Logging failure", 400);
    }
  }
}
