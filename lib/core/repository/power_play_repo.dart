import 'dart:developer';

import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/power_play_models/get_matches_model.dart';
import 'package:felloapp/core/model/power_play_models/match_winners_leaderboard_item_model.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/service/cache_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';

class PowerPlayRepository extends BaseRepo {
  final CustomLogger _logger = locator<CustomLogger>();
  final _cacheService = CacheService();
  final String _baseUrl = FlavorConfig.isDevelopment()
      ? "https://rco4comkpa.execute-api.ap-south-1.amazonaws.com/dev"
      : "https://l4aighxmj3.execute-api.ap-south-1.amazonaws.com/prod";

  Future<ApiResponse<MatchesModel>> getMatchesByStatus(
      String status, int limit, int offset) async {
    try {
      final response = await APIService.instance.getData(
        ApiPath.powerPlayMatches(status, limit, offset),
        cBaseUrl: _baseUrl,
      );
      if (response['data'] != null) {
        log("REPO getMatchesByStatus => ${response['data']}");

        return ApiResponse<MatchesModel>(
          model: MatchesModel.fromJson(response),
          code: 200,
        );
      }

      return ApiResponse<MatchesModel>(
        model: MatchesModel(),
        code: 200,
      );
    } catch (e) {
      _logger.e("getMatchesByStatus => ${e.toString()}");
      return ApiResponse.withError(
        e.toString(),
        400,
      );
    }
  }

  Future<ApiResponse<List<MatchWinnersLeaderboardItemModel>>>
      getWinnersLeaderboard(String matchId) async {
    List<MatchWinnersLeaderboardItemModel> winners = [];
    try {
      final response = await APIService.instance.getData(
        ApiPath.powerPlayWinnersLeaderboard(matchId),
        cBaseUrl: _baseUrl,
      );
      if (response['data'] != null) {
        winners = MatchWinnersLeaderboardItemModel.helper
            .fromMapArray(response['data']['users']);
      }
      return ApiResponse<List<MatchWinnersLeaderboardItemModel>>(
        model: winners,
        code: 200,
      );
    } catch (e) {
      _logger.e("getMatchesByStatus => ${e.toString()}");
      return ApiResponse.withError(
        e.toString(),
        400,
      );
    }
  }
}
