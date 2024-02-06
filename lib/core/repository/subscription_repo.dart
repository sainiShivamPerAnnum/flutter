import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/subscription_models/all_subscription_model.dart';
import 'package:felloapp/core/model/subscription_models/create_subs_response.dart';
import 'package:felloapp/core/model/subscription_models/subscription_model.dart';
import 'package:felloapp/core/model/subscription_models/subscription_status_response.dart';
import 'package:felloapp/core/model/subscription_models/subscription_transaction_model.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
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
      return const ApiResponse(model: [], code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<CreateSubscriptionResponse>> createSubscription({
    required String freq,
    required num amount,
    required num lbAmt,
    required num augAmt,
    required String assetType, //TODO(@DK070202) enum if possible.
    String? package,
  }) async {
    try {
      Map<String, dynamic> body = {
        "amount": amount,
        "lbAmt": lbAmt,
        "augAmt": augAmt,
        "frequency": freq,
        "assetType": "UNI_FLEXI", //TODO(@DK070202): remove this.
        "pspPackage": 'com.phonepe.app.preprod', //TODO(@DK070202): remove this.
      };

      if (package != null && package.toLowerCase().contains('phonepe')) {
        final res = await getPhonepeVersionCode();
        if (res.isSuccess()) body["version"] = res.model;
      }

      final response = await APIService.instance.postData(
        ApiPath.createSubscription(userService.baseUser!.uid!),
        body: body,
        cBaseUrl: baseUrl,
        apiName: '$_subscription/createSubscription',
      );

      final res = CreateSubscriptionResponse.fromJson(
        response,
      );

      return ApiResponse(
        model: res,
        code: 200,
      );
    } catch (e) {
      _logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<SubscriptionStatusResponse>> getTransactionStatus(
    String id,
  ) async {
    final uid = locator<UserService>().baseUser!.uid!;

    try {
      final response = await APIService.instance.getData(
        ApiPath.getTransactionStatus(uid, id),
        cBaseUrl: baseUrl,
        apiName: '$_subscription/getTransactionStatus',
      );

      final res = SubscriptionStatusResponse.fromJson(
        response,
      );

      return ApiResponse<SubscriptionStatusResponse>(
        model: res,
        code: 200,
      );
    } catch (e) {
      _logger.e(e.toString());
      return ApiResponse.withError(
        e.toString(),
        400, // client error.
      );
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

  Future<ApiResponse<SubscriptionModel>> updateSubscription({
    required String freq,
    required String id,
    required int amount,
  }) async {
    try {
      Map<String, dynamic> body = {
        "amount": amount,
        "id": id,
        "frequency": freq,
      };

      final response = await APIService.instance.patchData(
        ApiPath.updateSubscription(userService.baseUser!.uid!),
        body: body,
        cBaseUrl: baseUrl,
        apiName: '$_subscription/updateSubscription',
      );

      SubscriptionModel subscriptionModel =
          SubscriptionModel.fromJson(response['data']['subscription']);
      return ApiResponse(model: subscriptionModel, code: 200);
    } catch (e) {
      _logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }

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
      return const ApiResponse.withError(
          "Unable to get PhonePe version code", 400);
    }
  }

  Future<ApiResponse<SubscriptionModel>> pauseSubscription({
    required AutosavePauseOption option,
    required String id,
  }) async {
    try {
      Map<String, dynamic> body = {
        "id": id,
        "frequency": option.name,
      };

      final response = await APIService.instance.postData(
        ApiPath.pauseSubscription,
        body: body,
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

  Future<ApiResponse<SubscriptionModel>> resumeSubscription(String id) async {
    try {
      Map<String, dynamic> body = {
        "id": id,
      };

      final response = await APIService.instance.postData(
        ApiPath.resumeSubscription,
        body: body,
        cBaseUrl: baseUrl,
        apiName: '$_subscription/resumeSubscription',
      );

      SubscriptionModel subscriptionModel =
          SubscriptionModel.fromJson(response['data']);
      return ApiResponse(model: subscriptionModel, code: 200);
    } catch (e) {
      _logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }
}
