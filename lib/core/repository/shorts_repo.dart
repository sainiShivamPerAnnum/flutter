import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/shorts/shorts_home.dart';
import 'package:felloapp/core/model/shorts/shorts_notification.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/flavor_config.dart';

class ShortsRepository extends BaseRepo {
  static const _shorts = 'shorts';

  final _baseUrl = FlavorConfig.isDevelopment()
      ? 'https://advisors.fello-dev.net/'
      : 'https://advisors.fello-prod.net/';

  Future<ApiResponse<ShortsHome>> getShortsHomeData() async {
    try {
      final response = await APIService.instance.getData(
        ApiPath.shortsHome,
        cBaseUrl: _baseUrl,
        apiName: '$_shorts/getShortsHomeData',
      );
      final responseData = response["data"];
      return ApiResponse<ShortsHome>(
        model: ShortsHome.fromJson(responseData),
        code: 200,
      );
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<bool>> toggleNotification({
    required String theme,
    required bool isFollowed,
  }) async {
    final uid = userService.baseUser!.uid;
    final apiPath = isFollowed ? ApiPath.unfollowTheme : ApiPath.followTheme;
    try {
      final body = {
        "uid": uid,
        "theme": theme,
      };
      await APIService.instance.postData(
        apiPath,
        cBaseUrl: _baseUrl,
        apiName: '$_shorts/toggleNotification',
        body: body,
      );
      return const ApiResponse<bool>(
        model: true,
        code: 200,
      );
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<List<ShortsThemeData>>> applyQuery({
    required String query,
  }) async {
    try {
      final params = {"query": query, "type": "shorts"};
      final response = await APIService.instance.getData(
        ApiPath.searchShorts,
        cBaseUrl: _baseUrl,
        apiName: '$_shorts/applyQuery',
        queryParams: params,
      );
      final responseData = response["data"]["themes"];
      final List<ShortsThemeData> data = (responseData as List)
          .map(
            (item) => ShortsThemeData.fromJson(
              item,
            ),
          )
          .toList();
      return ApiResponse<List<ShortsThemeData>>(
        model: data,
        code: 200,
      );
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<List<ShortsThemeData>>> getSaved() async {
    try {
      final response = await APIService.instance.getData(
        ApiPath.getSaved,
        cBaseUrl: _baseUrl,
        apiName: '$_shorts/getSaved',
      );
      final responseData = response["data"]["themes"];
      final List<ShortsThemeData> data = (responseData as List)
          .map(
            (item) => ShortsThemeData.fromJson(
              item,
            ),
          )
          .toList();
      return ApiResponse<List<ShortsThemeData>>(
        model: data,
        code: 200,
      );
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<List<ShortsThemeData>>> applyCategory({
    required String query,
  }) async {
    try {
      final params = {
        "query": query,
      };
      final response = await APIService.instance.getData(
        ApiPath.shortsCategory,
        cBaseUrl: _baseUrl,
        apiName: '$_shorts/applyCategory',
        queryParams: params,
      );
      final responseData = response["data"];
      final List<ShortsThemeData> data = (responseData as List)
          .map(
            (item) => ShortsThemeData.fromJson(
              item,
            ),
          )
          .toList();
      return ApiResponse<List<ShortsThemeData>>(
        model: data,
        code: 200,
      );
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<PaginatedShorts>> getPaginatedResponse({
    required String theme,
    int page = 1,
    int limit = 10,
    String? query,
  }) async {
    try {
      final queryParameters = {
        'page': page.toString(),
        'limit': limit.toString(),
        'theme': theme,
      };
      if (query != null) {
        queryParameters.addAll(
          {
            "query": query,
          },
        );
      }
      final response = await APIService.instance.getData(
        'videos/search-shorts-theme',
        cBaseUrl: _baseUrl,
        apiName: 'ShortsRepo/getPaginatedResponse',
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

  Future<ApiResponse<ShortsNotification>> getShortsNotification({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final uid = userService.baseUser!.uid;
      final queryParameters = {
        'userId': uid,
        'page': page.toString(),
        'limit': limit.toString(),
      };
      final response = await APIService.instance.getData(
        'notifications/user-notifications',
        cBaseUrl: _baseUrl,
        apiName: 'ShortsRepo/getShortsNotification',
        queryParams: queryParameters,
      );
      final responseData = response["data"];
      return ApiResponse<ShortsNotification>(
        model: ShortsNotification.fromJson(responseData),
        code: 200,
      );
    } catch (e) {
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<bool>> updateNotifications({
    List<String> notifications = const [],
  }) async {
    try {
      final uid = userService.baseUser!.uid;
      final queryParameters = {
        'uid': uid,
        'videoIds': [notifications],
      };
      await APIService.instance.postData(
        'notifications/update-seen-uid',
        cBaseUrl: _baseUrl,
        apiName: 'ShortsRepo/updateNotifications',
        queryParams: queryParameters,
      );
      return const ApiResponse<bool>(
        model: true,
        code: 200,
      );
    } catch (e) {
      return ApiResponse.withError(e.toString(), 400);
    }
  }
}
