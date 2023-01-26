import 'package:felloapp/core/model/bottom_nav_bar_item_model.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_view.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_view.dart';
import 'package:felloapp/util/assets.dart';
import 'package:flutter/material.dart';

class RootController {
  static final tambolaNavBar =
      NavBarItemModel("Tambola", Assets.navTambolaLottie);
  static final journeyNavBarItem =
      NavBarItemModel("Journey", Assets.navJourneyLottie);

  static final playNavBarItem = NavBarItemModel("Play", Assets.navPlayLottie);

  static final winNavBarItem = NavBarItemModel("Account", Assets.navWinLottie);
  static final saveNavBarItem = NavBarItemModel("Save", Assets.navSaveLottie);

  late NavBarItemModel currentNavBarItemModel;

  Map<Widget, NavBarItemModel> navItems = {};

  void onChange(NavBarItemModel model) {
    currentNavBarItemModel = model;
  }

  void getNavItems(String navItem) {
    switch (navItem) {
      // case "JN":
      //   navItems.putIfAbsent(
      //       JourneyView(), () => RootController.journeyNavBarItem);

      //   break;

      // case "SV":
      //   navItems.putIfAbsent(Save(), () => RootController.saveNavBarItem);
      //   break;
      // case "TM":
      //   navItems.putIfAbsent(
      //       TambolaWrapper(), () => RootController.tambolaNavBar);
      //   break;

      case "WN":
      case "AC":
        navItems.putIfAbsent(Win(), () => RootController.winNavBarItem);
        break;
      case "PL":
        navItems.putIfAbsent(Play(), () => RootController.playNavBarItem);
        break;

      default:
    }
  }
}
