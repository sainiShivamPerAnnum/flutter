import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/subscription_models/all_subscription_model.dart';
import 'package:felloapp/core/model/subscription_models/subscription_model.dart';
import 'package:felloapp/core/model/subscription_models/subscription_transaction_model.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/service/subscription_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'base_repo.dart';

class SubscriptionRepo extends BaseRepo {
  final CustomLogger _logger = locator<CustomLogger>();
  String baseUrl = FlavorConfig.isProduction()
      ? "https://2z48o79cm5.execute-api.ap-south-1.amazonaws.com/prod"
      : "https://2je5zoqtuc.execute-api.ap-south-1.amazonaws.com/dev";

  static const _subscription = 'subscription';

  Future<ApiResponse<List<SubscriptionTransactionModel>>>
      getSubscriptionTransactionHistory(
          {required String asset, int? offset, int? limit}) async {
    try {
      final res = await APIService.instance.getData(
        ApiPath.txnsSubscription(userService.baseUser!.uid!),
        cBaseUrl: baseUrl,
        queryParams: {
          "limit": limit.toString(),
          if (asset.isNotEmpty) "asset": asset,
          if (offset != null) ...{
            "offset": offset.toString(),
          }
        },
        apiName: '$_subscription/transactions',
      );
      final responseData = res['data']['transactions'];
      logger.d(responseData);
      if (responseData != null) {
        final result =
            SubscriptionTransactionModel.helper.fromMapArray(responseData);
        return ApiResponse(model: result, code: 200);
      }
      return ApiResponse(model: [], code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<String>> createSubscription({
    required String freq,
    required int amount,
    required int lbAmt,
    required int augAmt,
    required String package,
  }) async {
    try {
      Map<String, dynamic> _body = {
        "amount": amount,
        "lbAmt": lbAmt,
        "augAmt": augAmt,
        "frequency": freq,
        "pspPackage": package,
      };

      if (package.toLowerCase().contains('phonepe')) {
        final res = await getPhonepeVersionCode();
        if (res.isSuccess()) _body["version"] = res.model;
      }

      final response = await APIService.instance.postData(
        ApiPath.subscription,
        body: _body,
        cBaseUrl: baseUrl,
        apiName: '$_subscription/createSubscription',
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

  /// TODO: Rremove this api as there will be array of object in new api.
  ///
  Future<ApiResponse<AllSubscriptionModel>> getSubscription() async {
    try {
      final response = await APIService.instance.getData(
        ApiPath.subscription,
        cBaseUrl: baseUrl,
        apiName: _subscription,
      );
      AllSubscriptionModel subscriptionModel =
          AllSubscriptionModel.fromJson(response['data']);
      return ApiResponse(model: subscriptionModel, code: 200);
    } catch (e) {
      _logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  ///TODO(@Hirdesh2101)
  // Future<ApiResponse<SubscriptionModel>> updateSubscription({
  //   required String freq,
  //   required int lbAmt,
  //   required int augAmt,
  //   required int amount,
  // }) async {
  //   try {
  //     Map<String, dynamic> _body = {
  //       "amount": amount,
  //       "lbAmt": lbAmt,
  //       "augAmt": augAmt,
  //       "frequency": freq,
  //     };

  //     final response = await APIService.instance.patchData(
  //       ApiPath.subscription,
  //       body: _body,
  //       cBaseUrl: baseUrl,
  //       apiName: '$_subscription/updateSubscription',
  //     );

  //     SubscriptionModel subscriptionModel =
  //         SubscriptionModel.fromMap(response['data']['subscription']);
  //     return ApiResponse(model: subscriptionModel, code: 200);
  //   } catch (e) {
  //     _logger.e(e.toString());
  //     return ApiResponse.withError(e.toString(), 400);
  //   }
  // }

  Future<ApiResponse<int>> getPhonepeVersionCode() async {
    int version = 0;
    try {
      const platform = MethodChannel("methodChannel/upiIntent");
      final int result = await platform.invokeMethod('getPhonePeVersion');
      version = result;
      return ApiResponse(model: version, code: 200);
    } catch (e) {
      debugPrint(e.toString());
      version = 0;
      return ApiResponse.withError("Unable to get PhonePe version code", 400);
    }
  }

  Future<ApiResponse<SubscriptionModel>> pauseSubscription({
    required AutosavePauseOption option,
    required String id,
  }) async {
    try {
      Map<String, dynamic> _body = {
        "id": id,
        "frequency": option.name,
      };

      final response = await APIService.instance.postData(
        ApiPath.pauseSubscription,
        body: _body,
        cBaseUrl: baseUrl,
        apiName: '$_subscription/pauseSubscription',
      );

      SubscriptionModel subscriptionModel =
          SubscriptionModel.fromJson(response['data']);
      return ApiResponse(model: subscriptionModel, code: 200);
    } catch (e) {
      _logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  // Future<ApiResponse<SubscriptionModel>> resumeSubscription() async {
  //   try {
  //     Map<String, dynamic> _body = {
  //       "uid": userService.baseUser!.uid!,
  //     };

  //     final response = await APIService.instance.postData(
  //       ApiPath.resumeSubscription,
  //       body: _body,
  //       cBaseUrl: baseUrl,
  //       apiName: '$_subscription/resumeSubscription',
  //     );

  //     SubscriptionModel subscriptionModel =
  //         SubscriptionModel.fromJson(response['data']);
  //     return ApiResponse(model: subscriptionModel, code: 200);
  //   } catch (e) {
  //     _logger.e(e.toString());
  //     return ApiResponse.withError(e.toString(), 400);
  //   }
  // }
}
