import 'dart:developer';

import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/journey/journey_view.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_view.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/save_banner.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_view.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_view.dart';
import 'package:felloapp/ui/pages/root/root_controller.dart';
import 'package:felloapp/ui/pages/root/root_vm.dart';
import 'package:felloapp/ui/pages/static/base_animation/base_animation.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/ui/widgets/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

GlobalKey felloAppBarKey = new GlobalKey();

class Root extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    log("ROOT: Root view build called");

    return BaseView<RootViewModel>(
      onModelReady: (model) {
        model.onInit();
      },
      onModelDispose: (model) {
        model.onDispose();
      },
      builder: (ctx, model, child) {
        log("ROOT: Root view baseview build called");

        return Scaffold(
          resizeToAvoidBottomInset: false,
          drawerEnableOpenDragGesture: false,
          body: Stack(
            children: [
              NewSquareBackground(),
              RefreshIndicator(
                triggerMode: RefreshIndicatorTriggerMode.onEdge,
                color: UiConstants.primaryColor,
                backgroundColor: Colors.black,
                onRefresh: model.refresh,
                child: Container(
                  child: Consumer<AppState>(
                    builder: (ctx, m, child) => IndexedStack(
                      children: model.navBarItems.keys.toList(),
                      index: AppState.delegate!.appState.getCurrentTabIndex,
                    ),
                  ),
                ),
              ),
              if (model.showHappyHourBanner)
                Consumer<AppState>(
                  builder: (ctx, m, child) => AnimatedPositioned(
                    bottom: !(locator<RootController>()
                                    .currentNavBarItemModel ==
                                RootController.tambolaNavBar ||
                            locator<RootController>().currentNavBarItemModel ==
                                RootController.journeyNavBarItem)
                        ? SizeConfig.navBarHeight
                        : -50,
                    duration: Duration(milliseconds: 400),
                    child: HappyHourBanner(model: model.happyHourCampaign),
                  ),
                ),
              BottomNavBar(
                parentModel: model,
              ),
              BaseAnimation(),
              if (FlavorConfig.isDevelopment())
                Container(
                  width: SizeConfig.screenWidth,
                  child: Banner(
                    message: FlavorConfig.getStage(),
                    location: BannerLocation.topEnd,
                    color: FlavorConfig.instance!.color,
                  ),
                ),
              if (FlavorConfig.isQA())
                Container(
                  width: SizeConfig.screenWidth,
                  child: Banner(
                    message: FlavorConfig.getStage(),
                    location: BannerLocation.topEnd,
                    color: FlavorConfig.instance!.color,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
