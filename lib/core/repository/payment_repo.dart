import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/bank_account_details_model.dart';
import 'package:felloapp/core/model/gold_pro_models/gold_pro_investment_reponse_model.dart';
import 'package:felloapp/core/model/gold_pro_models/gold_pro_scheme_model.dart';
import 'package:felloapp/core/model/withdrawable_gold_details_model.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/app_exceptions.dart';
import 'package:felloapp/util/flavor_config.dart';

class PaymentRepository extends BaseRepo {
  static const _payments = 'payments';

  final _baseUrl = FlavorConfig.isDevelopment()
      ? 'https://wd7bvvu7le.execute-api.ap-south-1.amazonaws.com/dev'
      : 'https://yg58g0feo0.execute-api.ap-south-1.amazonaws.com/prod';

  Future<ApiResponse<WithdrawableGoldResponseModel>>
      getWithdrawableAugGoldQuantity() async {
    try {
      final quantityResponse = await APIService.instance.getData(
        ApiPath.getWithdrawableGoldQuantity(
          userService.baseUser!.uid,
        ),
        cBaseUrl: _baseUrl,
        apiName: '$_payments/withdrawableByID',
      );
      WithdrawableGoldResponseModel responseModel =
          WithdrawableGoldResponseModel.fromMap(quantityResponse);

      return ApiResponse(model: responseModel, code: 200);
    } on BadRequestException catch (e) {
      logger.e(e.toString());
      BaseUtil.showNegativeAlert(
          e.toString() ?? "Unable to fetch gold details", "Please try again");
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(
          e.toString() ?? "Unable to fetch quantity", 400);
    }
    return ApiResponse();
  }

  Future<ApiResponse<BankAccountDetailsModel>> addBankDetails({
    String? bankAccNo,
    String? bankHolderName,
    String? bankIfsc,
    bool withNetBankingValidation = false,
  }) async {
    String message = '';

    final queryParameters = {
      'withNetBankingValidation': withNetBankingValidation,
    };

    try {
      final Map<String, String?> body = {
        "uid": userService.baseUser!.uid,
        "name": bankHolderName,
        "ifsc": bankIfsc,
        "account": bankAccNo
      };

      final response = await APIService.instance.postData(
        ApiPath.kAddBankAccount,
        body: body,
        cBaseUrl: _baseUrl,
        apiName: '$_payments/addBankDetails',
        queryParams: queryParameters,
      );

      final data = BankAccountDetailsModel.fromMap(response['data']);

      return ApiResponse<BankAccountDetailsModel>(
        model: data,
        code: 200,
        errorMessage: message,
      );
    } on BadRequestException catch (e) {
      return ApiResponse.withError(
        e.toString(),
        000, // doesn't make sense to define error code on client side.
      );
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(
        e.toString(),
        400,
      );
    }
  }

  Future<ApiResponse<BankAccountDetailsModel>> getActiveBankAccountDetails({
    bool withNetBankingValidation = false,
  }) async {
    final queryParameters = {
      'withNetBankingValidation': withNetBankingValidation,
    };

    try {
      final response = await APIService.instance.getData(
        ApiPath.kGetBankAccountDetails(userService.baseUser!.uid),
        cBaseUrl: _baseUrl,
        apiName: '$_payments/bankDetails',
        queryParams: queryParameters,
      );
      final Map? responseData = response["data"];

      final bankAccountDetails = BankAccountDetailsModel.fromMap(
        responseData as Map<String, dynamic>? ?? const {},
      );

      return ApiResponse(model: bankAccountDetails, code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError("Unable to fetch User Upi Id", 400);
    }
  }

  Future<ApiResponse<GoldProSchemeModel>> getGoldProScheme() async {
    try {
      final response = await APIService.instance.getData(
        ApiPath.goldProScheme,
        cBaseUrl: _baseUrl,
        apiName: '$_payments/scheme',
      );
      final responseData = response["data"]["scheme"];
      GoldProSchemeModel? goldProSchemeDetails;
      if (responseData != null) {
        goldProSchemeDetails =
            GoldProSchemeModel.fromMap(responseData as Map<String, dynamic>);
      }
      return ApiResponse(model: goldProSchemeDetails, code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<GoldProInvestmentResponseModel>> investInGoldPro(
      double leaseQty, String schemeId, bool isAutoLeaseChecked) async {
    try {
      final response = await APIService.instance.postData(
        ApiPath.Fd,
        cBaseUrl: _baseUrl,
        body: {
          "quantity": leaseQty,
          "schemeId": schemeId,
          "uid": userService.baseUser!.uid,
          "autoRenewFlag": isAutoLeaseChecked
        },
        apiName: '$_payments/fd',
      );
      final responseData = response["data"]["fd"];
      final subText = response['data']['subText'];
      GoldProInvestmentResponseModel? goldProInvestmentDetails;
      if (responseData != null) {
        goldProInvestmentDetails = GoldProInvestmentResponseModel.fromMap(
          responseData,
          subText: subText,
        );
      }

      return ApiResponse(model: goldProInvestmentDetails, code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<List<GoldProInvestmentResponseModel>>>
      getGoldProInvestments() async {
    try {
      final response = await APIService.instance.getData(
        ApiPath.getFds(userService.baseUser!.uid!),
        cBaseUrl: _baseUrl,
        apiName: '$_payments/getFDsByID',
      );
      final responseData = response["data"]["fds"];
      List<GoldProInvestmentResponseModel>? goldProInvestments;
      if (responseData != null) {
        goldProInvestments =
            GoldProInvestmentResponseModel.helper.fromMapArray(responseData);
      }

      return ApiResponse(model: goldProInvestments, code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<bool>> preCloseGoldProInvestment(String fdId) async {
    try {
      final response = await APIService.instance.putData(
        ApiPath.Fd,
        cBaseUrl: _baseUrl,
        body: {"fdId": fdId, "uid": userService.baseUser!.uid},
        apiName: '$_payments/fd',
      );

      return ApiResponse(model: true, code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }
}
