import 'dart:developer';

import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/power_play_models/match_user_predicted_model.dart';
import 'package:felloapp/core/service/power_play_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/locator.dart';

class LeaderBoardViewModel extends BaseViewModel {
  final PowerPlayService _powerPlayService = locator<PowerPlayService>();

  PowerPlayService get powerPlayService => _powerPlayService;

  List<MatchUserPredictedData> _userPredictedData = [];

  List<MatchUserPredictedData> get userPredictedData => _userPredictedData;

  set userPredictedData(List<MatchUserPredictedData> value) {
    _userPredictedData = value;
  }

  Future<void> getUserPredictedData() async {
    state = ViewState.Busy;
    await _powerPlayService
        .getUserPredictedStats(powerPlayService.liveMatchData!.id!);

    log("userPredictedData: ${_powerPlayService.userPredictedData}");

    if (_powerPlayService.userPredictedData.isNotEmpty) {
      userPredictedData = _powerPlayService.userPredictedData;
    }

    state = ViewState.Idle;
    notifyListeners();
  }
}
