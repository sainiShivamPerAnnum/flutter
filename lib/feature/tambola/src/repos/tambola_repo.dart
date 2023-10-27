import 'dart:async';

import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/constants/cache_keys.dart';
import 'package:felloapp/core/enums/ttl.dart';
import 'package:felloapp/core/model/timestamp_model.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/service/cache_service.dart';
import 'package:felloapp/feature/tambola/src/models/daily_pick_model.dart';
import 'package:felloapp/feature/tambola/src/models/tambola_best_tickets_model.dart';
import 'package:felloapp/feature/tambola/src/models/tambola_ticket_model.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/flavor_config.dart';

class TambolaRepo extends BaseRepo {
  final _cacheService = CacheService();
  TimestampModel? lastTimeStamp;
  List<TambolaTicketModel> activeTambolaTickets = [];
  static int expiringTicketCount = 0;

  static const _tambola = 'tambola';

  final _baseUrl = FlavorConfig.isDevelopment()
      ? 'https://qv53yko0b0.execute-api.ap-south-1.amazonaws.com/dev'
      : 'https://7icbm6j9e7.execute-api.ap-south-1.amazonaws.com/prod';

  Future<ApiResponse<TambolaBestTicketsModel>> getBestTickets(
      {bool postSpinStats = false}) async {
    TambolaBestTicketsModel? bestTickets;
    try {
      final uid = userService.baseUser!.uid;

      return await _cacheService.cachedApi(
          CacheKeys.TAMBOLA_TICKETS,
          TTL.UPTO_SIX_PM,
          () => APIService.instance.getData(
                ApiPath.tambolaBestTickets(uid!),
                queryParams: {'spinFlag': postSpinStats.toString()},
                cBaseUrl: _baseUrl,
                apiName: '$_tambola/winningTickets',
              ), (dynamic response) {
        bestTickets = TambolaBestTicketsModel.fromJson(response);
        expiringTicketCount = response["data"]["expiringTicketsCount"] ?? 0;

        return ApiResponse<TambolaBestTicketsModel>(
          model: bestTickets,
          code: 200,
        );
      });
    } catch (e) {
      logger.e('Failed to get best tickets: $e');
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<List<TambolaTicketModel>>> getTickets(
      int offset, int limit) async {
    try {
      final uid = userService.baseUser!.uid;

      final response = await APIService.instance.getData(
        ApiPath.tambolaTickets(uid),
        queryParams: {'limit': limit.toString(), 'offset': offset.toString()},
        cBaseUrl: _baseUrl,
        apiName: '$_tambola/tickets',
      );
      List<TambolaTicketModel>? tickets =
          TambolaTicketModel.helper.fromMapArray(response['data']['tickets']);
      expiringTicketCount = response["data"]["expiringTicketsCount"] ?? 0;
      // await postProcessTambolaTickets(response);
      return ApiResponse<List<TambolaTicketModel>>(
        model: tickets ?? [],
        code: 200,
      );
    } catch (e) {
      logger.e('Failed to get tickets: $e');
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<dynamic>> getWeeklyPicks() async {
    try {
      // cache till 6 PM only
      final now = DateTime.now();
      // final ttl = ((18 - now.hour) % 24) * 60 - now.minute;

      return await _cacheService.cachedApi(
          CacheKeys.TAMBOLA_PICKS,
          0,
          () => APIService.instance.getData(
                ApiPath.dailyPicks,
                cBaseUrl: _baseUrl,
                apiName: '$_tambola/dailyPicks',
              ), (dynamic response) {
        final data = response['data'];
        if (data != null && data.isNotEmpty) {
          return ApiResponse<DailyPick>(
            model: DailyPick.fromMap(data["picks"]),
            code: 200,
          );
        } else {
          return ApiResponse<DailyPick>(model: DailyPick.noPicks(), code: 200);
        }
      });
    } catch (e) {
      logger.e('daily pick $e');
      return ApiResponse<DailyPick>(model: DailyPick.noPicks(), code: 200);
    }
  }

  void dump() {
    lastTimeStamp = null;
    activeTambolaTickets = [];
    expiringTicketCount = 0;
  }
}
