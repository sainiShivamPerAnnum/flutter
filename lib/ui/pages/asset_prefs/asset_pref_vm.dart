import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/locator.dart';

enum AssetPrefOptions {
  NO_PREF,
  LENDBOX_P2P,
  AUGMONT_GOLD,
}

class AssetPreferenceViewModel extends BaseViewModel {
  List<dynamic> assets = AssetPrefOptions.values;
  AssetPrefOptions selectedAsset = AssetPrefOptions.LENDBOX_P2P;
  String? name = locator<UserService>().name;

  void changeSelectedAsset(AssetPrefOptions assetPrefOptions) {
    selectedAsset = assetPrefOptions;
    notifyListeners();
  }

  void handleRouting(AssetPrefOptions assetPrefOptions) {
    switch (assetPrefOptions) {
      case AssetPrefOptions.LENDBOX_P2P:
        break;
      case AssetPrefOptions.AUGMONT_GOLD:
        break;
      case AssetPrefOptions.NO_PREF:
        break;
    }
  }
}
