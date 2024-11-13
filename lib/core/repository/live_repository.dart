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
      final responseData = response["data"][0];
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

  Future<ApiResponse<bool>> likeEvent({
    required String id,
    required bool isLiked,
  }) async {
    try {
      final body = {
        'isLiked': isLiked,
      };
      final response = await APIService.instance.postData(
        'events/$id',
        cBaseUrl: _baseUrl,
        body: body,
        apiName: '$_live/likeEvent',
      );
      final responseData = response["data"];
      log("Live liked: $responseData");
      return const ApiResponse<bool>(
        model: true,
        code: 200,
      );
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<String>> dynamicLink({
    required String id,
  }) async {
    final query = {
      "type": "live",
      "id": id,
    };
    try {
      final response = await APIService.instance.postData(
        'events/generate-link',
        cBaseUrl: _baseUrl,
        queryParams: query,
        apiName: '$_live/dynamicLink',
      );
      final responseData = response["data"];
      return ApiResponse<String>(
        model: responseData['shortLink'],
        code: 200,
      );
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }
}
