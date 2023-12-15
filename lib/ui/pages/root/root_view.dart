import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/model/journey_models/user_journey_stats_model.dart';
import 'package:felloapp/core/model/portfolio_model.dart';
import 'package:felloapp/core/model/user_bootup_model.dart';
import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/feature/tambola/tambola.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/animations/welcome_rings/welcome_rings.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/appbar/appbar.dart';
import 'package:felloapp/ui/elements/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:felloapp/ui/elements/coin_bar/coin_bar_view.dart';
import 'package:felloapp/ui/elements/dev_rel/flavor_banners.dart';
import 'package:felloapp/ui/pages/hometabs/home/card_actions_notifier.dart';
import 'package:felloapp/ui/pages/hometabs/my_account/my_account_components/win_helpers.dart';
import 'package:felloapp/ui/pages/root/root_controller.dart';
import 'package:felloapp/ui/pages/root/root_vm.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/ui/shared/marquee_text.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/lazy_load_indexed_stack.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

GlobalKey felloAppBarKey = GlobalKey();

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<RootViewModel>(
      onModelReady: (model) {
        model.onInit();
      },
      onModelDispose: (model) => model.onDispose(),
      builder: (ctx, model, child) {
        RootController rootController = locator<RootController>();

        return Stack(
          children: [
            Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: UiConstants.kBackgroundColor,
              body: Stack(
                children: [
                  const NewSquareBackground(),
                  Column(
                    children: [
                      const RootAppBar(),
                      const HeadAlerts(),
                      Expanded(
                        child: RefreshIndicator(
                          triggerMode: RefreshIndicatorTriggerMode.onEdge,
                          color: UiConstants.primaryColor,
                          backgroundColor: Colors.black,
                          onRefresh: model.pullToRefresh,
                          child: Consumer<AppState>(
                            builder: (ctx, m, child) {
                              return LazyLoadIndexedStack(
                                index: m.getCurrentTabIndex,
                                children: model.navBarItems.keys.toList(),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const DEVBanner(),
                  const QABanner(),
                ],
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.miniCenterDocked,
              floatingActionButton: Selector<CardActionsNotifier, bool>(
                  selector: (_, notifier) => notifier.isVerticalView,
                  builder: (context, isCardsOpen, child) {
                    return AnimatedScale(
                      scale: isCardsOpen ? 0 : 1,
                      curve: Curves.easeIn,
                      duration: const Duration(milliseconds: 300),
                      child: rootController.navItems.values.length % 2 == 0
                          ? model.centerTab(ctx)
                          : const SizedBox(),
                    );
                  }),
              bottomNavigationBar: const BottomNavBar(),
            ),
            const CircularAnim(),
          ],
        );
      },
    );
  }
}

class HeadAlerts extends StatelessWidget {
  const HeadAlerts({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Selector<UserService, UserBootUpDetailsModel?>(
      selector: (ctx, userService) => userService.userBootUp,
      builder: (ctx, bootUp, child) {
        final data = bootUp?.data;

        if (data == null || data.marqueeMessages.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          width: SizeConfig.screenWidth,
          height: SizeConfig.padding40,
          color: data.marqueeColor.toColor(),
          child: MarqueeText(
            infoList: data.marqueeMessages,
            showBullet: true,
            bulletColor: Colors.white,
            textColor: Colors.white,
          ),
        );
      },
    );
  }
}

class RootAppBar extends StatelessWidget {
  const RootAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<UserService, UserServiceProperties>(
        properties: const [UserServiceProperties.mySegments],
        builder: (_, userservice, ___) {
          return Consumer<AppState>(
            builder: (ctx, appState, child) {
              return Selector<TambolaService, int>(
                selector: (_, tambolaService) =>
                    tambolaService.tambolaTicketCount,
                builder: (_, ticketCount, child) {
                  return (locator<RootController>().currentNavBarItemModel !=
                          RootController.journeyNavBarItem)
                      ? Container(
                          width: SizeConfig.screenWidth,
                          height: kToolbarHeight + SizeConfig.viewInsets.top,
                          alignment: Alignment.bottomCenter,
                          child: FAppBar(
                            showAvatar: true,
                            leadingPadding: false,
                            titleWidget:
                                !userservice!.userSegments.contains("NEW_USER")
                                    ? Expanded(
                                        child: Salutation(
                                          leftMargin: SizeConfig.padding8,
                                          textStyle: TextStyles.rajdhaniSB.body0
                                              .colour(Colors.white),
                                        ),
                                      )
                                    : null,
                            backgroundColor: UiConstants.kBackgroundColor,
                            showCoinBar: false,
                            action: Row(
                              children: [
                                Selector2<UserService, ScratchCardService,
                                    Tuple2<Portfolio?, int>>(
                                  builder: (context, value, child) =>
                                      FelloInfoBar(
                                    svgAsset: Assets.scratchCard,
                                    size: SizeConfig.padding16,
                                    child:
                                        "₹${value.item1?.rewards.toInt() ?? 0}",
                                    onPressed: () {
                                      Haptic.vibrate();
                                      AppState.delegate!
                                          .parseRoute(Uri.parse("myWinnings"));
                                    },
                                    mark: value.item2 > 0,
                                  ),
                                  selector: (p0, userService,
                                          scratchCardService) =>
                                      Tuple2(
                                          userService.userPortfolio,
                                          scratchCardService
                                              .unscratchedTicketsCount),
                                ),
                                Selector2<UserService, ScratchCardService,
                                    Tuple2<UserJourneyStatsModel?, int>>(
                                  builder: (context, value, child) =>
                                      FelloInfoBar(
                                    lottieAsset: Assets.navJourneyLottie,
                                    size: SizeConfig.padding24 -
                                        SizeConfig.padding1,
                                    child: "Level ${value.item1?.level ?? 0}",
                                    onPressed: () {
                                      Haptic.vibrate();
                                      AppState.delegate!
                                          .parseRoute(Uri.parse("journey"));
                                    },
                                    mark: value.item2 > 0,
                                  ),
                                  selector: (p0, userService,
                                          scratchCardService) =>
                                      Tuple2(
                                          userService.userJourneyStats,
                                          scratchCardService
                                              .unscratchedMilestoneScratchCardCount),
                                )
                              ],
                            ),
                          ),
                        )
                      : const SizedBox();
                },
              );
            },
          );
        });
  }
}
