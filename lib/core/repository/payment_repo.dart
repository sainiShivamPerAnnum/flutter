import 'package:felloapp/core/constants/apis_path_constants.dart';
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
  Future<ApiResponse<Map<String, dynamic>>>
      getWithdrawableAugGoldQuantity() async {
    try {
      String withdrawableQtyResponse = "";
      final token = await getBearerToken();
      final quantityResponse = await APIService.instance.getData(
        ApiPath.getWithdrawableGoldQuantity(
          this.userService.baseUser.uid,
        ),
        cBaseUrl: _baseUrl,
        token: token,
      );

      final quantity = quantityResponse["data"]["quantity"].toDouble();

      if (quantityResponse["data"]["lockedQuantity"] != null &&
          quantityResponse["data"]["lockedQuantity"] != 0)
        withdrawableQtyResponse = quantityResponse["message"];

      // if (quantityResponse["data"]["vpa"] != null &&
      //     quantityResponse["data"]["vpa"].toString().isNotEmpty) {
      //   // _userService.setMyUpiId(quantityResponse["data"]["vpa"]);
      //   _baseUtil.isUpiInfoMissing = false;
      // }

      return ApiResponse(
          model: {"quantity": quantity, "message": withdrawableQtyResponse},
          code: 200);
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError("Unable to fetch QUNTITY", 400);
    }
  }

  // Future<ApiResponse<bool>> validateUPI(String upiId) async {
  //   String message = "";
  //   try {
  //     final token = await getBearerToken();
  //     final Map<String, String> _body = {
  //       "uid": _userService.baseUser.uid,
  //       "vpa": upiId
  //     };
  //     final response = await APIService.instance.postData(
  //       ApiPath.validateVPA,
  //       body: _body,
  //       cBaseUrl: _baseUrl,
  //       token: token,
  //     );
  //     logger.d(response);
  //     message = response["message"];
  //     // if (message == "Vpa is valid") {
  //     _userService.setMyUpiId(upiId);
  //     _baseUtil.isUpiInfoMissing = false;
  //     return ApiResponse(model: true, code: 200, errorMessage: message);
  //     // } else
  //     // return ApiResponse(model: false, code: 400, errorMessage: message);
  //   } on BadRequestException catch (e) {
  //     return ApiResponse(model: false, code: 400, errorMessage: e.toString());
  //   } catch (e) {
  //     logger.e(e.toString());
  //     return ApiResponse.withError(e.toString() ?? message, 400);
  //   }
  // }

  // Future<ApiResponse<String>> getUserUpi() async {
  //   try {
  //     final token = await getBearerToken();
  //     final Map<String, String> _params = {"uid": _userService.baseUser.uid};
  //     final response = await APIService.instance.getData(
  //       ApiPath.vpa,
  //       queryParams: _params,
  //       cBaseUrl: _baseUrl,
  //       token: token,
  //     );
  //     final String vpa = response["data"]["vpa"];
  //     _userService.setMyUpiId(vpa);
  //     _baseUtil.isUpiInfoMissing = false;
  //     return ApiResponse(model: vpa, code: 200);
  //   } catch (e) {
  //     logger.e(e.toString());
  //     return ApiResponse.withError("Unable to fetch User Upi Id", 400);
  //   }
  // }
}
