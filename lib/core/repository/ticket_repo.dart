import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/daily_pick_model.dart';
import 'package:felloapp/core/model/tambola_ticket_model.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/util/api_response.dart';

import '../../util/flavor_config.dart';
import '../constants/cache_id.dart';
import '../enums/ttl.dart';
import '../model/flc_pregame_model.dart';
import '../service/cache_service.dart';

class TambolaRepo extends BaseRepo {
  final _cacheService = new CacheService();
  final _baseUrl = FlavorConfig.isDevelopment()
      ? 'https://qv53yko0b0.execute-api.ap-south-1.amazonaws.com/dev'
      : '';

  Future<ApiResponse<List<TambolaModel>>> getTickets() async {
    try {
      final uid = userService.baseUser.uid;
      final token = await getBearerToken();

      return await _cacheService.cachedApi(
          CacheId.TAMBOLA_TICKETS,
          TTL.ONE_DAY,
          () => APIService.instance.getData(
                ApiPath.tambolaTickets(uid),
                token: token,
                cBaseUrl: _baseUrl,
              ), (dynamic response) {
        final responseData = response["data"];
        logger.d('tambola repo $responseData');
        return ApiResponse<List<TambolaModel>>(
          model: TambolaModel.helper.fromMapArray(responseData),
          code: 200,
        );
      });
    } catch (e) {
      logger.e('get all tambola tickets $e');
      return ApiResponse.withError("Unable to fetch tambola tickets", 400);
    }
  }

  Future<ApiResponse<FlcModel>> buyTambolaTickets(int ticketCount) async {
    try {
      final uid = userService.baseUser.uid;
      final String bearer = await getBearerToken();

      final response = await APIService.instance.postData(
        ApiPath.buyTambolaTicket(uid),
        body: {
          "ticketCount": ticketCount,
        },
        token: bearer,
        cBaseUrl: _baseUrl,
      );

      final data = response['data'];

      logger.d('tambola repo $data');

      // clear cache
      await _cacheService.invalidateByKey(CacheId.TAMBOLA_TICKETS);

      FlcModel _flcModel = FlcModel.fromMap(data);
      return ApiResponse(model: _flcModel, code: 200);
    } catch (e) {
      logger.e(e);
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<DailyPick>> getWeeklyPicks() async {
    try {
      final String bearer = await getBearerToken();

      final response = await APIService.instance.getData(
        ApiPath.dailyPicks,
        token: bearer,
        cBaseUrl: _baseUrl,
      );

      final data = response['data'];
      return ApiResponse(model: DailyPick.fromMap(data), code: 200);
    } catch (e) {
      logger.e(e);
      return ApiResponse.withError(e.toString(), 400);
    }
  }
}
