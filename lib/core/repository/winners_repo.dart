import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/top_winners_model.dart';
import 'package:felloapp/core/model/winners_model.dart';
import 'package:felloapp/core/service/api.dart';
import 'package:felloapp/core/service/api_cache_manager.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/code_from_freq.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';

class WinnersRepository {
  final _userService = locator<UserService>();
  final _api = locator<Api>();
  final _logger = locator<CustomLogger>();
  final _apiPaths = locator<ApiPath>();
  final _apiCacheManager = locator<ApiCacheManager>();

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

      String cacheKey = "winners" + gameType + freq;
      _logger.d("Cachekey: $cacheKey");

      Map data;
      WinnersModel _responseModel;

      //Caching Mechanism
      data = await _apiCacheManager.getApiCache(key: cacheKey);
      _logger.d("Cache with key $cacheKey data: $data");

      if (data != null) {
        _logger.d("Reading Api cache with key: $cacheKey");
        _responseModel = WinnersModel.fromMap(data, gameType);
      } else {
        _logger.d("Adding Api cache with key isCacheable: $cacheKey");
        final QueryDocumentSnapshot _response =
            await _api.getWinnersByGameTypeFreqAndCode(gameType, freq, code);

        data = _response.data();
        _responseModel = WinnersModel.fromMap(data, gameType);

        await _apiCacheManager.writeApiCache(
          key: cacheKey,
          ttl: Duration(hours: 6),
          value: _responseModel.toJson(),
        );
      }

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

  Future<ApiResponse<List<WinnersModel>>> getPastWinners(
      String gameType, String freq) async {
    try {
      // String code = CodeFromFreq.getPastEventCodeFromFreq(freq);
      List<WinnersModel> pastWinnersList = [];
      _logger.d("Past Winners :: Game Type : $gameType \n Frequency: $freq");
      final List<QueryDocumentSnapshot> _response =
          await _api.getPastHighestSaverWinners(gameType, freq);
      if (_response != null && _response.isNotEmpty) {
        for (int i = 0; i < _response.length; i++) {
          pastWinnersList
              .add(WinnersModel.fromMap(_response[i].data(), gameType));
        }
      }

      // _logger.d(past.data().toString());
      return ApiResponse(model: pastWinnersList, code: 200);
    } catch (e) {
      _logger.e(e);
      return ApiResponse.withError(e.toString(), 400);
    }
  }
}
