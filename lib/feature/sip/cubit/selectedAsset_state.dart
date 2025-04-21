part of 'selectedAsset_cubit.dart';

sealed class AutoSaveSetupState extends Equatable {
  const AutoSaveSetupState();
}

final class SelectAssetCubitState extends AutoSaveSetupState {
  final AssetOptions? selectedAsset;

  SelectAssetCubitState({
    AssetOptions? selectedAsset,
  }) : selectedAsset = selectedAsset ?? _getDefaultAugGoldAsset();

  static AssetOptions? _getDefaultAugGoldAsset() {
    return SipDataHolder.instance.data.selectAssetScreen.options.firstWhere(
      (option) => option.isAugGold,
      orElse: () =>
          SipDataHolder.instance.data.selectAssetScreen.options.isNotEmpty
              ? SipDataHolder.instance.data.selectAssetScreen.options.first
              : const AssetOptions(),
    );
  }

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
