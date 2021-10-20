import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/service/api.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/locator.dart';
import 'package:logger/logger.dart';

class UserRepository {
  final _logger = locator<Logger>();
  final _api = locator<Api>();


//Stack overflow condition when we inject _userUid from user service.
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
