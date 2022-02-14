import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/golden_ticket_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/service/golden_ticket_service.dart';
import 'package:felloapp/core/service/user_coin_service.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_scratch_card/gt_detailed_view.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/rsa_encryption.dart';
import 'package:flutter/services.dart';

class GTInstantViewModel extends BaseModel {
  final _userService = locator<UserService>();
  final _userCoinService = locator<UserCoinService>();
  final _logger = locator<CustomLogger>();
  final _apiPaths = locator<ApiPath>();
  final _gtService = locator<GoldenTicketService>();
  final _dbModel = locator<DBModel>();
  final _rsaEncryption = new RSAEncryption();

  bool _isShimmerEnabled = false;
  GoldenTicket _goldenTicket;
  double _buttonOpacity = 0;

  double get buttonOpacity => this._buttonOpacity;

  set buttonOpacity(value) {
    this._buttonOpacity = value;
    notifyListeners();
  }

  GoldenTicket get goldenTicket => this._goldenTicket;

  set goldenTicket(value) {
    this._goldenTicket = value;
    notifyListeners();
  }

  get isShimmerEnabled => this._isShimmerEnabled;

  set isShimmerEnabled(value) {
    this._isShimmerEnabled = value;
    notifyListeners();
  }

  bool _showScratchGuide = false;

  get showScratchGuide => this._showScratchGuide;

  set showScratchGuide(value) {
    this._showScratchGuide = value;
    notifyListeners();
  }

  bool _isCardScratchStarted = false;
  bool get isCardScratchStarted => this._isCardScratchStarted;

  set isCardScratchStarted(bool value) {
    this._isCardScratchStarted = value;
    notifyListeners();
  }

  bool _isCardScratched = false;

  get isCardScratched => this._isCardScratched;

  set isCardScratched(value) {
    this._isCardScratched = value;
    notifyListeners();
  }

  init() async {
    Haptic.vibrate();
    goldenTicket = GoldenTicketService.currentGT;
    GoldenTicketService.currentGT = null;
    Future.delayed(Duration(seconds: 6), () {
      if (!isCardScratchStarted) {
        showScratchGuide = true;
      }
    });
  }

  Future<void> redeemTicket() async {
    scratchKey.currentState.reveal();
    Haptic.vibrate();
    buttonOpacity = 1.0;
    isCardScratched = true;
    Map<String, dynamic> _body = {
      "uid": _userService.baseUser.uid,
      "gtId": goldenTicket.gtId
    };
    // _logger.d("initiateUserDeposit:: Pre encryption: $_body");
    // if (await _rsaEncryption.init()) {
    //   _body = _rsaEncryption.encryptRequestBody(_body);
    //   _logger.d("initiateUserDeposit:: Post encryption: ${_body.toString()}");
    // } else {
    //   _logger.e("Encrypter initialization failed!! exiting method");
    // }
    try {
      _getBearerToken().then((String token) => APIService.instance
              .postData(_apiPaths.kRedeemGtReward, token: token, body: _body)
              .then((value) {
            _userService.getUserFundWalletData();
            _userCoinService.getUserCoinBalance();
          }));
    } catch (e) {
      _logger.e(e);
      BaseUtil.showNegativeAlert(
          "An error occured while redeeming your golden ticket",
          "Please try again in your winnings section");
    }
  }

  Future<String> _getBearerToken() async {
    String token = await _userService.firebaseUser.getIdToken();
    _logger.d(token);

    return token;
  }
}
