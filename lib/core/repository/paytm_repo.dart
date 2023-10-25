// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/model/paytm_models/create_paytm_subscription_response_model.dart';
import 'package:felloapp/core/model/paytm_models/create_paytm_transaction_model.dart';
import 'package:felloapp/core/model/paytm_models/paytm_transaction_response_model.dart';
import 'package:felloapp/core/model/paytm_models/process_transaction_model.dart';
import 'package:felloapp/core/model/paytm_models/validate_vpa_response_model.dart';
import 'package:felloapp/core/model/subscription_models/active_subscription_model.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:intl/intl.dart';

// ignore: constant_identifier_names
enum AppUse { PHONE_PE, GOOGLE_PAY, PAYTM }

class PaytmRepository extends BaseRepo {
  String processText = "processing";

  static const _payments = 'payments/';
  static const _subscription = 'subscription';

  /// Payments microservice.
  final String _baseUrl = FlavorConfig.isProduction()
      ? "https://yg58g0feo0.execute-api.ap-south-1.amazonaws.com/prod"
      : "https://wd7bvvu7le.execute-api.ap-south-1.amazonaws.com/dev";

  /// Subscription microservice.
  final String _baseUrl2 = FlavorConfig.isProduction()
      ? "https://2z48o79cm5.execute-api.ap-south-1.amazonaws.com/prod"
      : "https://2je5zoqtuc.execute-api.ap-south-1.amazonaws.com/dev";

