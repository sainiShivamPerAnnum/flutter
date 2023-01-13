import 'package:felloapp/core/model/bottom_nav_bar_item_model.dart';
import 'package:felloapp/util/assets.dart';
import 'package:flutter/material.dart';

class RootController {
  static final tambolaNavBar =
      NavBarItemModel("Tambola", Assets.navTambolaLottie);
  static final journeyNavBarItem =
      NavBarItemModel("Journey", Assets.navJourneyLottie);

  static final playNavBarItem = NavBarItemModel("Play", Assets.navPlayLottie);

  static final winNavBarItem = NavBarItemModel("Win", Assets.navWinLottie);
  static final saveNavBarItem = NavBarItemModel("Save", Assets.navSaveLottie);

  late NavBarItemModel currentNavBarItemModel;

  Map<Widget, NavBarItemModel> navItems = {};

  void onChange(NavBarItemModel model) {
    currentNavBarItemModel = model;
  }
}
