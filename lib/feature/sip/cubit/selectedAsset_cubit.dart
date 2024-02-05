import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'selectedAsset_state.dart';

class SelectAssetCubit extends Cubit<SelectAssetCubitState> {
  SelectAssetCubit() : super(SelectAssetCubitState());

  void setSelectedAsset(int index) {
    emit(state.copyWith(selectedAsset: index));
  }
}