  Future<ApiResponse<CreatePaytmTransactionModel>> createTransaction(
    double? amount,
    Map<String, dynamic>? augMap,
    Map<String, dynamic>? lbMap,
    String? couponCode,
    bool? skipMl,
    String mid,
    InvestmentType investmentType,
    AppUse? appUse, [
    Map<String, dynamic>? goldProMap,
  ]) async {
    try {
      final String? _uid = userService.baseUser!.uid;
      final Map<String, dynamic> _body = {
        "uid": _uid,
        "txnAmount": amount,
        "assetType": investmentType.name,
        "couponcode": couponCode ?? '',
        "skipMl": skipMl ?? false
      };

      if (investmentType == InvestmentType.AUGGOLD99) _body["augMap"] = augMap;
      if (investmentType == InvestmentType.LENDBOXP2P) _body["lbMap"] = lbMap;

      logger.d("This is body: $_body");

      final Map<String, String> _header = {
        if (appUse != null) 'appUse': appUse.name,
        "mid": mid ?? '',
      };
      logger.d("This is header: $_header");

      if (goldProMap != null && goldProMap.isNotEmpty) {
        _body.addAll(goldProMap);
      }

      final response = await APIService.instance.postData(
        ApiPath.kCreatePaytmTransaction,
        body: _body,
        cBaseUrl: _baseUrl,
        headers: _header,
        // decryptData: true,
        apiName: '$_payments/createTransaction',
      );

      CreatePaytmTransactionModel _responseModel =
          CreatePaytmTransactionModel.fromMap(response);

      return ApiResponse<CreatePaytmTransactionModel>(
          model: _responseModel, code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<ProcessTransactionModel>> processPaytmTransaction({
    String? tempToken,
    String? osType,
    String? pspApp,
    String? orderId,
    String? paymentMode,
  }) async {
    try {
      final Map<String, dynamic> _body = {
        "tempToken": tempToken,
        "osType": osType,
        "pspApp": pspApp,
        "orderId": orderId,
        "paymentMode": paymentMode
      };

      logger.d("This is body: $_body");
      final response = await APIService.instance.postData(
        ApiPath.kProcessPaytmTransaction,
        body: _body,
        cBaseUrl: _baseUrl,
        apiName: '$_payments/processTransaction',
      );

      ProcessTransactionModel _responseModel =
          ProcessTransactionModel.fromJson(response);

      print(_responseModel.data!.body!.deepLinkInfo);
      return ApiResponse<ProcessTransactionModel>(
          model: _responseModel, code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(
          e.toString() ?? "Unable create transaction", 400);
    }
  }

  Future<ApiResponse<TransactionResponseModel>> getTransactionStatus(
    String? orderId,
  ) async {
    try {
      final String? _uid = userService.baseUser!.uid;
      final _queryParams = {
        "orderId": orderId,
        "uid": _uid,
        "isOldLbUser":
            userService.userSegments.contains(Constants.US_FLO_OLD).toString()
      };

      final response = await APIService.instance.getData(
        ApiPath.kCreatePaytmTransaction,
        queryParams: _queryParams,
        cBaseUrl: _baseUrl,
        apiName: '$_payments/createTransaction',
      );
      final _responseModel = TransactionResponseModel.fromMap(response);

      return ApiResponse<TransactionResponseModel>(
          model: _responseModel, code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(
          e.toString() ?? "Unable to validate transaction", 400);
    }
  }

  Future<ApiResponse<CreateSubscriptionResponseModel>>
      createPaytmSubscription() async {
    print(DateFormat('dd-MM-YYY').format(DateTime.now()));
    try {
      final String? _uid = userService.baseUser!.uid;
      final Map<String, dynamic> _body = {
        "uid": _uid,
        "maxAmount": 5000,
        "amount": 0
      };

      logger.d("This is body: $_body");
      final response = await APIService.instance.postData(
        ApiPath().kCreateSubscription,
        body: _body,
        cBaseUrl: _baseUrl2,
        apiName: '$_payments/createSubscription',
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
      final String? _uid = userService.baseUser!.uid;
      final _queryParams = {
        "uid": _uid,
        "vpa": vpa,
        "token": subscriptionResponseModel.data!.temptoken,
      };
      final response = await APIService.instance.getData(
        ApiPath().kValidateVpa,
        queryParams: _queryParams,
        cBaseUrl: _baseUrl2,
        apiName: '$_subscription/validateVPAByID',
      );

      final _responseModel = ValidateVpaResponseModel.fromJson(response);
      return ApiResponse<ValidateVpaResponseModel>(
          model: _responseModel, code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(
          e.toString() ?? "Unable to validate VPA", 400);
    }
  }

  Future<ApiResponse<bool>> updateDailyAmount(
      {required double amount, required String freq}) async {
    try {
      final _body = {
        'uid': userService.baseUser!.uid,
        'amount': amount,
        'freq': freq
      };
      final response = await APIService.instance.putData(
        ApiPath().kCreateSubscription,
        body: _body,
        cBaseUrl: _baseUrl2,
        apiName: '$_payments/createSubscription',
      );
      if (response != null) {
        final Map responseData = response["data"];

        if (responseData["status"] != null &&
            responseData["status"] == Constants.SUBSCRIPTION_ACTIVE) {
          return ApiResponse(model: true, code: 200);
        } else {
          return ApiResponse(model: false, code: 400);
        }
      } else {
        return ApiResponse(model: false, code: 400);
      }
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(
          e.toString() ?? "Unable to update daily amount", 400);
    }
  }

  Future<ApiResponse<bool>> pauseSubscription(String resumeDate) async {
    try {
      final _body = {
        'uid': userService.baseUser!.uid,
        'resume': resumeDate,
      };
      logger.d(_body);
      final response = await APIService.instance.postData(
        ApiPath().kPauseSubscription,
        body: _body,
        cBaseUrl: _baseUrl2,
        apiName: '$_payments/pauseSubscription',
      );
      final Map responseData = response["data"];

      if (responseData["status"] != null && responseData["status"]) {
        return ApiResponse(model: true, code: 200);
      } else {
        return ApiResponse(model: false, code: 400);
      }
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(
          e.toString() ?? "Unable to pause subscription", 400);
    }
  }

  Future<ApiResponse<bool>> resumeSubscription() async {
    try {
      final _body = {
        'uid': userService.baseUser!.uid,
      };
      final response = await APIService.instance.postData(
        ApiPath().kResumeSubscription,
        body: _body,
        cBaseUrl: _baseUrl2,
        apiName: '$_payments/resumeSubscription',
      );

      final Map responseData = response["data"];

      if (responseData["status"] != null && responseData["status"]) {
        return ApiResponse(model: true, code: 200);
      } else {
        return ApiResponse(model: false, code: 400);
      }
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(
          e.toString() ?? "Unable to resume subscription", 400);
    }
  }

  Future<ApiResponse<bool>> processSubscription() async {
    try {
      final _body = {
        'uid': userService.baseUser!.uid,
      };

      final response = await APIService.instance.postData(
        ApiPath().kProcessSubscription,
        body: _body,
        cBaseUrl: _baseUrl2,
        apiName: '$_payments/processSubscription',
      );
      final Map<String, dynamic> responseData = response['data'];
      if (responseData['status']) {
        return ApiResponse(model: true, code: 200);
      } else {
        return ApiResponse(model: false, code: 400);
      }
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError("Unable to resume subscription", 400);
    }
  }

  Future<ApiResponse<ActiveSubscriptionModel>> getActiveSubscription() async {
    try {
      final _queryParams = {
        "uid": userService.baseUser!.uid,
      };
      final response = await APIService.instance.getData(
        ApiPath().kActiveSubscription,
        queryParams: _queryParams,
        cBaseUrl: _baseUrl2,
        apiName: '$_subscription/byID',
      );
      logger.d(response);
      final _responseData = response["data"];
      final _responseModel = ActiveSubscriptionModel.fromJson(_responseData);

      return ApiResponse<ActiveSubscriptionModel>(
          model: _responseModel, code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(
          e.toString() ?? "Unable to find active subscription", 400);
    }
  }

  Future<ApiResponse<String>> getNextDebitDate() async {
    try {
      final _queryParams = {
        "uid": userService.baseUser!.uid,
      };
      final response = await APIService.instance.getData(
        ApiPath().kNextDebitDate,
        queryParams: _queryParams,
        cBaseUrl: _baseUrl2,
        apiName: '$_subscription/debitDateById',
      );

      final _responseStatus = response["data"];
      logger.d(response);
      if (_responseStatus["status"] != null &&
          _responseStatus["status"] == true) {
        return ApiResponse<String>(model: response["message"], code: 200);
      } else {
        return ApiResponse.withError("Unable to find active subscription", 400);
      }
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(
          e.toString() ?? "Unable to find active subscription", 400);
    }
  }
}
