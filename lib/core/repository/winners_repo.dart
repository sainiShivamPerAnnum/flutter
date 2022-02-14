import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/top_winners_model.dart';
import 'package:felloapp/core/model/winners_model.dart';
import 'package:felloapp/core/service/api.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/code_from_freq.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/custom_logger.dart';

class WinnersRepository {
  final _userService = locator<UserService>();
  final _api = locator<Api>();
  final _logger = locator<CustomLogger>();
  final _apiPaths = locator<ApiPath>();

  Future<String> _getBearerToken() async {
    String token = await _userService.firebaseUser.getIdToken();
    _logger.d(token);

    return token;
  }

  Future<ApiResponse<WinnersModel>> getWinners(
      String gameType, String freq) async {
    try {
      String code = CodeFromFreq.getCodeFromFreq(freq);
      _logger.d("Game Type : $gameType \n Frequency: $freq \n Code: $code");
      final QueryDocumentSnapshot _response =
          await _api.getWinnersByGameTypeFreqAndCode(gameType, freq, code);

      WinnersModel _responseModel =
          WinnersModel.fromMap(_response.data(), gameType);

      _logger.d(_response.data().toString());
      return ApiResponse(model: _responseModel, code: 200);
    } catch (e) {
      _logger.e(e);
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<List<String>>> getTopWinners() async {
    try {
      final String _bearer = await _getBearerToken();
      final _apiResponse = await APIService.instance
          .getData(_apiPaths.kTopWinners, token: _bearer);
      TopWinnersModel _topWinnersModel = TopWinnersModel.fromMap(_apiResponse);

      return ApiResponse(model: _topWinnersModel.currentTopWinners, code: 200);
    } catch (e) {
      _logger.e(e);
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<WinnersModel>> getPastWinners(
      String gameType, String freq) async {
    try {
      String code = CodeFromFreq.getPastEventCodeFromFreq(freq);
      _logger.d(
          "Past Winners :: Game Type : $gameType \n Frequency: $freq \n Code: $code");
      final QueryDocumentSnapshot _response =
          await _api.getWinnersByGameTypeFreqAndCode(gameType, freq, code);

      WinnersModel _responseModel =
          WinnersModel.fromMap(_response.data(), gameType);

      _logger.d(_response.data().toString());
      return ApiResponse(model: _responseModel, code: 200);
    } catch (e) {
      _logger.e(e);
      return ApiResponse.withError(e.toString(), 400);
    }
  }
}
