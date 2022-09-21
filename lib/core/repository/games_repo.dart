import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/game_model.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:flutter/cupertino.dart';

import 'base_repo.dart';

class GameRepo extends BaseRepo {
  final _baseUrl = FlavorConfig.isDevelopment()
      ? "https://4mm5ihvkz0.execute-api.ap-south-1.amazonaws.com/dev"
      : "https://u9c7w6pnw7.execute-api.ap-south-1.amazonaws.com/prod";

  List<GameModel> _allgames;

  List<GameModel> get allgames => this._allgames;

  set allgames(List<GameModel> value) => this._allgames = value;
  Future<ApiResponse<List<GameModel>>> getGames() async {
    try {
      final token = await getBearerToken();
      final response = await APIService.instance.getData(
        ApiPath.getGames,
        cBaseUrl: _baseUrl,
        token: token,
      );
      logger.d("Games: ${response["data"]}");

      final List<GameModel> games =
          GameModel.helper.fromMapArray(response["data"]["games"]);
      // games.removeWhere((game) => game.code == 'TA');
      allgames = games;

      return ApiResponse<List<GameModel>>(model: games, code: 200);
    } catch (e) {
      logger.e("Unable to fetch games ${e.toString()}");
      allgames = [];
      return ApiResponse.withError("Unable to fetch games", 400);
    }
  }

  Future<ApiResponse<GameModel>> getGameByCode(
      {@required String gameCode}) async {
    try {
      final token = await getBearerToken();
      final response = await APIService.instance.getData(
        ApiPath.getGameByCode(gameCode),
        cBaseUrl: _baseUrl,
        token: token,
      );
      final game = GameModel.fromMap(response["data"]);
      return ApiResponse<GameModel>(model: game, code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError("Unable to fetch game by id", 400);
    }
  }

  ApiResponse<String> getGameToken({@required String gameName}) {
    String res = getGameApiToken(gameName);
    return ApiResponse(model: res, code: 200);
  }
}
