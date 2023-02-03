import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/enums/marketing_event_handler_enum.dart';
import 'package:felloapp/core/service/notifier_services/marketing_event_handler_service.dart';
import 'package:felloapp/core/service/notifier_services/tambola_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/animations/welcome_rings/welcome_rings.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/appbar/appbar.dart';
import 'package:felloapp/ui/elements/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:felloapp/ui/elements/dev_rel/flavor_banners.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/save_banner.dart';
import 'package:felloapp/ui/pages/root/root_controller.dart';
import 'package:felloapp/ui/pages/root/root_vm.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:provider/provider.dart';

GlobalKey felloAppBarKey = new GlobalKey();

class Root extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PropertyChangeProvider<MarketingEventHandlerService,
        MarketingEventsHandlerProperties>(
      value: locator<MarketingEventHandlerService>(),
      child: BaseView<RootViewModel>(
        onModelReady: (model) => model.onInit(),
        onModelDispose: (model) => model.onDispose(),
        builder: (ctx, model, child) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: UiConstants.kBackgroundColor,
            body: Stack(
              children: [
                const NewSquareBackground(),
                RefreshIndicator(
                  triggerMode: RefreshIndicatorTriggerMode.onEdge,
                  color: UiConstants.primaryColor,
                  backgroundColor: Colors.black,
                  onRefresh: model.refresh,
                  child: Consumer<AppState>(
                    builder: (ctx, m, child) {
                      return IndexedStack(
                        children: model.navBarItems.keys.toList(),
                        index: m.getCurrentTabIndex,
                      );
                    },
                  ),
                ),
                RootAppBar(),
                if (model.showHappyHourBanner)
                  Consumer<AppState>(
                    builder: (ctx, m, child) => AnimatedPositioned(
                      bottom:
                          !(locator<RootController>().currentNavBarItemModel ==
                                      RootController.journeyNavBarItem ||
                                  !_showHappyHour())
                              ? SizeConfig.navBarHeight
                              : -50,
                      duration: Duration(milliseconds: 400),
                      child: HappyHourBanner(model: model.happyHourCampaign),
                    ),
                  ),
                const BottomNavBar(),
                // const BaseAnimation(),
                const CircularAnim(),
                const DEVBanner(),
                const QABanner(),
              ],
            ),
          );
        },
      ),
    );
  }
}

bool _showHappyHour() {
  if (locator<RootController>().currentNavBarItemModel ==
      RootController.tambolaNavBar) {
    return ((locator<TambolaService>().userWeeklyBoards?.length ?? 0) > 0);
  }
  return true;
}

class RootAppBar extends StatelessWidget {
  const RootAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      child: Consumer<AppState>(
        builder: (ctx, appState, child) {
          return (locator<RootController>().currentNavBarItemModel !=
                  RootController.journeyNavBarItem)
              ? Container(
                  width: SizeConfig.screenWidth,
                  height: kToolbarHeight + SizeConfig.viewInsets.top,
                  alignment: Alignment.bottomCenter,
                  color: (locator<RootController>().currentNavBarItemModel ==
                          RootController.saveNavBarItem)
                      ? UiConstants.kSecondaryBackgroundColor
                      : Colors.transparent,
                  child: FAppBar(
                    type: FaqsType.play,
                    backgroundColor:
                        (locator<RootController>().currentNavBarItemModel ==
                                RootController.saveNavBarItem)
                            ? UiConstants.kSecondaryBackgroundColor
                            : UiConstants.kBackgroundColor,
                    showAvatar: true,
                  ),
                )
              : SizedBox();
        },
      ),
    );
  }
}
