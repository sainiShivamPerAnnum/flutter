import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui show Image;
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/model/game_model.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/elements/parallax-card/data_model.dart';
import 'package:felloapp/ui/modals_sheets/want_more_tickets_modal_sheet.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class PlayViewModel extends BaseModel {
  List<GameModel> _gamesList = [
    GameModel(gameName: "Tambola", pageConfig: THomePageConfig, tag: 'tambola'),
    GameModel(gameName: "Cricket", pageConfig: THomePageConfig, tag: 'cricket')
  ];

  List<GameModel> get gameList => _gamesList;

  showTicketModal(BuildContext context) {
    AppState.screenStack.add(ScreenItem.dialog);
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return WantMoreTicketsModalSheet();
        });
  }
}
