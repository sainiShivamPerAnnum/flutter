import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/navbar.dart';
import 'package:felloapp/ui/modals_sheets/want_more_tickets_modal_sheet.dart';
import 'package:felloapp/ui/pages/root/root_vm.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/service_elements/user_service/profile_image.dart';
import 'package:felloapp/ui/widgets/appbars/fello_appbar_view.dart';
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
                    child: ProfileImageSE(
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
                  height: AppState.getCurrentTabIndex == 0
                      ? kToolbarHeight * 3.6
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
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: SizeConfig.screenWidth,
                    height: kBottomNavigationBarHeight * 4,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Color(0xffF1F6FF),
                          Color(0xffF1F6FF).withOpacity(0.2),
                          Colors.white.withOpacity(0)
                        ],
                      ),
                    ),
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

//   AppBar appBar(RootViewModel model, BuildContext context) {
//     return AppBar(
//       backgroundColor: ThemeData().scaffoldBackgroundColor,
//       leading: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8),
//         child: InkWell(
//           onTap: model.showDrawer,
//           child: ProfileImage(),
//         ),
//       ),
//       title: PropertyChangeConsumer<UserService, UserServiceProperties>(
//         properties: [UserServiceProperties.myUserName],
//         builder: (context, model, property) => Text(
//           "Hi, ${model.myUserName?.split(' ')?.first ?? "user"}",
//           style: TextStyles.body1.bold,
//         ),
//       ),
//       actions: [
//         InkWell(
//           onTap: () => model.showTicketModal(context),
//           child: Container(
//             margin: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(100),
//                 color: UiConstants.primaryColor),
//             padding: EdgeInsets.symmetric(horizontal: 8),
//             child: Row(
//               children: [
//                 PropertyChangeConsumer<UserService, UserServiceProperties>(
//                   builder: (context, model, property) => Text(
//                       model.userTicketWallet.getActiveTickets().toString() ?? 0,
//                       style: TextStyles.body3.bold),
//                 ),
//                 SizedBox(width: 8),
//                 Icon(
//                   Icons.control_point_rounded,
//                   color: Colors.white,
//                   size: kToolbarHeight / 2.5,
//                 ),
//               ],
//             ),
//           ),
//         ),
//         InkWell(
//           child: Icon(
//             Icons.notifications,
//             size: kToolbarHeight * 0.5,
//             color: Color(0xff4C4C4C),
//           ),
//           //icon: Icon(Icons.contact_support_outlined),
//           // iconSize: kToolbarHeight * 0.5,
//           onTap: model.openAlertsScreen,
//         ),
//         SizedBox(
//           width: SizeConfig.globalMargin,
//         )
//       ],
//     );
//  }
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
            padding: EdgeInsets.all(SizeConfig.scaffoldMargin),
            child: Container(
              height: kBottomNavigationBarHeight * 1.6,
              width: SizeConfig.screenWidth,
              decoration: BoxDecoration(
                color: UiConstants.primaryColor,
                borderRadius: BorderRadius.circular(32),
              ),
              padding: EdgeInsets.symmetric(vertical: 8),
              child: NavBar(
                itemTapped: (int index) => model.onItemTapped(index),
                currentIndex: AppState.getCurrentTabIndex,
                items: [
                  NavBarItemData("Finance", Icons.home, "images/svgs/save.svg",
                      SizeConfig.screenWidth * 0.36),
                  NavBarItemData("Save", Icons.games, "images/svgs/game.svg",
                      SizeConfig.screenWidth * 0.28),
                  NavBarItemData("Win", Icons.wallet_giftcard,
                      "images/svgs/home.svg", SizeConfig.screenWidth * 0.28),
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
      bottom: kBottomNavigationBarHeight * 1.5,
      left: SizeConfig.scaffoldMargin,
      right: SizeConfig.scaffoldMargin,
      child: Container(
        height: kBottomNavigationBarHeight * 1.8,
        width: SizeConfig.screenWidth,
        decoration: BoxDecoration(
          color: Color(0xffCBECED),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.only(bottom: kBottomNavigationBarHeight / 2),
        child: Text(
          "Want more tickets",
          style: TextStyles.body1.colour(UiConstants.primaryColor).bold,
        ),
      ),
    );
  }
}
