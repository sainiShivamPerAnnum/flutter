import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/flc_pregame_model.dart';
import 'package:felloapp/core/model/game_model.dart';
import 'package:felloapp/core/repository/fcl_actions_repo.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/modals_sheets/want_more_tickets_modal_sheet.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class OfferCardModel {
  String title1;
  String title2;
  String buttonText;
  String routePath;
  Color bgColor;

  OfferCardModel(
      {this.bgColor,
      this.buttonText,
      this.routePath,
      this.title1,
      this.title2});
}

class PlayViewModel extends BaseModel {
  List<OfferCardModel> _offerList = [
    OfferCardModel(
      title1: "WIN",
      title2: "4 Tickets Now",
      bgColor: UiConstants.tertiarySolid,
      buttonText: "Explore",
      routePath: '/not/yet/defined',
    ),
    OfferCardModel(
      title1: "WIN",
      title2: "8 Tickets Now",
      bgColor: UiConstants.primaryColor,
      buttonText: "Hop in",
      routePath: '/not/yet/defined',
    ),
  ];
  List<GameModel> _gamesList = [
    GameModel(
        gameName: "Tambola",
        pageConfig: THomePageConfig,
        tag: 'tambola',
        thumbnailImage:
            "https://store-images.s-microsoft.com/image/apps.7421.14526104391731353.3efa198c-600d-47e2-a495-171846e34e31.74622fdc-08ff-434d-9cec-a4b5266dc24c?mode=scale&q=90&h=1080&w=1920"),
    GameModel(
        gameName: "Cricket",
        pageConfig: THomePageConfig,
        tag: 'cricket',
        thumbnailImage:
            "https://www.mpl.live/blog/wp-content/uploads/2020/09/WCC2-mobile-game-becomes-the-worlds-No.1-cricket-game-silently-1.png")
  ];
  final _fclActionRepo = locator<FlcActionsRepo>();
  final _logger = locator<Logger>();

  List<GameModel> get gameList => _gamesList;
  List<OfferCardModel> get offerList => _offerList;

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
