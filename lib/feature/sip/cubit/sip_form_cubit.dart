import 'package:bloc/bloc.dart';
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/sip_asset_type.dart';
import 'package:felloapp/core/repository/subscription_repo.dart';
import 'package:felloapp/core/service/subscription_service.dart';
import 'package:felloapp/feature/sip/sip_polling_page/view/sip_polling_view.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';

part 'sip_form_state.dart';

class SipFormCubit extends Cubit<SipFormCubitState> {
  SipFormCubit() : super(SipFormCubitState());
  final SubService _subService = locator<SubService>();
  final _subscriptionRepo = locator<SubscriptionRepo>();

  void setAmount(int amount) {
    emit(state.copyWith(formAmount: amount));
  }

  Future<void> getData() async {
    await _subService.getSubscription();
  }

  Future<bool> editSipTrigger(
      num principalAmount, String frequency, String id) async {
    emit(state.copyWith(isLoading: true));
    bool response = await _subService.updateSubscription(
        freq: frequency, amount: principalAmount.toInt(), id: id);
    if (!response) {
      BaseUtil.showNegativeAlert("Failed to update SIP", "Please try again");
      emit(state.copyWith(isLoading: false));
      return false;
    } else {
      await getData();
      emit(state.copyWith(isLoading: false));
      BaseUtil.showPositiveAlert("Subscription updated successfully",
          "Effective changes will take place from tomorrow");
      await AppState.backButtonDispatcher!.didPopRoute();
      return true;
    }
  }

  Future<void> createSubscription({
    required num amount,
    required String freq,
    required SIPAssetTypes assetType,
  }) async {
    emit(state.copyWith(isLoading: true));

    final response = await _subscriptionRepo.createSubscription(
      freq: freq,
      amount: amount,
      assetType: assetType.name,
      lbAmt: assetType != SIPAssetTypes.AUGGOLD99 ? amount : 0,
      augAmt: assetType == SIPAssetTypes.AUGGOLD99 ? amount : 0,
    );

    final data = response.model?.data;
    final subscription = data?.subscription;

    if (response.isSuccess() && subscription != null) {
      AppState.delegate!.appState.currentAction = PageAction(
        state: PageState.addWidget,
        page: SipPollingPageConfig,
        widget: SipPollingPage(
          data: subscription,
        ),
      );
    } else {
      emit(state.copyWith(isLoading: false));
      BaseUtil.showNegativeAlert(
        'Failed to create subscription',
        response.errorMessage,
      );
    }
  }
}
