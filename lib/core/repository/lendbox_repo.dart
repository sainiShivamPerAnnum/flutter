import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/util/api_response.dart';

import '../../util/flavor_config.dart';

class LendboxRepo extends BaseRepo {
  final _baseUrl = FlavorConfig.isDevelopment()
      ? 'https://lczsbr3cjl.execute-api.ap-south-1.amazonaws.com/dev'
      : 'https://sdypt3fcnh.execute-api.ap-south-1.amazonaws.com/prod';

  Future<ApiResponse<String>> createWithdrawal(
    int amount,
    String payoutSourceId,
  ) async {
    try {
      final uid = userService.baseUser.uid;
      final String bearer = await getBearerToken();

      final response = await APIService.instance.postData(
        ApiPath.lendboxWithdrawal(uid),
        body: {
          "amount": amount,
          "payoutSourceId": payoutSourceId,
        },
        token: bearer,
        cBaseUrl: _baseUrl,
      );

      final data = response['data'];
      return ApiResponse(model: data['txnId'], code: 200);
    } catch (e) {
      logger.e(e);
      return ApiResponse.withError(e.toString(), 400);
    }
  }
}
