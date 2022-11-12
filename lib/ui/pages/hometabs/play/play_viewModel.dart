import 'dart:async';

import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/game_model.dart';
import 'package:felloapp/core/model/promo_cards_model.dart';
import 'package:felloapp/core/repository/games_repo.dart';
import 'package:felloapp/core/repository/getters_repo.dart';
import 'package:felloapp/core/service/analytics/analyticsProperties.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_components/gow_card.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_components/more_games_section.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_components/play_info_section.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_components/safety_widget.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_components/trendingGames.dart';
import 'package:felloapp/ui/pages/static/app_footer.dart';
import 'package:felloapp/ui/widgets/tambola_card/tambola_card_view.dart';
import 'package:felloapp/util/dynamic_ui_utils.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
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
  String boxHeading = "How Fello games work?";
  List<String> boxAssets = [
    Assets.ludoGameAsset,
    Assets.token,
    Assets.leaderboardGameAsset,
    Assets.gift,
  ];
  List<String> boxTitles = [
    'Earn tokens by saving & completing milestones',
    'Use tokens to play different games',
    'Get listed on the game leaderboard',
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

  getOrderedPlayViewItems(PlayViewModel model) {
    List<Widget> playViewChildren = [];

    DynamicUiUtils.playViewOrder.forEach((key) {
      switch (key) {
        case 'TM':
          playViewChildren.add(TambolaCard());
          break;
        case 'AG':
          playViewChildren.add(TrendingGamesSection(model: model));
          break;
        case 'HTP':
          playViewChildren.add(InfoComponent2(
            heading: model.boxHeading,
            assetList: model.boxAssets,
            titleList: model.boxTitles,
            height: SizeConfig.screenWidth * 0.3,
          ));
          break;
        case 'GOW':
          playViewChildren.add(GOWCard(model: model));
          break;
        case 'ST':
          playViewChildren.add(SafetyWidget());
          break;
        case 'MG':
          playViewChildren.add(MoreGamesSection(model: model));
          break;
      }
    });
    playViewChildren.add(
        AppFooter(bottomPad: SizeConfig.navBarHeight + SizeConfig.padding80));
    return playViewChildren;
  }

  void openGame(GameModel game) {
    _analyticsService.track(eventName: game.analyticEvent);
    AppState.delegate.appState.currentAction =
        PageAction(state: PageState.addPage, page: THomePageConfig);
  }
}
