import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/root/root_vm.dart';
import 'package:felloapp/ui/service_elements/user_service/profile_image.dart';
import 'package:felloapp/ui/widgets/drawer/drawer_view.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
          appBar: AppBar(
            backgroundColor: ThemeData().scaffoldBackgroundColor,
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: InkWell(
                onTap: model.showDrawer,
                child: ProfileImage(),
              ),
            ),
            title: Text(
              "Hi, ${model.name.split(' ').first ?? "user"}",
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500,
                  fontSize: SizeConfig.largeTextSize),
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
                      Text(
                        model.userTicketCount,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
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
          ),
          drawer: FDrawer(),
          body: IndexedStack(
              children: model.pages, index: AppState().getCurrentTabIndex),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.shifting,
            selectedFontSize: 16,
            selectedIconTheme:
                IconThemeData(color: UiConstants.primaryColor, size: 32),
            selectedItemColor: UiConstants.primaryColor,
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedIconTheme: IconThemeData(
              color: Colors.grey[500],
            ),
            unselectedItemColor: Colors.grey[500],
            currentIndex: AppState().getCurrentTabIndex, //New
            onTap: model.onItemTapped,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.emoji_events_rounded),
                label: 'Play',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_wallet),
                label: 'Save',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.celebration_rounded),
                label: 'Win',
              ),
            ],
          ),
          // ),
        );
        ;
      },
    );
  }
}


