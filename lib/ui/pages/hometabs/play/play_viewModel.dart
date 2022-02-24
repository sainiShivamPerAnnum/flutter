import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/flc_pregame_model.dart';
import 'package:felloapp/core/model/game_model.dart';
import 'package:felloapp/core/model/promo_cards_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/repository/flc_actions_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/user_coin_service.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';

class PlayViewModel extends BaseModel {
  final _fclActionRepo = locator<FlcActionsRepo>();
  final _userCoinService = locator<UserCoinService>();
  final _userService = locator<UserService>();
  final _dbProvider = locator<DBModel>();
  final _logger = locator<CustomLogger>();
  final _baseUtil = locator<BaseUtil>();
  final _analyticsService = locator<AnalyticsService>();
  final PageController promoPageController =
      new PageController(viewportFraction: 0.9, initialPage: 0);
  int _currentPage = 0;
  Timer _timer;
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

  initiate() {
    _timer = Timer.periodic(Duration(seconds: 6), (Timer timer) {
      if (_currentPage < offerList.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      promoPageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 600),
        curve: Curves.easeIn,
      );
    });
  }

  void clear() {
    _timer?.cancel();
  }

  loadOfferList() async {
    isOfferListLoading = true;
    await _dbProvider.getPromoCards().then((cards) {
      _offerList = cards;
    });
    print(_offerList);
    if (_offerList != null && offerList.length > 1) initiate();
    isOfferListLoading = false;
  }

  // void showMessage(context) {
  //   _baseUtil.showNegativeAlert('Permission Denied', _message, context);
  // }
  void openGame(GameModel game) {
    _analyticsService.track(eventName: game.analyticEvent);
    AppState.delegate.appState.currentAction =
        PageAction(state: PageState.addPage, page: game.pageConfig);
  }

  Future<bool> openWebView() async {
    setState(ViewState.Busy);
    String _cricPlayCost = BaseRemoteConfig.remoteConfig
            .getString(BaseRemoteConfig.CRICKET_PLAY_COST) ??
        "10";
    int _cost = -1 * int.tryParse(_cricPlayCost) ?? 10;
    ApiResponse<FlcModel> _flcResponse =
        await _fclActionRepo.substractFlc(_cost);
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
