import 'package:felloapp/core/enums/pagestate.dart';
import 'package:felloapp/core/enums/screen_item.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/modals_sheets/want_more_tickets_modal_sheet.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:flutter/material.dart';

class FelloAppBarViewModel extends BaseModel {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  showDrawer() {
    scaffoldKey.currentState.openDrawer();
  }

  showTicketModal(BuildContext context) {
    AppState.screenStack.add(ScreenItem.dialog);
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return WantMoreTicketsModalSheet();
        });
  }

  openAlertsScreen() {
    Haptic.vibrate();
    AppState.delegate.appState.currentAction =
        PageAction(state: PageState.addPage, page: NotificationsConfig);
  }
}
