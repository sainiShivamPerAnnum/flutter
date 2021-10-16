import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/service/api.dart';
import 'package:felloapp/util/locator.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class StatisticsRepo {
  final _api = locator<Api>();
  final _logger = locator<Logger>();

  getLeaderBoard(String gameType, String freq) async {
    String code = getCodeFromFreq(freq);
    final DocumentReference _response =
        await _api.getStatisticsByFreqGameTypeAndCode(gameType, freq, code);
    _logger.d(_response);
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
