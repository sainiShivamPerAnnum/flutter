import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/core/model/leader_board_modal.dart';
import 'package:felloapp/core/service/api.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/code_from_freq.dart';
import 'package:felloapp/util/locator.dart';
import 'package:logger/logger.dart';

class StatisticsRepository {
  final _api = locator<Api>();
  final _logger = locator<Logger>();

  Future<ApiResponse<LeaderBoardModal>> getLeaderBoard(
      String gameType, String freq) async {
    try {
      String code = CodeFromFreq.getCodeFromFreq(freq);
      _logger.d("Game Type : $gameType \n Frequency: $freq \n Code: $code");
      final QueryDocumentSnapshot _response =
          await _api.getStatisticsByFreqGameTypeAndCode(gameType, freq, code);

      LeaderBoardModal _responseModel =
          LeaderBoardModal.fromMap(_response.data());

      _logger.d(_responseModel.toJson().toString());
      return ApiResponse(model: _responseModel, code: 200);
    } catch (e) {
      return ApiResponse.withError(e.toString(), 400);
    }
  }
}
