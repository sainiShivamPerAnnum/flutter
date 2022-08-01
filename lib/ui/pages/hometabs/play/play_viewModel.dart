import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/game_model.dart';
import 'package:felloapp/core/model/promo_cards_model.dart';
import 'package:felloapp/core/repository/flc_actions_repo.dart';
import 'package:felloapp/core/repository/games_repo.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/campaigns_service.dart';
import 'package:felloapp/core/service/notifier_services/user_coin_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';

class PlayViewModel extends BaseModel {
  final _fclActionRepo = locator<FlcActionsRepo>();
  final _userCoinService = locator<UserCoinService>();
  final _userService = locator<UserService>();
  // final _dbProvider = locator<DBModel>();
  final _promoService = locator<CampaignService>();
  final _logger = locator<CustomLogger>();
  final _baseUtil = locator<BaseUtil>();
  final _analyticsService = locator<AnalyticsService>();
  final GamesRepository gamesRepo = locator<GamesRepository>();
  final PageController promoPageController =
      new PageController(viewportFraction: 0.9, initialPage: 0);
  int _currentPage = 0;
  Timer _timer;
  String _message;
  String _sessionId;
  bool _isOfferListLoading = true;
  bool _isGamesListDataLoading = true;

  List<PromoCardModel> _offerList;
  List<GameDataModel> _gamesListData;
  GameDataModel gow;
  List<GameDataModel> trendingGamesListData;
  List<GameDataModel> moreGamesListData;

  List<GameDataModel> get gamesListData => _gamesListData;

  List<PromoCardModel> get offerList => _offerList;

  String get message => _message;
  String get sessionId => _sessionId;

  get isOfferListLoading => this._isOfferListLoading;
  get isGamesListDataLoading => this._isGamesListDataLoading;

  set isOfferListLoading(value) {
    this._isOfferListLoading = value;
    notifyListeners();
  }

  set gamesListData(List<GameDataModel> games) {
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
    await gamesRepo.loadGamesList();
    gamesListData = gamesRepo.allgames;
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
    await _promoService.getPromoCards().then((cards) {
      _offerList = cards.model;
    });
    if (_offerList != null && offerList.length > 1) initiate();
    isOfferListLoading = false;
  }

  // void showMessage(context) {
  //   _baseUtil.showNegativeAlert('Permission Denied', _message, context);
  // }
  // void openGame(GameDataModel game) {
  //   _analyticsService.track(eventName: game.analyticEvent);
  //   AppState.delegate.appState.currentAction =
  //       PageAction(state: PageState.addPage, page: game.pageConfig);
  // }

  // Future<bool> openWebView() async {
  //   setState(ViewState.Busy);
  //   String _cricPlayCost = BaseRemoteConfig.remoteConfig
  //           .getString(BaseRemoteConfig.CRICKET_PLAY_COST) ??
  //       "10";
  //   int _cost = -1 * int.tryParse(_cricPlayCost) ?? 10;
  //   ApiResponse<FlcModel> _flcResponse =
  //       await _fclActionRepo.substractFlc(_cost);
  //   _message = _flcResponse.model.message;
  //   if (_flcResponse.model.flcBalance != null) {
  //     _userCoinService.setFlcBalance(_flcResponse.model.flcBalance);
  //   } else {
  //     _logger.d("Flc balance is null");
  //   }

  //   if (_flcResponse.model.sessionId != null) {
  //     _sessionId = _flcResponse.model.sessionId;
  //   } else {
  //     _logger.d("sessionId null");
  //   }

  //   if (_flcResponse.model.canUserPlay) {
  //     setState(ViewState.Idle);
  //     return true;
  //   } else {
  //     setState(ViewState.Idle);
  //     return false;
  //   }
  // }

  // Play 4.0 Model View
  // Future<String> _getBearerToken() async {
  //   String token = await _userService.firebaseUser.getIdToken();
  //   _logger.d('Token: $token');
  //   return token;
  // }

  // loadGameLists() async {
  //   Future.delayed(Duration(seconds: 5));
  //   try {
  //     final token = await _getBearerToken();
  //     final response = await APIService.instance.getData(
  //       ApiPath().kGames,
  //       token: token,
  //       cBaseUrl: 'https://4mm5ihvkz0.execute-api.ap-south-1.amazonaws.com',
  //     );
  //     final _responseModel = NewGameModel.fromJson(response);
  //     _logger.d(response);
  //     _gamesListData = _responseModel.data.games;
  //     _logger.d('Game Length: ${_responseModel.data.games.length}');
  //     _logger.d('Game Response: $response');
  //     if (_gamesListData.isNotEmpty) {
  //       // sorting games by order
  //       _gamesListData.sort((a, b) => a.order.compareTo(b.order));
  //       isGamesListDataLoading = false;
  //       for (var item in _gamesListData) {
  //         if (item.isGOW)
  //         {
  //           _isGOWCheck = true;
  //           _isGOWIndex = item.order;
  //         }
  //         if(item.isTrending)
  //         isTrendingCount += 1;
  //       }
  //     }
  //   } catch (e) {
  //     _logger.d('Catch Error: $e');
  //   }
  // }
}
