import 'dart:developer';

import 'package:felloapp/core/model/bottom_nav_bar_item_model.dart';
import 'package:felloapp/feature/tambola/tambola.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_view.dart';
import 'package:felloapp/ui/pages/support-new/support_new.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/show_case_key.dart';
import 'package:flutter/material.dart';

class RootController {
  // static final tambolaNavBar = NavBarItemModel(
  //     "Tickets", Assets.navTambolaLottie, ShowCaseKeys.TambolaKey);
  static final liveNavBarItem =
      NavBarItemModel("Live", Assets.live_bottom_nav, ShowCaseKeys.Journey);

  static final expertNavBarItem = NavBarItemModel(
      "Experts", Assets.experts_bottom_nav, ShowCaseKeys.PlayKey);

  static final supportNavBarItem = NavBarItemModel(
      "Support", Assets.support_bottom_nav, ShowCaseKeys.AccountKey);
  static final saveNavBarItem =
      NavBarItemModel("Home", Assets.home_bottom_nav, ShowCaseKeys.SaveKey);

  NavBarItemModel currentNavBarItemModel = NavBarItemModel(
    "Home",
    Assets.home_bottom_nav,
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
      // case "TM":
      //   navItems.putIfAbsent(
      //       const TambolaHomeTicketsView(), () => RootController.tambolaNavBar);
      //   break;
      case "LV":
        navItems.putIfAbsent(const TambolaHomeTicketsView(),
            () => RootController.liveNavBarItem);
        break;
      case "EP":
        navItems.putIfAbsent(const TambolaHomeTicketsView(),
            () => RootController.expertNavBarItem);
        break;
      case "SP":
        navItems.putIfAbsent(
            const SupportNewPage(), () => RootController.supportNavBarItem);
        break;
      default:
    }
  }
}
