import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/scratch_card_model.dart';
import 'package:felloapp/core/repository/scratch_card_repo.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/core/service/notifier_services/marketing_event_handler_service.dart';
import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
import 'package:felloapp/core/service/notifier_services/user_coin_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/rewards/detailed_scratch_card/gt_detailed_view.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';

class GTInstantViewModel extends BaseViewModel {
  final UserService _userService = locator<UserService>();
  final UserCoinService _userCoinService = locator<UserCoinService>();
  final CustomLogger _logger = locator<CustomLogger>();
  final ApiPath _apiPaths = locator<ApiPath>();
  final ScratchCardService _gtService = locator<ScratchCardService>();

  // final PaytmService? _paytmService = locator<PaytmService>();
  final JourneyService _journeyService = locator<JourneyService>();
  final MarketingEventHandlerService _marketingEventHandlerService =
      locator<MarketingEventHandlerService>();

  // final _rsaEncryption =  RSAEncryption();
  S locale = locator<S>();
  final UserCoinService _coinService = locator<UserCoinService>();
  final ScratchCardRepository _gtRepo = locator<ScratchCardRepository>();
  AnimationController? lottieAnimationController;

  // double coinsPositionY = SizeConfig.viewInsets.top +
  //     SizeConfig.padding12 +
  //     SizeConfig.avatarRadius * 3;

  // double coinsPositionX =
  //     SizeConfig.screenWidth / 2 - SizeConfig.screenWidth / 8;
  double coinContentOpacity = 1;
  bool isCoinAnimationInProgress = false;
  bool isInvestmentAnimationInProgress = false;
  bool showMainContent = false;
  bool isAutosaveAlreadySetup = false;

  int? coinsCount = 0;
  double coinScale = 1;
  bool _isShimmerEnabled = false;
  ScratchCard? _scratchCard;
  double _buttonOpacity = 0;

  double get buttonOpacity => _buttonOpacity;

  set buttonOpacity(value) {
    _buttonOpacity = value;
    notifyListeners();
  }

  ScratchCard? get scratchCard => _scratchCard;

  set scratchCard(value) {
    _scratchCard = value;
    notifyListeners();
  }

  get isShimmerEnabled => _isShimmerEnabled;

  set isShimmerEnabled(value) {
    _isShimmerEnabled = value;
    notifyListeners();
  }

  bool _showScratchGuide = false;

  get showScratchGuide => _showScratchGuide;

  set showScratchGuide(value) {
    _showScratchGuide = value;
    notifyListeners();
  }

  bool _isCardScratchStarted = false;

  bool get isCardScratchStarted => _isCardScratchStarted;

  set isCardScratchStarted(bool value) {
    _isCardScratchStarted = value;
    notifyListeners();
  }

  bool _isCardScratched = false;

  get isCardScratched => _isCardScratched;

  set isCardScratched(value) {
    _isCardScratched = value;
    notifyListeners();
  }

  init() async {
    Haptic.vibrate();
    // isAutosaveAlreadySetup = _paytmService!.activeSubscription != null &&
    //     (_paytmService!.activeSubscription!.status ==
    //             Constants.SUBSCRIPTION_ACTIVE ||
    //         (_paytmService!.activeSubscription!.status ==
    //                 Constants.SUBSCRIPTION_INACTIVE &&
    //             _paytmService!.activeSubscription!.resumeDate != null &&
    //             _paytmService!.activeSubscription!.resumeDate!.isNotEmpty));
    scratchCard = ScratchCardService.currentGT;
    ScratchCardService.currentGT = null;

    Future.delayed(const Duration(seconds: 3), () {
      if (!isCardScratchStarted) {
        showScratchGuide = true;
      }
    });
  }

  // showAutosavePrompt() {
  //   _gtService!.showAutosavePrompt();
  // }

  Future<void> redeemTicket(bool showRatingDialog) async {
    scratchKey.currentState!.reveal();
    Haptic.vibrate();
    AppState.isInstantGtViewInView = true;
    buttonOpacity = 1.0;
    isCardScratched = true;

    try {
      _getBearerToken().then(
        (String token) => _gtRepo.redeemReward(scratchCard!.gtId).then(
          (_) {
            _gtService.updateUnscratchedGTCount();
            _userService.getUserFundWalletData();
            _userCoinService.getUserCoinBalance().then(
              (_) {
                coinsCount = _userCoinService.flcBalance;
                notifyListeners();
              },
            );

            // _journeyService.updateRewardSTooltips().then((_) {
            // });
          },
        ),
      );
      _journeyService.updateRewardStatus(scratchCard!.prizeSubtype!);
    } catch (e) {
      _logger.e(e);
      BaseUtil.showNegativeAlert(
          locale.gtRedeemErrorTitle, locale.getRedeemErrorSubtitle);
    }

    Future.delayed(const Duration(seconds: 3), () {
      AppState.isInstantGtViewInView = false;
      _marketingEventHandlerService.showModalsheet = true;
      AppState.backButtonDispatcher!.didPopRoute();
      if (showRatingDialog) BaseUtil.showFelloRatingSheet();
    });
  }

  Future<String> _getBearerToken() async {
    String token = await _userService.firebaseUser!.getIdToken();
    _logger.d(token);

    return token;
  }

  initNormalFlow() {
    Future.delayed(const Duration(milliseconds: 500), () {
      coinsCount = _coinService.flcBalance;
      showMainContent = true;
      notifyListeners();
    });
  }
}
