import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/sdui/sections/home_page_sections.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/asset_prefs/asset_pref_bottom_sheet.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';

class AssetPreferenceViewModel extends BaseViewModel {
  AssetPrefType? selectedAsset;
  String name = locator<UserService>().name ?? '';
  static AppState appStateProvider = AppState.delegate!.appState;

  void changeSelectedAsset(AssetPrefType assetPrefOptions) {
    if (selectedAsset == assetPrefOptions) return;
    selectedAsset = assetPrefOptions;
    notifyListeners();
  }

  void handleRouting(AssetPrefType? assetPrefOptions) {
    switch (assetPrefOptions) {
      case AssetPrefType.P2P:
        break;
      case AssetPrefType.GOLD:
        break;
      case AssetPrefType.NONE:
        appStateProvider.currentAction = PageAction(
          state: PageState.replaceAll,
          page: RootPageConfig,
        );
        break;
      default:
        appStateProvider.currentAction = PageAction(
          state: PageState.replaceAll,
          page: RootPageConfig,
        );
    }
  }

  void onPressedSkip() {
    BaseUtil.openModalBottomSheet(
      isBarrierDismissible: true,
      content: NoPrefBottomSheet(
        model: this,
      ),
    );
  }

  void onProceed(BottomSheetComponent bottomSheetData) {
    switch (selectedAsset) {
      case AssetPrefType.NONE:
        BaseUtil.openModalBottomSheet(
          addToScreenStack: true,
          isBarrierDismissible: true,
          isScrollControlled: true,
          backgroundColor: UiConstants.grey4,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(SizeConfig.roundness24),
          ),
          content: SkipToHomeBottomSheet(
            model: this,
            bottomSheetData: bottomSheetData,
          ),
        );
        break;

      case AssetPrefType.P2P || AssetPrefType.GOLD:
        handleRouting(selectedAsset);
        break;

      default:
    }
  }
}
