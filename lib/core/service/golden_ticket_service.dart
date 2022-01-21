import 'dart:developer';

import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/model/golden_ticket_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_scratch_dialog/gt_instant_view.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';

class GoldenTicketService extends ChangeNotifier {
  final _logger = locator<CustomLogger>();
  final _dbModel = locator<DBModel>();
  final _userservice = locator<UserService>();
  // static bool hasGoldenTicket = false;

  static String goldenTicketId;
  static GoldenTicket currentGT;

  List<GoldenTicket> _activeGoldenTickets;

  List<GoldenTicket> get activeGoldenTickets => this._activeGoldenTickets ?? [];

  set activeGoldenTickets(List<GoldenTicket> value) {
    this._activeGoldenTickets = value;
    notifyListeners();
    log("GoldenTicket list updated");
  }

  Future<bool> fetchAndVerifyGoldenTicketByID() async {
    if (goldenTicketId != null && goldenTicketId.isNotEmpty) {
      currentGT = await _dbModel.getGoldenTicketById(
          _userservice.baseUser.uid, goldenTicketId);
      goldenTicketId = null;
      if (currentGT != null && isGTValid(currentGT)) {
        return true;
      }
    }
    return false;
  }

  showInstantGoldenTicketView({@required GTSOURCE source, String title}) {
    if (currentGT != null) {
      Future.delayed(Duration(milliseconds: 200), () {
        if (source != GTSOURCE.deposit)
          AppState.screenStack.add(ScreenItem.dialog);

        Navigator.of(AppState.delegate.navigatorKey.currentContext)
            .push(PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) => GTInstantView(
                      source: source,
                      title: title,
                    )));
      });
    }
  }

  // void showGoldenTicketFlushbar() {
  //   hasGoldenTicket = false;
  //   try {
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       Flushbar(
  //         flushbarPosition: FlushbarPosition.BOTTOM,
  //         flushbarStyle: FlushbarStyle.FLOATING,
  //         padding: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
  //         mainButton: IconButton(
  //           onPressed: () {},
  //           icon: Icon(Icons.arrow_forward_ios_rounded),
  //           color: Colors.white,
  //         ),
  //         isDismissible: true,
  //         dismissDirection: FlushbarDismissDirection.HORIZONTAL,
  //         icon: Container(
  //           decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(SizeConfig.padding16),
  //               image: DecorationImage(
  //                   image: AssetImage("assets/images/gtbg.png"))),
  //           height: SizeConfig.iconSize1,
  //         ),
  //         onTap: (data) {
  //           AppState.delegate.appState.currentAction = PageAction(
  //             page: MyWinnigsPageConfig,
  //             state: PageState.addPage,
  //           );
  //         },
  //         margin: EdgeInsets.all(10),
  //         borderRadius: SizeConfig.roundness16,
  //         // title: "You won a Golden Ticket",
  //         message: "Tap to find out what you have won",
  //         duration: Duration(seconds: 3),
  //         shouldIconPulse: true,
  //         titleText: Text(
  //           "You have a new Golden Ticket",
  //           style: TextStyles.body2.bold.colour(Colors.white),
  //         ),
  //         backgroundGradient: new LinearGradient(
  //           colors: [
  //             UiConstants.primaryColor,
  //             UiConstants.primaryColor.withGreen(150)
  //           ],
  //         ),
  //         boxShadows: [
  //           BoxShadow(
  //             color: UiConstants.primaryColor.withOpacity(0.5),
  //             offset: Offset(0.0, 2.0),
  //             blurRadius: 8.0,
  //           )
  //         ],
  //       ).show(AppState.delegate.navigatorKey.currentContext);
  //     });
  //   } catch (e) {
  //     _logger.e(e.toString());
  //   }
  // }

  //HELPERS

  isGTValid(GoldenTicket ticket) {
    if (ticket.isRewarding != null &&
        ticket.gtId != null &&
        ticket.gtType != null &&
        ticket.timestamp != null &&
        ticket.timestamp != null) return true;
    return false;
  }
}
