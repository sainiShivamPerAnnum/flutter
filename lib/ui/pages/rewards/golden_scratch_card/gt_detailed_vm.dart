import 'dart:developer';

import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/scratch_card_model.dart';
import 'package:felloapp/core/model/timestamp_model.dart';
import 'package:felloapp/core/repository/scratch_card_repo.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/core/service/notifier_services/scratch_card_service.dart';
import 'package:felloapp/core/service/notifier_services/user_coin_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/rewards/golden_scratch_card/gt_detailed_view.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/rsa_encryption.dart';
import 'package:felloapp/util/styles/size_config.dart';

class GTDetailedViewModel extends BaseViewModel {
  bool _viewScratcher = false;
  double _detailsModalHeight = 0;
  bool _viewScratchedCard = false;
  bool isCardScratched = false;
  bool _isShareLoading = false;
  final UserService? _userService = locator<UserService>();
  final UserCoinService? _userCoinService = locator<UserCoinService>();
  final ScratchCardService _gtService = locator<ScratchCardService>();
  final CustomLogger? _logger = locator<CustomLogger>();
  final ApiPath? _apiPaths = locator<ApiPath>();
  final JourneyService _journeyService = locator<JourneyService>();

  final _rsaEncryption = new RSAEncryption();
  final ScratchCardRepository? _gtRepo = locator<ScratchCardRepository>();

  get viewScratchedCard => this._viewScratchedCard;

  set viewScratchedCard(value) => this._viewScratchedCard = value;

  get viewScratcher => this._viewScratcher;

  set viewScratcher(value) => this._viewScratcher = value;

  get detailsModalHeight => this._detailsModalHeight;

  set detailsModalHeight(value) => this._detailsModalHeight = value;

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
      await _gtRepo!.redeemReward(ticket.gtId);
      _gtService.updateUnscratchedGTCount();
      _userService!.getUserFundWalletData();
      _userCoinService!.getUserCoinBalance();
      _journeyService.updateRewardStatus(ticket.prizeSubtype!);
      _gtService.refreshTickets(prizeSubtype: ticket.prizeSubtype!);
      return true;
    } catch (e) {
      _logger!.e(e);
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
    Future.delayed(Duration(seconds: 0), () {
      _viewScratcher = true;
      notifyListeners();
    });
  }

  Future<String> _getBearerToken() async {
    String token = await _userService!.firebaseUser!.getIdToken();
    _logger!.d(token);

    return token;
  }
}
