import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/blog_model.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/util/api_response.dart';

class SaveRepo extends BaseRepo {
  final _baseUrl = "https://felloblog815893968.wpcomstaging.com/wp-json/wp/v2";

  Future<ApiResponse<List<BlogPostModel>>> getBlogs() async {
    List<BlogPostModel> blogs = <BlogPostModel>[];
    try {
      var token =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjIsIm5hbWUiOiJzaG91cnlhIiwiaWF0IjoxNjU5NzgwMDkyLCJleHAiOjE4MTc0NjAwOTJ9.J6fUbS_lqi-4fldnA2lDQWPjrAI19czO5C6cwRecjwo';
      List responseData = await APIService.instance
          .getData(ApiPath.getBlogs(5), token: token, cBaseUrl: _baseUrl);
      responseData.forEach((e) {
        blogs.add(BlogPostModel.fromMap(e));
      });
      print(blogs.length);
      return ApiResponse(code: 200, model: blogs);
    } catch (e) {
      return ApiResponse(code: 404, errorMessage: 'No Blogs Found');
    }
  }
}
