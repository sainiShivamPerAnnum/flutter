import 'dart:async';

import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/game_model.dart';
import 'package:felloapp/core/model/promo_cards_model.dart';
import 'package:felloapp/core/repository/games_repo.dart';
import 'package:felloapp/core/repository/getters_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:felloapp/base_util.dart';
import '../../../../util/assets.dart';

class PlayViewModel extends BaseViewModel {
  final _getterRepo = locator<GetterRepository>();
  final _userService = locator<UserService>();
  final _analyticsService = locator<AnalyticsService>();
  final GameRepo gamesRepo = locator<GameRepo>();
  final _baseUtil = locator<BaseUtil>();
  bool _showSecurityMessageAtTop = true;

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
  String boxHeading = "How fello games work?";
  List<String> boxAssets = [
    Assets.ludoGameAsset,
    Assets.ludoGameAsset,
    Assets.leaderboardGameAsset,
    Assets.giftGameAsset,
  ];
  List<String> boxTitlles = [
    'Earn tokens by completing milestones',
    'Use tokens to play games. Each game requires certain tokens to play',
    'Score high scores and get listed on the game leaderboard',
    'Win rewards every sunday midnight',
  ];
  ////////////////////////////////////////////

  List<GameModel> get gamesListData => _gamesListData;

  get isGamesListDataLoading => this._isGamesListDataLoading;

  set gamesListData(List<GameModel> games) {
    _gamesListData = games;
    if (_gamesListData != null) {
      trendingGamesListData = [];
      moreGamesListData = [];
      gow = gamesListData?.firstWhere((game) => game.isGOW,
          orElse: () => gamesListData[0]);
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

  get showSecurityMessageAtTop => this._showSecurityMessageAtTop;

  set showSecurityMessageAtTop(value) {
    this._showSecurityMessageAtTop = value;
    notifyListeners();
  }

  openProfile() {
    _baseUtil.openProfileDetailsScreen();
  }

  init() async {
    isGamesListDataLoading = true;
    final response = await gamesRepo.getGames();
    showSecurityMessageAtTop =
        _userService.userJourneyStats.mlIndex > 6 ? false : true;
    if (response.isSuccess()) {
      gamesListData = response.model;
      isGamesListDataLoading = false;
    } else {
      BaseUtil.showNegativeAlert("", response.errorMessage);
    }
  }

  void openGame(GameModel game) {
    _analyticsService.track(eventName: game.analyticEvent);
    AppState.delegate.appState.currentAction =
        PageAction(state: PageState.addPage, page: THomePageConfig);
  }
}
