import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/daily_pick_model.dart';
import 'package:felloapp/core/model/tambola_ticket_model.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/date_helper.dart';

import '../../util/flavor_config.dart';
import '../constants/cache_keys.dart';
import '../model/flc_pregame_model.dart';
import '../service/cache_service.dart';

class TambolaRepo extends BaseRepo {
  final _cacheService = new CacheService();
  final _baseUrl = FlavorConfig.isDevelopment()
      ? 'https://qv53yko0b0.execute-api.ap-south-1.amazonaws.com/dev'
      : 'https://7icbm6j9e7.execute-api.ap-south-1.amazonaws.com/prod';

  Future<ApiResponse<List<TambolaModel>>> getTickets() async {
    try {
      final uid = userService.baseUser.uid;
      final token = await getBearerToken();

      // cache till end of week only
      final ttl = DateHelper.timeToWeekendInMinutes();
      return await _cacheService.cachedApi(
          CacheKeys.TAMBOLA_TICKETS,
          ttl,
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
      await _cacheService.invalidateByKey(CacheKeys.TAMBOLA_TICKETS);

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

      // cache till 6 PM only
      final now = DateTime.now();
      final ttl = ((18 - now.hour) % 24) * 60 - now.minute;

      return await _cacheService.cachedApi(
          CacheKeys.TAMBOLA_PICKS,
          ttl,
          () => APIService.instance.getData(
                ApiPath.dailyPicks,
                token: bearer,
                cBaseUrl: _baseUrl,
              ), (dynamic response) {
        final data = response['data'];
        return ApiResponse<DailyPick>(
          model: DailyPick.fromMap(data),
          code: 200,
        );
      });
    } catch (e) {
      logger.e('daily pick $e');
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<int>> getTicketCount() async {
    try {
      final uid = userService.baseUser.uid;
      final String bearer = await getBearerToken();

      final response = await APIService.instance.getData(
        ApiPath.ticketCount(uid),
        token: bearer,
        cBaseUrl: _baseUrl,
      );

      final data = response['data'];
      logger.d('tambola repo $data');

      return ApiResponse(model: data['count'], code: 200);
    } catch (e) {
      logger.e(e);
      return ApiResponse.withError(e.toString(), 400);
    }
  }
}
