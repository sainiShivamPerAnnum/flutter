import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/eligible_coupon_model.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';

class StatisticsRepository {
  final _logger = locator<CustomLogger>();
  final _userService = locator<UserService>();
  final _apiPaths = locator<ApiPath>();

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
      final _body = {"uid": uid, "couponcode": couponcode, "amt": amount};
      final res = await APIService.instance
          .postData(_apiPaths.kCreateSimpleUser, body: _body, token: _bearer);

      EligibleCouponResponseModel _reponseModel =
          EligibleCouponResponseModel.fromMap(res);

      return ApiResponse(model: _reponseModel, code: 200);
    } catch (e) {
      return ApiResponse.withError(e.toString(), 400);
    }
  }
}
