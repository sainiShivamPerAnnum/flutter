import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/enums/marketing_event_handler_enum.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/model/bottom_nav_bar_item_model.dart';
import 'package:felloapp/core/model/happy_hour_campign.dart';
import 'package:felloapp/core/model/journey_models/user_journey_stats_model.dart';
import 'package:felloapp/core/model/user_funt_wallet_model.dart';
import 'package:felloapp/core/service/notifier_services/marketing_event_handler_service.dart';
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
import 'package:felloapp/ui/pages/hometabs/save/save_components/save_banner.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_components/win_helpers.dart';
import 'package:felloapp/ui/pages/root/root_controller.dart';
import 'package:felloapp/ui/pages/root/root_vm.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
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
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: UiConstants.kBackgroundColor,
            body: Stack(
              children: [
                const NewSquareBackground(),
                Column(
                  children: [
                    const RootAppBar(),
                    Expanded(
                      child: RefreshIndicator(
                        triggerMode: RefreshIndicatorTriggerMode.onEdge,
                        color: UiConstants.primaryColor,
                        backgroundColor: Colors.black,
                        onRefresh: model.refresh,
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

                PropertyChangeProvider<MarketingEventHandlerService,
                    MarketingEventsHandlerProperties>(
                  value: locator<MarketingEventHandlerService>(),
                  child: PropertyChangeConsumer<MarketingEventHandlerService,
                      MarketingEventsHandlerProperties>(
                    properties: const [
                      MarketingEventsHandlerProperties.HappyHour
                    ],
                    builder: (context, state, _) {
                      return !state!.showHappyHourBanner
                          ? Container()
                          : Consumer<AppState>(
                              builder: (ctx, m, child) => AnimatedPositioned(
                                bottom: !(locator<RootController>()
                                                .currentNavBarItemModel ==
                                            RootController.journeyNavBarItem ||
                                        !_showHappyHour())
                                    ? SizeConfig.navBarHeight
                                    : -50,
                                duration: const Duration(milliseconds: 400),
                                child: HappyHourBanner(
                                    model: locator<HappyHourCampign>()),
                              ),
                            );
                    },
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
        });
  }
}

class RootPageView extends StatefulWidget {
  const RootPageView({
    Key? key,
    required this.model,
  }) : super(key: key);

  final RootViewModel model;

  @override
  State<RootPageView> createState() => _RootPageViewState();
}

class _RootPageViewState extends State<RootPageView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    // return PageView(
    //   physics: const NeverScrollableScrollPhysics(),
    //   controller: AppState.homeTabPageController,
    //   children: widget.model.navBarItems.keys.toList(),
    // );

    return Consumer<AppState>(builder: (context, m, child) {
      return LazyLoadIndexedStack(
        index: m.getCurrentTabIndex,
        children: widget.model.navBarItems.keys.toList(),
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}

bool _showHappyHour() {
  if (locator<RootController>().currentNavBarItemModel ==
      RootController.tambolaNavBar) {
    return (locator<TambolaService>().bestTickets?.data?.totalTicketCount ??
            0) >
        0;
  }
  return true;
}

class RootAppBar extends StatelessWidget {
  const RootAppBar({super.key});

  FaqsType getFaqType() {
    final NavBarItemModel navItem =
        locator<RootController>().currentNavBarItemModel;
    if (navItem == RootController.playNavBarItem) {
      return FaqsType.play;
    } else if (navItem == RootController.saveNavBarItem) {
      return FaqsType.savings;
    } else if (navItem == RootController.winNavBarItem) {
      return FaqsType.winnings;
    } else if (navItem == RootController.tambolaNavBar) {
      return FaqsType.play;
    } else if (navItem == RootController.tambolaNavBar) {
      return FaqsType.tambola;
    } else {
      return FaqsType.gettingStarted;
    }
  }

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
                  print("Tambola Ticket count: $ticketCount");
                  return (locator<RootController>().currentNavBarItemModel !=
                          RootController.journeyNavBarItem)
                      ? Container(
                          width: SizeConfig.screenWidth,
                          height: kToolbarHeight + SizeConfig.viewInsets.top,
                          alignment: Alignment.bottomCenter,
                          color: (locator<RootController>()
                                      .currentNavBarItemModel ==
                                  RootController.saveNavBarItem)
                              ? (userservice!.userSegments.contains("NEW_USER"))
                                  ? UiConstants.kBackgroundColor
                                  : UiConstants.kSecondaryBackgroundColor
                              : UiConstants.kBackgroundColor,
                          child: FAppBar(
                            showAvatar: true,
                            leadingPadding: false,
                            titleWidget: Expanded(
                              child: Salutation(
                                leftMargin: SizeConfig.padding8,
                                textStyle: TextStyles.rajdhaniSB.body0
                                    .colour(Colors.white),
                              ),
                            ),
                            backgroundColor: ((locator<RootController>()
                                            .currentNavBarItemModel ==
                                        RootController.tambolaNavBar) &&
                                    ticketCount == 0)
                                ? Color(0XFF141414)
                                : (locator<RootController>()
                                            .currentNavBarItemModel ==
                                        RootController.saveNavBarItem)
                                    ? (userservice!.userSegments
                                            .contains("NEW_USER"))
                                        ? UiConstants.kBackgroundColor
                                        : UiConstants.kSecondaryBackgroundColor
                                    : UiConstants.kBackgroundColor,
                            showCoinBar: false,
                            action: Row(
                              children: [
                                Selector2<UserService, ScratchCardService,
                                    Tuple2<UserFundWallet?, int>>(
                                  builder: (context, value, child) =>
                                      FelloInfoBar(
                                    svgAsset: Assets.scratchCard,
                                    size: SizeConfig.padding16,
                                    child:
                                        "₹${value.item1?.unclaimedBalance.toInt() ?? 0}",
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
                                          userService.userFundWallet,
                                          scratchCardService
                                              .unscratchedTicketsCount),
                                ),
                                Selector2<UserService, ScratchCardService,
                                    Tuple2<UserJourneyStatsModel?, int>>(
                                  builder: (context, value, child) =>
                                      FelloInfoBar(
                                    svgAsset: Assets.journeyIcon,
                                    size: SizeConfig.padding20,
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
                                              .unscratchedTicketsCount),
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
