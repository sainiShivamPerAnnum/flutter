import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/navbar.dart';
import 'package:felloapp/ui/pages/root/root_vm.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/service_elements/user_service/profile_image.dart';
import 'package:felloapp/ui/widgets/drawer/drawer_view.dart';
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
          //appBar: appBar(model, context),
          drawer: FDrawer(),
          body: HomeBackground(
            child: Stack(
              children: [
                FelloAppBar(
                  leading: InkWell(
                    onTap: () => model.showDrawer(),
                    child: ProfileImage(
                      height: 0.4,
                    ),
                  ),
                  actions: [
                    FelloCurrency(),
                    SizedBox(width: 16),
                    NotificationButton(),
                  ],
                ),
                WhiteBackground(
                  color: Color(0xffF1F6FF),
                  height: AppState.getCurrentTabIndex == 0
                      ? kToolbarHeight * 3
                      : kToolbarHeight * 2.8,
                ),
                SafeArea(
                  child: Container(
                    margin: EdgeInsets.only(top: kToolbarHeight * 1.2),
                    child: IndexedStack(
                        children: model.pages,
                        index: AppState.getCurrentTabIndex),
                  ),
                ),
                if (AppState.getCurrentTabIndex == 0) WantMoreTickets(),
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
    return Positioned(
      bottom: 0,
      child: SafeArea(
        child: Container(
          width: SizeConfig.screenWidth,
          child: Padding(
            padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
            child: Container(
              height: SizeConfig.navBarHeight,
              width: SizeConfig.screenWidth,
              decoration: BoxDecoration(
                color: UiConstants.primaryColor,
                borderRadius: BorderRadius.circular(32),
              ),
              child: NavBar(
                itemTapped: (int index) => model.onItemTapped(index),
                currentIndex: AppState.getCurrentTabIndex,
                items: [
                  NavBarItemData(
                      "Finance",
                      Icons.home,
                      "assets/vectors/icons/wallet.svg",
                      SizeConfig.screenWidth * 0.36),
                  NavBarItemData(
                      "Save",
                      Icons.games,
                      "assets/vectors/icons/support.svg",
                      SizeConfig.screenWidth * 0.28),
                  NavBarItemData(
                    "Win",
                    Icons.wallet_giftcard,
                    "assets/vectors/icons/medal.svg",
                    SizeConfig.screenWidth * 0.28,
                  ),
                ],
              ),
            ),
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
    return Positioned(
      bottom: SizeConfig.pageHorizontalMargins,
      left: SizeConfig.pageHorizontalMargins,
      right: SizeConfig.pageHorizontalMargins,
      child: Container(
        height: SizeConfig.screenWidth * 0.362,
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
            "Want more tickets",
            style: TextStyles.body1.colour(UiConstants.primaryColor).bold,
          ),
        ),
      ),
    );
  }
}
