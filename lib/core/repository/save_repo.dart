import 'dart:convert';

import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/blog_model.dart';
import 'package:felloapp/core/model/top_expert_model.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/util/api_response.dart';

class SaveRepo extends BaseRepo {
  final String _blogUrl =
      "https://felloblog815893968.wpcomstaging.com/wp-json/wp/v2";
  final String _topExpertUrl =
      "https://95b913c3-495b-42fd-b3c6-bb4e3d72bef8.mock.pstmn.io/dev/static/advisor";

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
  Future<ApiResponse<List<TopExpertModel>>> getTopExperts() async {
    List<TopExpertModel> topExperts = <TopExpertModel>[];
    try { 
      final responseData = await APIService.instance.getData(
        '',
        cBaseUrl: _topExpertUrl,
        apiName: 'experts/getTopExperts',
      );
      responseData['data'].forEach((e) {
        topExperts.add(TopExpertModel.fromJson(e));
      });
      print(topExperts.length);
      return ApiResponse(code: 200, model: topExperts);
    } catch (e) {
      return const ApiResponse(code: 404, errorMessage: 'No Blogs Found');
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
