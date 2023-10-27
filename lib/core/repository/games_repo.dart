import 'dart:developer';

import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/game_model.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/flavor_config.dart';

import '../model/game_tier_model.dart' hide GameModel;
import 'base_repo.dart';

class GameRepo extends BaseRepo {
  final _baseUrl = FlavorConfig.isDevelopment()
      ? "https://4mm5ihvkz0.execute-api.ap-south-1.amazonaws.com/dev"
      : "https://u9c7w6pnw7.execute-api.ap-south-1.amazonaws.com/prod";

  static const _games = 'games';

  List<GameModel>? _allgames;
  List<GameModel>? games;

  List<GameModel>? get allgames => _allgames;

  set allgames(List<GameModel>? value) => _allgames = value;

  late GameTiers _gameTiers;

  GameTiers get gameTier => _gameTiers;

  set gameTiers(GameTiers value) {
    _gameTiers = value;
  }

  Future<ApiResponse<List<GameModel>>> getGames() async {
    try {
      final response = await APIService.instance.getData(
        ApiPath.getGames,
        cBaseUrl: _baseUrl,
        apiName: _games,
      );
      log("Games: ${response["data"]}");

      games = GameModel.helper.fromMapArray(response["data"]["games"]);
      allgames = GameModel.helper.fromMapArray(response["data"]["games"]);
      allgames?.removeWhere((game) => game.code == 'TA');

      return ApiResponse<List<GameModel>>(model: allgames, code: 200);
    } catch (e) {
      logger.e("Unable to fetch games ${e.toString()}");

      allgames = [];
      return ApiResponse.withError(
          e.toString() ?? "Unable to fetch games", 400);
    }
  }

  Future<ApiResponse<GameModel>> getGameByCode(
      {required String gameCode}) async {
    try {
      final response = await APIService.instance.getData(
        ApiPath.getGameByCode(gameCode),
        cBaseUrl: _baseUrl,
        apiName: "$_games/byCode",
      );
      final game = GameModel.fromMap(response["data"]);
      return ApiResponse<GameModel>(model: game, code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(
          e.toString() ?? "Unable to fetch game by id", 400);
    }
  }

  Future<ApiResponse<GameTiers>> getGameTiers() async {
    try {
      final response = await APIService.instance.getData(
        '/games/tiers',
        cBaseUrl: _baseUrl,
        apiName: "$_games/tiers",
      );

      gameTiers = GameTiers.fromJson(response);
      return ApiResponse<GameTiers>(model: gameTier, code: 200);
    } catch (e) {
      logger.e("Unable to fetch games ${e.toString()}");

      allgames = [];
      return ApiResponse.withError(
          e.toString() ?? "Unable to fetch games", 400);
    }
  }

  ApiResponse<String> getGameToken({required String? gameName}) {
    String res = getGameApiToken(gameName);
    return ApiResponse(model: res, code: 200);
  }
}
