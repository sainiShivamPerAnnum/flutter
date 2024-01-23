// ignore_for_file: equal_keys_in_map

import 'dart:developer';

import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/model/timestamp_model.dart';
import 'package:felloapp/core/model/transaction_response_model.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/flavor_config.dart';

class TransactionHistoryRepository extends BaseRepo {
  static const _transactions = 'transactions';

  final _baseUrl = FlavorConfig.isDevelopment()
      ? 'https://wd7bvvu7le.execute-api.ap-south-1.amazonaws.com/dev'
      : 'https://yg58g0feo0.execute-api.ap-south-1.amazonaws.com/prod';

  Future<ApiResponse<TransactionResponse>> getUserTransactions({
    int limit = 30,
    int? offset,
    String? type,
    String? subtype,
    String? status,
    String? lbFundType,
  }) async {
    List<UserTransaction> events = [];
    try {
      final String? uid = userService.baseUser!.uid;
      final queryParams = {
        "type": type,
        "subType": [
          subtype,
          if (subtype == InvestmentType.AUGGOLD99.name) 'AUGGOLD99_FD',
        ],
        "limit": limit.toString(),
        if (offset != null && offset != 0) ...{
          "offset": offset.toString(),
        },
        "status": status,
        if (lbFundType != null) "lbFundType": lbFundType
      };
      final response = await APIService.instance.getData(
        ApiPath.kSingleTransactions(uid),
        queryParams: queryParams,
        cBaseUrl: _baseUrl,
        apiName: '$_transactions/getTransactionByID',
      );

      final responseData = response["data"];
      log("Transactions data: $responseData");
      responseData["transactions"].forEach((e) {
        events.add(UserTransaction.fromMap(e, e["id"]));
      });

      final bool isLastPage = responseData["isLastPage"] ?? false;
      final TransactionResponse txnResponse =
          TransactionResponse(isLastPage: isLastPage, transactions: events);

      return ApiResponse<TransactionResponse>(model: txnResponse, code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(
          e.toString() ?? "Unable to fetch transactions", 400);
    }
  }

  Future<ApiResponse<TransactionResponse>> getPowerPlayUserTransactions({
    TimestampModel? startTime,
    String? type,
    TimestampModel? endTime,
    String? status,
    num? minAmount,
    num? maxAmount,
  }) async {
    List<UserTransaction> events = [];
    try {
      print(endTime!.toDate().toUtc().toIso8601String());
      print(startTime!.toDate().toUtc().toIso8601String());
      final String? uid = userService.baseUser!.uid;

      final queryParams = {
        "type": type,
        "status": status,
        "endTime": endTime.toDate().toUtc().toIso8601String(),
        "startTime": startTime.toDate().toUtc().toIso8601String(),
      };

      if (minAmount != null) {
        queryParams.putIfAbsent('minAmount', () => minAmount.toString());
      }

      if (maxAmount != null) {
        queryParams.putIfAbsent('maxAmount', () => maxAmount.toString());
      }

      final response = await APIService.instance.getData(
        ApiPath.kSingleTransactions(uid),
        queryParams: queryParams,
        cBaseUrl: _baseUrl,
        apiName: '$_transactions/getPaymentByID',
      );

      final responseData = response["data"];
      log("Transactions data: $responseData");
      responseData["transactions"].forEach((e) {
        events.add(UserTransaction.fromMap(e, e["id"]));
      });

      // final bool isLastPage = responseData["isLastPage"] ?? false;
      final TransactionResponse txnResponse =
          TransactionResponse(isLastPage: true, transactions: events);

      return ApiResponse<TransactionResponse>(model: txnResponse, code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(
          e.toString() ?? "Unable to fetch transactions", 400);
    }
  }
}
