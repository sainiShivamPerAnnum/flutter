import 'dart:async';
import 'dart:developer';

import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/scratch_card_model.dart';
import 'package:felloapp/core/model/timestamp_model.dart';
import 'package:felloapp/core/repository/scratch_card_repo.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
import 'package:felloapp/core/service/notifier_services/user_coin_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/feature/tambola/src/services/tambola_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/rewards/detailed_scratch_card/gt_detailed_view.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';

class GTDetailedViewModel extends BaseViewModel {
  bool _viewScratcher = false;
  double _detailsModalHeight = 0;
  bool _viewScratchedCard = false;
  bool isCardScratched = false;
  bool _isShareLoading = false;
  final UserService _userService = locator<UserService>();
  final UserCoinService _userCoinService = locator<UserCoinService>();
  final ScratchCardService _gtService = locator<ScratchCardService>();
  final TambolaService _tambolaService = locator<TambolaService>();
  final CustomLogger _logger = locator<CustomLogger>();

  // final ApiPath _apiPaths = locator<ApiPath>();
  final JourneyService _journeyService = locator<JourneyService>();

  // final _rsaEncryption = RSAEncryption();
  final ScratchCardRepository _gtRepo = locator<ScratchCardRepository>();

  get viewScratchedCard => _viewScratchedCard;

  set viewScratchedCard(value) => _viewScratchedCard = value;

  get viewScratcher => _viewScratcher;

  set viewScratcher(value) => _viewScratcher = value;

  get detailsModalHeight => _detailsModalHeight;

  set detailsModalHeight(value) => _detailsModalHeight = value;

  bool get isShareLoading => _isShareLoading;

  set isShareLoading(bool val) {
    _isShareLoading = val;
    notifyListeners();
  }

  changeToUnlockedUI() {
    _detailsModalHeight = SizeConfig.screenHeight! * 0.5;
    isCardScratched = true;
    _viewScratchedCard = true;
    notifyListeners();
  }

  redeemCard(ScratchCard ticket) async {
    scratchKey.currentState!.reveal();
    // showDetailsModal(ticket.isRewarding);
    isCardScratched = true;
    setState(ViewState.Busy);
    AppState.blockNavigation();
    await redeemTicket(ticket);
    AppState.unblockNavigation();
    log(ticket.redeemedTimestamp.toString());
    setState(ViewState.Idle);
  }

  Future<bool> redeemTicket(ScratchCard ticket) async {
    try {
      final res = await _gtRepo.redeemReward(ticket.gtId);
      _gtService.refreshTickets(gtId: ticket.gtId!);
      if (res.isSuccess()) {
        unawaited(_gtService.updateUnscratchedGTCount());
        unawaited(_userService.getUserFundWalletData());
        unawaited(_userCoinService.getUserCoinBalance());
        unawaited(_tambolaService.refreshTickets());
        _journeyService.updateRewardStatus(ticket.prizeSubtype!);
        return true;
      }
      return false;
    } catch (e) {
      _logger.e(e);
      return false;
    }
  }

  init(ScratchCard ticket) {
    if (ticket.redeemedTimestamp != null &&
        ticket.redeemedTimestamp !=
            TimestampModel(seconds: 0, nanoseconds: 0)) {
      //Redeemed ticket
      changeToUnlockedUI();
    } else {
      if (ticket.isRewarding!) {
      } else {
        //Pity ticket
      }
    }
    Future.delayed(const Duration(seconds: 0), () {
      _viewScratcher = true;
      notifyListeners();
    });
  }

  Future<String> _getBearerToken() async {
    String token = await _userService.firebaseUser!.getIdToken();
    _logger.d(token);

    return token;
  }
}
