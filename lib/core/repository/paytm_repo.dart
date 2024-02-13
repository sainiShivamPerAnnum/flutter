// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/model/paytm_models/create_paytm_transaction_model.dart';
import 'package:felloapp/core/model/paytm_models/paytm_transaction_response_model.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/flavor_config.dart';

// ignore: constant_identifier_names
enum AppUse {
  PHONE_PE,
  GOOGLE_PAY,
  PAYTM;
}

extension UpiRenameExtension on String {
  AppUse formatUpiAppName() {
    switch (this) {
      case "Phonepe":
        return AppUse.PHONE_PE;
      case "Paytm":
        return AppUse.PAYTM;
      case "Google Pay":
        return AppUse.GOOGLE_PAY;
      default:
        return AppUse.PHONE_PE;
    }
  }

  AppUse? getAppUseByName() {
    switch (this) {
      case "PhonePe":
        return AppUse.PHONE_PE;
      case "Paytm":
        return AppUse.PAYTM;
      case "Google Pay":
        return AppUse.GOOGLE_PAY;
      default:
        return null;
    }
  }
}

class PaytmRepository extends BaseRepo {
  static const _payments = 'payments/';

  /// Payments microservice.
  final String _baseUrl = FlavorConfig.isProduction()
      ? "https://yg58g0feo0.execute-api.ap-south-1.amazonaws.com/prod"
      : "https://wd7bvvu7le.execute-api.ap-south-1.amazonaws.com/dev";

  Future<ApiResponse<CreatePaytmTransactionModel>> createTransaction(
      double? amount,
      Map<String, dynamic>? augMap,
      Map<String, dynamic>? lbMap,
      String? couponCode,
      bool? skipMl,
      String mid,
      InvestmentType investmentType,
      AppUse? appUse,
      bool? isAutoLeaseChecked,
      [Map<String, dynamic>? goldProMap,
      String? paymode]) async {
    try {
      final String? _uid = userService.baseUser!.uid;
      final Map<String, dynamic> _body = {
        "uid": _uid,
        "txnAmount": amount,
        "assetType": investmentType.name,
        "couponcode": couponCode ?? '',
        "skipMl": skipMl ?? false,
        if (paymode != null) 'paymode': paymode,
        if (isAutoLeaseChecked != null) 'autoRenewFlag': isAutoLeaseChecked
      };

      if (investmentType == InvestmentType.AUGGOLD99) _body["augMap"] = augMap;
      if (investmentType == InvestmentType.LENDBOXP2P) _body["lbMap"] = lbMap;

      logger.d("This is body: $_body");

      final Map<String, String> _header = {
        if (appUse != null) 'appUse': appUse.name,
        "mid": mid,
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
      return ApiResponse.withError(e.toString(), 400);
    }
  }
}
