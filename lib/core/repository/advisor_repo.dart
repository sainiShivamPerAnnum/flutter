import 'dart:developer';

import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/advisor/advisor_details.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/flavor_config.dart';

class AdvisorRepo extends BaseRepo {
  String baseUrl = FlavorConfig.isDevelopment()
      ? "https://advisors.fello-dev.net"
      : "https://advisors.fello-dev.net";

  static const _advisor = 'advisor';

  Future<ApiResponse<AdvisorDetails>> putEvent(
    Object payload,
  ) async {
    try {
      final uid = userService.baseUser!.uid;
      final Map<String, dynamic> eventPayload = payload as Map<String, dynamic>;

      final response = await APIService.instance.putData(
        ApiPath.updateEvent(eventPayload['id']),
        body: {
          "topic": eventPayload['topic'],
          "description": eventPayload['description'] ?? "Default description",
          "categories": eventPayload['categories'] ?? ["General"],
          "coverImage": eventPayload['coverImage'] ??
              "https://example.com/default-image.jpg",
          "eventTimeSlot":
              eventPayload['eventTimeSlot'] ?? "2024-09-30T12:00:00.000Z",
          "duration": eventPayload['duration'] ??
              60, // Default to 60 minutes if duration is not provided
          "advisorId": eventPayload['advisorId'] ?? "advisor-123",
          "status":
              eventPayload['status'] ?? "draft", // Default to draft status
          "totalLiveCount": eventPayload['totalLiveCount'] ?? 100,
          "broadcasterLive": eventPayload['broadcasterLive'] ??
              "https://example.com/live/default",
          "viewerLink": eventPayload['viewerLink'] ??
              "https://example.com/default-viewerLink",
          "100msEventId":
              eventPayload['100msEventId'] ?? "100ms-default-event-id",
          "token": eventPayload['token'] ?? "default-token"
        },
        cBaseUrl: baseUrl,
        apiName: '$_advisor/event',
      );

      final data = response['data'];
      log("UpdateUpdateUpdateUpdateUpdate data: $data");
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

  Future<ApiResponse<AdvisorDetails>> saveEvent(
    Object payload,
  ) async {
    try {
      final uid = userService.baseUser!.uid;
      final Map<String, dynamic> eventPayload = payload as Map<String, dynamic>;

      final response = await APIService.instance.postData(
        ApiPath.createEvent(),
        body: {
          "id": "event-123",
          "topic": eventPayload['topic'],
          "description": eventPayload['description'] ?? "Default description",
          "categories": eventPayload['categories'] ?? ["General"],
          "coverImage": eventPayload['coverImage'] ??
              "https://example.com/default-image.jpg",
          "eventTimeSlot":
              eventPayload['eventTimeSlot'] ?? "2024-09-30T12:00:00.000Z",
          "duration": eventPayload['duration'] ??
              60, // Default to 60 minutes if duration is not provided
          "advisorId": eventPayload['advisorId'] ?? "advisor-123",
          "status":
              eventPayload['status'] ?? "draft", // Default to draft status
          "totalLiveCount": eventPayload['totalLiveCount'] ?? 100,
          "broadcasterLive": eventPayload['broadcasterLive'] ??
              "https://example.com/live/default",
          "viewerLink": eventPayload['viewerLink'] ??
              "https://example.com/default-viewerLink",
          "100msEventId":
              eventPayload['100msEventId'] ?? "100ms-default-event-id",
          "token": eventPayload['token'] ?? "default-token"
        },
        cBaseUrl: baseUrl,
        apiName: '$_advisor/event',
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

  Future<ApiResponse<dynamic>> getEvents(
    Object payload,
  ) async {
    try {
      final uid = userService.baseUser!.uid;
      final Map<String, dynamic> eventPayload = payload as Map<String, dynamic>;

      final response = await APIService.instance.getData(
        ApiPath.createEvent(),
        queryParams: eventPayload,
        cBaseUrl: baseUrl,
        apiName: '$_advisor/event',
      );

      final data = response['data'];
      return ApiResponse(model: data, code: 200);
    } catch (e) {
      logger.e(e);
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<dynamic>> getUpcomingCalls(
    Object payload,
  ) async {
    try {
      final uid = userService.baseUser!.uid;
      final Map<String, dynamic> eventPayload = payload as Map<String, dynamic>;

      final response = await APIService.instance.getData(
        ApiPath.getUpcomingAdvisorBooking(eventPayload['advisorId']),
        // queryParams: eventPayload,
        cBaseUrl: baseUrl,
        apiName: '$_advisor/event',
      );

      final data = response['data'];
      return ApiResponse(model: data, code: 200);
    } catch (e) {
      logger.e(e);
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<dynamic>> getPastCalls(
    Object payload,
  ) async {
    try {
      final uid = userService.baseUser!.uid;
      final Map<String, dynamic> eventPayload = payload as Map<String, dynamic>;

      final response = await APIService.instance.getData(
        ApiPath.getPastAdvisorBooking(eventPayload['advisorId']),
        // queryParams: eventPayload,
        cBaseUrl: baseUrl,
        apiName: '$_advisor/event',
      );

      final data = response['data'];
      return ApiResponse(model: data, code: 200);
    } catch (e) {
      logger.e(e);
      return ApiResponse.withError(e.toString(), 400);
    }
  }
}
