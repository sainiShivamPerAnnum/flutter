import 'package:felloapp/core/model/shorts/shorts_home.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'comment_data.dart';
import 'video_data.dart';

class ShortsRepo extends BaseRepo {
  static final _baseUrl = FlavorConfig.isDevelopment()
      ? 'https://advisors.fello-dev.net/'
      : 'https://advisors.fello-prod.net/';

  Future<ApiResponse<PaginatedShorts>> getVideosByCategory({
    required String category,
    required String theme,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final queryParameters = {
        'page': page.toString(),
        'limit': limit.toString(),
        'category': category,
        'theme': theme,
      };

      final response = await APIService.instance.getData(
        'videos/theme-category-paginated',
        cBaseUrl: _baseUrl,
        apiName: 'ShortsRepo/getVideosByCategory',
        queryParams: queryParameters,
      );
      final responseData = response["data"];
      return ApiResponse<PaginatedShorts>(
        model: PaginatedShorts.fromJson(responseData),
        code: 200,
      );
    } catch (e) {
      return ApiResponse.withError(e.toString(), 400);
    }
  }

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

      return ApiResponse<List<VideoData>>(
        model: (responseData as List<dynamic>)
            .map((json) => VideoData.fromJson(json))
            .toList(),
        code: 200,
      );
    } catch (e) {
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<VideoData>> getVideoById({
    String? videoId,
  }) async {
    try {
      final queryParameters = {
        'videoID': videoId,
      };
      final response = await APIService.instance.getData(
        'videos/list',
        cBaseUrl: _baseUrl,
        apiName: 'ShortsRepo/getVideoById',
        queryParams: queryParameters,
      );
      final responseData = response["data"][0];

      return ApiResponse<VideoData>(
        model: VideoData.fromJson(responseData),
        code: 200,
      );
    } catch (e) {
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

      return ApiResponse<List<CommentData>>(
        model: (commentsData as List<dynamic>)
            .map((json) => CommentData.fromJson(json))
            .toList(),
        code: 200,
      );
    } catch (e) {
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  // Updated addComment function
  Future<ApiResponse<void>> addComment(
    String videoId,
    String userId,
    String name,
    String commentText,
  ) async {
    final String addCommentUrl = 'videos/comment/$videoId';
    try {
      final String? avatarId = userService.baseUser!.avatarId;
      final String? dpUrl = userService.myUserDpUrl;
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
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  // Updated addLike function
  Future<ApiResponse<void>> addLike(
    bool isLiked,
    String videoId,
    String name,
  ) async {
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
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<void>> followAdvisor(
    bool isFollowed,
    String advisorId,
  ) async {
    final uid = userService.baseUser!.uid;
    final String followUrl = isFollowed
        ? 'user-notify/unfollow-advisor'
        : 'user-notify/follow-advisor';
    try {
      await APIService.instance.postData(
        followUrl,
        cBaseUrl: _baseUrl,
        apiName: 'ShortsRepo/followAdvisor',
        body: {
          "uid": uid,
          'advisorId': advisorId,
        },
      );
      return const ApiResponse<void>(code: 200);
    } catch (e) {
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<void>> addSave(
    bool isSaved,
    String advisorId,
    String videoId,
    String theme,
    String category,
  ) async {
    final String saveUrl = isSaved
        ? 'user-video-interactions/unsave/$videoId'
        : 'user-video-interactions/$videoId';
    final requestBody = {
      "videoId": videoId,
      "category": category,
      "theme": theme,
      "interactionType": "SAVED",
    };
    try {
      await APIService.instance.postData(
        saveUrl,
        cBaseUrl: _baseUrl,
        apiName: 'ShortsRepo/addSave',
        body: isSaved ? null : requestBody,
      );
      return const ApiResponse<void>(code: 200);
    } catch (e) {
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
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<void>> updateSeen(
    String videoId,
  ) async {
    final String countUrl = 'videos/$videoId/mark-seen';
    try {
      await APIService.instance.patchData(
        countUrl,
        cBaseUrl: _baseUrl,
        apiName: 'ShortsRepo/updateSeen',
      );
      return const ApiResponse<void>(code: 200);
    } catch (e) {
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<String>> dynamicLink({
    required String id,
  }) async {
    final query = {
      "type": "shorts",
      "id": id,
    };
    try {
      final response = await APIService.instance.postData(
        'events/generate-link',
        cBaseUrl: _baseUrl,
        queryParams: query,
        apiName: 'ShortsRepo/dynamicLink',
      );
      final responseData = response["data"];
      return ApiResponse<String>(
        model: responseData['shortLink'],
        code: 200,
      );
    } catch (e) {
      return ApiResponse.withError(e.toString(), 400);
    }
  }
}
