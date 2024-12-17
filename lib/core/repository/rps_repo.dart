import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/rps_model.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';

import '../../util/custom_logger.dart';

class RpsRepository extends BaseRepo {
  final CustomLogger _logger = locator<CustomLogger>();
  final String _baseUrl = FlavorConfig.isDevelopment()
      ? "https://lczsbr3cjl.execute-api.ap-south-1.amazonaws.com/dev"
      : "https://sdypt3fcnh.execute-api.ap-south-1.amazonaws.com/prod";

  static const _rps = 'rps';

  Future<ApiResponse<RpsData>> getRpsData(String fundType) async {
    try {
      final response = await APIService.instance.getData(
        ApiPath.rpsPath,
        queryParams: {
          "fundType": fundType,
        },
        cBaseUrl: _baseUrl,
        apiName: '$_rps/getRpsData',
      );
      if (response['data'] != null && response['data'] is List) {
        return const ApiResponse.withError(
          'No Data',
          500,
        );
      } else if (response['data'] != null) {
        return ApiResponse<RpsData>(
          model: RpsData.fromJson(response['data'] ?? {}),
          code: 200,
        );
      }
      return const ApiResponse.withError("No data found", 400);
    } catch (e) {
      _logger.e("getMatchesByStatus => ${e.toString()}");
      return ApiResponse.withError(
        e.toString(),
        400,
      );
    }
  }
}
