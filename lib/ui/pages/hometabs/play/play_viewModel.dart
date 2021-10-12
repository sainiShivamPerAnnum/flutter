import 'package:felloapp/core/enums/screen_item.dart';
import 'package:felloapp/core/enums/view_state.dart';
import 'package:felloapp/core/model/flc_pregame_model.dart';
import 'package:felloapp/core/repository/fcl_actions_repo.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/modals/want_more_tickets_modal_sheet.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class PlayViewModel extends BaseModel {
  final _fclActionRepo = locator<FlcActionsRepo>();
  final _logger = locator<Logger>();

  List<String> _gamesList = ["Tambola", "Google"];

  List get gameList => _gamesList;

  showTicketModal(BuildContext context) {
    AppState.screenStack.add(ScreenItem.dialog);
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return WantMoreTicketsModalSheet();
        });
  }

  Future<bool> openWebView() async {
    setState(ViewState.Busy);
    ApiResponse<FlcModel> _flcResponse = await _fclActionRepo.substractFlc();
    if (_flcResponse.code == 200) {
      setState(ViewState.Idle);
      return true;
    } else {
      setState(ViewState.Idle);
      return false;
    }
  }
}
