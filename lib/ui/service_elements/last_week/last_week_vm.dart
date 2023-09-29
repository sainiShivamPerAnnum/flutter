import 'dart:developer';

import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/last_week_model.dart';
import 'package:felloapp/core/repository/campaigns_repo.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';

class LastWeekViewModel extends BaseViewModel {
  bool fetchCampaign = true;

  LastWeekData? _data;

  LastWeekData? get data => _data;

  set data(LastWeekData? value) {
    _data = value;
    notifyListeners();
  }

  Future<void> init() async {
    setState(ViewState.Busy);
    final response = await locator<CampaignRepo>().getLastWeekData();

    log('last_week => ${response.model?.data?.toJson()}', name: 'last_week_vm');

    try {
      if (response.isSuccess() &&
          response.model != null &&
          response.model?.data != null) {
        data = response.model!.data!;
        notifyListeners();
      }
      setState(ViewState.Idle);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
