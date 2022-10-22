import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/enums/prize_claim_choice.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/util/api_response.dart';

import '../../util/flavor_config.dart';

class PrizingRepo extends BaseRepo {
  final _baseUrl = FlavorConfig.isDevelopment()
      ? 'https://4itmncow4c.execute-api.ap-south-1.amazonaws.com/dev'
      : 'https://3606ojnwl3.execute-api.ap-south-1.amazonaws.com/prod';

  Future<ApiResponse<String>> claimPrize(
    double amount,
    PrizeClaimChoice claimChoice,
  ) async {
    try {
      final uid = userService.baseUser.uid;
      final String bearer = await getBearerToken();

      final response = await APIService.instance.postData(
        ApiPath.claimPrize,
        body: {
          "uid": uid,
          "amount": amount,
          "redeemType": claimChoice.name,
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
