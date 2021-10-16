import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/leader_board_modal.dart';
import 'package:felloapp/core/service/api.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/locator.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class StatisticsRepo {
  final _api = locator<Api>();
  final _logger = locator<Logger>();

  Future<ApiResponse<LeaderBoardModal>> getLeaderBoard(
      String gameType, String freq) async {
    try {
      String code = getCodeFromFreq(freq);
      _logger.d("Game Type : $gameType \n Frequency: $freq \n Code: $code");
      final QueryDocumentSnapshot _response = await _api
          .getStatisticsByFreqGameTypeAndCode(gameType, freq, code);

      LeaderBoardModal _responseModel =
          LeaderBoardModal.fromMap(_response.data());

      _logger.d(_responseModel.toJson().toString());
      return ApiResponse(model: _responseModel, code: 200);
    } catch (e) {
      return ApiResponse.withError(e, 400);
    }
  }

  String getCodeFromFreq(String freq) {
    final DateTime _currentTime = DateTime.now();
    final monthlyFormat = new DateFormat('yyyy-MM');
    String response = monthlyFormat.format(_currentTime);

    if (freq == 'weekly' || freq == 'daily') {
      int weekcode = BaseUtil.getWeekNumber();
      response += "-$weekcode";
      if (freq == 'daily') {
        final dailyFormat = new DateFormat('dd');
        response += "-${dailyFormat.format(_currentTime)}";
      }
    }
    return response;
  }
}
