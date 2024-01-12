import 'dart:developer';

import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/last_week_model.dart';
import 'package:felloapp/core/model/winners_model.dart';
import 'package:felloapp/core/repository/campaigns_repo.dart';
import 'package:felloapp/core/service/notifier_services/winners_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';

class LastWeekViewModel extends BaseViewModel {
  bool fetchCampaign = true;

  LastWeekData? _data;
  List<Winners>? pastWeekWinners;
  final WinnerService _winnerService = locator<WinnerService>();

  LastWeekData? get data => _data;

  set data(LastWeekData? value) {
    _data = value;
    notifyListeners();
  }

  Future<void> init() async {
    setState(ViewState.Busy);
    final response = await locator<CampaignRepo>().getLastWeekData();
    final winnersModel = await _winnerService
        .fetchWinnersByGameCode(Constants.GAME_TYPE_TAMBOLA);

    log('last_week => ${response.model?.data?.toJson()}', name: 'last_week_vm');

    try {
      if (response.isSuccess() &&
          response.model != null &&
          response.model?.data != null) {
        data = response.model!.data!;
        pastWeekWinners = winnersModel!.winners!;
        notifyListeners();
      }
      setState(ViewState.Idle);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
