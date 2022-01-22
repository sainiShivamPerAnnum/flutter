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
