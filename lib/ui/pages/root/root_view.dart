import 'package:felloapp/base_util.dart';
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
        return Scaffold(
          key: model.scaffoldKey,
          drawer: FDrawer(),
          // bottomSheet: AppState.getCurrentTabIndex == 2
          //     ? DraggableScrollableSheet(
          //         initialChildSize: 0.2,
          //         minChildSize: 0.2,
          //         maxChildSize: 0.8,
          //         expand: true,
          //         builder: (ctx, controller) {
          //           return Container(
          //             height: SizeConfig.navBarHeight * 0.5,
          //             child: CustomPaint(
          //               painter: ModalCustomBackground(),
          //             ),
          //           );
          //         })
          //     : SizedBox(),
          body: HomeBackground(
            whiteBackground: WhiteBackground(
              height: kToolbarHeight * 2.8,
            ),
            child: Stack(
              children: [
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
                RefreshIndicator(
                  color: UiConstants.primaryColor,
                  backgroundColor: Colors.black,
                  onRefresh: model.refresh,
                  child: SafeArea(
                    child: Container(
                      margin: EdgeInsets.only(top: kToolbarHeight * 1.2),
                      child: IndexedStack(
                          children: model.pages,
                          index: AppState.getCurrentTabIndex),
                    ),
                  ),
                ),
                WantMoreTickets(),
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
    return Positioned(
      bottom: SizeConfig.pageHorizontalMargins,
      left: SizeConfig.pageHorizontalMargins,
      child: SafeArea(
        child: Container(
          width:
              SizeConfig.screenWidth - (SizeConfig.pageHorizontalMargins * 2),
          height: SizeConfig.navBarHeight,
          decoration: BoxDecoration(
            color: UiConstants.primaryColor,
            borderRadius: BorderRadius.circular(SizeConfig.roundness32),
          ),
          child: NavBar(
            itemTapped: (int index) => model.onItemTapped(index),
            currentIndex: AppState.getCurrentTabIndex,
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
  const WantMoreTickets({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return Positioned(
      bottom: SizeConfig.pageHorizontalMargins,
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
        child: AnimatedContainer(
          duration: Duration(seconds: 1),
          height: AppState.getCurrentTabIndex == 1
              ? SizeConfig.screenWidth * 0.362
              : SizeConfig.navBarHeight,
          width: SizeConfig.screenWidth,
          decoration: BoxDecoration(
            color: UiConstants.primaryLight,
            borderRadius: BorderRadius.circular(
              SizeConfig.roundness32,
            ),
          ),
          alignment: Alignment.topCenter,
          child: Container(
            height: SizeConfig.screenWidth * 0.15,
            alignment: Alignment.center,
            child: Text(
              locale.navWMT,
              style: TextStyles.body1.colour(UiConstants.primaryColor).bold,
            ),
          ),
        ),
      ),
    );
  }
}
