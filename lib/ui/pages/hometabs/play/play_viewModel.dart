import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/flc_pregame_model.dart';
import 'package:felloapp/core/model/promo_cards_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/repository/flc_actions_repo.dart';
import 'package:felloapp/core/service/user_coin_service.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/modals_sheets/want_more_tickets_modal_sheet.dart';
import 'package:felloapp/ui/pages/others/games/cricket/cricket_game/cricket_game_view.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class PlayViewModel extends BaseModel {
  final _fclActionRepo = locator<FlcActionsRepo>();
  final _userCoinService = locator<UserCoinService>();
  final _userService = locator<UserService>();
  final _dbProvider = locator<DBModel>();
  final _logger = locator<Logger>();

  String _message;
  String _sessionId;
  bool _isOfferListLoading = true;
  List<PromoCardModel> _offerList;

  List<PromoCardModel> get offerList => _offerList;

  String get message => _message;
  String get sessionId => _sessionId;

  get isOfferListLoading => this._isOfferListLoading;

  set isOfferListLoading(value) {
    this._isOfferListLoading = value;
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

  loadOfferList() async {
    isOfferListLoading = true;
    await _dbProvider.getPromoCards().then((cards) {
      _offerList = cards;
    });
    print(_offerList);

    isOfferListLoading = false;
  }

  // void showMessage(context) {
  //   _baseUtil.showNegativeAlert('Permission Denied', _message, context);
  // }
  openGame(PageConfiguration pageConfig) {
    AppState.delegate.appState.currentAction =
        PageAction(state: PageState.addPage, page: pageConfig);
  }

  void navigateToCricketView() {
    AppState.delegate.appState.currentAction = PageAction(
        state: PageState.addWidget,
        page: CricketGamePageConfig,
        widget: CricketGameView(
          sessionId: _sessionId,
          userId: _userService.baseUser.uid,
          userName: _userService.baseUser.username,
          stage: FlavorConfig.getStage(),
        ));
  }

  Future<bool> openWebView() async {
    setState(ViewState.Busy);
    ApiResponse<FlcModel> _flcResponse = await _fclActionRepo.substractFlc(-10);
    _message = _flcResponse.model.message;
    if (_flcResponse.model.flcBalance != null) {
      _userCoinService.setFlcBalance(_flcResponse.model.flcBalance);
    } else {
      _logger.d("Flc balance is null");
    }

    if (_flcResponse.model.sessionId != null) {
      _sessionId = _flcResponse.model.sessionId;
    } else {
      _logger.d("sessionId null");
    }

    if (_flcResponse.model.canUserPlay) {
      setState(ViewState.Idle);
      return true;
    } else {
      setState(ViewState.Idle);
      return false;
    }
  }
}
