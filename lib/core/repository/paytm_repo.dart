import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/paytm_models/create_paytm_transaction_model.dart';
import 'package:felloapp/core/model/paytm_models/create_paytm_subscription_response_model.dart';
import 'package:felloapp/core/model/paytm_models/paytm_transaction_response_model.dart';
import 'package:felloapp/core/model/paytm_models/validate_vpa_response_model.dart';
import 'package:felloapp/core/model/subscription_models/active_subscription_model.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaytmRepository {
  final _logger = locator<CustomLogger>();
  final _userService = locator<UserService>();
  String processText = "processing";

  Future<String> _getBearerToken() async {
    String token = await _userService.firebaseUser.getIdToken();
    _logger.d(token);
    return token;
  }

  Future<ApiResponse<CreatePaytmTransactionModel>> createPaytmTransaction(
      double amount, Map<String, dynamic> augMap, String couponCode) async {
    try {
      final String _uid = _userService.baseUser.uid;
      final Map<String, dynamic> _body = {
        "uid": _uid,
        "txnAmount": amount,
        "augMap": augMap,
        "couponcode": couponCode,
      };
      final _token = await _getBearerToken();
      _logger.d("This is body: $_body");
      final response = await APIService.instance.postData(
          ApiPath.kCreatePaytmTransaction,
          body: _body,
          token: _token,
          isAwsTxnUrl: true);

      CreatePaytmTransactionModel _responseModel =
          CreatePaytmTransactionModel.fromMap(response);

      return ApiResponse<CreatePaytmTransactionModel>(
          model: _responseModel, code: 200);
    } catch (e) {
      _logger.e(e.toString());
      return ApiResponse.withError("Unable create transaction", 400);
    }
  }

  Future<ApiResponse<TransactionResponseModel>> getTransactionStatus(
      String orderId) async {
    try {
      final String _uid = _userService.baseUser.uid;
      final _token = await _getBearerToken();
      final _queryParams = {"orderId": orderId, "uid": _uid};
      final response = await APIService.instance.getData(
          ApiPath.kCreatePaytmTransaction,
          token: _token,
          queryParams: _queryParams,
          isAwsTxnUrl: true);

      final _responseModel = TransactionResponseModel.fromMap(response);
      return ApiResponse<TransactionResponseModel>(
          model: _responseModel, code: 200);
    } catch (e) {
      _logger.e(e.toString());
      return ApiResponse.withError("Unable create transaction", 400);
    }
  }

  Future<ApiResponse<CreateSubscriptionResponseModel>>
      createPaytmSubscription() async {
    print(DateFormat('dd-MM-YYY').format(DateTime.now()));
    try {
      final String _uid = _userService.baseUser.uid;
      final Map<String, dynamic> _body = {
        "uid": _uid,
        "maxAmount": 5000,
        "amount": 0
      };
      //  final Map<String, dynamic> _body = {
      //   "uid": _uid,
      //   "maxAmount": 3000,
      //   "expiryDate": "2030-03-10",
      //   "amount": 1
      // };
      final _token = await _getBearerToken();
      _logger.d("This is body: $_body");
      final response = await APIService.instance.postData(
          ApiPath().kCreateSubscription,
          body: _body,
          token: _token,
          isAwsSubUrl: true);

      CreateSubscriptionResponseModel _responseModel =
          CreateSubscriptionResponseModel.fromMap(response);

      return ApiResponse<CreateSubscriptionResponseModel>(
          model: _responseModel, code: 200);
    } catch (e) {
      _logger.e(e.toString());
      return ApiResponse.withError("Unable create subscription", 400);
    }
  }

  Future<ApiResponse<ValidateVpaResponseModel>> validateVPA(
      CreateSubscriptionResponseModel subscriptionResponseModel,
      String vpa) async {
    try {
      final String _uid = _userService.baseUser.uid;
      final _token = await _getBearerToken();
      final _queryParams = {
        "uid": _uid,
        "vpa": vpa,
        "token": subscriptionResponseModel.data.temptoken,
      };
      final response = await APIService.instance.getData(
        ApiPath().kValidateVpa,
        token: _token,
        queryParams: _queryParams,
        isAwsSubUrl: true,
      );

      final _responseModel = ValidateVpaResponseModel.fromJson(response);
      return ApiResponse<ValidateVpaResponseModel>(
          model: _responseModel, code: 200);
    } catch (e) {
      _logger.e(e.toString());
      return ApiResponse.withError("Unable to validate VPA", 400);
    }
  }

  Future<ApiResponse<bool>> updateDailyAmount(
      {@required double amount, @required String freq}) async {
    try {
      final _token = await _getBearerToken();

      final _body = {
        'uid': _userService.baseUser.uid,
        'amount': amount,
        'freq': freq
      };
      final response = await APIService.instance.putData(
        ApiPath().kCreateSubscription,
        body: _body,
        token: _token,
        isAwsSubUrl: true,
      );
      if (response != null) {
        final Map responseData = response["data"];

        if (responseData["status"] != null &&
            responseData["status"] == Constants.SUBSCRIPTION_ACTIVE)
          return ApiResponse(model: true, code: 200);
        else
          return ApiResponse(model: false, code: 400);
      } else
        return ApiResponse(model: false, code: 400);
    } catch (e) {
      _logger.e(e.toString());
      return ApiResponse.withError("Unable to update daily amount", 400);
    }
  }

  Future<ApiResponse<bool>> pauseSubscription(String resumeDate) async {
    try {
      final _token = await _getBearerToken();

      final _body = {
        'uid': _userService.baseUser.uid,
        'resume': resumeDate,
      };
      _logger.d(_body);
      //  final _body = {
      //   'uid': _userService.baseUser.uid,
      //   'subId': subId,
      // };
      final response = await APIService.instance.postData(
        ApiPath().kPauseSubscription,
        body: _body,
        token: _token,
        isAwsSubUrl: true,
      );
      final Map responseData = response["data"];

      if (responseData["status"] != null && responseData["status"])
        return ApiResponse(model: true, code: 200);
      else
        return ApiResponse(model: false, code: 400);
    } catch (e) {
      _logger.e(e.toString());
      return ApiResponse.withError("Unable to pause subscription", 400);
    }
  }

  Future<ApiResponse<bool>> resumeSubscription() async {
    try {
      final _token = await _getBearerToken();

      final _body = {
        'uid': _userService.baseUser.uid,
      };
      //  final _body = {
      //   'uid': _userService.baseUser.uid,
      //   'subId': subId,
      // };
      final response = await APIService.instance.postData(
        ApiPath().kResumeSubscription,
        body: _body,
        token: _token,
        isAwsSubUrl: true,
      );

      final Map responseData = response["data"];

      if (responseData["status"] != null && responseData["status"])
        return ApiResponse(model: true, code: 200);
      else
        return ApiResponse(model: false, code: 400);
    } catch (e) {
      _logger.e(e.toString());
      return ApiResponse.withError("Unable to resume subscription", 400);
    }
  }

  Future<ApiResponse<bool>> processSubscription() async {
    try {
      final _token = await _getBearerToken();

      final _body = {
        'uid': _userService.baseUser.uid,
      };

      final response = await APIService.instance.postData(
        ApiPath().kProcessSubscription,
        body: _body,
        token: _token,
        isAwsSubUrl: true,
      );
      final Map<String, dynamic> responseData = response['data'];
      if (responseData['status'])
        return ApiResponse(model: true, code: 200);
      else
        return ApiResponse(model: false, code: 400);
    } catch (e) {
      _logger.e(e.toString());
      return ApiResponse.withError("Unable to resume subscription", 400);
    }
  }

  Future<ApiResponse<ActiveSubscriptionModel>> getActiveSubscription() async {
    try {
      final _token = await _getBearerToken();
      final _queryParams = {
        "uid": _userService.baseUser.uid,
      };
      final response = await APIService.instance.getData(
        ApiPath().kActiveSubscription,
        token: _token,
        queryParams: _queryParams,
        isAwsSubUrl: true,
      );
      _logger.d(response);
      final _responseData = response["data"];
      final _responseModel = ActiveSubscriptionModel.fromJson(_responseData);

      return ApiResponse<ActiveSubscriptionModel>(
          model: _responseModel, code: 200);
    } catch (e) {
      _logger.e(e.toString());
      return ApiResponse.withError("Unable to find active subscription", 400);
    }
  }

  Future<ApiResponse<String>> getNextDebitDate() async {
    try {
      final _token = await _getBearerToken();
      final _queryParams = {
        "uid": _userService.baseUser.uid,
      };
      final response = await APIService.instance.getData(
        ApiPath().kNextDebitDate,
        token: _token,
        queryParams: _queryParams,
        isAwsSubUrl: true,
      );

      final _responseStatus = response["data"];
      _logger.d(response);
      if (_responseStatus["status"] != null &&
          _responseStatus["status"] == true)
        return ApiResponse<String>(model: response["message"], code: 200);
      else
        return ApiResponse.withError("Unable to find active subscription", 400);
    } catch (e) {
      _logger.e(e.toString());
      return ApiResponse.withError("Unable to find active subscription", 400);
    }
  }
}
