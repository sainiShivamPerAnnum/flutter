import 'dart:async';

import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/game_model.dart';
import 'package:felloapp/core/model/promo_cards_model.dart';
import 'package:felloapp/core/repository/games_repo.dart';
import 'package:felloapp/core/repository/getters_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
import 'package:flutter/material.dart';

import '../../../../util/assets.dart';

class PlayViewModel extends BaseModel {
  final _getterRepo = locator<GetterRepository>();
  final _analyticsService = locator<AnalyticsService>();
  final GameRepo gamesRepo = locator<GameRepo>();
  final PageController promoPageController =
      new PageController(viewportFraction: 0.9, initialPage: 0);
  int _currentPage = 0;
  Timer _timer;
  String _message;
  String _sessionId;
  bool _isOfferListLoading = true;
  bool _isGamesListDataLoading = true;

  List<PromoCardModel> _offerList;
  List<GameModel> _gamesListData;
  GameModel gow;
  List<GameModel> trendingGamesListData;
  List<GameModel> moreGamesListData;

  //Related to the info box/////////////////
  String boxHeading = "What to do on Play?";
  List<String> boxAssets = [
    Assets.ludoGameAsset,
    Assets.leaderboardGameAsset,
    Assets.giftGameAsset,
  ];
  List<String> boxTitlles = [
    'Play Games with the\ntokens won',
    'Get listed on the game\nleaderboard',
    'Win coupons and cashbacks\nas rewards',
  ];
  ////////////////////////////////////////////

  List<GameModel> get gamesListData => _gamesListData;

  List<PromoCardModel> get offerList => _offerList;

  String get message => _message;
  String get sessionId => _sessionId;

  get isOfferListLoading => this._isOfferListLoading;
  get isGamesListDataLoading => this._isGamesListDataLoading;

  set isOfferListLoading(value) {
    this._isOfferListLoading = value;
    notifyListeners();
  }

  set gamesListData(List<GameModel> games) {
    _gamesListData = games;
    if (_gamesListData != null) {
      trendingGamesListData = [];
      moreGamesListData = [];
      gow = gamesListData?.firstWhere((game) => game.isGOW, orElse: null);
      _gamesListData.forEach((game) {
        if (game.isTrending)
          trendingGamesListData.add(game);
        else
          moreGamesListData.add(game);
      });
    }

    notifyListeners();
  }

  set isGamesListDataLoading(value) {
    this._isGamesListDataLoading = value;
    notifyListeners();
  }

  init() async {
    isGamesListDataLoading = true;
    final response = await gamesRepo.getGames();
    if (response.isSuccess()) gamesListData = response.model;
    isGamesListDataLoading = false;
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
        PageAction(state: PageState.addPage, page: THomePageConfig);
  }
}
