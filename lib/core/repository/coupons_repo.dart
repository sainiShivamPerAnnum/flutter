import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/app_environment.dart';
import 'package:felloapp/core/model/coupon_card_model.dart';
import 'package:felloapp/core/model/eligible_coupon_model.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/rsa_encryption.dart';

class CouponRepository extends BaseRepo {
  final CustomLogger _logger = locator<CustomLogger>();
  final _rsaEncryption = RSAEncryption();

  static const _coupons = 'coupons';

  Future<ApiResponse<EligibleCouponResponseModel>> getEligibleCoupon(
      {required String assetType,
      String? uid,
      String? couponcode,
      int? amount}) async {
    try {
      Map<String, dynamic> body = {
        "uid": uid,
        "type": assetType,
        "couponCode": couponcode,
        "amt": amount,
      };
      _logger.d("initiateUserDeposit:: Pre encryption: $body");
      if (await _rsaEncryption.init()) {
        body = _rsaEncryption.encryptRequestBody(body);
        _logger.d("initiateUserDeposit:: Post encryption: ${body.toString()}");
      } else {
        _logger.e("Encrypter initialization failed!! exiting method");
      }
      final res = await APIService.instance.postData(
        ApiPath.kFelloCoupons,
        body: body,
        cBaseUrl: AppEnvironment.instance.coupons,
        apiName: '$_coupons/eligible',
      );
      EligibleCouponResponseModel reponseModel =
          EligibleCouponResponseModel.fromMap(res["data"]);

      return ApiResponse(
          model: reponseModel, code: 200, errorMessage: res["message"]);
    } catch (e) {
      _logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<List<CouponModel>>> getCoupons(
      {required String assetType}) async {
    try {
      final couponResponse = await APIService.instance.getData(
        ApiPath.getCoupons,
        cBaseUrl: AppEnvironment.instance.coupons,
        queryParams: {
          "type": assetType,
        },
        apiName: _coupons,
      );

      final List<CouponModel> coupons =
          CouponModel.helper.fromMapArray(couponResponse['data']);

      return ApiResponse<List<CouponModel>>(
          model: coupons, code: 200, errorMessage: couponResponse['message']);
    } catch (e) {
      return ApiResponse.withError(
        e.toString(),
        400,
      );
    }
  }
}
