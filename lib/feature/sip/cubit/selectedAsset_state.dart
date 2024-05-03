part of 'selectedAsset_cubit.dart';

sealed class AutoSaveSetupState extends Equatable {
  const AutoSaveSetupState();
}

final class SelectAssetCubitState extends AutoSaveSetupState {
  final AssetOptions? selectedAsset;
  const SelectAssetCubitState({
    this.selectedAsset,
  });

  SelectAssetCubitState copyWith({
    AssetOptions? selectedAsset,
  }) {
    return SelectAssetCubitState(
      selectedAsset: selectedAsset ?? this.selectedAsset,
    );
  }

  @override
  List<Object?> get props => [selectedAsset];
}
