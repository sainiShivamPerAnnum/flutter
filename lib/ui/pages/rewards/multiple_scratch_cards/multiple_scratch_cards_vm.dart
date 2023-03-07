import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/scratch_card_model.dart';
import 'package:felloapp/core/repository/scratch_card_repo.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
import 'package:felloapp/core/service/notifier_services/user_coin_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:scratcher/widgets.dart';

class MultipleScratchCardsViewModel extends BaseViewModel {
  //VIEW variables
  PageController? pageController;
  ValueNotifier<double>? pageNotifier;

  //VM variables
  List<String>? scratchCardIdsList;
  List<ScratchCard> scratchCardList = [];
  List<GlobalKey<ScratcherState>> scratchStateKeys = [];
  int currentTokens = 0;

  double _currentCardScratchPercentage = 0.0;

  get currentCardScratchPercentage => this._currentCardScratchPercentage;

  set currentCardScratchPercentage(value) {
    if (value > 0 && showScratchGuideLabel) showScratchGuideLabel = false;
    this._currentCardScratchPercentage = value;
  }

  // bool _isCardScratched = false;
  // get isCardScratched => this._isCardScratched;
  // set isCardScratched(value) {
  //   this._isCardScratched = value;
  //   notifyListeners();
  // }

  bool _isCurrentScratchCardLoading = false;
  bool get isCurrentScratchCardLoading => this._isCurrentScratchCardLoading;
  set isCurrentScratchCardLoading(value) {
    this._isCurrentScratchCardLoading = value;
    notifyListeners();
  }

  bool _showScratchGuideLabel = false;
  bool get showScratchGuideLabel => this._showScratchGuideLabel;
  set showScratchGuideLabel(bool value) {
    this._showScratchGuideLabel = value;
    notifyListeners();
  }

  List<bool> _isScratchCardRedeemed = [];
  get isScratchCardRedeemed => this._isScratchCardRedeemed;
  set isScratchCardRedeemed(value) {
    this._isScratchCardRedeemed = value;
    notifyListeners();
  }

  bool _showConfetti = false;
  get showConfetti => this._showConfetti;
  set showConfetti(value) {
    this._showConfetti = value;
    notifyListeners();
  }

  bool _showRewardLottie = false;

  get showRewardLottie => this._showRewardLottie;

  set showRewardLottie(value) {
    this._showRewardLottie = value;
    notifyListeners();
  }

  double _cardScale = 0.8;
  double get cardScale => this._cardScale;

  set cardScale(double value) {
    this._cardScale = value;
    notifyListeners();
  }

  final ScratchCardService _scService = locator<ScratchCardService>();
  final ScratchCardRepository _scRepo = locator<ScratchCardRepository>();
  final UserService _userService = locator<UserService>();
  final UserCoinService _userCoinService = locator<UserCoinService>();
  final JourneyService _journeyService = locator<JourneyService>();
  final CustomLogger _logger = locator<CustomLogger>();
  final S locale = locator<S>();

  init() {
    //Clearing global variable every time this screen comes in view so that no old data is represented
    //Initializing view required variables
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      showRewardLottie = true;
    });
    pageController = PageController(viewportFraction: 0.65);
    pageController!.addListener(_pageListener);
    pageNotifier = ValueNotifier(0.0);
    //Assigning items to the local variable of this viewModel
    scratchCardIdsList = ScratchCardService.scratchCardsList;
    //Creating an List of equal length of items and assigning every item as an empty scratch card to avoid null errors
    scratchCardList = List.generate(ScratchCardService.scratchCardsList!.length,
        (index) => ScratchCard.none());
    isScratchCardRedeemed = List.generate(
        ScratchCardService.scratchCardsList!.length, (i) => false);
    currentTokens = _userCoinService.flcBalance ?? 0;
    _generateKeysForTickets();
    _performPreScratchProcessing(0).then((value) {
      // ScratchCardService.scratchCardsList?.clear();
      showRewardLottie = false;
      Future.delayed(Duration(milliseconds: 50), () {
        cardScale = 1;
      });
      Future.delayed(Duration(seconds: 2), () {
        if (currentCardScratchPercentage == 0) showScratchGuideLabel = true;
      });
    });
  }

  void _pageListener() {
    print(pageController!.page);
    pageNotifier!.value = pageController!.page!;
  }

  //Fetch the details of the current ticket and replaces the Empty scratchCard from the list with the actual details
  Future<void> _performPreScratchProcessing(int index) async {
    isCurrentScratchCardLoading = true;
    if (index == 0) {
      final res =
          await _scService.getScratchCardById(scratchCardIdsList![index]);
      if (res != null) scratchCardList[index] = res;
    }
    if (index + 1 < scratchCardIdsList!.length) {
      final res =
          await _scService.getScratchCardById(scratchCardIdsList![index + 1]);
      if (res != null) scratchCardList[index + 1] = res;
    }
    isCurrentScratchCardLoading = false;
  }

  //Checks if the current scratch card is the last in the list or not
  //if not then animates to next scratch card and call [_performPreScratchProcessing]
  Future<void> _performPostScratchProcessing(int index) async {
    if (index < scratchCardList.length - 1) {
      int nextPageIndex = index + 1;
      Future.delayed(Duration(milliseconds: 500), () {
        pageController!.animateToPage(nextPageIndex,
            duration: Duration(seconds: 1), curve: Curves.easeInCubic);
        _performPreScratchProcessing(nextPageIndex);
      });
    } else {
      log("Last scratch card, exiting view");
      AppState.isInstantGtViewInView = true;
      Future.delayed(Duration(seconds: 2), () {
        AppState.isInstantGtViewInView = false;
        AppState.backButtonDispatcher!.didPopRoute();
      });
    }
  }

  //generates keys for all the scratchCards scratcher
  void _generateKeysForTickets() {
    for (int i = 0; i < scratchCardIdsList!.length; i++) {
      scratchStateKeys.add(GlobalKey<ScratcherState>());
    }
  }

  //Calls redeem api from [_scRepo] and on successful result
  //unblocks navigation
  //updates scratchCard count in win section
  //updates user fund wallet data
  //updates user coin wallet data
  //updates journeyRewards for tooltips with scratchCard
  Future<void> redeemScratchCard(int index) async {
    scratchStateKeys[index].currentState!.reveal();
    Haptic.vibrate();
    AppState.blockNavigation();
    if (scratchCardList[index].isRewarding ?? false) showConfetti = true;
    isScratchCardRedeemed[index] = true;
    Future.delayed(Duration(seconds: 2), () => showConfetti = false);
    try {
      _scRepo.redeemReward(scratchCardList[index].gtId).then(
        (_) {
          AppState.unblockNavigation();

          _scService.updateUnscratchedGTCount();
          _userService.getUserFundWalletData();
          _userCoinService.getUserCoinBalance().then(
            (_) {
              currentTokens = _userCoinService.flcBalance ?? 0;
              // notifyListeners();
            },
          );
        },
      );
      _performPostScratchProcessing(index);
      _journeyService.updateRewardStatus(scratchCardList[index].prizeSubtype!);
    } catch (e) {
      AppState.isInstantGtViewInView = false;
      _logger.e(e);

      BaseUtil.showNegativeAlert(
          locale.gtRedeemErrorTitle, locale.getRedeemErrorSubtitle);
    }
  }

  dump() {
    pageController?.dispose();
    pageNotifier?.dispose();
  }
}
