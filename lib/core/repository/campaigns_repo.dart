import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/constants/cache_keys.dart';
import 'package:felloapp/core/enums/ttl.dart';
import 'package:felloapp/core/model/badges_leader_board_model.dart';
import 'package:felloapp/core/model/event_model.dart';
import 'package:felloapp/core/model/fello_badges_model.dart';
import 'package:felloapp/core/model/fello_facts_model.dart';
import 'package:felloapp/core/model/happy_hour_campign.dart';
import 'package:felloapp/core/model/last_week_model.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/service/cache_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/flavor_config.dart';

import 'base_repo.dart';

class CampaignRepo extends BaseRepo {
  final _cacheService = CacheService();
  final _baseUrl = FlavorConfig.isDevelopment()
      ? "https://8bopjrisyb.execute-api.ap-south-1.amazonaws.com/dev"
      : "https://l4aighxmj3.execute-api.ap-south-1.amazonaws.com/prod";

  final _cdnBaseUrl = FlavorConfig.isDevelopment()
      ? 'https://d18gbwu7fwwwtf.cloudfront.net/'
      : 'https://d11q4cti75qmcp.cloudfront.net/';

  static const _campaigns = 'campaigns';
  static const _superFello = 'super-fello';

  Future<ApiResponse<dynamic>> getOngoingEvents() async {
    List<EventModel> events = [];
    try {
      final String? uid = userService.baseUser!.uid;
      final queryParams = {"uid": uid};

      return await _cacheService.cachedApi(
        CacheKeys.CAMPAIGNS,
        TTL.TWO_HOURS,
        () => APIService.instance.getData(
          ApiPath.kOngoingCampaigns,
          cBaseUrl: _baseUrl,
          queryParams: queryParams,
          apiName: _campaigns,
        ),
        (response) {
          final responseData = response["data"];
          logger.d(responseData);
          if (responseData['status'] == true) {
            responseData["campaigns"].forEach((e) {
              events.add(EventModel.fromMap(e));
            });
          }
          return ApiResponse<List<EventModel>>(model: events, code: 200);
        },
      );
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(
        e.toString(),
        400,
      );
    }
  }

  Future<ApiResponse<List<FelloFactsModel>>> getFelloFacts() async {
    List<FelloFactsModel> facts = [];
    try {
      final response = await APIService.instance.getData(
        'felloFacts.txt',
        cBaseUrl: _cdnBaseUrl,
        decryptData: true,
        apiName: "felloFacts",
      );

      logger.d(response);
      if (response != null) {
        response.forEach((e) {
          facts.add(FelloFactsModel.fromMap(e));
        });
      }
      return ApiResponse<List<FelloFactsModel>>(model: facts, code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(
        e.toString(),
        400,
      );
    }
  }

  Future<ApiResponse<HappyHourCampign>> getHappyHourCampaign() async {
    try {
      final response = await APIService.instance.getData(
        ApiPath.happyHour,
        cBaseUrl: _baseUrl,
        apiName: "$_campaigns/happyHour",
      );

      return ApiResponse<HappyHourCampign>(
          model: HappyHourCampign.fromJson(response), code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<LastWeekModel>> getLastWeekData() async {
    try {
      final response = await APIService.instance.getData(
        ApiPath.lastWeekRecap,
        cBaseUrl: _baseUrl,
        apiName: "$_campaigns/lastWeekRecap",
      );

      final responseData = response["data"];

      if (responseData == null) {
        return ApiResponse.withError("Unable to fetch data", 400);
      }

      return ApiResponse<LastWeekModel>(
        model: LastWeekModel.fromJson(response),
        code: 200,
      );
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError("Unable to fetch data", 400);
    }
  }

  Future<ApiResponse<BadgesLeaderBoardModel>> getBadgesLeaderBoard() async {
    try {
      final res = await APIService.instance.getData(
        ApiPath.badgesLeaderBoard,
        cBaseUrl: _baseUrl,
        apiName: '$_superFello/leaderboard',
      );

      return res != null && res['data'] != null && res['data'].isNotEmpty
          ? ApiResponse<BadgesLeaderBoardModel>(
              model: BadgesLeaderBoardModel.fromJson(res),
              code: 200,
            )
          : ApiResponse<BadgesLeaderBoardModel>(
              model: null,
              code: 200,
            );
    } catch (e) {
      logger.d(e);
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<FelloBadgesModel>> getFelloBadges() async {
    try {
      final res = await APIService.instance.getData(
        ApiPath.felloBadges,
        cBaseUrl: _baseUrl,
        apiName: _superFello,
      );

      return res != null && res['data'] != null && res['data'].isNotEmpty
          ? ApiResponse<FelloBadgesModel>(
              model: FelloBadgesModel.fromJson(res),
              code: 200,
            )
          : ApiResponse<FelloBadgesModel>(
              model: null,
              code: 200,
            );
    } catch (e) {
      logger.d(e);
      return ApiResponse.withError(e.toString(), 400);
    }
  }
}
