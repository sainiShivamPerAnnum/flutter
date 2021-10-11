import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/navbar.dart';
import 'package:felloapp/ui/pages/root/root_vm.dart';
import 'package:felloapp/ui/service_elements/user_service/profile_image.dart';
import 'package:felloapp/ui/widgets/drawer/drawer_view.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

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
          backgroundColor: UiConstants.primaryColor,
          key: model.scaffoldKey,
          //appBar: appBar(model, context),
          drawer: FDrawer(),
          body: Stack(
            children: [
              Positioned(
                top: -SizeConfig.screenWidth / 6,
                left: -SizeConfig.screenWidth / 3,
                child: Container(
                  width: SizeConfig.screenWidth / 1.4,
                  height: SizeConfig.screenWidth / 1.4,
                  decoration: BoxDecoration(
                    //color: Color(0xffFFF5E6),
                    gradient: RadialGradient(
                      colors: [
                        Color(0xffFFF5E6).withOpacity(0.5),
                        UiConstants.primaryColor
                        // UiConstants.primaryColor
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                top: -SizeConfig.screenWidth / 3,
                right: -SizeConfig.screenWidth / 3,
                child: Container(
                  width: SizeConfig.screenWidth / 1.2,
                  height: SizeConfig.screenWidth / 1.2,
                  decoration: BoxDecoration(
                    //color: Color(0xffFFF5E6),
                    gradient: RadialGradient(
                      colors: [
                        Color(0xffFED69A).withOpacity(0.8),
                        UiConstants.primaryColor
                        // UiConstants.primaryColor
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                top: -20,
                height: SizeConfig.screenHeight * 0.3,
                width: SizeConfig.screenWidth,
                child: SvgPicture.asset("assets/vectors/home_bg_shape.svg"),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  margin: EdgeInsets.only(top: SizeConfig.screenWidth * 0.15),
                  width: SizeConfig.screenWidth,
                  height: SizeConfig.screenHeight * 0.72,
                  decoration: BoxDecoration(
                    color: Color(0xffF1F6FF),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                  ),
                ),
              ),
              SafeArea(
                child: Container(
                  height: SizeConfig.screenHeight,
                  width: SizeConfig.screenWidth,
                  child: Column(
                    children: [
                      SizedBox(height: kToolbarHeight / 3),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: SizeConfig.scaffoldMargin),
                        child: Row(
                          children: [
                            ProfileImage(
                              height: 0.5,
                            ),
                            Spacer(),
                            Container(
                              height: kToolbarHeight,
                              padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.globalMargin,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.white.withOpacity(0.4),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.airplane_ticket,
                                    color: UiConstants.tertiarySolid,
                                  ),
                                  Text("40"),
                                  Icon(
                                    Icons.add_circle,
                                    color: UiConstants.primaryColor,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 16),
                            CircleAvatar(
                              backgroundColor: Colors.black,
                              radius: kToolbarHeight * 0.5,
                              child: Icon(
                                Icons.notifications,
                                color: Colors.white,
                                size: kToolbarHeight * 0.54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SafeArea(
                child: Container(
                  margin: EdgeInsets.only(top: kToolbarHeight * 2),
                  child: IndexedStack(
                      children: model.pages,
                      index: AppState.getCurrentTabIndex),
                ),
              ),
              if (AppState.getCurrentTabIndex == 0)
                Positioned(
                  bottom: kBottomNavigationBarHeight,
                  child: SafeArea(
                    child: Container(
                      width: SizeConfig.screenWidth,
                      child: Padding(
                        padding: EdgeInsets.all(SizeConfig.scaffoldMargin),
                        child: Container(
                          height: kBottomNavigationBarHeight * 2,
                          width: SizeConfig.screenWidth,
                          decoration: BoxDecoration(
                            color: Color(0xffCBECED),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24),
                            ),
                          ),
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(
                              bottom: kBottomNavigationBarHeight / 2),
                          child: Text(
                            "Want more tickets",
                            style: TextStyles.title3
                                .colour(UiConstants.primaryColor)
                                .bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              Positioned(
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
                        padding: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: SizeConfig.blockSizeHorizontal * 5),
                        child: NavBar(
                          itemTapped: (int index) => model.onItemTapped(index),
                          currentIndex: AppState.getCurrentTabIndex,
                          items: [
                            NavBarItemData(
                              "Play",
                              Icons.home,
                              "images/svgs/game.svg",
                            ),
                            NavBarItemData(
                              "Save",
                              Icons.games,
                              "images/svgs/save.svg",
                            ),
                            NavBarItemData(
                              "Win",
                              Icons.wallet_giftcard,
                              "images/svgs/home.svg",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // ),
            ],
          ),
        );
      },
    );
  }

  AppBar appBar(RootViewModel model, BuildContext context) {
    return AppBar(
      backgroundColor: ThemeData().scaffoldBackgroundColor,
      leading: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: InkWell(
          onTap: model.showDrawer,
          child: ProfileImage(),
        ),
      ),
      title: PropertyChangeConsumer<UserService, UserServiceProperties>(
        properties: [UserServiceProperties.myUserName],
        builder: (context, model, property) => Text(
          "Hi, ${model.myUserName?.split(' ')?.first ?? "user"}",
          style: TextStyles.body1.bold,
        ),
      ),
      actions: [
        InkWell(
          onTap: () => model.showTicketModal(context),
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: UiConstants.primaryColor),
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                PropertyChangeConsumer<UserService, UserServiceProperties>(
                  builder: (context, model, property) => Text(
                      model.userTicketWallet.getActiveTickets().toString() ?? 0,
                      style: TextStyles.body3.bold),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.control_point_rounded,
                  color: Colors.white,
                  size: kToolbarHeight / 2.5,
                ),
              ],
            ),
          ),
        ),
        InkWell(
          child: Icon(
            Icons.notifications,
            size: kToolbarHeight * 0.5,
            color: Color(0xff4C4C4C),
          ),
          //icon: Icon(Icons.contact_support_outlined),
          // iconSize: kToolbarHeight * 0.5,
          onTap: model.openAlertsScreen,
        ),
        SizedBox(
          width: SizeConfig.globalMargin,
        )
      ],
    );
  }
}

 // BottomNavigationBar(
                            //   type: BottomNavigationBarType.shifting,
                            //   backgroundColor: UiConstants.primaryColor,
                            //   selectedFontSize: 16,
                            //   selectedIconTheme: IconThemeData(
                            //       color: UiConstants.primaryColor, size: 32),
                            //   selectedItemColor: UiConstants.primaryColor,
                            //   selectedLabelStyle:
                            //       TextStyle(fontWeight: FontWeight.bold),
                            //   unselectedIconTheme: IconThemeData(
                            //     color: Colors.grey[500],
                            //   ),
                            //   unselectedItemColor: Colors.grey[500],
                            //   currentIndex: AppState().getCurrentTabIndex, //New
                            //   onTap: model.onItemTapped,
                            //   items: const <BottomNavigationBarItem>[
                            //     BottomNavigationBarItem(
                            //       icon: Icon(Icons.emoji_events_rounded),
                            //       label: 'Play',
                            //     ),
                            //     BottomNavigationBarItem(
                            //       icon: Icon(Icons.account_balance_wallet),
                            //       label: 'Save',
                            //     ),
                            //     BottomNavigationBarItem(
                            //       icon: Icon(Icons.celebration_rounded),
                            //       label: 'Win',
                            //     ),
                            //   ],
                            // ),
