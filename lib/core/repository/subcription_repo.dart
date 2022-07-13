import 'dart:developer';

import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/subscription_models/subscription_transaction_model.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/cupertino.dart';

import 'base_repo.dart';

class SubcriptionRepo extends BaseRepo {
  final _baseUrl = FlavorConfig.isDevelopment()
      ? "https://2je5zoqtuc.execute-api.ap-south-1.amazonaws.com/dev"
      : "";
  final _apiPaths = locator<ApiPath>();
  Future<ApiResponse<List<AutosaveTransactionModel>>> getAutosaveTransactions({
    @required String uid,
    String lastDocument,
    int limit,
  }) async {
    try {
      final res = await APIService.instance.getData(
        _apiPaths.getTransaction(uid),
        cBaseUrl: _baseUrl,
        queryParams: {
          "lastDocId": lastDocument,
          "limit": limit.toString(),
        },
      );

      final result = AutosaveTransactionModel.helper.fromMapArray(res['data']);

      return ApiResponse(model: result, code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError("Unable to get txns", 400);
    }
  }
}
