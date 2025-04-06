import 'dart:developer';

import 'package:felloapp/core/model/bottom_nav_bar_item_model.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/feature/advisor/advisor_root.dart';
import 'package:felloapp/feature/expert/expert_root.dart';
import 'package:felloapp/feature/expert/widgets/scroll_to_index.dart';
import 'package:felloapp/feature/live/live_root.dart';
import 'package:felloapp/feature/shorts/flutter_preload_videos.dart';
import 'package:felloapp/feature/shortsHome/shorts_v2.dart';
import 'package:felloapp/feature/support-new/support_new.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_view.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RootController {
  static const liveNavBarItem = NavBarItemModel(
    "Live",
    Assets.live_bottom_nav,
  );
  static const expertNavBarItem = NavBarItemModel(
    "Experts",
    Assets.experts_bottom_nav,
  );
  static const supportNavBarItem = NavBarItemModel(
    "Support",
    Assets.support_bottom_nav,
  );
  static const advisortNavBarItem = NavBarItemModel(
    "Advisor",
    Assets.advisor_bottom_nav,
  );

  static const saveNavBarItem = NavBarItemModel(
    "Home",
    Assets.home_bottom_nav,
  );

  static const shortsNavBarItem = NavBarItemModel(
    "Shorts",
    Assets.shorts_bottom_nav,
  );

  NavBarItemModel currentNavBarItemModel = const NavBarItemModel(
    "Home",
    Assets.home_bottom_nav,
  );

  Map<Widget, NavBarItemModel> navItems = {};

  static ScrollController controller = ScrollController();
  static AutoScrollController autoScrollController = AutoScrollController();
  static List<String> expertsSections = [];

  void onChange(NavBarItemModel model) {
    log("onChange ${model.title}");
    final currentContext = AppState.delegate!.navigatorKey.currentContext!;
    if (currentNavBarItemModel.title == model.title && controller.hasClients) {
      controller.animateTo(
        0,
        duration: const Duration(seconds: 2),
        curve: Curves.decelerate,
      );
    }
    if (currentNavBarItemModel.title == model.title &&
        autoScrollController.hasClients) {
      autoScrollController.animateTo(
        0,
        duration: const Duration(seconds: 2),
        curve: Curves.decelerate,
      );
    }
    currentNavBarItemModel = model;
    if (navItems.containsValue(shortsNavBarItem)) {
      final state = currentContext.read<PreloadBloc>().state;
      if (model.title == 'Shorts') {
        // Video comes into view
      } else {
        shortsScreenKey.currentState?.resetState();
        // Video goes out of view
        if (state.controllers[state.focusedIndex] != null) {
          // AppState.backButtonDispatcher!.didPopRoute();
          BlocProvider.of<PreloadBloc>(
            AppState.delegate!.navigatorKey.currentContext!,
            listen: false,
          ).add(PreloadEvent.pauseVideoAtIndex(state.focusedIndex));
        }
      }
    }
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
          const LiveHomeView(),
          () => RootController.liveNavBarItem,
        );
        break;
      case "EP":
        navItems.putIfAbsent(
          const ExpertsHomeView(),
          () => RootController.expertNavBarItem,
        );
        break;
      case "SH":
        navItems.putIfAbsent(
          const ShortsNewPage(),
          () => RootController.shortsNavBarItem,
        );
        break;
      case "SP":
        final UserService userService = locator<UserService>();
        if (userService.baseUser?.isAdvisor ?? false) {
          navItems.putIfAbsent(
            const AdvisorPage(),
            () => RootController.advisortNavBarItem,
          );
        } else {
          navItems.putIfAbsent(
            const SupportNewPage(),
            () => RootController.supportNavBarItem,
          );
        }
        break;
      default:
    }
  }
}
