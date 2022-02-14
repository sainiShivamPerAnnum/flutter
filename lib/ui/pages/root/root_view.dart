import 'dart:ui';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/navbar.dart';
import 'package:felloapp/ui/modals_sheets/want_more_tickets_modal_sheet.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_view.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_view.dart';
import 'package:felloapp/ui/pages/hometabs/win/win_view.dart';
import 'package:felloapp/ui/pages/root/root_vm.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/service_elements/user_service/profile_image.dart';
import 'package:felloapp/ui/widgets/coin_bar/coin_bar_view.dart';
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
  final pages = [Save(), Play(), Win()];

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
          body: HomeBackground(
            whiteBackground:
                WhiteBackground(height: SizeConfig.safeScreenHeight * 0.16),
            child: Stack(
              children: [
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
                RefreshIndicator(
                  color: UiConstants.primaryColor,
                  backgroundColor: Colors.black,
                  onRefresh: model.refresh,
                  child: Container(
                    margin: EdgeInsets.only(
                        top: SizeConfig.screenWidth * 0.1 +
                            SizeConfig.viewInsets.top +
                            SizeConfig.padding32),
                    child: IndexedStack(
                      children: pages,
                      index: AppState.delegate.appState.getCurrentTabIndex,
                    ),
                  ),
                ),
                FelloAppBar(
                  key: felloAppBarKey,
                  leading: InkWell(
                    onTap: () => model.showDrawer(),
                    child: ProfileImageSE(
                      radius: SizeConfig.avatarRadius,
                    ),
                  ),
                  actions: [
                    const FelloCoinBar(),
                    SizedBox(width: 16),
                    NotificationButton(),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: SizeConfig.screenWidth,
                    height: SizeConfig.navBarHeight,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            UiConstants.scaffoldColor.withOpacity(0.8),
                            UiConstants.scaffoldColor.withOpacity(0.2),
                          ],
                          stops: [
                            0.8,
                            1
                          ]),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    ),
                  ),
                ),
                if (SizeConfig.screenWidth < 600)
                  WantMoreTickets(
                    model: model,
                  ),
                if (SizeConfig.screenWidth < 600)
                  SaveBaseline(
                    model: model,
                  ),
                BottomNavBar(
                  model: model,
                ),
              ],
            ),
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
    S locale = S.of(context);
    return Consumer<AppState>(
      builder: (ctx, m, child) => Positioned(
        bottom: SizeConfig.pageHorizontalMargins,
        left: SizeConfig.pageHorizontalMargins,
        right: SizeConfig.pageHorizontalMargins,
        child: Container(
          width: SizeConfig.navBarWidth,
          height: SizeConfig.navBarHeight,
          decoration: BoxDecoration(
            color: UiConstants.primaryColor,
            borderRadius: BorderRadius.circular(SizeConfig.roundness24),
          ),
          child: NavBar(
            itemTapped: (int index) => model.onItemTapped(index),
            currentIndex: AppState.delegate.appState.getCurrentTabIndex,
            items: [
              NavBarItemData(
                locale.navBarFinance,
                Assets.navSave,
                SizeConfig.screenWidth * 0.27,
              ),
              NavBarItemData(
                locale.navBarPlay,
                Assets.navPlay,
                SizeConfig.screenWidth * 0.27,
              ),
              NavBarItemData(
                locale.navBarWin,
                Assets.navWin,
                SizeConfig.screenWidth * 0.27,
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
    return AnimatedPositioned(
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
                  style: TextStyles.body1.colour(UiConstants.primaryColor).bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
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
    return AnimatedPositioned(
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
    );
  }
}
