import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';

import '../../util/custom_logger.dart';

class ReportRepository extends BaseRepo {
  final CustomLogger _logger = locator<CustomLogger>();
  final String _baseUrl = FlavorConfig.isDevelopment()
      ? "https://w16a2854kb.execute-api.ap-south-1.amazonaws.com/dev"
      : "https://5l0eh4q438.execute-api.ap-south-1.amazonaws.com/prod";

  static const _report = 'reports';

  Future<ApiResponse<Map<String, dynamic>>> getReport(String? txnId) async {
    try {
      if (txnId == null) return ApiResponse.withError("No data found", 400);
      final response = await APIService.instance.getData(
        ApiPath.augmontReport(txnId),
        cBaseUrl: _baseUrl,
        apiName: '$_report/augmontTransactionByID',
      );
      if (response['data'] != null) {
        return ApiResponse<Map<String, dynamic>>(
          model: response['data'],
          code: 200,
        );
      }

      return ApiResponse.withError("No data found", 400);
    } catch (e) {
      _logger.e("getMatchesByStatus => ${e.toString()}");
      return ApiResponse.withError(
        e.toString(),
        400,
      );
    }
  }
}
