part of 'selectedAsset_cubit.dart';

@immutable
abstract class AutoSaveSetupState {}

final class SelectAssetCubitState extends AutoSaveSetupState {
  final int? selectedAsset;
  // int? editIndex;
  SelectAssetCubitState({
    this.selectedAsset = -1,
  });

  SelectAssetCubitState copyWith({
    int? selectedAsset,
  }) {
    return SelectAssetCubitState(
      selectedAsset: selectedAsset ?? this.selectedAsset,
    );
  }
}
