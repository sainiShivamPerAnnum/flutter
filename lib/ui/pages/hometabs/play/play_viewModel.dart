import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/model/game_model.dart';
import 'package:felloapp/core/model/game_stats_model.dart';
import 'package:felloapp/core/model/game_tier_model.dart' hide GameModel;
import 'package:felloapp/core/model/promo_cards_model.dart';
import 'package:felloapp/core/repository/games_repo.dart';
import 'package:felloapp/core/repository/getters_repo.dart';
import 'package:felloapp/core/repository/user_stats_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_components/gow_card.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_components/more_games_section.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_components/play_info_section.dart';
import 'package:felloapp/ui/pages/hometabs/play/play_components/safety_widget.dart';
import 'package:felloapp/ui/pages/hometabs/play/widgets/games_widget/games_widget.dart';
import 'package:felloapp/util/dynamic_ui_utils.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';

import '../../../../util/assets.dart';

class PlayViewModel extends BaseViewModel {
  S? locale;

  PlayViewModel({this.locale}) {
    locale = locator<S>();
    boxHeading = locale!.howGamesWork;
    boxTitles.addAll([
      'Earn tokens by saving in Gold or Flo',
      'Use Fello tokens to play different games',
      "Win scratch cards for every high score!",
      "Maintain savings to play all games"
    ]);
  }

  final GetterRepository _getterRepo = locator<GetterRepository>();
  final UserService _userService = locator<UserService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  final GameRepo? gamesRepo = locator<GameRepo>();
  final BaseUtil _baseUtil = locator<BaseUtil>();

  // final WinnerService _winnerService = locator<WinnerService>();
  final UserStatsRepo _userStatsRepo = locator<UserStatsRepo>();
  bool _showSecurityMessageAtTop = true;

  // final TambolaWidgetController _tambolaController = TambolaWidgetController();
  String? _message;
  String? _sessionId;
  final bool _isOfferListLoading = true;
  bool _isGamesListDataLoading = true;
  late GameStats? gameStats;

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
    // Assets.gift,
    "assets/svg/piggy_bank.svg",
  ];
  List<String> boxTitles = [];

  ////////////////////////////////////////////

  List<GameModel>? get gamesListData => _gamesListData;

  get isGamesListDataLoading => _isGamesListDataLoading;

  set gamesListData(List<GameModel>? games) {
    _gamesListData = games;
    if (_gamesListData != null) {
      trendingGamesListData = [];
      moreGamesListData = [];
      gow = gamesListData?.firstWhere((game) => game.isGOW!,
          orElse: () => gamesListData![0]);
      _gamesListData!.forEach((game) {
        if (game.isTrending!) {
          trendingGamesListData.add(game);
        } else {
          moreGamesListData.add(game);
        }
      });
    }

    notifyListeners();
  }

  set isGamesListDataLoading(value) {
    _isGamesListDataLoading = value;
    notifyListeners();
  }

  get showSecurityMessageAtTop => _showSecurityMessageAtTop;

  set showSecurityMessageAtTop(value) {
    _showSecurityMessageAtTop = value;
    notifyListeners();
  }

  openProfile() {
    _baseUtil.openProfileDetailsScreen();
  }

  Future<void> setGameStatus() async {
    final data = await _userStatsRepo.completer.future;
    if (data?.data?.updatedOn?.seconds != gameStats?.data?.updatedOn?.seconds) {
      gameStats = data;

      notifyListeners();
    }
  }

  Future<void> init() async {
    isGamesListDataLoading = true;

    final response = await gamesRepo!.getGames();
    final res = await gamesRepo!.getGameTiers();
    locator<UserStatsRepo>().getGameStats();
    gameStats =
        await _userStatsRepo.completer.future.onError((error, stackTrace) {
      BaseUtil.showNegativeAlert("", "Something went wrong please try again");
      return;
    });

    showSecurityMessageAtTop =
        (_userService.userJourneyStats?.mlIndex ?? 0) > 6 ? false : true;

    if (res.isSuccess()) {
      gameTier = res.model;
    }
    if (response.isSuccess()) {
      gamesListData = response.model;
      isGamesListDataLoading = false;
    } else {
      BaseUtil.showNegativeAlert("", response.errorMessage);
    }
    _userStatsRepo.addListener(setGameStatus);
  }

  GameTiers? gameTier;

  getOrderedPlayViewItems(PlayViewModel model) {
    List<Widget> playViewChildren = [];

    DynamicUiUtils.playViewOrder.forEach((key) {
      switch (key) {
        // case 'TM':
        //   if (!locator<RootController>()
        //       .navItems
        //       .containsValue(RootController.tambolaNavBar)) {
        //     playViewChildren.add(TambolaCard(
        //       tambolaController: _tambolaController,
        //     ));
        //   }
        //   break;
        case 'AG':
          playViewChildren.add(GamesWidget(model: model));
          break;
        case 'HTP':
          playViewChildren.add(InfoComponent2(
            heading: model.boxHeading,
            assetList: model.boxAssets,
            titleList: model.boxTitles,
            height: SizeConfig.screenWidth! * 0.25,
          ));
          break;
        case 'GOW':
          playViewChildren.add(GOWCard(model: model));
          break;
        case 'ST':
          playViewChildren.add(const SafetyWidget());
          break;
        case 'MG':
          playViewChildren.add(MoreGamesSection(model: model));
          break;
      }
    });
    // playViewChildren.add(AppFooter(bottomPad: 0));
    // playViewChildren.add(TermsAndConditions(url: Constants.gamingtnc));
    playViewChildren.add(SizedBox(
      height: SizeConfig.padding10,
    ));
    playViewChildren.add(SizedBox(height: SizeConfig.padding16));

    // playViewChildren.add(
    //   LottieBuilder.network(
    //       "https://d37gtxigg82zaw.cloudfront.net/scroll-animation.json"),
    // );
    return playViewChildren;
  }

  void openGame(GameModel game) {
    _analyticsService.track(eventName: game.analyticEvent);
    AppState.delegate!.appState.currentAction =
        PageAction(state: PageState.addPage, page: THomePageConfig);
  }
}
