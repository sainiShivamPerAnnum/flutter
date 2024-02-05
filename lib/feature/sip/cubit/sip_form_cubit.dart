import 'package:bloc/bloc.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/service/subscription_service.dart';
import 'package:felloapp/feature/sip/cubit/sub_data_handler.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';

part 'sip_form_state.dart';

class SipFormCubit extends Cubit<SipFormCubitState> {
  SipFormCubit() : super(SipFormCubitState());
  final SubService _subService = locator<SubService>();

  void setAmount(double amount) {
    emit(state.copyWith(formAmount: amount));
  }

  Future<void> getData() async {
    await _subService.getSubscription();
    AllSubscriptionHolder.init(_subService.subscriptionData!);
  }

  Future<bool> editSipTrigger(
      num principalAmount, String frequency, String id) async {
    bool response = await _subService.updateSubscription(
        freq: frequency, amount: principalAmount.toInt(), id: id);
    if (!response) {
      BaseUtil.showNegativeAlert("Failed to update SIP", "Please try again");
      return false;
    } else {
      await getData();
      BaseUtil.showPositiveAlert("Subscription updated successfully",
          "Effective changes will take place from tomorrow");
      await AppState.backButtonDispatcher!.didPopRoute();
      return true;
    }
  }
}
