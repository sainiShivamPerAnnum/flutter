import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
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
  final _userService = locator<UserService>();
  String get name => _userService.name ?? '';
  static AppState appStateProvider = AppState.delegate!.appState;

  Future<void> init() async {
    setState(ViewState.Busy);
    await _userService.getUserFundWalletData();
    setState(ViewState.Idle);
  }

  void changeSelectedAsset(AssetPrefType assetPrefOptions) {
    if (selectedAsset == assetPrefOptions) return;
    selectedAsset = assetPrefOptions;
    notifyListeners();
  }

  void handleRouting(AssetPrefType? assetPrefOptions) {
    switch (assetPrefOptions) {
      case AssetPrefType.P2P:
        AppState.backButtonDispatcher!.didPopRoute();
        AppState.delegate!.parseRoute(Uri.parse('/floDetails'));
        break;
      case AssetPrefType.GOLD:
        AppState.backButtonDispatcher!.didPopRoute();
        AppState.delegate!.parseRoute(Uri.parse('/goldDetails'));
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

  void onPressedSkip(
      bool enteredFromHomePage, BottomSheetComponent bottomSheetData) {
    if (enteredFromHomePage) {
      AppState.backButtonDispatcher!.didPopRoute();
    }

    _showBottomSheet(bottomSheetData);
  }

  void onProceed(BottomSheetComponent bottomSheetData) {
    switch (selectedAsset) {
      case AssetPrefType.NONE:
        _showBottomSheet(bottomSheetData);
        break;

      case AssetPrefType.P2P || AssetPrefType.GOLD:
        handleRouting(selectedAsset);
        break;

      default:
    }
  }

  void _showBottomSheet(BottomSheetComponent bottomSheetData) {
    BaseUtil.openModalBottomSheet(
      isBarrierDismissible: true,
      isScrollControlled: true,
      addToScreenStack: true,
      backgroundColor: UiConstants.grey4,
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(SizeConfig.roundness24),
      ),
      content: DSLBottomSheet(
        model: this,
        bottomSheetData: bottomSheetData,
      ),
    );
  }
}
