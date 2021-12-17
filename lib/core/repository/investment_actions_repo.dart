
import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/deposit_response_model.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/rsa_encryption.dart';
import 'package:logger/logger.dart';

class InvestmentActionsRepository {
  final _userService = locator<UserService>();
  final _apiPaths = locator<ApiPath>();
  final _logger = locator<Logger>();
  final _rsaEncryption = new RSAEncryption();

  Future<String> _getBearerToken() async {
    String token = await _userService.firebaseUser.getIdToken();
    _logger.d(token);

    return token;
  }

  Future<ApiResponse<String>> createTranId({String userUid}) async {
    Map<String, dynamic> _params = {
      'uid': userUid,
    };
    _logger.d("CreateTranID : $_params");

    try {
      final String _bearer = await _getBearerToken();
      final response = await APIService.instance.getData(
          _apiPaths.kCreateTranId,
          queryParams: _params,
          token: _bearer);

      _logger.d(response.toString());
      String _tranId = response['txnDocRefId'];

      return ApiResponse(model: _tranId, code: 200);
    } catch (e) {
      _logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<DepositResponseModel>> initiateUserDeposit(
      {String tranId,
      Map<String, dynamic> initAugMap,
      Map<String, dynamic> initRzpMap,
      double amount,
      String userUid}) async {
    Map<String, dynamic> _body = {
      'tran_doc_id': tranId,
      'user_id': userUid,
      'amount': amount,
      "aug_map": initAugMap,
      "rzp_map": initRzpMap
    };
    _logger.d("initiateUserDeposit:: Pre encryption: $_body");
    if (await _rsaEncryption.init()) {
      _body = _rsaEncryption.encryptRequestBody(_body);
      _logger.d("initiateUserDeposit:: Post encryption: ${_body.toString()}");
    } else {
      _logger.e("Encrypter initialization failed!! exiting method");
    }

    try {
      ///Add the authorisation bearer token
      final String _bearer = await _getBearerToken();

      final response = await APIService.instance
          .postData(_apiPaths.kDepositPending, body: _body, token: _bearer);

      _logger.d(response.toString());

      DepositResponseModel _investmentDepositModel =
          DepositResponseModel.fromMap(response);

      _logger.d("response from api: ${_investmentDepositModel.toString()}");

      return ApiResponse(model: _investmentDepositModel, code: 200);
    } catch (e) {
      _logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<DepositResponseModel>> completeUserDeposit({
    String txnId,
    double amount,
    Map<String, dynamic> rzpUpdates,
    Map<String, dynamic> submitGoldUpdates,
    String userUid,
    EnqueuedTaskDetails enqueuedTaskDetails,
  }) async {
    Map<String, dynamic> _body = {
      "user_id": userUid,
      "amount": amount,
      "rzp_map": rzpUpdates,
      "submit_gold_map": submitGoldUpdates,
      "tran_id": txnId,
      "enqueuedTaskDetails": enqueuedTaskDetails.toMap()
    };
    _logger.d("completeUserDeposit:: Pre encryption: $_body");
    if (await _rsaEncryption.init()) {
      _body = _rsaEncryption.encryptRequestBody(_body);
      _logger.d("completeUserDeposit:: Post encryption: ${_body.toString()}");
    } else {
      _logger.e("Encrypter initialization failed.");
    }
    try {
      final String _bearer = await _getBearerToken();
      final response = await APIService.instance
          .postData(_apiPaths.kDepositComplete, body: _body, token: _bearer);
      _logger.d(response.toString());
      DepositResponseModel _investmentDepositModel =
          DepositResponseModel.fromMap(response);
      return ApiResponse(model: _investmentDepositModel, code: 200);
    } catch (e) {
      _logger.e(e);
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<DepositResponseModel>> cancelUserDeposit({
    String txnId,
    String userUid,
    Map<String, dynamic> rzpMap,
    Map<String, dynamic> augMap,
    EnqueuedTaskDetails enqueuedTaskDetails,
  }) async {
    Map<String, dynamic> _body = {
      "user_id": userUid,
      "rzp_map": rzpMap,
      "aug_map": augMap,
      "tran_id": txnId,
      "enqueuedTaskDetails": enqueuedTaskDetails.toMap()
    };

    _logger.d("cancelUserDeposit:: Pre encryption: $_body");
    if (await _rsaEncryption.init()) {
      _body = _rsaEncryption.encryptRequestBody(_body);
      _logger.d("cancelUserDeposit:: Post encryption: ${_body.toString()}");
    } else {
      _logger.e("Encryption initialization failed.");
    }
    try {
      final String _bearer = await _getBearerToken();
      final response = await APIService.instance
          .postData(_apiPaths.kDepositCancelled, body: _body, token: _bearer);

      DepositResponseModel _investmentDepositModel =
          DepositResponseModel.fromMap(response);

      _logger.d(_investmentDepositModel.toString());

      return ApiResponse(model: _investmentDepositModel, code: 200);
    } catch (e) {
      _logger.e(e);
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<DepositResponseModel>> withdrawlComplete(
      {String tranDocId,
      double amount,
      String userUid,
      Map<String, dynamic> sellGoldMap}) async {
    Map<String, dynamic> _body = {
      "tran_doc_id": tranDocId,
      "user_id": userUid,
      "amount": amount,
      "sell_gold_map": sellGoldMap,
    };

    _logger.d("withdrawComplete:: Pre encryption: $_body");
    if (await _rsaEncryption.init()) {
      _body = _rsaEncryption.encryptRequestBody(_body);
      _logger.d("withdrawComplete:: Post encryption: ${_body.toString()}");
    } else {
      _logger.e("Encryption initialization failed.");
    }
    try {
      final String _bearer = await _getBearerToken();
      final response = await APIService.instance
          .postData(_apiPaths.kWithdrawlComplete, body: _body, token: _bearer);

      DepositResponseModel _investmentDepositModel =
          DepositResponseModel.fromMap(response);

      _logger.d(_investmentDepositModel.toString());

      return ApiResponse(model: _investmentDepositModel, code: 200);
    } catch (e) {
      _logger.e(e);
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<DepositResponseModel>> withdrawlCancelled(
      {String tranDocId,
      double amount,
      String userUid,
      Map<String, dynamic> augMap}) async {
    Map<String, dynamic> _body = {
      "tran_doc_id": tranDocId,
      "user_id": userUid,
      "amount": amount,
      "aug_map": augMap,
    };

    _logger.d("withdrawCancelled:: Pre encryption: $_body");
    if (await _rsaEncryption.init()) {
      _body = _rsaEncryption.encryptRequestBody(_body);
      _logger.d("withdrawCancelled:: Post encryption: ${_body.toString()}");
    } else {
      _logger.e("Encryption initialization failed.");
    }
    try {
      final String _bearer = await _getBearerToken();
      final response = await APIService.instance
          .postData(_apiPaths.kWithdrawlCancelled, body: _body, token: _bearer);

      DepositResponseModel _investmentDepositModel =
          DepositResponseModel.fromMap(response);

      _logger.d(_investmentDepositModel.toString());

      return ApiResponse(model: _investmentDepositModel, code: 200);
    } catch (e) {
      _logger.e(e);
      return ApiResponse.withError(e.toString(), 400);
    }
  }
}
