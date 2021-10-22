import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/core/model/winners_model.dart';
import 'package:felloapp/core/service/api.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/code_from_freq.dart';
import 'package:felloapp/util/locator.dart';
import 'package:logger/logger.dart';

class WinnersRepository {
  final _api = locator<Api>();
  final _logger = locator<Logger>();

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
}
