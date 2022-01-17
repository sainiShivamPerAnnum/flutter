import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/widgets/fello_dialog/fello_confirm_dialog.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/ui_constants.dart';

class GoldenTicketService {
  static bool hasGoldenTicket = false;
  void showGoldenTicketAvailableDialog() {
    if (hasGoldenTicket) {
      hasGoldenTicket = false;
      Future.delayed(Duration(milliseconds: 800), () {
        BaseUtil.openDialog(
          addToScreenStack: true,
          isBarrierDismissable: false,
          hapticVibrate: false,
          content: FelloConfirmationDialog(
              title: 'Yayy!',
              subtitle: 'You won a golden ticket',
              accept: 'Open',
              acceptColor: UiConstants.primaryColor,
              asset: Assets.goldenTicket,
              reject: "Ok",
              rejectColor: UiConstants.tertiarySolid,
              showCrossIcon: false,
              onAccept: () async {
                Future.delayed(Duration(milliseconds: 500), () {
                  AppState.backButtonDispatcher.didPopRoute();
                  AppState.delegate.appState.currentAction = PageAction(
                    page: GoldenTicketsViewPageConfig,
                    state: PageState.addPage,
                  );
                });
              },
              onReject: () {
                AppState.backButtonDispatcher.didPopRoute();
              }),
        );
      });
    }
  }
}
