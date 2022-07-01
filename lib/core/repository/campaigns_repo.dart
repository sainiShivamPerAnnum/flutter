import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/constants/cache_keys.dart';
import 'package:felloapp/core/enums/ttl.dart';
import 'package:felloapp/core/model/event_model.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/service/cache_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/flavor_config.dart';

import 'base_repo.dart';

class CampaignRepo extends BaseRepo {
  final _cacheService = new CacheService();
  final _baseUrl = FlavorConfig.isDevelopment()
      ? "https://rco4comkpa.execute-api.ap-south-1.amazonaws.com"
      : "https://l4aighxmj3.execute-api.ap-south-1.amazonaws.com";

  Future<ApiResponse<List<EventModel>>> getOngoingEvents() async {
    List<EventModel> events = [];
    try {
      final String _uid = userService.baseUser.uid;
      final _token = await getBearerToken();
      final _queryParams = {"uid": _uid};

      return await _cacheService.cachedApi(
          CacheKeys.CAMPAIGNS,
          TTL.TWO_HOURS,
          () => APIService.instance.getData(
                ApiPath().kOngoingCampaigns,
                token: _token,
                cBaseUrl: _baseUrl,
                queryParams: _queryParams,
              ), (response) {
        final responseData = response["data"];
        logger.d(responseData);
        if (responseData['status'] == true) {
          responseData["campaigns"].forEach((e) {
            events.add(EventModel.fromMap(e));
          });
        }
        return ApiResponse<List<EventModel>>(model: events, code: 200);
      });
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError("Unable to fetch campaings", 400);
    }
  }
}
