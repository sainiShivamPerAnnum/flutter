import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/eligible_coupon_model.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/rsa_encryption.dart';

class CouponRepository {
  final _logger = locator<CustomLogger>();
  final _userService = locator<UserService>();
  final _apiPaths = locator<ApiPath>();
  final _rsaEncryption = new RSAEncryption();

  Future<String> _getBearerToken() async {
    try {
      String token = await _userService.firebaseUser.getIdToken();
      _logger.d(token);
      return token;
    } catch (e) {
      throw new Exception("Unable to fetch Bearer Token");
    }
  }

  Future<ApiResponse<EligibleCouponResponseModel>> getEligibleCoupon(
      {String uid, String couponcode, int amount}) async {
    try {
      final String _bearer = await _getBearerToken();
      Map<String, dynamic> _body = {
        "uid": uid,
        "couponcode": couponcode,
        "amt": amount
      };
      _logger.d("initiateUserDeposit:: Pre encryption: $_body");
      if (await _rsaEncryption.init()) {
        _body = _rsaEncryption.encryptRequestBody(_body);
        _logger.d("initiateUserDeposit:: Post encryption: ${_body.toString()}");
      } else {
        _logger.e("Encrypter initialization failed!! exiting method");
      }
      final res = await APIService.instance
          .postData(_apiPaths.kFelloCoupons, body: _body, token: _bearer);

      EligibleCouponResponseModel _reponseModel =
          EligibleCouponResponseModel.fromMap(res);

      return ApiResponse(model: _reponseModel, code: 200);
    } catch (e) {
      _logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }
}
