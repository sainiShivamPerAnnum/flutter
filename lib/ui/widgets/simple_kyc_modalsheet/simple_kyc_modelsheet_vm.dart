import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/model/signzy_pan/pan_verification_res_model.dart';
import 'package:felloapp/core/model/signzy_pan/signzy_login.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/https/http_ops.dart';
import 'package:felloapp/core/repository/user_repo.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/ui/dialogs/augmont_confirm_register_dialog.dart';
import 'package:felloapp/ui/dialogs/more_info_dialog.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/icici_api_util.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class SimpleKycModelsheetViewModel extends BaseModel {
  final _logger = locator<Logger>();
  final _userService = locator<UserService>();
  final _dbModel = locator<DBModel>();
  final _httpModel = locator<HttpModel>();
  final _baseUtil = locator<BaseUtil>();
  final _userRepo = locator<UserRepository>();

  final depositformKey3 = GlobalKey<FormState>();

  final TextEditingController panInput = TextEditingController();
  final TextEditingController panHolderNameInput = TextEditingController();

  bool _isKycInProgress = false;

  get isKycInProgress => _isKycInProgress;

  bool _preVerifyInputs() {
    RegExp panCheck = RegExp(r"[A-Z]{5}[0-9]{4}[A-Z]{1}");
    if (panInput.text.isEmpty) {
      BaseUtil.showNegativeAlert(
          'Invalid Pan', 'Kindly enter a valid PAN Number');
      return false;
    } else if (!panCheck.hasMatch(panInput.text) ||
        panInput.text.length != 10) {
      BaseUtil.showNegativeAlert(
          'Invalid Pan', 'Kindly enter a valid PAN Number');
      return false;
    } else if (panHolderNameInput.text.isEmpty) {
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

    _isKycInProgress = true;
    refresh();

    ///next get all details required for registration
    Map<String, dynamic> veriDetails =
        await _getVerifiedDetails(panInput.text, panHolderNameInput.text);
    if (veriDetails != null &&
        veriDetails['flag'] != null &&
        veriDetails['flag']) {
      AppState.screenStack.add(ScreenItem.dialog);

      ///show confirmation dialog to user
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => AugmontConfirmRegnDialog(
          panNumber: panInput.text,
          panName: panHolderNameInput.text,
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
                _baseUtil.userRegdPan != panInput.text) {
              _baseUtil.userRegdPan = panInput.text;
              _p =
                  await _baseUtil.panService.saveUserPan(_baseUtil.userRegdPan);
            }
            if (_baseUtil.myUser.isSimpleKycVerified == null ||
                !_baseUtil.myUser.isSimpleKycVerified) {
              _baseUtil.myUser.isSimpleKycVerified = true;
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

      _isKycInProgress = false;

      refresh();
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

    bool registeredFlag = await _httpModel.isPanRegistered(enteredPan);
    if (registeredFlag) {
      _flag = false;
      _failCode = 1;
      _reason =
          'This PAN number is already associated with a different account';
    }
    var kObj;
    if (_flag) {
      SignzyPanLogin _signzyPanLogin =
          await _dbModel.getActiveSignzyPanApiKey();

      try {
        ApiResponse<PanVerificationResModel> _response =
            await _httpModel.verifyPanSignzy(
                baseUrl: _signzyPanLogin.baseUrl,
                panNumber: enteredPan,
                panName: enteredPanName,
                authToken: _signzyPanLogin.accessToken,
                patronId: _signzyPanLogin.userId);

        _flag = _response.model.response.result.verified;

        if (_flag) {
          try {
            _userRepo.addKycName(
                userUid: _userService.baseUser.uid,
                upstreamKycName: _response.model.response.result.upstreamName);
          } catch (e) {
            _logger.e(e);
          }
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
      return {'flag': _flag, 'fail_code': _failCode, 'reason': _reason};
    }

    return {
      'flag': true,
      'pan_name': kObj[GetKycStatus.resName],
    };
  }
}
