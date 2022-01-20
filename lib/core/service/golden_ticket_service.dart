import 'dart:developer';

import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/model/golden_ticket_model.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_scratch_dialog/gt_instant_view.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class GoldenTicketService extends ChangeNotifier {
  final _logger = locator<CustomLogger>();
  static bool hasGoldenTicket = false;

  static String goldenTicketId;

  List<GoldenTicket> _activeGoldenTickets;

  List<GoldenTicket> get activeGoldenTickets => this._activeGoldenTickets ?? [];

  set activeGoldenTickets(List<GoldenTicket> value) {
    this._activeGoldenTickets = value;
    notifyListeners();
    log("GoldenTicket list updated");
  }

  showInstantGoldenTicketView() {
    if (goldenTicketId != null) {
      Future.delayed(Duration(milliseconds: 700), () {
        AppState.screenStack.add(ScreenItem.dialog);
        Navigator.of(AppState.delegate.navigatorKey.currentContext).push(
            PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) => GTInstantView()));
      });
    }
  }

  void showGoldenTicketFlushbar() {
    hasGoldenTicket = false;
    try {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Flushbar(
          flushbarPosition: FlushbarPosition.BOTTOM,
          flushbarStyle: FlushbarStyle.FLOATING,
          padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
          mainButton: IconButton(
            onPressed: () {},
            icon: Icon(Icons.arrow_forward_ios_rounded),
            color: Colors.white,
          ),
          isDismissible: true,
          dismissDirection: FlushbarDismissDirection.HORIZONTAL,
          icon: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(SizeConfig.padding16),
                image: DecorationImage(
                    image: AssetImage("assets/images/gtbg.png"))),
            height: SizeConfig.iconSize1,
          ),
          onTap: (data) {
            AppState.delegate.appState.currentAction = PageAction(
              page: MyWinnigsPageConfig,
              state: PageState.addPage,
            );
          },
          margin: EdgeInsets.all(10),
          borderRadius: SizeConfig.roundness16,
          // title: "You won a Golden Ticket",
          message: "Tap to find out what you have won",
          duration: Duration(seconds: 3),
          shouldIconPulse: true,
          titleText: Text(
            "You have a new Golden Ticket",
            style: TextStyles.body2.bold.colour(Colors.white),
          ),
          backgroundGradient: new LinearGradient(
            colors: [
              UiConstants.primaryColor,
              UiConstants.primaryColor.withGreen(150)
            ],
          ),
          boxShadows: [
            BoxShadow(
              color: UiConstants.primaryColor.withOpacity(0.5),
              offset: Offset(0.0, 2.0),
              blurRadius: 8.0,
            )
          ],
        ).show(AppState.delegate.navigatorKey.currentContext);
      });
    } catch (e) {
      _logger.e(e.toString());
    }
  }
}
