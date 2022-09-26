import 'dart:io';

import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/model/paytm_models/create_paytm_subscription_response_model.dart';
import 'package:felloapp/core/model/paytm_models/create_paytm_transaction_model.dart';
import 'package:felloapp/core/model/paytm_models/paytm_transaction_response_model.dart';
import 'package:felloapp/core/model/paytm_models/process_transaction_model.dart';
import 'package:felloapp/core/model/paytm_models/txn_result_model.dart';
import 'package:felloapp/core/model/paytm_models/validate_vpa_response_model.dart';
import 'package:felloapp/core/model/subscription_models/active_subscription_model.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaytmRepository extends BaseRepo {
  String processText = "processing";
  String _baseUrl = FlavorConfig.isProduction()
      ? "https://yg58g0feo0.execute-api.ap-south-1.amazonaws.com/prod"
      : "https://wd7bvvu7le.execute-api.ap-south-1.amazonaws.com/dev";

  Future<ApiResponse<CreatePaytmTransactionModel>> createTransaction(
    double amount,
    Map<String, dynamic> augMap,
    Map<String, dynamic> lbMap,
    String couponCode,
    bool skipMl,
    InvestmentType investmentType,
  ) async {
    try {
      final String _uid = userService.baseUser.uid;
      final Map<String, dynamic> _body = {
        "uid": _uid,
        "txnAmount": amount,
        "assetType": investmentType.name,
        "couponcode": couponCode ?? '',
        "skipMl": skipMl ?? false
      };

      if (investmentType == InvestmentType.AUGGOLD99) _body["augMap"] = augMap;
      if (investmentType == InvestmentType.LENDBOXP2P) _body["lbMap"] = lbMap;

      final _token = await getBearerToken();
      logger.d("This is body: $_body");

      final paymentMode = Platform.isAndroid
          ? BaseRemoteConfig.remoteConfig
              .getString(BaseRemoteConfig.ACTIVE_PG_ANDROID)
          : BaseRemoteConfig.remoteConfig
              .getString(BaseRemoteConfig.ACTIVE_PG_IOS);

      final response = await APIService.instance.postData(
        ApiPath.kCreatePaytmTransaction,
        body: _body,
        token: _token,
        cBaseUrl: _baseUrl,
        headers: {'pg-mode': paymentMode},
      );

      CreatePaytmTransactionModel _responseModel =
          CreatePaytmTransactionModel.fromMap(response);

      return ApiResponse<CreatePaytmTransactionModel>(
          model: _responseModel, code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(
          e?.toString() ?? "Unable to create transaction", 400);
    }
  }

  Future<ApiResponse<ProcessTransactionModel>> processPaytmTransaction({
    String tempToken,
    String osType,
    String pspApp,
    String orderId,
    String paymentMode,
  }) async {
    try {
      final Map<String, dynamic> _body = {
        "tempToken": tempToken,
        "osType": osType,
        "pspApp": pspApp,
        "orderId": orderId,
        "paymentMode": paymentMode
      };
      final _token = await getBearerToken();
      logger.d("This is body: $_body");
      final response = await APIService.instance.postData(
        ApiPath.kProcessPaytmTransaction,
        body: _body,
        token: _token,
        cBaseUrl: _baseUrl,
      );

      ProcessTransactionModel _responseModel =
          ProcessTransactionModel.fromJson(response);

      print(_responseModel.data.body.deepLinkInfo);
      return ApiResponse<ProcessTransactionModel>(
          model: _responseModel, code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(
          e?.toString() ?? "Unable create transaction", 400);
    }
  }

  Future<ApiResponse<TransactionResponseModel>> getTransactionStatus(
    String orderId,
  ) async {
    try {
      final String _uid = userService.baseUser.uid;
      final _token = await getBearerToken();
      final _queryParams = {"orderId": orderId, "uid": _uid};

      final response = await APIService.instance.getData(
        ApiPath.kCreatePaytmTransaction,
        token: _token,
        queryParams: _queryParams,
        cBaseUrl: _baseUrl,
      );
      final _responseModel = TransactionResponseModel.fromMap(response);
      logger.d(_responseModel);
      return ApiResponse<TransactionResponseModel>(
          model: _responseModel, code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(
          e?.toString() ?? "Unable to validate transaction", 400);
    }
  }

  Future<ApiResponse<CreateSubscriptionResponseModel>>
      createPaytmSubscription() async {
    print(DateFormat('dd-MM-YYY').format(DateTime.now()));
    try {
      final String _uid = userService.baseUser.uid;
      final Map<String, dynamic> _body = {
        "uid": _uid,
        "maxAmount": 5000,
        "amount": 0
      };
      final _token = await getBearerToken();
      logger.d("This is body: $_body");
      final response = await APIService.instance.postData(
        ApiPath().kCreateSubscription,
        body: _body,
        token: _token,
        cBaseUrl: _baseUrl,
      );

      CreateSubscriptionResponseModel _responseModel =
          CreateSubscriptionResponseModel.fromMap(response);

      return ApiResponse<CreateSubscriptionResponseModel>(
          model: _responseModel, code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(
          e.toString() ?? "Unable create subscription", 400);
    }
  }

  Future<ApiResponse<ValidateVpaResponseModel>> validateVPA(
      CreateSubscriptionResponseModel subscriptionResponseModel,
      String vpa) async {
    try {
      final String _uid = userService.baseUser.uid;
      final _token = await getBearerToken();
      final _queryParams = {
        "uid": _uid,
        "vpa": vpa,
        "token": subscriptionResponseModel.data.temptoken,
      };
      final response = await APIService.instance.getData(
        ApiPath().kValidateVpa,
        token: _token,
        queryParams: _queryParams,
        cBaseUrl: _baseUrl,
      );

      final _responseModel = ValidateVpaResponseModel.fromJson(response);
      return ApiResponse<ValidateVpaResponseModel>(
          model: _responseModel, code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(
          e?.toString() ?? "Unable to validate VPA", 400);
    }
  }

  // Future<ApiResponse> fetchTxnResultDetails(String orderId) async {
  //   try {
  //     final String _uid = userService.baseUser.uid;
  //     final _token = await getBearerToken();
  //     final _queryParams = {
  //       "orderId": orderId,
  //     };
  //     final response = await APIService.instance.getData(
  //       ApiPath.fecthLatestTxnDetails(_uid),
  //       token: _token,
  //       queryParams: _queryParams,
  //       cBaseUrl: _baseUrl,
  //     );

  //     final _responseModel = TxnResultModel.fromJson(response);
  //     return ApiResponse<TxnResultModel>(model: _responseModel, code: 200);
  //   } catch (e) {
  //     logger.e(e.toString());
  //     return ApiResponse.withError("Unable to fetch txn result", 400);
  //   }
  // }

  Future<ApiResponse<bool>> updateDailyAmount(
      {@required double amount, @required String freq}) async {
    try {
      final _token = await getBearerToken();

      final _body = {
        'uid': userService.baseUser.uid,
        'amount': amount,
        'freq': freq
      };
      final response = await APIService.instance.putData(
        ApiPath().kCreateSubscription,
        body: _body,
        token: _token,
        cBaseUrl: _baseUrl,
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
      logger.e(e.toString());
      return ApiResponse.withError(
          e?.toString() ?? "Unable to update daily amount", 400);
    }
  }

  Future<ApiResponse<bool>> pauseSubscription(String resumeDate) async {
    try {
      final _token = await getBearerToken();

      final _body = {
        'uid': userService.baseUser.uid,
        'resume': resumeDate,
      };
      logger.d(_body);
      final response = await APIService.instance.postData(
        ApiPath().kPauseSubscription,
        body: _body,
        token: _token,
        cBaseUrl: _baseUrl,
      );
      final Map responseData = response["data"];

      if (responseData["status"] != null && responseData["status"])
        return ApiResponse(model: true, code: 200);
      else
        return ApiResponse(model: false, code: 400);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(
          e?.toString() ?? "Unable to pause subscription", 400);
    }
  }

  Future<ApiResponse<bool>> resumeSubscription() async {
    try {
      final _token = await getBearerToken();

      final _body = {
        'uid': userService.baseUser.uid,
      };
      final response = await APIService.instance.postData(
        ApiPath().kResumeSubscription,
        body: _body,
        token: _token,
        cBaseUrl: _baseUrl,
      );

      final Map responseData = response["data"];

      if (responseData["status"] != null && responseData["status"])
        return ApiResponse(model: true, code: 200);
      else
        return ApiResponse(model: false, code: 400);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(
          e?.toString() ?? "Unable to resume subscription", 400);
    }
  }

  Future<ApiResponse<bool>> processSubscription() async {
    try {
      final _token = await getBearerToken();

      final _body = {
        'uid': userService.baseUser.uid,
      };

      final response = await APIService.instance.postData(
        ApiPath().kProcessSubscription,
        body: _body,
        token: _token,
        cBaseUrl: _baseUrl,
      );
      final Map<String, dynamic> responseData = response['data'];
      if (responseData['status'])
        return ApiResponse(model: true, code: 200);
      else
        return ApiResponse(model: false, code: 400);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError("Unable to resume subscription", 400);
    }
  }

  Future<ApiResponse<ActiveSubscriptionModel>> getActiveSubscription() async {
    try {
      final _token = await getBearerToken();
      final _queryParams = {
        "uid": userService.baseUser.uid,
      };
      final response = await APIService.instance.getData(
        ApiPath().kActiveSubscription,
        token: _token,
        queryParams: _queryParams,
        cBaseUrl: _baseUrl,
      );
      logger.d(response);
      final _responseData = response["data"];
      final _responseModel = ActiveSubscriptionModel.fromJson(_responseData);

      return ApiResponse<ActiveSubscriptionModel>(
          model: _responseModel, code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(
          e?.toString() ?? "Unable to find active subscription", 400);
    }
  }

  Future<ApiResponse<String>> getNextDebitDate() async {
    try {
      final _token = await getBearerToken();
      final _queryParams = {
        "uid": userService.baseUser.uid,
      };
      final response = await APIService.instance.getData(
        ApiPath().kNextDebitDate,
        token: _token,
        queryParams: _queryParams,
        cBaseUrl: _baseUrl,
      );

      final _responseStatus = response["data"];
      logger.d(response);
      if (_responseStatus["status"] != null &&
          _responseStatus["status"] == true)
        return ApiResponse<String>(model: response["message"], code: 200);
      else
        return ApiResponse.withError("Unable to find active subscription", 400);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(
          e?.toString() ?? "Unable to find active subscription", 400);
    }
  }
}
