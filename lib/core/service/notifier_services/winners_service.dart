import 'package:felloapp/core/model/winners_model.dart';
import 'package:felloapp/core/repository/getters_repo.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../ops/db_ops.dart';

class WinnerService extends ChangeNotifier {
  final CustomLogger _logger = locator<CustomLogger>();
  final GetterRepository _getterRepo = locator<GetterRepository>();
  final DBModel _dbModel = locator<DBModel>();
  Map<String, List<Winners>> gameWinnersMap = {};

  Future getProfileDpWithUid(String? uid) async {
    return _dbModel.getUserDP(uid);
  }

  String getDateRange() {
    var today = DateTime.now();
    var beforeSevenDays = today.subtract(const Duration(days: 7));
    DateFormat formatter = DateFormat('MMM');

    int dayToday = today.day;
    String monthToday = formatter.format(today);
    String todayDateToShow = "$dayToday $monthToday";

    int dayOld = beforeSevenDays.day;
    String monthOld = formatter.format(beforeSevenDays);
    String oldDateToShow = "$dayOld $monthOld";

    return "$oldDateToShow - $todayDateToShow";
  }

  Future<WinnersModel?> fetchWinnersByGameCode(String code) async {
    return getWinners(
      code,
      "weekly",
    );
  }

  Future<WinnersModel> getWinners(
    String gameType,
    String freq,
  ) async {
    _logger.d("Winner Game Type : $gameType \n Frequency: $freq");

    final ApiResponse response = await _getterRepo.getWinnerByFreqGameType(
      type: gameType,
      freq: freq,
    );

    if (response.code == 200) {
      return response.model;
    }
    return WinnersModel.base();
  }
}
