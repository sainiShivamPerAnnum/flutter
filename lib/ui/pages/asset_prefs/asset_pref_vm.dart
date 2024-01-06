import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/asset_prefs/asset_pref_bottom_sheet.dart';
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
  static AppState appStateProvider = AppState.delegate!.appState;
  AnimationController? oldSelectedController;
  AnimationController? newSelectedController;
  Animation<double>? oldSelectedAnimation;
  Animation<double>? newSelectedAnimation;

  void changeSelectedAsset(AssetPrefOptions assetPrefOptions) {
    if (selectedAsset == assetPrefOptions) return;
    selectedAsset = assetPrefOptions;
    notifyListeners();
  }

  void handleRouting(AssetPrefOptions? assetPrefOptions) {
    switch (assetPrefOptions) {
      case AssetPrefOptions.LENDBOX_P2P:
        appStateProvider.currentAction = PageAction(
            state: PageState.replaceAll, page: FelloBadgeHomeViewPageConfig);
        break;
      case AssetPrefOptions.AUGMONT_GOLD:
        break;
      case AssetPrefOptions.NO_PREF:
        appStateProvider.currentAction =
            PageAction(state: PageState.replaceAll, page: RootPageConfig);
        break;
      default:
        appStateProvider.currentAction =
            PageAction(state: PageState.replaceAll, page: RootPageConfig);
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

  void handleBottomSheet() {
    BaseUtil.openModalBottomSheet(
        isBarrierDismissible: true,
        content: NoPrefBottomSheet(
          model: this,
        ));
  }
}

class Benefit {
  final String title;
  final String subtitle;

  Benefit({required this.title, required this.subtitle});
}
