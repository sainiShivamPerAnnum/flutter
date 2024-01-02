import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/cupertino.dart';

enum AssetPrefOptions {
  NO_PREF,
  LENDBOX_P2P,
  AUGMONT_GOLD,
}

class AssetPreferenceViewModel extends BaseViewModel {
  List<dynamic> assets = AssetPrefOptions.values;
  AssetPrefOptions? selectedAsset;
  String? name = locator<UserService>().name;
  AnimationController? oldSelectedController;
  AnimationController? newSelectedController;
  Animation<double>? oldSelectedAnimation;
  Animation<double>? newSelectedAnimation;

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

  void triggerAnimation(
      AnimationController controller, AssetPrefOptions assetPrefOptions) {
    if (selectedAsset == assetPrefOptions) {
      oldSelectedController = newSelectedController;
      newSelectedController = controller;

      newSelectedAnimation = CurvedAnimation(
        parent: newSelectedController!,
        curve: Curves.bounceInOut,
      );
      newSelectedController!.forward(from: 0.0);

      if (oldSelectedController != null) {
        oldSelectedAnimation = CurvedAnimation(
          parent: oldSelectedController!,
          curve: Curves.bounceInOut,
        );

        oldSelectedController!.reverse(from: 1.0);
      }
    }
  }
}
