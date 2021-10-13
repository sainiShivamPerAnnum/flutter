import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/core/service/api.dart';
import 'package:felloapp/util/locator.dart';
import 'package:logger/logger.dart';

class StatisticsRepo {
  final _api = locator<Api>();
  final _logger = locator<Logger>();

  getLeaderBoard(String gameType, String freq) async {
    // String code = getCodeFromFreq();
    String code = "";
    final DocumentReference _response =
        await _api.getStatisticsByFreqGameTypeAndCode(gameType, freq, code);
  }
}
