import 'dart:developer';

import 'package:felloapp/core/model/bottom_nav_bar_item_model.dart';
import 'package:felloapp/feature/expert/expert_root.dart';
import 'package:felloapp/feature/live/live_root.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_view.dart';
import 'package:felloapp/ui/pages/support-new/support_new.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/show_case_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_preload_videos/flutter_preload_videos.dart';

class RootController {
  static final liveNavBarItem = NavBarItemModel(
    "Live",
    Assets.live_bottom_nav,
    ShowCaseKeys.LiveKey,
  );
  static final expertNavBarItem = NavBarItemModel(
    "Experts",
    Assets.experts_bottom_nav,
    ShowCaseKeys.ExpertsKey,
  );
  static final supportNavBarItem = NavBarItemModel(
    "Support",
    Assets.support_bottom_nav,
    ShowCaseKeys.SupportKey,
  );
  static final saveNavBarItem = NavBarItemModel(
    "Home",
    Assets.shorts_bottom_nav,
    ShowCaseKeys.SaveKey,
  );

  static final shortsNavBarItem = NavBarItemModel(
    "Shorts",
    Assets.home_bottom_nav,
    ShowCaseKeys.ShortsKey,
  );

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
      controller.animateTo(
        0,
        duration: const Duration(seconds: 2),
        curve: Curves.decelerate,
      );
    }
    currentNavBarItemModel = model;
  }

  void getNavItems(String navItem) {
    switch (navItem) {
      case "SV":
        navItems.putIfAbsent(
          const Save(),
          () => RootController.saveNavBarItem,
        );
        break;
      case "LV":
        navItems.putIfAbsent(
          const LiveHome(),
          () => RootController.liveNavBarItem,
        );
        break;
      case "EP":
        navItems.putIfAbsent(
          const ExpertHome(),
          () => RootController.expertNavBarItem,
        );
        break;
      case "SP":
        navItems.putIfAbsent(
          const SupportNewPage(),
          () => RootController.supportNavBarItem,
        );
        break;
      case "SH":
        navItems.putIfAbsent(
          BlocProvider(
            create: (_) =>
                PreloadBloc()..add(const PreloadEvent.getVideosFromApi()),
            child: const ShortsVideoPage(),
          ),
          () => RootController.shortsNavBarItem,
        );
        break;
      default:
    }
  }
}
