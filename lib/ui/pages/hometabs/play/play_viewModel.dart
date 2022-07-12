import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/deposit_response_model.dart';
import 'package:felloapp/core/model/flc_pregame_model.dart';
import 'package:felloapp/core/model/game_model.dart';
import 'package:felloapp/core/model/promo_cards_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/repository/flc_actions_repo.dart';
import 'package:felloapp/core/repository/getters_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/campaigns_service.dart';
import 'package:felloapp/core/service/cache_manager.dart';
import 'package:felloapp/core/service/notifier_services/user_coin_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:flutter/material.dart';

class PlayViewModel extends BaseModel {
  final _fclActionRepo = locator<FlcActionsRepo>();
  final _userCoinService = locator<UserCoinService>();
  final _userService = locator<UserService>();
  // final _dbProvider = locator<DBModel>();
  final _getterRepo = locator<GetterRepository>();
  final _logger = locator<CustomLogger>();
  final _baseUtil = locator<BaseUtil>();
  final _analyticsService = locator<AnalyticsService>();
  String gamesListOneTitle = "Trending", gamesListTwoTitle = "More games";
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

    setGameListTitle();
  }

  void clear() {
    _timer?.cancel();
  }

  loadOfferList() async {
    isOfferListLoading = true;
    final response = await _getterRepo.getPromoCards();
    if (response.code == 200) {
      _offerList = response.model;
    } else {
      _offerList = [];
    }
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

  setGameListTitle() async {
    if (PreferenceHelper.exist(PreferenceHelper.CACHE_LAST_PLAYED_GAMES)) {
      gamesListOneTitle = "Recently played";
      notifyListeners();
    }
  }
}
