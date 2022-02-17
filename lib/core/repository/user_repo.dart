import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/model/fundbalance_model.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/service/api.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/custom_logger.dart';

class UserRepository {
  final _logger = locator<CustomLogger>();
  final _api = locator<Api>();
  final _apiPaths = locator<ApiPath>();

//Stack overflow condition when we inject _userUid from user service.

  Future<ApiResponse<String>> getCustomUserToken(String mobileNo) async {
    try {
      final _body = {
        "mobileNumber": mobileNo,
      };
      final res = await APIService.instance.postData(_apiPaths.kCustomAuthToken,
          body: _body, isAuthTokenAvailable: false);
      return ApiResponse(model: res['token'], code: 200);
    } catch (e) {
      return ApiResponse.withError(
          "Unable to register user using truecaller", 400);
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> setNewUser(
      BaseUser baseUser, token) async {
    try {
      final String _bearer = token;

      final _body = {
        'uid': baseUser.uid,
        'data': {
          BaseUser.fldMobile: baseUser.mobile,
          BaseUser.fldName: baseUser.name,
          BaseUser.fldEmail: baseUser.email,
          BaseUser.fldIsEmailVerified: baseUser.isEmailVerified ?? false,
          BaseUser.fldDob: baseUser.dob,
          BaseUser.fldGender: baseUser.gender,
          BaseUser.fldUsername: baseUser.username,
          BaseUser.fldUserPrefs: {"tn": 1, "al": 0}
        }
      };

      final res = await APIService.instance
          .postData(_apiPaths.kAddNewUser, body: _body, token: _bearer);

      return ApiResponse(
          code: 200, model: {"flag": res['flag'], "gtId": res['gtId']});
    } catch (e) {
      ApiResponse.withError("User not added to firestore", 400);
    }
  }

  Future<ApiResponse> getFundBalance(
    String userUid,
  ) async {
    try {
      final DocumentSnapshot response = await _api.getUserFundBalance(userUid);
      _logger.d(response.data().toString());
      return ApiResponse(
          model: FundBalanceModel.fromMap(response.data()), code: 200);
    } catch (e) {
      _logger.e(e);
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<List<UserTransaction>>> getWinningHistory(
      String userUid) async {
    List<UserTransaction> _userPrizeTransactions = [];
    try {
      final QuerySnapshot _querySnapshot =
          await _api.getUserPrizeTransactionDocuments(userUid);

      if (_querySnapshot.docs.length != 0) {
        _querySnapshot.docs.forEach((element) {
          _userPrizeTransactions
              .add(UserTransaction.fromMap(element.data(), element.id));
        });
        _logger.d(
            "User prize transaction successfully fetched: ${_userPrizeTransactions.first.toJson().toString()}");
      } else {
        _logger.d("user prize transaction empty");
      }

      return ApiResponse(model: _userPrizeTransactions, code: 200);
    } catch (e) {
      _logger.e(e);
      throw e;
    }
  }

  Future<void> removeUserFCM(String userUid) async {
    try {
      await _api.deleteUserClientToken(userUid);
      _logger.d("Token successfully removed from firestore, on user signout.");
    } catch (e) {
      _logger.e(e);
      throw e;
    }
  }

  Future<void> addKycName({String userUid, String upstreamKycName}) async {
    try {
      Map<String, dynamic> _data = {'mKycName': upstreamKycName};
      await _api.addKycName(userUid, _data);
      _logger.d("Kyc name successfully added to firestore");
    } catch (e) {
      _logger.e(e);
      throw e;
    }
  }
}
