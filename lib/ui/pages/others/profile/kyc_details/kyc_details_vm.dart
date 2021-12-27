import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/model/verify_pan_response_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/https/http_ops.dart';
import 'package:felloapp/core/repository/signzy_repo.dart';
import 'package:felloapp/core/repository/user_repo.dart';
import 'package:felloapp/core/service/mixpanel_service.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/dialogs/augmont_confirm_register_dialog.dart';
import 'package:felloapp/ui/dialogs/more_info_dialog.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/mixpanel_events.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class KYCDetailsViewModel extends BaseModel {
  String stateChosenValue;
  TextEditingController nameController, panController;
  bool inEditMode = true;
  bool isUpadtingKycDetails = false;
  final _logger = locator<Logger>();
  final _userService = locator<UserService>();
  final _dbModel = locator<DBModel>();
  final _httpModel = locator<HttpModel>();
  final _baseUtil = locator<BaseUtil>();
  final _userRepo = locator<UserRepository>();
  final _mixpanelService = locator<MixpanelService>();
  final _signzyRepository = locator<SignzyRepository>();

  FocusNode panFocusNode = FocusNode();
  TextInputType panTextInputType = TextInputType.name;

  final depositformKey3 = GlobalKey<FormState>();

  bool _isKycInProgress = false;

  get isKycInProgress => _isKycInProgress;

  set isKycInProgress(val) {
    this._isKycInProgress = val;
    notifyListeners();
  }

  init() {
    nameController = new TextEditingController();
    panController = new TextEditingController();
    checkForKycExistence();
  }

  checkForKeyboardChange(String val) {
    if (val.length >= 0 &&
        val.length < 5 &&
        panTextInputType != TextInputType.name) {
      panFocusNode.unfocus();
      panTextInputType = TextInputType.name;
      notifyListeners();
      Future.delayed(Duration(milliseconds: 100), () {
        panFocusNode.requestFocus();
      });
      return;
    }
    if (val.length >= 5 &&
        val.length < 9 &&
        panTextInputType != TextInputType.number) {
      print("I got called");
      panFocusNode.unfocus();
      panTextInputType = TextInputType.number;
      notifyListeners();
      Future.delayed(Duration(milliseconds: 100), () {
        panFocusNode.requestFocus();
      });
      return;
    }

    if (val.length >= 9 && panTextInputType != TextInputType.name) {
      panFocusNode.unfocus();
      panTextInputType = TextInputType.name;
      notifyListeners();
      Future.delayed(Duration(milliseconds: 100), () {
        panFocusNode.requestFocus();
      });
    }

    return;
  }

  checkForKycExistence() async {
    setState(ViewState.Busy);
    String pan = await _baseUtil.panService.getUserPan();
    if (_baseUtil.myUser.isSimpleKycVerified != null &&
        pan != null &&
        pan.isNotEmpty) {
      if (_baseUtil.myUser.isSimpleKycVerified) {
        panController.text = pan;
        nameController.text = _userService.baseUser.kycName;
        inEditMode = false;
      }
    }

    setState(ViewState.Idle);
  }

  bool _preVerifyInputs() {
    RegExp panCheck = RegExp(r"[A-Z]{5}[0-9]{4}[A-Z]{1}");
    if (panController.text.isEmpty) {
      BaseUtil.showNegativeAlert(
          'Invalid Pan', 'Kindly enter a valid PAN Number');
      return false;
    } else if (!panCheck.hasMatch(panController.text) ||
        panController.text.length != 10) {
      BaseUtil.showNegativeAlert(
          'Invalid Pan', 'Kindly enter a valid PAN Number');
      return false;
    } else if (nameController.text.isEmpty) {
      BaseUtil.showNegativeAlert(
          'Name missing', 'Kindly enter your name as per your pan card');
      return false;
    }
    return true;
  }

  void onSubmit(context) async {
    if (!_preVerifyInputs()) {
      return;
    }

    FocusScope.of(context).unfocus();

    isKycInProgress = true;

    ///next get all details required for registration
    Map<String, dynamic> veriDetails =
        await _getVerifiedDetails(panController.text, nameController.text);
    if (veriDetails != null &&
        veriDetails['flag'] != null &&
        veriDetails['flag']) {
      AppState.screenStack.add(ScreenItem.dialog);

      ///show confirmation dialog to user
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AugmontConfirmRegnDialog(
          panNumber: panController.text,
          panName: nameController.text,
          bankHolderName: "",
          bankBranchName: "",
          bankAccNo: "",
          bankIfsc: "",
          bankName: "",
          dialogColor: UiConstants.primaryColor,
          onAccept: () async {
            bool _p = true;
            bool _q = true;

            ///add the pan number
            if (_baseUtil.userRegdPan == null ||
                _baseUtil.userRegdPan.isEmpty ||
                _baseUtil.userRegdPan != panController.text) {
              _baseUtil.userRegdPan = panController.text;
              _p =
                  await _baseUtil.panService.saveUserPan(_baseUtil.userRegdPan);
            }
            if (_baseUtil.myUser.isSimpleKycVerified == null ||
                !_baseUtil.myUser.isSimpleKycVerified) {
              _baseUtil.myUser.isSimpleKycVerified = true;
              if (veriDetails['upstreamName'] != null &&
                  veriDetails['upstreamName'] != '') {
                _baseUtil.myUser.kycName = veriDetails['upstreamName'];
                _baseUtil.myUser.name = veriDetails['upstreamName'];
              }
              _baseUtil.setKycVerified(true);
              _q = await _dbModel.updateUser(_userService.baseUser);
            }
            if (!_p || !_q) {
              BaseUtil.showNegativeAlert('Verification Failed',
                  'Failed to verify at the moment. Please try again.');
              _isKycInProgress = false;
              refresh();
              return;
            } else {
              _mixpanelService.track(
                  eventName: MixpanelEvents.panVerified,
                  properties: {'userId': _userService.baseUser.uid});
              _userService.isSimpleKycVerified = true;
              _userService.setMyUserName(_userService.baseUser.name);
              BaseUtil.showPositiveAlert(
                  'Verification Successful', 'You are successfully verified!');
              _isKycInProgress = false;
              refresh();
              AppState.backButtonDispatcher.didPopRoute();
            }
          },
          onReject: () {
            BaseUtil.showNegativeAlert(
                'Registration Cancelled', 'Please try again');
            _isKycInProgress = false;
            refresh();
            return;
          },
        ),
      );
    } else {
      print('inside failed name');
      if (veriDetails['fail_code'] == 0)
        showDialog(
            context: context,
            builder: (BuildContext context) => MoreInfoDialog(
                  text: veriDetails['reason'],
                  imagePath: Assets.dummyPanCardShowNumber,
                  title: 'Invalid Details',
                ));
      else
        BaseUtil.showNegativeAlert(
            'Registration failed', veriDetails['reason'] ?? 'Please try again');

      isKycInProgress = false;

      return;
    }
  }

  Future<Map<String, dynamic>> _getVerifiedDetails(
      String enteredPan, String enteredPanName) async {
    if (enteredPan == null || enteredPan.isEmpty)
      return {'flag': false, 'reason': 'Invalid Details'};
    bool _flag = true;
    int _failCode = 0;
    String _reason = '';
    String upstreamName = '';

    bool registeredFlag = await _httpModel.isPanRegistered(enteredPan);
    if (registeredFlag) {
      _flag = false;
      _failCode = 1;
      _reason =
          'This PAN number is already associated with a different account';
    }

    if (_flag) {
      try {
        ApiResponse<VerifyPanResponseModel> _response = await _signzyRepository
            .verifyPan(panNumber: enteredPan, panName: enteredPanName);

        if (_response.code == 200) {
          _flag = true;
        } else {
          _flag = false;
        }

        if (!_flag) {
          _reason =
              'The name on your PAN card does not match with the entered name. Please try again.';
        } else {
          upstreamName = _response.model.upstreamName;
        }
      } catch (e) {
        _flag = false;
        _logger.e(e.toString());
        _reason =
            'The name on your PAN card does not match with the entered name. Please try again.';
      }
    }
    if (!_flag) {
      print('returning false flag');
      Map<String, dynamic> _data = {
        'flag': _flag,
        'fail_code': _failCode,
        'reason': _reason,
        'user_pan_name': enteredPanName,
        'user_pan_number': enteredPan,
        'upstream_name': upstreamName,
      };
      _dbModel.logFailure(
          _userService.baseUser.uid, FailType.UserKYCFlagFetchFailed, _data);
      return {'flag': _flag, 'fail_code': _failCode, 'reason': _reason};
    }

    return {
      'upstreamName': upstreamName,
      'flag': true,
    };
  }
}
