import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/coupon_card_model.dart';
import 'package:felloapp/core/model/eligible_coupon_model.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/rsa_encryption.dart';

class CouponRepository extends BaseRepo {
  final _logger = locator<CustomLogger>();
  final _rsaEncryption = new RSAEncryption();
  final String _baseUrl = FlavorConfig.isDevelopment()
      ? "https://z8gkfckos5.execute-api.ap-south-1.amazonaws.com/dev"
      : "https://mwl33qq6sd.execute-api.ap-south-1.amazonaws.com/prod";

  Future<ApiResponse<EligibleCouponResponseModel>> getEligibleCoupon({
    String uid,
    String couponcode,
    int amount,
  }) async {
    try {
      final String _bearer = await getBearerToken();
      Map<String, dynamic> _body = {
        "uid": uid,
        "couponCode": couponcode,
        "amt": amount
      };
      _logger.d("initiateUserDeposit:: Pre encryption: $_body");
      if (await _rsaEncryption.init()) {
        _body = _rsaEncryption.encryptRequestBody(_body);
        _logger.d("initiateUserDeposit:: Post encryption: ${_body.toString()}");
      } else {
        _logger.e("Encrypter initialization failed!! exiting method");
      }
      final res = await APIService.instance.postData(
        ApiPath.kFelloCoupons,
        body: _body,
        token: _bearer,
        cBaseUrl: _baseUrl,
      );
      EligibleCouponResponseModel _reponseModel =
          EligibleCouponResponseModel.fromMap(res["data"]);

      return ApiResponse(
          model: _reponseModel, code: 200, errorMessage: res["message"]);
    } catch (e) {
      _logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<List<CouponModel>>> getCoupons() async {
    try {
      final token = await getBearerToken();
      final couponResponse = await APIService.instance.getData(
        ApiPath.getCoupons,
        cBaseUrl: _baseUrl,
        token: token,
      );
      final List<CouponModel> coupons =
          CouponModel.helper.fromMapArray(couponResponse['data']);

      return ApiResponse<List<CouponModel>>(
          model: coupons, code: 200, errorMessage: couponResponse['message']);
    } catch (e) {
      return ApiResponse.withError(
        e?.toString() ?? "Unable to fetch coupons",
        400,
      );
    }
  }
}
