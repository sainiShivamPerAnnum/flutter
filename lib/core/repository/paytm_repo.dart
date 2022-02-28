import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/paytm_models/create_paytm_transaction_model.dart';
import 'package:felloapp/core/model/paytm_models/create_paytm_subscription_response_model.dart';
import 'package:felloapp/core/model/paytm_models/paytm_subscription_response_model.dart';
import 'package:felloapp/core/model/paytm_models/paytm_transaction_response_model.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:intl/intl.dart';

class PaytmRepository {
  final _logger = locator<CustomLogger>();
  final _userService = locator<UserService>();

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
          token: _token);

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
          queryParams: _queryParams);

      final _responseModel = TransactionResponseModel.fromMap(response);
      return ApiResponse<TransactionResponseModel>(
          model: _responseModel, code: 200);
    } catch (e) {
      _logger.e(e.toString());
      return ApiResponse.withError("Unable create transaction", 400);
    }
  }

  Future<ApiResponse<SubscriptionResponseModel>> getSubscriptionStatus(
      String subId) async {
    try {
      final String _uid = _userService.baseUser.uid;
      final _token = await _getBearerToken();
      final _queryParams = {"subId": subId, "uid": _uid};
      final response = await APIService.instance.getData(
          ApiPath().kCreatePaytmSubscription,
          token: _token,
          queryParams: _queryParams);

      final _responseModel = SubscriptionResponseModel.fromJson(response);
      return ApiResponse<SubscriptionResponseModel>(
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
        "subscriptionAmountType": "VARIABLE",
        "subscriptionFrequencyUnit": "DAY",
        // "subscriptionStartDate": DateFormat('dd-MM-YYY').format(DateTime.now()),
        "subscriptionGraceDays": 0,
        "subscriptionExpiryDate": "2030-12-31",
        "subscriptionMaxAmount": 2000,
        "txnAmount": {"value": 1, "currency": "INR"}
      };
      final _token = await _getBearerToken();
      _logger.d("This is body: $_body");
      final response = await APIService.instance.postData(
          ApiPath().kCreatePaytmSubscription,
          body: _body,
          token: _token);

      CreateSubscriptionResponseModel _responseModel =
          CreateSubscriptionResponseModel.fromMap(response);

      return ApiResponse<CreateSubscriptionResponseModel>(
          model: _responseModel, code: 200);
    } catch (e) {
      _logger.e(e.toString());
      return ApiResponse.withError("Unable create subscription", 400);
    }
  }
}
