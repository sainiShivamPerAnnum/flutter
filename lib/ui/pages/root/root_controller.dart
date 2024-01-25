import 'dart:developer';

import 'package:felloapp/core/model/bottom_nav_bar_item_model.dart';
import 'package:felloapp/feature/tambola/tambola.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_view.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/show_case_key.dart';
import 'package:flutter/material.dart';

class RootController {
  static final tambolaNavBar = NavBarItemModel(
      "Tickets", Assets.navTambolaLottie, ShowCaseKeys.TambolaKey);
  static final journeyNavBarItem =
      NavBarItemModel("Journey", Assets.navJourneyLottie, ShowCaseKeys.Journey);

  static final playNavBarItem =
      NavBarItemModel("Play", Assets.navPlayLottie, ShowCaseKeys.PlayKey);

  static final winNavBarItem =
      NavBarItemModel("Account", Assets.navWinLottie, ShowCaseKeys.AccountKey);
  static final saveNavBarItem =
      NavBarItemModel("Save", Assets.navSaveLottie, ShowCaseKeys.SaveKey);

  NavBarItemModel currentNavBarItemModel = NavBarItemModel(
    "Save",
    Assets.navSaveLottie,
    ShowCaseKeys.SaveKey,
  );

  Map<Widget, NavBarItemModel> navItems = {};

  static ScrollController controller = ScrollController();

  void onChange(NavBarItemModel model) {
    log("onChange ${model.title}");
    if (currentNavBarItemModel.title == model.title && controller.hasClients) {
      controller.animateTo(0,
          duration: const Duration(seconds: 2), curve: Curves.decelerate);
    }
    currentNavBarItemModel = model;
  }

  void getNavItems(String navItem) {
    switch (navItem) {
      case "SV":
        navItems.putIfAbsent(const Save(), () => RootController.saveNavBarItem);
        break;
      case "TM":
        navItems.putIfAbsent(
            const TambolaHomeTicketsView(), () => RootController.tambolaNavBar);
        break;

      default:
    }
  }
}
