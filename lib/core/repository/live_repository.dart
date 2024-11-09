import 'dart:developer';

import 'package:felloapp/core/model/advisor/advisor_events.dart';
import 'package:felloapp/core/model/live/live_home.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/flavor_config.dart';

class LiveRepository extends BaseRepo {
  static const _live = 'live';

  final _baseUrl = FlavorConfig.isDevelopment()
      ? 'https://advisors.fello-dev.net/'
      : 'https://advisors.fello-prod.net/';

  Future<ApiResponse<LiveHome>> getLiveHomeData() async {
    try {
      final response = await APIService.instance.getData(
        'events/home',
        cBaseUrl: _baseUrl,
        apiName: '$_live/getLiveHomeData',
      );
      final responseData = response["data"];
      log("Live data: $responseData");
      return ApiResponse<LiveHome>(
        model: LiveHome.fromJson(responseData),
        code: 200,
      );
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<AdvisorEvents>> getEventById({
    required String id,
  }) async {
    try {
      final params = {"eventId": id};
      final response = await APIService.instance.getData(
        'events',
        cBaseUrl: _baseUrl,
        queryParams: params,
        apiName: '$_live/getEventById',
      );
      final responseData = response["data"];
      log("Live data: $responseData");
      return ApiResponse<AdvisorEvents>(
        model: AdvisorEvents.fromJson(responseData),
        code: 200,
      );
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }
}
