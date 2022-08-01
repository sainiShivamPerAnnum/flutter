import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/game_model.dart';
import 'package:felloapp/core/model/game_model4.0.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';

class GamesRepository {
  //Dependencies

  final UserService _userService = locator<UserService>();
  final CustomLogger _logger = locator<CustomLogger>();

  //Local Variables

  List<GameDataModel> _allgames;

  //Getters

  List<GameDataModel> get allgames => this._allgames;

  //Setters
  set allgames(List<GameDataModel> value) => this._allgames = value;

//Main functions

  Future<void> loadGamesList() async {
    Future.delayed(Duration(seconds: 5));
    // try {
    final token = await _getBearerToken();
    final response = await APIService.instance.getData(
      ApiPath().kGames,
      token: token,
      cBaseUrl: 'https://4mm5ihvkz0.execute-api.ap-south-1.amazonaws.com',
    );
    final _responseData = response["data"]["games"];
    if (_responseData != null) {
      allgames = [];
      _responseData.forEach((game) {
        allgames.add(GameDataModel.fromJson(game));
      });
    }

    _responseData.map((game) => GameDataModel.fromJson(game)).toList();
    _logger.d(allgames.length);
    // allgames = _responseModel;
    // _logger.d('Game Length: ${_responseModel.length}');
    _logger.d('Game Response: $response');
    // } catch (e) {
    //   _logger.d('Catch Error: $e');
    // }
  }

  Future<GameDataModel> getGameByCode(String gameCode) async {
    try {
      final token = await _getBearerToken();
      final response = await APIService.instance.getData(
        ApiPath.kGame(gameCode),
        token: token,
        cBaseUrl: 'https://4mm5ihvkz0.execute-api.ap-south-1.amazonaws.com',
      );
      final _responseData = response["data"];
      final GameDataModel _responseModel =
          GameDataModel.fromJson(_responseData);
      _logger.d(_responseData);
      return _responseModel;
    } catch (e) {
      _logger.e(e);
      return null;
    }
  }

  //Helper functions

  Future<String> _getBearerToken() async {
    String token = await _userService.firebaseUser.getIdToken();
    _logger.d('Token: $token');
    return token;
  }
}
