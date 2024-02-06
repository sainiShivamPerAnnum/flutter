import 'package:bloc/bloc.dart';
import 'package:felloapp/core/enums/sip_asset_type.dart';
import 'package:flutter/material.dart';

part 'selectedAsset_state.dart';

class SelectAssetCubit extends Cubit<SelectAssetCubitState> {
  SelectAssetCubit() : super(SelectAssetCubitState());

  void setSelectedAsset(SIPAssetTypes asset) {
    emit(state.copyWith(selectedAsset: asset));
  }
}
