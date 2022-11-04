import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/golden_ticket_model.dart';
import 'package:felloapp/core/repository/golden_ticket_repo.dart';
import 'package:felloapp/core/service/notifier_services/golden_ticket_service.dart';
import 'package:felloapp/core/service/notifier_services/user_coin_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_scratch_card/gt_detailed_view.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';

class GTInstantViewModel extends BaseViewModel {
  final _userService = locator<UserService>();
  final _userCoinService = locator<UserCoinService>();
  final _logger = locator<CustomLogger>();
  final _gtService = locator<GoldenTicketService>();
  final _coinService = locator<UserCoinService>();
  final _gtRepo = locator<GoldenTicketRepository>();
  List<GoldenTicket> unscratchedGtList = [];
  AnimationController lottieAnimationController;
  double coinContentOpacity = 1;
  bool isCoinAnimationInProgress = false;
  bool isInvestmentAnimationInProgress = false;
  bool showMainContent = false;
  bool isAutosaveAlreadySetup = false;
  int tokens = 0;
  int _coinsCount = 0;
  double coinScale = 1;
  bool _isShimmerEnabled = false;
  GoldenTicket _goldenTicket;
  double _buttonOpacity = 0;
  bool _showScratchGuide = false;
  bool _isCardScratchStarted = false;
  bool _isCardScratched = false;
  int get coinsCount => this._coinsCount;
  double get buttonOpacity => this._buttonOpacity;
  GoldenTicket get goldenTicket => this._goldenTicket;
  bool get isShimmerEnabled => this._isShimmerEnabled;
  bool get showScratchGuide => this._showScratchGuide;
  bool get isCardScratched => this._isCardScratched;
  bool get isCardScratchStarted => this._isCardScratchStarted;

  set coinsCount(value) {
    this._coinsCount = value;
    notifyListeners();
  }

  set buttonOpacity(value) {
    this._buttonOpacity = value;
    notifyListeners();
  }

  set goldenTicket(value) {
    this._goldenTicket = value;
    notifyListeners();
  }

  set isShimmerEnabled(value) {
    this._isShimmerEnabled = value;
    notifyListeners();
  }

  set showScratchGuide(value) {
    this._showScratchGuide = value;
    notifyListeners();
  }

  set isCardScratchStarted(bool value) {
    this._isCardScratchStarted = value;
    notifyListeners();
  }

  set isCardScratched(value) {
    this._isCardScratched = value;
    notifyListeners();
  }

  init() async {
    Haptic.vibrate();
    goldenTicket = GoldenTicketService.currentGT;
    GoldenTicketService.currentGT = null;
    if (goldenTicket.isRewarding &&
        goldenTicket.rewardArr.any((element) => element.type == 'flc')) {
      tokens = goldenTicket.rewardArr
          .firstWhere((element) => element.type == 'flc')
          .value;
    }
    Future.delayed(Duration(seconds: 3), () {
      if (!isCardScratchStarted) {
        showScratchGuide = true;
      }
    });
  }

  showAutosavePrompt() {
    _gtService.showAutosavePrompt();
  }

  Future<void> redeemTicket() async {
    scratchKey.currentState.reveal();
    Haptic.vibrate();
    buttonOpacity = 1.0;
    isCardScratched = true;
    coinsCount = _userCoinService.flcBalance + tokens;

    try {
      _getBearerToken().then(
        (String token) => _gtRepo.redeemReward(goldenTicket.gtId).then(
          (_) {
            _gtService.updateUnscratchedGTCount();
            _userService.getUserFundWalletData();
            _userCoinService.getUserCoinBalance();
          },
        ),
      );
    } catch (e) {
      _logger.e(e);
      BaseUtil.showNegativeAlert(
          "An error occurred while redeeming your golden ticket",
          "Please try again in your winnings section");
    }

    Future.delayed(Duration(seconds: 3), () {
      AppState.backButtonDispatcher.didPopRoute();
    });
  }

  Future<String> _getBearerToken() async {
    String token = await _userService.firebaseUser.getIdToken();
    _logger.d(token);

    return token;
  }

  handleMultipleUnscratchedTickets() async {
    final res = await _gtRepo.getUnscratchedGoldenTickets();
    if (res.isSuccess()) {
      if (res.model.isNotEmpty && res.model.length > 1) {
        unscratchedGtList = res.model;
        updateToMultipleTicketsView();
      } else
        unscratchedGtList = [];
    }
  }

  updateToMultipleTicketsView() {}
  initNormalFlow() {
    Future.delayed(Duration(milliseconds: 500), () {
      showMainContent = true;
      coinsCount = _coinService.flcBalance;
    });
  }
}
