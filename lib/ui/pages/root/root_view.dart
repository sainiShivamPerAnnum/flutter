import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/navbar.dart';
import 'package:felloapp/ui/pages/hometabs/journey/journey_view.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_view.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_view.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_view.dart';
import 'package:felloapp/ui/pages/root/root_vm.dart';
import 'package:felloapp/ui/pages/static/base_animation/base_animation.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/ui/pages/static/transaction_loader.dart';
import 'package:felloapp/ui/widgets/drawer/drawer_view.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

GlobalKey felloAppBarKey = new GlobalKey();

class Root extends StatelessWidget {
  final pages = [JourneyView(), Play(), Save(), Win()];

  @override
  Widget build(BuildContext context) {
    return BaseView<RootViewModel>(
      onModelReady: (model) {
        model.onInit();
      },
      onModelDispose: (model) {
        model.onDispose();
      },
      builder: (ctx, model, child) {
        model.initialize();
        return Scaffold(
          resizeToAvoidBottomInset: false,
          key: RootViewModel.scaffoldKey,
          drawer: FDrawer(),
          drawerEnableOpenDragGesture: false,
          // bottomNavigationBar: BottomNavigationBar(
          //   currentIndex: model.bottomNavBarIndex,
          //   onTap: (index) {
          //     model.onItemTapped(index);
          //   },
          //   selectedFontSize: SizeConfig.body4,
          //   unselectedFontSize: SizeConfig.body4,
          //   selectedLabelStyle:
          //       TextStyles.rajdhaniSB.body4.colour(UiConstants.kTextColor),
          //   unselectedLabelStyle:
          //       TextStyles.rajdhaniSB.body4.colour(UiConstants.kTextColor),
          //   unselectedItemColor: UiConstants.kTextColor2,
          //   selectedItemColor: UiConstants.kTextColor,
          //   backgroundColor: UiConstants.kBackgroundColor,
          //   elevation: 0,
          //   enableFeedback: true,
          //   iconSize: SizeConfig.padding32,
          //   type: BottomNavigationBarType.fixed,
          //   items: [
          //     BottomNavigationBarItem(
          //         backgroundColor: UiConstants.kBackgroundColor,
          //         icon: SvgPicture.asset(Assets.navJourneyInactive),
          //         activeIcon: SvgPicture.asset(Assets.navJourneyActive),
          //         label: 'Journey'),
          //     BottomNavigationBarItem(
          //         backgroundColor: UiConstants.kBackgroundColor,
          //         icon: SvgPicture.asset(Assets.navPlayInactive),
          //         activeIcon: SvgPicture.asset(Assets.navPlayActive),
          //         label: 'Play'),
          //     BottomNavigationBarItem(
          //         backgroundColor: UiConstants.kBackgroundColor,
          //         icon: SvgPicture.asset(Assets.navSaveInactive),
          //         activeIcon: SvgPicture.asset(Assets.navSaveActive),
          //         label: 'Save'),
          //     BottomNavigationBarItem(
          //         backgroundColor: UiConstants.kBackgroundColor,
          //         icon: SvgPicture.asset(Assets.navWinInactive),
          //         activeIcon: SvgPicture.asset(Assets.navWinActive),
          //         label: 'Win'),
          //   ],
          // ),
          body: Stack(
            children: [
              NewSquareBackground(),
              RefreshIndicator(
                color: UiConstants.primaryColor,
                backgroundColor: Colors.black,
                onRefresh: model.refresh,
                child: Container(
                  child: Consumer<AppState>(
                    builder: (ctx, m, child) => IndexedStack(
                      children: pages,
                      index: AppState.delegate.appState.getCurrentTabIndex,
                    ),
                  ),
                ),
              ),
              if (AppState.delegate.appState.getCurrentTabIndex == 3)
                FelloAppBar(
                  showAppBar: false,
                  leading: InkWell(
                    onTap: model.showDrawer,
                    child: Container(
                      width: SizeConfig.padding38,
                      height: SizeConfig.padding38,
                      // color: Colors.red,
                    ),
                  ),
                ),
              Consumer<AppState>(
                builder: (ctx, m, child) =>
                    AppState.delegate.appState.isTxnLoaderInView
                        ? TransactionLoader()
                        : SizedBox(),
              ),
              BottomNavBar(
                model: model,
              ),
              BaseAnimation(),
              if (FlavorConfig.isDevelopment())
                Container(
                  width: SizeConfig.screenWidth,
                  child: Banner(
                    message: FlavorConfig.getStage(),
                    location: BannerLocation.topEnd,
                    color: FlavorConfig.instance.color,
                  ),
                ),
              if (FlavorConfig.isQA())
                Container(
                  width: SizeConfig.screenWidth,
                  child: Banner(
                    message: FlavorConfig.getStage(),
                    location: BannerLocation.topEnd,
                    color: FlavorConfig.instance.color,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class BottomNavBar extends StatelessWidget {
  final RootViewModel model;
  BottomNavBar({@required this.model});

  @override
  Widget build(BuildContext context) {
    S locale = S();
    //TODO change svg to better sizes and change bottomNavBar to flutter's native
    return Consumer<AppState>(
      builder: (ctx, m, child) => Positioned(
        bottom: 0, //SizeConfig.pageHorizontalMargins / 2,
        child: Container(
          width: SizeConfig.screenWidth,
          height: kBottomNavigationBarHeight + SizeConfig.viewInsets.bottom / 2,
          decoration: BoxDecoration(
            color: Colors.black,
          ),
          child: NavBar(
            itemTapped: (int index) => model.onItemTapped(index),
            currentIndex: AppState.delegate.appState.getCurrentTabIndex,
            items: [
              NavBarItemData(
                locale.navBarJourney,
                Assets.navJourneyActive,
                Assets.navJourneyInactive,
              ),
              NavBarItemData(
                locale.navBarPlay,
                Assets.navPlayActive,
                Assets.navPlayInactive,
              ),
              NavBarItemData(
                locale.navBarSave,
                Assets.navSaveActive,
                Assets.navSaveInactive,
              ),
              NavBarItemData(
                locale.navBarWin,
                Assets.navWinActive,
                Assets.navWinInactive,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WantMoreTickets extends StatelessWidget {
  final RootViewModel model;
  WantMoreTickets({
    @required this.model,
  });

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return Consumer<AppState>(
        builder: (ctx, m, c) => AnimatedPositioned(
              duration: Duration(milliseconds: 300),
              curve: Curves.decelerate,
              bottom: SizeConfig.pageHorizontalMargins,
              left: SizeConfig.pageHorizontalMargins,
              right: SizeConfig.pageHorizontalMargins,
              child: InkWell(
                onTap: model.earnMoreTokens,
                child: Shimmer(
                  duration: Duration(seconds: 5),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.decelerate,
                    height: AppState.delegate.appState.getCurrentTabIndex == 1
                        ? SizeConfig.navBarHeight * 1.5
                        : SizeConfig.navBarHeight,
                    width: SizeConfig.navBarWidth,
                    decoration: BoxDecoration(
                      color: UiConstants.primaryLight,
                      borderRadius: BorderRadius.circular(
                        SizeConfig.roundness24,
                      ),
                    ),
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: SizeConfig.navBarHeight * 0.5,
                      alignment: Alignment.center,
                      child: Shimmer(
                        duration: Duration(seconds: 1),
                        interval: Duration(seconds: 4),
                        child: Text(
                          locale.navWMT,
                          style: TextStyles.body1
                              .colour(UiConstants.primaryColor)
                              .bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ));
  }
}

class SaveBaseline extends StatelessWidget {
  final RootViewModel model;
  SaveBaseline({
    @required this.model,
  });

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return Consumer<AppState>(
      builder: (ctx, m, c) => AnimatedPositioned(
        duration: Duration(milliseconds: 300),
        curve: Curves.decelerate,
        bottom: SizeConfig.pageHorizontalMargins,
        left: SizeConfig.pageHorizontalMargins,
        right: SizeConfig.pageHorizontalMargins,
        child: InkWell(
          onTap: model.focusBuyField,
          child: Shimmer(
            duration: Duration(seconds: 5),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.decelerate,
              height: AppState.delegate.appState.getCurrentTabIndex == 0
                  ? SizeConfig.navBarHeight * 1.5
                  : SizeConfig.navBarHeight,
              width: SizeConfig.navBarWidth,
              decoration: BoxDecoration(
                color: UiConstants.tertiaryLight,
                borderRadius: BorderRadius.circular(
                  SizeConfig.roundness24,
                ),
              ),
              alignment: Alignment.topCenter,
              child: Container(
                height: SizeConfig.navBarHeight * 0.5,
                alignment: Alignment.center,
                child: Shimmer(
                  duration: Duration(seconds: 1),
                  interval: Duration(seconds: 4),
                  child: Text(
                    locale.saveBaseline,
                    style:
                        TextStyles.body1.colour(UiConstants.tertiarySolid).bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
