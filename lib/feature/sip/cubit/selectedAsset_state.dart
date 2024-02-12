part of 'selectedAsset_cubit.dart';

sealed class AutoSaveSetupState extends Equatable {
  const AutoSaveSetupState();
}

final class SelectAssetCubitState extends AutoSaveSetupState {
  final SIPAssetTypes? selectedAsset;
  const SelectAssetCubitState({
    this.selectedAsset,
  });

  SelectAssetCubitState copyWith({
    SIPAssetTypes? selectedAsset,
  }) {
    return SelectAssetCubitState(
      selectedAsset: selectedAsset ?? this.selectedAsset,
    );
  }

  @override
  List<Object?> get props => [selectedAsset];
}
