import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui show Image;
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/modals_sheets/want_more_tickets_modal_sheet.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class PlayViewModel extends BaseModel {
  List<String> _gamesList = ["Tambola", "Google"];
  ui.Image _gameImage;
  ui.Image get gameImage => _gameImage;

  set gameImage(ui.Image image) {
    _gameImage = image;
    notifyListeners();
  }

  List get gameList => _gamesList;

  showTicketModal(BuildContext context) {
    AppState.screenStack.add(ScreenItem.dialog);
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return WantMoreTicketsModalSheet();
        });
  }

  loadImage() {
    setState(ViewState.Busy);
    getImageFileFromAssets("PAN_card.png");
    setState(ViewState.Idle);
  }

  Future<ui.Image> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('images/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    Uint8List list = file.readAsBytesSync();
    ui.Image myBackground = await decodeImageFromList(list);
    gameImage = myBackground;
    //return myBackground;
  }
}
