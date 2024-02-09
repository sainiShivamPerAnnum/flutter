import 'package:bloc/bloc.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/sip_asset_type.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';

part 'selectedAsset_state.dart';

class SelectAssetCubit extends Cubit<SelectAssetCubitState> {
  SelectAssetCubit() : super(SelectAssetCubitState());

  void setSelectedAsset(SIPAssetTypes asset) {
    emit(state.copyWith(selectedAsset: asset));

    locator<AnalyticsService>().track(
      eventName: AnalyticsEvents.sipAssetSelected,
      properties: {
        "asset selected": asset.name,
      },
    );
  }
}
