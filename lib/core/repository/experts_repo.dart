import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/bookings/new_booking.dart';
import 'package:felloapp/core/model/bookings/payment_polling.dart';
import 'package:felloapp/core/model/bookings/payment_response.dart';
import 'package:felloapp/core/model/experts/experts_details.dart';
import 'package:felloapp/core/model/experts/experts_home.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/feature/shorts/src/service/video_data.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/flavor_config.dart';

class ExpertsRepository extends BaseRepo {
  static const _experts = 'experts';
  static const _booking = 'booking';
  static const _ratings = 'ratings';

  final _baseUrl = FlavorConfig.isDevelopment()
      ? 'https://advisors.fello-dev.net/'
      : 'https://advisors.fello-prod.net/';

  Future<ApiResponse<ExpertsHome>> getExpertsHomeData() async {
    try {
      final response = await APIService.instance.getData(
        'advisors/sections',
        cBaseUrl: _baseUrl,
        apiName: '$_experts/getExpertsHomeData',
      );
      final responseData = response["data"];
      return ApiResponse<ExpertsHome>(
        model: ExpertsHome.fromJson(responseData),
        code: 200,
      );
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<ExpertDetails>> getExperDetailsByID({
    required String advisorId,
  }) async {
    try {
      final response = await APIService.instance.getData(
        'advisors/$advisorId',
        cBaseUrl: _baseUrl,
        apiName: '$_experts/getExperDetailsByID',
      );
      final responseData = response["data"];

      return ApiResponse<ExpertDetails>(
        model: ExpertDetails.fromJson(responseData),
        code: 200,
      );
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<List<UserRating>>> getRatingByExpert({
    required String advisorId,
  }) async {
    try {
      final response = await APIService.instance.getData(
        'ratings',
        cBaseUrl: _baseUrl,
        queryParams: {
          'advisorId': advisorId,
        },
        apiName: '$_ratings/getRatingByExpert',
      );
      final responseData = response["data"];

      final List<UserRating> ratings = (responseData as List)
          .map(
            (item) => UserRating.fromJson(
              item,
            ),
          )
          .toList();
      return ApiResponse<List<UserRating>>(
        model: ratings,
        code: 200,
      );
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<UserRating>> postRatingDetails({
    required num rating,
    required String comments,
    required String advisorId,
  }) async {
    final String? uid = userService.baseUser!.uid;
    final String userName = (userService.baseUser!.kycName != null &&
                userService.baseUser!.kycName!.isNotEmpty
            ? userService.baseUser!.kycName
            : userService.baseUser!.name) ??
        "N/A";
    try {
      final body = {
        "rating": rating,
        "comments": comments,
        "userId": uid,
        "userName": userName,
        "advisorId": advisorId,
      };
      final response = await APIService.instance.postData(
        'ratings',
        cBaseUrl: _baseUrl,
        body: body,
        apiName: '$_ratings/postRatingDetails',
      );
      final responseData = response["data"];
      BaseUtil.showPositiveAlert(
        'Rating Uploaded Successfully!',
        'Thanks for your feedback!',
      );
      return ApiResponse<UserRating>(
        model: UserRating.fromJson(responseData),
        code: 200,
      );
    } catch (e) {
      logger.e(e.toString());
      BaseUtil.showNegativeAlert('Failed to upload rating!', e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<Schedule>> getExpertAvailableSlots({
    required String advisorId,
    required int duration,
  }) async {
    try {
      final response = await APIService.instance.getData(
        'booking/available-slots',
        queryParams: {
          "duration": duration,
          "advisorId": advisorId,
        },
        cBaseUrl: _baseUrl,
        apiName: '$_experts/getExpertAvailableSlots',
      );
      final responseData = response['data'];

      return ApiResponse<Schedule>(
        model: Schedule.fromJson(responseData),
        code: 200,
      );
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<String>> getCertificateById({
    required String advisorId,
    required String certificateId,
  }) async {
    try {
      final response = await APIService.instance.getData(
        'advisors/$advisorId/credentials/$certificateId/download',
        cBaseUrl: _baseUrl,
        apiName: '$_experts/getCertificateById',
      );
      final responseData = response['data'];
      return ApiResponse<String>(
        model: responseData["presignedUrl"] ?? '',
        code: 200,
      );
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<List<VideoData>>> getLiveByAdvisor({
    required String advisorId,
  }) async {
    try {
      final response = await APIService.instance.getData(
        'videos/list',
        queryParams: {
          'type': "live",
          'advisorId': advisorId,
        },
        cBaseUrl: _baseUrl,
        apiName: '$_experts/getLiveByAdvisor',
      );
      final responseData = response["data"];

      final List<VideoData> recentStreams = (responseData as List)
          .map(
            (item) => VideoData.fromJson(
              item,
            ),
          )
          .toList();

      return ApiResponse<List<VideoData>>(
        model: recentStreams,
        code: 200,
      );
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<List<VideoData>>> getShortsByAdvisor({
    required String advisorId,
  }) async {
    try {
      final response = await APIService.instance.getData(
        'videos/list',
        queryParams: {
          'type': "shorts",
          'advisorId': advisorId,
        },
        cBaseUrl: _baseUrl,
        apiName: '$_experts/getShortsByAdvisor',
      );
      final responseData = response["data"];

      final List<VideoData> recentStreams = (responseData as List)
          .map(
            (item) => VideoData.fromJson(
              item,
            ),
          )
          .toList();

      return ApiResponse<List<VideoData>>(
        model: recentStreams,
        code: 200,
      );
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<bool>> updateBooking({
    required int duration,
    required String bookingId,
    required String selectedDate,
  }) async {
    try {
      final body = {
        "duration": duration,
        "bookingId": bookingId,
        "newFromTime": selectedDate,
      };

      final response = await APIService.instance.patchData(
        'booking/reschedule',
        body: body,
        cBaseUrl: _baseUrl,
        apiName: '$_booking/updateBooking',
      );
      final responseData = response['data'];

      return const ApiResponse<bool>(
        model: true,
        code: 200,
      );
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<PricingResponse>> getPricing({
    required String advisorId,
    required int duration,
    required bool isCoinBalance,
  }) async {
    try {
      final body = {
        "duration": duration,
        "service": 'generic',
        "isCoinBalance": isCoinBalance,
      };

      final response = await APIService.instance.postData(
        'advisors/$advisorId/pricing',
        body: body,
        cBaseUrl: _baseUrl,
        apiName: '$_booking/getPricing',
      );
      final responseData = response['data'];

      return ApiResponse<PricingResponse>(
        model: PricingResponse.fromJson(responseData),
        code: 200,
      );
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  String formatUpiAppName(String name) {
    switch (name) {
      case "Phonepe":
        return "PHONE_PE";
      case "Paytm":
        return "PAYTM";
      case "Google Pay":
        return "GOOGLE_PAY";
      default:
        return "PHONE_PE";
    }
  }

  Future<ApiResponse<PaymentStatusResponse>> submitBooking({
    required String advisorId,
    required num amount,
    required String fromTime,
    required num duration,
    required String appuse,
    required bool isFree,
    required bool isCoinBalance,
  }) async {
    try {
      final String? uid = userService.baseUser!.uid;
      final body = {
        "advisorId": advisorId,
        "amount": amount,
        "userId": uid,
        "fromTime": fromTime,
        "duration": duration,
        "isFree": isFree,
        "isCoinBalance": isCoinBalance,
      };
      final headers = {
        "appuse": formatUpiAppName(appuse),
        "paymode": 'UPI_INTENT',
      };

      final response = await APIService.instance.postData(
        'booking',
        body: body,
        cBaseUrl: _baseUrl,
        headers: headers,
        apiName: '$_booking/submitBooking',
      );
      final responseData = response;
      return ApiResponse<PaymentStatusResponse>(
        model: PaymentStatusResponse.fromJson(responseData),
        code: 200,
      );
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<bool>> submitQNA({
    required List<Map<String, String>> detailsQA,
    required String bookingID,
  }) async {
    try {
      final body = {
        "detailsQA": detailsQA,
      };
      final response = await APIService.instance.patchData(
        'booking/$bookingID/details-qa',
        body: body,
        cBaseUrl: _baseUrl,
        apiName: '$_booking/submitQNA',
      );
      final responseData = response;

      return const ApiResponse<bool>(
        model: true,
        code: 200,
      );
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<PollingStatusResponse>> pollForPayemtStatus(
    String paymentId,
  ) async {
    int pollCount = 1;
    const pollLimit = 6;
    const relayDuration = Duration(seconds: 5);

    ApiResponse<PollingStatusResponse> lastResult =
        await getPollingResponse(paymentId);

    while (pollCount < pollLimit) {
      final data = lastResult.model?.data;

      // Termination condition for polling:
      // - Either the request fails completely then break further polling and
      // propagate error response to further.
      // - Or request completes with success and the status of payment is
      // complete.
      final predicate = lastResult.isSuccess() &&
              data != null &&
              data.paymentDetails != null &&
              data.paymentDetails!.status == BookingPaymentStatus.complete ||
          !lastResult.isSuccess();

      if (predicate) {
        return lastResult;
      }

      // delay between two requests.
      if (pollCount > 1) {
        await Future.delayed(
          relayDuration,
        );
      }

      lastResult = await getPollingResponse(paymentId);

      pollCount++;
    }

    return lastResult;
  }

  Future<ApiResponse<PollingStatusResponse>> getPollingResponse(
    String paymentID,
  ) async {
    try {
      final response = await APIService.instance.getData(
        'payments/$paymentID',
        cBaseUrl: _baseUrl,
        apiName: '$_booking/getPollingResponse',
      );
      final responseData = response;

      return ApiResponse<PollingStatusResponse>(
        model: PollingStatusResponse.fromJson(responseData),
        code: 200,
      );
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }
}
