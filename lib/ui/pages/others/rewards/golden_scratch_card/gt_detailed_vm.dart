import 'dart:developer';

import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/golden_ticket_model.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/service/notifier_services/golden_ticket_service.dart';
import 'package:felloapp/core/service/notifier_services/user_coin_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_scratch_card/gt_detailed_view.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_tickets/golden_tickets_vm.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/rsa_encryption.dart';
import 'package:felloapp/util/styles/size_config.dart';

import '../../../../../util/locator.dart';

class GTDetailedViewModel extends BaseModel {
  bool _viewScratcher = false;
  double _detailsModalHeight = 0;
  bool _bottompadding = true;
  bool _viewScratchedCard = false;
  bool isCardScratched = false;
  bool _isShareLoading = false;
  GoldenTicketService _gtService = new GoldenTicketService();
  final _userService = locator<UserService>();
  final _userCoinService = locator<UserCoinService>();
  final _logger = locator<CustomLogger>();
  final _apiPaths = locator<ApiPath>();

  final _rsaEncryption = new RSAEncryption();
  // bool _isTicketRedeemedSuccessfully = true;

  // get isTicketRedeemedSuccessfully => this._isTicketRedeemedSuccessfully;

  // set isTicketRedeemedSuccessfully(value) {
  //   this._isTicketRedeemedSuccessfully = value;
  //   notifyListeners();
  // }

  get viewScratchedCard => this._viewScratchedCard;

  set viewScratchedCard(value) => this._viewScratchedCard = value;

  get viewScratcher => this._viewScratcher;

  set viewScratcher(value) => this._viewScratcher = value;

  get detailsModalHeight => this._detailsModalHeight;

  set detailsModalHeight(value) => this._detailsModalHeight = value;

  get bottompadding => this._bottompadding;

  set bottompadding(value) => this._bottompadding = value;

  bool get isShareLoading => _isShareLoading;

  set isShareLoading(bool val) {
    _isShareLoading = val;
    notifyListeners();
  }

  // showDetailsModal(bool isRewarding) {
  //   _bottompadding = false;
  //   _detailsModalHeight = isRewarding
  //       ? SizeConfig.screenHeight * 0.5
  //       : SizeConfig.screenHeight * 0.2;
  //   notifyListeners();
  // }

  changeToUnlockedUI() {
    _bottompadding = false;
    _detailsModalHeight = SizeConfig.screenHeight * 0.5;
    isCardScratched = true;
    //isTicketRedeemedSuccessfully = true;
    _viewScratchedCard = true;
    notifyListeners();
  }

  redeemCard(GoldenTicket ticket) async {
    scratchKey.currentState.reveal();
    // showDetailsModal(ticket.isRewarding);
    isCardScratched = true;
    setState(ViewState.Busy);
    await redeemTicket(ticket);
    log(ticket.redeemedTimestamp.toString());
    setState(ViewState.Idle);
  }

  Future<bool> redeemTicket(GoldenTicket ticket) async {
    Map<String, dynamic> _body = {
      "uid": _userService.baseUser.uid,
      "gtId": ticket.gtId
    };
    _logger.d("initiateUserDeposit:: Pre encryption: $_body");
    if (await _rsaEncryption.init()) {
      _body = _rsaEncryption.encryptRequestBody(_body);
      _logger.d("initiateUserDeposit:: Post encryption: ${_body.toString()}");
    } else {
      _logger.e("Encrypter initialization failed!! exiting method");
    }
    try {
      final String _bearer = await _getBearerToken();
      final _apiResponse = await APIService.instance
          .postData(_apiPaths.kRedeemGtReward, token: _bearer, body: _body);
      _logger.d(_apiResponse.toString());
      _userService.getUserFundWalletData();
      _userCoinService.getUserCoinBalance();
      return true;
    } catch (e) {
      _logger.e(e);
      return false;
    }
  }

  init(GoldenTicket ticket) {
    if (ticket.redeemedTimestamp != null) {
      //Redeemed ticket
      changeToUnlockedUI();
    } else {
      if (ticket.isRewarding) {
        //ticket has some reward
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
    String token = await _userService.firebaseUser.getIdToken();
    _logger.d(token);

    return token;
  }

  // share(GoldenTicket ticket) async {
  //   isShareLoading = true;
  //   _gtService.shareGoldenTicket(ticket);
  //   Future.delayed(Duration(seconds: 2), () {
  //     isShareLoading = false;
  //   });
  // }
}
