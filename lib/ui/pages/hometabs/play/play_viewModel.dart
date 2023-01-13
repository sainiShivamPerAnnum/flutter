import 'dart:async';

import 'package:apxor_flutter/apxor_flutter.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/game_model.dart';
import 'package:felloapp/core/model/game_stats_model.dart';
import 'package:felloapp/core/model/promo_cards_model.dart';
import 'package:felloapp/core/repository/games_repo.dart';
import 'package:felloapp/core/repository/getters_repo.dart';
import 'package:felloapp/core/repository/user_stats_repo.dart';
import 'package:felloapp/core/service/analytics/analyticsProperties.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/notifier_services/winners_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_components/gow_card.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_components/more_games_section.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_components/play_info_section.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_components/safety_widget.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_components/trendingGames.dart';
import 'package:felloapp/ui/pages/hometabs/play/widgets/tambola/tambola_controller.dart';
import 'package:felloapp/ui/pages/others/games/tambola/tambola_home/tambola_new_user_page.dart';
import 'package:felloapp/ui/pages/root/root_vm.dart';
import 'package:felloapp/ui/pages/static/app_footer.dart';
import 'package:felloapp/ui/widgets/tambola_card/tambola_card_view.dart';
import 'package:felloapp/util/dynamic_ui_utils.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:felloapp/base_util.dart';
import '../../../../util/assets.dart';

class PlayViewModel extends BaseViewModel {
  S? locale;
  RootViewModel model;
  PlayViewModel({this.locale, required this.model}) {
    locale = locator<S>();
    boxHeading = locale!.howGamesWork;
    boxTitles.addAll([
      locale!.boxPlayTitle1,
      locale!.boxPlayTitle2,
      locale!.boxPlayTitle3,
      locale!.boxPlayTitle4,
    ]);
  }
  final GetterRepository? _getterRepo = locator<GetterRepository>();
  final UserService? _userService = locator<UserService>();
  final AnalyticsService? _analyticsService = locator<AnalyticsService>();
  final GameRepo? gamesRepo = locator<GameRepo>();
  final BaseUtil? _baseUtil = locator<BaseUtil>();
  final WinnerService _winnerService = locator<WinnerService>();
  final UserStatsRepo _userStatsRepo = locator<UserStatsRepo>();
  bool _showSecurityMessageAtTop = true;
  final TambolaWidgetController _tambolaController = TambolaWidgetController();
  String? _message;
  String? _sessionId;
  bool _isOfferListLoading = true;
  bool _isGamesListDataLoading = true;

  GameStats? get gameStats => _userStatsRepo.gameStats;

  List<PromoCardModel>? _offerList;
  List<GameModel>? _gamesListData;
  GameModel? gow;
  late List<GameModel> trendingGamesListData;
  late List<GameModel> moreGamesListData;

  //Related to the info box/////////////////
  String boxHeading = '';
  List<String> boxAssets = [
    Assets.ludoGameAsset,
    Assets.token,
    Assets.leaderboardGameAsset,
    Assets.gift,
  ];
  List<String> boxTitles = [];
  ////////////////////////////////////////////

  List<GameModel>? get gamesListData => _gamesListData;

  get isGamesListDataLoading => this._isGamesListDataLoading;

  set gamesListData(List<GameModel>? games) {
    _gamesListData = games;
    if (_gamesListData != null) {
      trendingGamesListData = [];
      moreGamesListData = [];
      gow = gamesListData?.firstWhere((game) => game.isGOW!,
          orElse: () => gamesListData![0]);
      _gamesListData!.forEach((game) {
        if (game.isTrending!)
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
    _baseUtil!.openProfileDetailsScreen();
  }

  init() async {
    isGamesListDataLoading = true;
    locator<UserStatsRepo>().getGameStats();

    final response = await gamesRepo!.getGames();
    _winnerService.fetchWinnersForAllGames();

    showSecurityMessageAtTop =
        _userService!.userJourneyStats!.mlIndex! > 6 ? false : true;
    if (response.isSuccess()) {
      gamesListData = response.model;
      isGamesListDataLoading = false;
    } else {
      BaseUtil.showNegativeAlert("", response.errorMessage);
    }
  }

  getOrderedPlayViewItems(PlayViewModel model, RootViewModel rootVm) {
    List<Widget> playViewChildren = [];

    DynamicUiUtils.playViewOrder.forEach((key) {
      switch (key) {
        case 'TM':
          if (!rootVm.navBarItems.values.contains(rootVm.tambolaNavBar)) {
            playViewChildren.add(TambolaCard(
              tambolaController: _tambolaController,
            ));
          }
          break;
        case 'AG':
          playViewChildren.add(TrendingGamesSection(model: model));
          break;
        case 'HTP':
          playViewChildren.add(InfoComponent2(
            heading: model.boxHeading,
            assetList: model.boxAssets,
            titleList: model.boxTitles,
            height: SizeConfig.screenWidth! * 0.3,
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
    _analyticsService!.track(eventName: game.analyticEvent);
    AppState.delegate!.appState.currentAction =
        PageAction(state: PageState.addPage, page: THomePageConfig);
  }
}
