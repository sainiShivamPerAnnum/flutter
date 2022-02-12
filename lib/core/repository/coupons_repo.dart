import 'package:felloapp/core/service/api.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';

class StatisticsRepository {
  final _api = locator<Api>();
  final _logger = locator<CustomLogger>();

  Future<ApiResponse<EligibleCouponResponseModel>> getEligibleCoupon() async {
   
    try {
      return ApiResponse(model: _responseModel, code: 200);
    } catch (e) {
      return ApiResponse.withError(e.toString(), 400);
    }
  }
}
