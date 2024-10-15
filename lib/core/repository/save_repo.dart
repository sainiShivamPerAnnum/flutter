import 'dart:developer';

import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/blog_model.dart';
import 'package:felloapp/core/model/bookings/upcoming_booking.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/util/api_response.dart';

class SaveRepo extends BaseRepo {
  final String _blogUrl =
      "https://felloblog815893968.wpcomstaging.com/wp-json/wp/v2";
  final String _bookingsUrl = "https://advisors.fello-dev.net/";

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
    final String? uid = userService.baseUser!.uid;
    try {
      final response = await APIService.instance.getData(
        'booking/user/upcoming/$uid',
        cBaseUrl: _bookingsUrl,
        apiName: 'bookings/getUpcomingBookings',
      );
      final responseData = response["data"];
      log("Upcoming booking data: $responseData");
      final List<Booking> upcomingBooking = (responseData as List)
          .map((item) => Booking.fromJson(
              item,),)
          .toList();
      return ApiResponse<List<Booking>>(
        model: upcomingBooking,
        code: 200,
      );
    } catch (e) {
      return const ApiResponse(code: 404, errorMessage: 'No Bookings Found');
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
