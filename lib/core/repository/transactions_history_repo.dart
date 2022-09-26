import 'dart:developer';

import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/transaction_response_model.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/flavor_config.dart';

class TransactionHistoryRepository extends BaseRepo {
  final _baseUrl = FlavorConfig.isDevelopment()
      ? 'https://wd7bvvu7le.execute-api.ap-south-1.amazonaws.com/dev'
      : 'https://yg58g0feo0.execute-api.ap-south-1.amazonaws.com/prod';

  // Future<ApiResponse<double>> getWithdrawableAugGoldQuantity() async {
  //   try {
  //     final token = await getBearerToken();
  //     final quntityResponse = await APIService.instance.getData(
  //       ApiPath.getWithdrawableGoldQuantity(
  //         this.userService.baseUser.uid,
  //       ),
  //       cBaseUrl: _baseUrl,
  //       token: token,
  //     );

  //     final quantity = quntityResponse["data"]["quantity"].toDouble();
  //     return ApiResponse(model: quantity, code: 200);
  //   } catch (e) {
  //     logger.e(e.toString());
  //     return ApiResponse.withError("Unable to fetch QUNTITY", 400);
  //   }
  // }

  Future<ApiResponse<TransactionResponse>> getUserTransactions({
    String start,
    String type,
    String subtype,
    String status,
  }) async {
    List<UserTransaction> events = [];
    try {
      final String _uid = userService.baseUser.uid;
      final _token = await getBearerToken();
      final _queryParams = {
        "type": type,
        "subtype": subtype,
        "start": start,
        "status": status
      };
      final response = await APIService.instance.getData(
        ApiPath.kSingleTransactions(_uid),
        token: _token,
        queryParams: _queryParams,
        cBaseUrl: _baseUrl,
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
          e?.toString() ?? "Unable to fetch transactions", 400);
    }
  }
}
