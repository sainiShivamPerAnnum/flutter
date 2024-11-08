import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/advisor/advisor_details.dart';
import 'package:felloapp/core/model/advisor/advisor_events.dart';
import 'package:felloapp/core/model/advisor/advisor_upcoming_call.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:image_picker/image_picker.dart';

class AdvisorRepo extends BaseRepo {
  String baseUrl = FlavorConfig.isDevelopment()
      ? "https://advisors.fello-dev.net"
      : "https://advisors.fello-prod.net";

  static const _advisor = 'advisor';

  Future<ApiResponse<AdvisorDetails>> putEvent(
    Map<dynamic, dynamic> payload,
    String id,
  ) async {
    try {
      final uid = userService.baseUser!.advisorId;
      final Map<dynamic, dynamic> eventPayload = payload;
      eventPayload.addAll({
        "advisorId": uid,
      });
      print(payload);

      final response = await APIService.instance.putData(
        ApiPath.updateEvent(id),
        body: eventPayload,
        cBaseUrl: baseUrl,
        apiName: '$_advisor/putEvent',
      );

      final data = response['data'];
      log("UpdateUpdateUpdateUpdateUpdate data: $data");
      return ApiResponse<AdvisorDetails>(
        model: AdvisorDetails.fromJson(data),
        code: 200,
      );
    } catch (e) {
      logger.e(e);
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<String>> getPresignedUrl({
    required String format,
  }) async {
    try {
      final uid = userService.baseUser!.advisorId;
      final params = {"advisor-id": uid};
      final response = await APIService.instance.getData(
        "/events/presigned-url",
        headers: {'Content-Type': "image/$format"},
        queryParams: params,
        cBaseUrl: baseUrl,
        apiName: '$_advisor/getPresignedUrl',
      );
      final responseData = response['data']['url'];
      return ApiResponse(model: responseData, code: 200);
    } catch (e) {
      logger.e(e);
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<bool>> putToPresignedUrl({
    required String url,
    required XFile file,
  }) async {
    try {
      final dio = Dio();
      await dio.put(
        url,
        options: Options(
          headers: {'Content-Type': "image/${file.name.split('.').last}"},
        ),
        data: await File(file.path).readAsBytes(),
      );
      return const ApiResponse(model: true, code: 200);
    } catch (e) {
      logger.e(e);
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<AdvisorDetails>> saveEvent(
    Map<String, dynamic> payload,
  ) async {
    try {
      final uid = userService.baseUser!.advisorId;
      final Map<String, dynamic> eventPayload = payload;
      eventPayload.addAll({
        "advisorId": uid,
      });

      final response = await APIService.instance.postData(
        ApiPath.events,
        body: eventPayload,
        cBaseUrl: baseUrl,
        apiName: '$_advisor/saveEvent',
      );
      final data = response['data'];
      log("Experts data: $data");
      return ApiResponse<AdvisorDetails>(
        model: AdvisorDetails.fromJson(data),
        code: 200,
      );
      // return ApiResponse(model: data, code: 200);
    } catch (e) {
      logger.e(e);
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<List<AdvisorEvents>>> getEvents() async {
    try {
      final uid = userService.baseUser!.advisorId;
      final params = {"advisorId": uid, "type": "live", "status": "upcoming"};
      final response = await APIService.instance.getData(
        ApiPath.events,
        queryParams: params,
        cBaseUrl: baseUrl,
        apiName: '$_advisor/getEvents',
      );
      final responseData = response['data'];
      final List<AdvisorEvents> eventsData = (responseData as List)
          .map(
            (item) => AdvisorEvents.fromJson(
              item,
            ),
          )
          .toList();
      return ApiResponse(model: eventsData, code: 200);
    } catch (e) {
      logger.e(e);
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<List<AdvisorCall>>> getUpcomingCalls() async {
    try {
      final uid = userService.baseUser!.advisorId;
      final response = await APIService.instance.getData(
        ApiPath.getUpcomingAdvisorBooking(uid),
        cBaseUrl: baseUrl,
        apiName: '$_advisor/getUpcomingCalls',
      );
      final data = response['data'];
      final List<AdvisorCall> responseData = (data as List)
          .map(
            (item) => AdvisorCall.fromJson(
              item,
            ),
          )
          .toList();
      return ApiResponse(model: responseData, code: 200);
    } catch (e) {
      logger.e(e);
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<List<AdvisorCall>>> getPastCalls() async {
    try {
      final uid = userService.baseUser!.advisorId;
      final response = await APIService.instance.getData(
        ApiPath.getPastAdvisorBooking(uid),
        cBaseUrl: baseUrl,
        apiName: '$_advisor/getPastCalls',
      );
      final data = response['data'];
      final List<AdvisorCall> responseData = (data as List)
          .map(
            (item) => AdvisorCall.fromJson(
              item,
            ),
          )
          .toList();
      return ApiResponse(model: responseData, code: 200);
    } catch (e) {
      logger.e(e);
      return ApiResponse.withError(e.toString(), 400);
    }
  }
}
