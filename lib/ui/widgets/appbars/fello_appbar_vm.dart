import 'package:felloapp/core/enums/page_state_enum.dart';

import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/service/user_coin_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/modals_sheets/want_more_tickets_modal_sheet.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';

class FelloAppBarVM extends BaseModel {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final _userCoinService = locator<UserCoinService>();

  bool _isLoadingFlc = true;
  get isLoadingFlc => _isLoadingFlc;

  showDrawer() {
    scaffoldKey.currentState.openDrawer();
  }

  getFlc() async {
    _isLoadingFlc = true;
    await _userCoinService?.getUserCoinBalance();
    _isLoadingFlc = false;
    notifyListeners();
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
