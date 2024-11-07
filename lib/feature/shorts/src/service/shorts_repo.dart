import 'dart:developer';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';
import 'comment_data.dart';
import 'video_data.dart';

class ShortsRepo {
  static final _baseUrl = FlavorConfig.isDevelopment()
      ? 'https://advisors.fello-dev.net/'
      : 'https://yg58g0feo0.execute-api.ap-south-1.amazonaws.com/prod';

  // Updated getVideos function
  Future<ApiResponse<List<VideoData>>> getVideos({
    int page = 1,
    int limit = 10,
    String? advisorId,
  }) async {
    try {
      final queryParameters = {
        'page': page.toString(),
        'limit': limit.toString(),
        'type': 'shorts',
      };

      final response = await APIService.instance.getData(
        'videos/list',
        cBaseUrl: _baseUrl,
        apiName: 'ShortsRepo/getVideos',
        queryParams: queryParameters,
      );

      final responseData = response["data"];
      log("Video data: $responseData");

      return ApiResponse<List<VideoData>>(
        model: (responseData as List<dynamic>)
            .map((json) => VideoData.fromJson(json))
            .toList(),
        code: 200,
      );
    } catch (e) {
      log("Error fetching videos: ${e.toString()}");
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  // Updated getComments function
  Future<ApiResponse<List<CommentData>>> getComments(String videoId) async {
    final String commentsUrl = 'videos/comments/$videoId';
    try {
      final response = await APIService.instance.getData(
        commentsUrl,
        cBaseUrl: _baseUrl,
        apiName: 'ShortsRepo/getComments',
      );

      final commentsData = response["data"];
      log("Comments data: $commentsData");

      return ApiResponse<List<CommentData>>(
        model: (commentsData as List<dynamic>)
            .map((json) => CommentData.fromJson(json))
            .toList(),
        code: 200,
      );
    } catch (e) {
      log("Error fetching comments: ${e.toString()}");
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  // Updated addComment function
  Future<ApiResponse<void>> addComment(
      String videoId, String userId, String name, String commentText) async {
    final String addCommentUrl = 'videos/comment/$videoId';
    try {
      final String? avatarId = locator<UserService>().baseUser!.avatarId;
      final String? dpUrl = locator<UserService>().myUserDpUrl;
      await APIService.instance.postData(
        addCommentUrl,
        cBaseUrl: _baseUrl,
        apiName: 'ShortsRepo/addComment',
        body: {
          'videoId': videoId,
          'userId': userId,
          'name': name,
          'comment': commentText,
          'avatarId': avatarId,
          'dpUrl': dpUrl,
        },
      );
      return const ApiResponse<void>(code: 201);
    } catch (e) {
      log("Error adding comment: ${e.toString()}");
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  // Updated addLike function
  Future<ApiResponse<void>> addLike(
      bool isLiked, String videoId, String name) async {
    final String likeUrl = 'videos/like/$videoId';
    try {
      await APIService.instance.postData(
        likeUrl,
        cBaseUrl: _baseUrl,
        apiName: 'ShortsRepo/addLike',
        body: {
          'id': videoId,
          'name': name,
          'isLiked': isLiked,
        },
      );
      return const ApiResponse<void>(code: 200);
    } catch (e) {
      log("Error adding like: ${e.toString()}");
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<void>> updateViewCount(
    String videoId,
  ) async {
    final String countUrl = 'videos/$videoId/view-count';
    try {
      await APIService.instance.patchData(
        countUrl,
        cBaseUrl: _baseUrl,
        apiName: 'ShortsRepo/updateViewCount',
      );
      return const ApiResponse<void>(code: 200);
    } catch (e) {
      log("Error adding like: ${e.toString()}");
      return ApiResponse.withError(e.toString(), 400);
    }
  }
}
