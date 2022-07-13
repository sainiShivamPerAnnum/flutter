import 'dart:developer';

import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/event_model.dart';
import 'package:felloapp/core/model/game_model.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/flavor_config.dart';

import 'base_repo.dart';

class GameRepo extends BaseRepo {
  final _baseUrl = FlavorConfig.isDevelopment()
      ? "https://4mm5ihvkz0.execute-api.ap-south-1.amazonaws.com/dev"
      : "";

  Future<ApiResponse<List<GameModel>>> getGames() async {
    try {
      final response = await APIService.instance.getData(
        ApiPath.getGames,
        cBaseUrl: _baseUrl,
      );
      final games = GameModel.helper.fromMapArray(response["data"]["games"]);
      return ApiResponse<List<GameModel>>(model: games, code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError("Unable to fetch campaings", 400);
    }
  }
}
