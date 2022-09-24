import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/bank_account_details_model.dart';
import 'package:felloapp/core/model/withdrawable_gold_details_model.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/app_exceptions.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/base_util.dart';

class PaymentRepository extends BaseRepo {
  final _baseUrl = FlavorConfig.isDevelopment()
      ? 'https://wd7bvvu7le.execute-api.ap-south-1.amazonaws.com/dev'
      : 'https://yg58g0feo0.execute-api.ap-south-1.amazonaws.com/prod';

  final UserService _userService = locator<UserService>();
  final BaseUtil _baseUtil = locator<BaseUtil>();
  
  Future<ApiResponse<WithdrawableGoldResponseModel>>
      getWithdrawableAugGoldQuantity() async {
    try {
      String withdrawableQtyResponse = "";
      double balance = 0;
      double lockedQuantity = 0;
      double quantity = 0;
      final token = await getBearerToken();
      final quantityResponse = await APIService.instance.getData(
        ApiPath.getWithdrawableGoldQuantity(
          this.userService.baseUser.uid,
        ),
        cBaseUrl: _baseUrl,
        token: token,
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
      return ApiResponse.withError("Unable to fetch quantity", 400);
    }
  }

  Future<ApiResponse<bool>> addBankDetails(
      {String bankAccno, String bankHolderName, String bankIfsc}) async {
    String message = '';
    try {
      final token = await getBearerToken();
      final Map<String, String> _body = {
        "uid": userService.baseUser.uid,
        "name": bankHolderName,
        "ifsc": bankIfsc,
        "account": bankAccno
      };

      final response = await APIService.instance.postData(
        ApiPath().kAddBankAccount,
        body: _body,
        cBaseUrl: _baseUrl,
        token: token,
      );
      logger.d(response);

      return ApiResponse(
        model: true,
        code: 200,
        errorMessage: message,
      );
    } on BadRequestException catch (e) {
      return ApiResponse(
        model: false,
        code: 400,
        errorMessage: e.toString(),
      );
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(
        e.toString() ?? message,
        400,
      );
    }
  }

  Future<ApiResponse<BankAccountDetailsModel>>
      getActiveBankAccountDetails() async {
    try {
      final token = await getBearerToken();
      final response = await APIService.instance.getData(
        ApiPath.kGetBankAccountDetails(userService.baseUser.uid),
        cBaseUrl: _baseUrl,
        token: token,
      );
      final Map responseData = response["data"];
      BankAccountDetailsModel bankAccountDetails;
      if (responseData != null) {
        bankAccountDetails = BankAccountDetailsModel.fromMap(responseData);
      }

      return ApiResponse(model: bankAccountDetails, code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError("Unable to fetch User Upi Id", 400);
    }
  }
}
