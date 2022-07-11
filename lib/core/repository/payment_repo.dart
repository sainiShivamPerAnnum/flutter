import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/flavor_config.dart';

class PaymentRepository extends BaseRepo {
  final _baseUrl = FlavorConfig.isDevelopment()
      ? 'https://wd7bvvu7le.execute-api.ap-south-1.amazonaws.com/dev'
      : '';

  Future<ApiResponse<double>> getNonWithdrawableAugGoldQuantity() async {
    try {
      final quntityResponse = await APIService.instance.getData(
        ApiPath.getWithdrawableGoldQuantity(
          this.userService.baseUser.uid,
        ),
        cBaseUrl: _baseUrl,
      );

      final quantity = quntityResponse["data"]["quantity"];
      return ApiResponse(model: quantity, code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError("Unable to fetch QUNTITY", 400);
    }
  }
}
