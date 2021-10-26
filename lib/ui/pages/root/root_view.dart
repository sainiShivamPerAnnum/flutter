import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/navbar.dart';
import 'package:felloapp/ui/modals_sheets/want_more_tickets_modal_sheet.dart';
import 'package:felloapp/ui/pages/root/root_vm.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/service_elements/user_service/profile_image.dart';
import 'package:felloapp/ui/widgets/coin_bar/coin_bar_view.dart';
import 'package:felloapp/ui/widgets/drawer/drawer_view.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:provider/provider.dart';

class Root extends StatelessWidget {
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
        return WillPopScope(
          onWillPop: () async {
            if (RootViewModel.scaffoldKey.currentState.isDrawerOpen) {
              print("Pop Popped");
              Navigator.pop(context);
              return false;
            }
            return true;
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            key: RootViewModel.scaffoldKey,
            drawer: FDrawer(),
            drawerEnableOpenDragGesture: false,
            body: HomeBackground(
              whiteBackground: WhiteBackground(
                  height: model.currentTabIndex == 1
                      ? SizeConfig.screenHeight * 0.17
                      : SizeConfig.screenHeight * 0.2),
              child: Stack(
                children: [
                  RefreshIndicator(
                    color: UiConstants.primaryColor,
                    backgroundColor: Colors.black,
                    onRefresh: model.refresh,
                    child: Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top),
                      child: Consumer<AppState>(
                        builder: (ctx, m, child) => IndexedStack(
                            children: model.pages, index: m.rootIndex),
                      ),
                    ),
                  ),
                  FelloAppBar(
                    leading: InkWell(
                      onTap: () => model.showDrawer(),
                      child: ProfileImageSE(
                        radius: SizeConfig.avatarRadius,
                      ),
                    ),
                    actions: [
                      FelloCoinBar(),
                      SizedBox(width: 16),
                      NotificationButton(),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(
                          width: SizeConfig.screenWidth,
                          height: SizeConfig.navBarHeight,
                        ),
                      ),
                    ),
                  ),
                  WantMoreTickets(
                    model: model,
                  ),
                  BottomNavBar(
                    model: model,
                  ),
                ],
              ),
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
            currentIndex: m.rootIndex,
            items: [
              NavBarItemData(locale.navBarFinance, Assets.navSave,
                  SizeConfig.screenWidth * 0.27),
              NavBarItemData(locale.navBarPlay, Assets.navPlay,
                  SizeConfig.screenWidth * 0.27),
              NavBarItemData(locale.navBarWin, Assets.navWin,
                  SizeConfig.screenWidth * 0.27),
            ],
          ),
        ),
      ),
    );
  }
}

class WantMoreTickets extends StatelessWidget {
  final RootViewModel model;

  WantMoreTickets({@required this.model});

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return Consumer<AppState>(
      builder: (ctx, m, child) => AnimatedPositioned(
        duration: Duration(milliseconds: 300),
        curve: Curves.decelerate,
        bottom: m.rootIndex == 1
            ? SizeConfig.pageHorizontalMargins + SizeConfig.navBarHeight / 2
            : SizeConfig.pageHorizontalMargins,
        left: SizeConfig.pageHorizontalMargins,
        right: SizeConfig.pageHorizontalMargins,
        child: InkWell(
          onTap: () => BaseUtil.openModalBottomSheet(
            addToScreenStack: true,
            content: WantMoreTicketsModalSheet(),
            hapticVibrate: true,
            backgroundColor: Colors.transparent,
            isBarrierDismissable: true,
          ),
          child: Container(
            height: SizeConfig.navBarHeight,
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
              child: Text(
                locale.navWMT,
                style: TextStyles.body1.colour(UiConstants.primaryColor).bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
