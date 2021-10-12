import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/root/root_vm.dart';
import 'package:felloapp/ui/widgets/appbars/fello_appbar_view.dart';
import 'package:felloapp/ui/widgets/drawer/drawer_view.dart';
import 'package:felloapp/util/ui_constants.dart';
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
          appBar: FelloAppBar(
            appBar: AppBar(),
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
