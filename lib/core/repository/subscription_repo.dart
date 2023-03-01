import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/subscription_models/subscription_model.dart';
import 'package:felloapp/core/model/subscription_models/subscription_transaction_model.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/service/subscription_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';

import 'base_repo.dart';

class SubscriptionRepo extends BaseRepo {
  final CustomLogger _logger = locator<CustomLogger>();
  String baseUrl = FlavorConfig.isProduction()
      ? ""
      : "https://2je5zoqtuc.execute-api.ap-south-1.amazonaws.com/dev";

  Future<ApiResponse<List<AutosaveTransactionModel>>> getAutosaveTransactions({
    required String? uid,
    String? lastDocument,
    int? limit,
  }) async {
    try {
      final String token = await getBearerToken();
      final res = await APIService.instance.getData(
        ApiPath.getTransaction(uid),
        cBaseUrl: baseUrl,
        queryParams: {
          "lastDocId": lastDocument,
          "limit": limit.toString(),
        },
        token: token,
      );
      final responseData = res['data'];
      logger!.d(responseData);
      final result = AutosaveTransactionModel.helper.fromMapArray(res['data']);

      return ApiResponse(model: result, code: 200);
    } catch (e) {
      logger!.e(e.toString());
      return ApiResponse.withError(e?.toString() ?? "Unable to get txns", 400);
    }
  }

  Future<ApiResponse<String>> createSubscription(
      {required String freq,
      required int amount,
      required String package,
      required String asset}) async {
    try {
      Map<String, dynamic> _body = {
        "amount": amount,
        "frequency": freq,
        "pspPackage": package,
        "asset": asset
      };

      final token = await getBearerToken();

      final response = await APIService.instance.postData(
        ApiPath.subscription(userService.baseUser!.uid!),
        body: _body,
        cBaseUrl: baseUrl,
        token: token,
      );

      if (response['data'] != null) {
        final responseData = response['data'];
        if (responseData["intent"] != null) {
          final responseIntent = responseData["intent"];
          if ((responseIntent["redirectUrl"] ?? '').isNotEmpty) {
            final responseRedirectUrl = responseIntent["redirectUrl"];
            return ApiResponse(model: responseRedirectUrl, code: 200);
          }
        }
      }
      return ApiResponse.withError('No redirect url found', 400);
    } catch (e) {
      _logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<SubscriptionModel>> getSubscription() async {
    try {
      final token = await getBearerToken();
      final response = await APIService.instance.getData(
        ApiPath.subscription(userService.baseUser!.uid!),
        cBaseUrl: baseUrl,
        token: token,
      );
      SubscriptionModel subscriptionModel =
          SubscriptionModel.fromMap(response['data']['subscription']);
      return ApiResponse(model: subscriptionModel, code: 200);
    } catch (e) {
      _logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<SubscriptionModel>> updateSubscription({
    required String freq,
    required int amount,
  }) async {
    try {
      Map<String, dynamic> _body = {
        "amount": amount,
        "frequency": freq,
      };

      final token = await getBearerToken();

      final response = await APIService.instance.putData(
        ApiPath.subscription(userService.baseUser!.uid!),
        body: _body,
        cBaseUrl: baseUrl,
        token: token,
      );

      SubscriptionModel subscriptionModel =
          SubscriptionModel.fromMap(response['data']['subscription']);
      return ApiResponse(model: subscriptionModel, code: 200);
    } catch (e) {
      _logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<SubscriptionModel>> pauseSubscription({
    required AutosavePauseOption option,
  }) async {
    try {
      Map<String, dynamic> _body = {
        "uid": userService.baseUser!.uid!,
        "frequency": option.name,
      };

      final token = await getBearerToken();

      final response = await APIService.instance.postData(
        ApiPath.pauseSubscription,
        body: _body,
        cBaseUrl: baseUrl,
        token: token,
      );

      SubscriptionModel subscriptionModel =
          SubscriptionModel.fromMap(response['data']);
      return ApiResponse(model: subscriptionModel, code: 200);
    } catch (e) {
      _logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<SubscriptionModel>> resumeSubscription() async {
    try {
      Map<String, dynamic> _body = {
        "uid": userService.baseUser!.uid!,
      };

      final token = await getBearerToken();

      final response = await APIService.instance.putData(
        ApiPath.subscription(userService.baseUser!.uid!),
        body: _body,
        cBaseUrl: baseUrl,
        token: token,
      );

      SubscriptionModel subscriptionModel =
          SubscriptionModel.fromMap(response['data']);
      return ApiResponse(model: subscriptionModel, code: 200);
    } catch (e) {
      _logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }
}
