import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/blog_model.dart';
import 'package:felloapp/core/model/bookings/upcoming_booking.dart';
import 'package:felloapp/core/model/experts/experts_home.dart';
import 'package:felloapp/core/model/live/live_home.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/feature/shorts/src/service/video_data.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/flavor_config.dart';

class SaveRepo extends BaseRepo {
  static const _experts = 'experts';
  static const _live = 'live';
  final String _blogUrl =
      "https://felloblog815893968.wpcomstaging.com/wp-json/wp/v2";
  final _baseUrl = FlavorConfig.isDevelopment()
      ? 'https://advisors.fello-dev.net/'
      : 'https://advisors.fello-prod.net/';

  Future<ApiResponse<List<BlogPostModel>>> getBlogs(int noOfBlogs) async {
    List<BlogPostModel> blogs = <BlogPostModel>[];
    try {
      var token =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjIsIm5hbWUiOiJzaG91cnlhIiwiaWF0IjoxNjU5NzgwMDkyLCJleHAiOjE4MTc0NjAwOTJ9.J6fUbS_lqi-4fldnA2lDQWPjrAI19czO5C6cwRecjwo';
      List responseData = await APIService.instance.getData(
        ApiPath.getBlogs(noOfBlogs),
        token: token,
        cBaseUrl: _blogUrl,
        apiName: 'blogs/getAllBlogs',
      );
      responseData.forEach((e) {
        blogs.add(BlogPostModel.fromMap(e));
      });
      print(blogs.length);
      return ApiResponse(code: 200, model: blogs);
    } catch (e) {
      return ApiResponse(code: 404, errorMessage: 'No Blogs Found');
    }
  }

  Future<ApiResponse<List<Booking>>> getUpcomingBookings() async {
    try {
      final response = await APIService.instance.getData(
        'booking/user/upcoming',
        cBaseUrl: _baseUrl,
        apiName: 'bookings/getUpcomingBookings',
      );
      final responseData = response["data"];
      final List<Booking> upcomingBooking = (responseData as List)
          .map(
            (item) => Booking.fromJson(
              item,
            ),
          )
          .toList();
      return ApiResponse<List<Booking>>(
        model: upcomingBooking,
        code: 200,
      );
    } catch (e) {
      return const ApiResponse(code: 404, errorMessage: 'No Bookings Found');
    }
  }

  Future<ApiResponse<List<Booking>>> getPastBookings() async {
    try {
      final response = await APIService.instance.getData(
        'booking/user/past',
        cBaseUrl: _baseUrl,
        apiName: 'bookings/getPastBookings',
      );
      final responseData = response["data"];
      final List<Booking> pastBooking = (responseData as List)
          .map(
            (item) => Booking.fromJson(
              item,
            ),
          )
          .toList();
      return ApiResponse<List<Booking>>(
        model: pastBooking,
        code: 200,
      );
    } catch (e) {
      return const ApiResponse(code: 404, errorMessage: 'No Bookings Found');
    }
  }

  Future<ApiResponse<VideoData>> getRecordingByVideoId({
    required String videoId,
  }) async {
    try {
      final response = await APIService.instance.getData(
        'videos/list',
        queryParams: {
          'eventID': videoId,
        },
        cBaseUrl: _baseUrl,
        apiName: '$_experts/getRecordingByVideoId',
      );
      final responseData = response["data"][0];
      final VideoData recentStreams = VideoData.fromJson(responseData);
      return ApiResponse<VideoData>(
        model: recentStreams,
        code: 200,
      );
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<(List<Expert>, bool)>> getTopExpertsData() async {
    try {
      final response = await APIService.instance.getData(
        'advisors/sections',
        cBaseUrl: _baseUrl,
        apiName: '$_experts/getTopExpertsData',
      );
      final responseData = response["data"];
      final allData = ExpertsHome.fromJson(responseData);
      final List<Expert> topExperts = [];
      allData.values.forEach((key, expertsList) {
        if (key.toLowerCase() == 'top') {
          topExperts.addAll(expertsList.take(3));
        }
      });

      return ApiResponse<(List<Expert>, bool)>(
        model: (topExperts, allData.isAnyFreeCallAvailable),
        code: 200,
      );
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<LiveHome>> getLiveHomeData() async {
    try {
      final response = await APIService.instance.getData(
        'events/home',
        cBaseUrl: _baseUrl,
        apiName: '$_live/getLiveHomeData',
      );
      final responseData = response["data"];
      return ApiResponse<LiveHome>(
        model: LiveHome.fromJson(responseData),
        code: 200,
      );
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  // Future<ApiResponse> verifyVPAAddress(String uid) async {
  //   try {
  //     var response = await APIService.instance
  //         .getData(ApiPath.kVerifyVPAAddress(uid), cBaseUrl: _baseUrl);
  //     print(response);
  //     return ApiResponse(code: 200, model: response['data']);
  //   } catch (e) {
  //     return ApiResponse(
  //         code: 404, errorMessage: 'Couldn\'t verify VPA address', model: {});
  //   }
  // }
}
