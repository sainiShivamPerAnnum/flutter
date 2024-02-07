part of 'selectedAsset_cubit.dart';

@immutable
abstract class AutoSaveSetupState {}

final class SelectAssetCubitState extends AutoSaveSetupState {
  final SIPAssetTypes? selectedAsset;
  SelectAssetCubitState({
    this.selectedAsset,
  });

  SelectAssetCubitState copyWith({
    SIPAssetTypes? selectedAsset,
  }) {
    return SelectAssetCubitState(
      selectedAsset: selectedAsset ?? this.selectedAsset,
    );
  }
}
