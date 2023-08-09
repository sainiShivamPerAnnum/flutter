import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/constants/cache_keys.dart';
import 'package:felloapp/core/enums/ttl.dart';
import 'package:felloapp/core/model/referral_details_model.dart';
import 'package:felloapp/core/model/referral_registered_user_model.dart';
import 'package:felloapp/core/model/referral_response_model.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/service/cache_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/flavor_config.dart';

import 'base_repo.dart';

class ReferralRepo extends BaseRepo {
  final _cacheService = CacheService();
  final _baseUrl = FlavorConfig.isDevelopment()
      ? "https://2k3cus82jj.execute-api.ap-south-1.amazonaws.com/dev"
      : "https://bt3lswjiw1.execute-api.ap-south-1.amazonaws.com/prod";

  Future<ApiResponse<ReferralResponse>> getReferralCode() async {
    try {

      final String bearer = await getBearerToken();

      return await _cacheService.cachedApi(
        CacheKeys.REFERRAL_CODE,
        TTL.ONE_DAY,
        () => APIService.instance.getData(
          ApiPath.getReferralCode(userService.baseUser!.uid),
          token: bearer,
          cBaseUrl: _baseUrl,
        ),
        (response) {
          return ApiResponse(
              model: ReferralResponse.fromJson(response), code: 200);
        },
      );
    } catch (e) {
      logger!.e('getReferralCode $e ${userService!.baseUser!.uid}');
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<String>> getUserIdByRefCode(String code) async {
    try {
      final String bearer = await getBearerToken();
      final response = await APIService.instance.getData(
        ApiPath.getUserIdByRefCode(code),
        token: bearer,
        cBaseUrl: _baseUrl,
      );

      final data = response['data'];
      return ApiResponse<String>(
        model: data['uid'],
        code: 200,
      );
    } catch (e) {
      logger!.e('getUserIdByRefCode $e');
      return ApiResponse.withError(e.toString() ?? 'Failed to get user', 400);
    }
  }

  Future<ApiResponse<List<ReferralDetail>>> getReferralHistory() async {
    // List<ReferralDetail> referralHistory = [];
    try {
      final String bearer = await getBearerToken();
      final response = await APIService.instance.getData(
        ApiPath.getReferralHistory(userService!.baseUser!.uid),
        token: bearer,
        cBaseUrl: _baseUrl,
      );

      final data = response['data'];
      logger!.d(data);

      return ApiResponse<List<ReferralDetail>>(
        model: ReferralDetail.helper.fromMapArray(data),
        code: 200,
      );
    } catch (e) {
      logger!.e('Referral History fetch error $e');
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<bool>> createReferral(
    String? userId,
    String? referee,
  ) async {
    try {
      final String bearer = await getBearerToken();

      final response = await APIService.instance.postData(
        ApiPath.createReferral,
        body: {
          'uid': userId,
          'rid': referee,
        },
        token: bearer,
        cBaseUrl: _baseUrl,
      );

      logger!.d(response);
      return ApiResponse(model: true, code: 200);
    } catch (e) {
      logger!.e(e);
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<RegisteredUser>> getRegisteredUsers(
      List<String> phoneNumbers,
      {bool forceRefresh = false}) async {
    try {
      final String bearer = await getBearerToken();

      if (forceRefresh) {
        await CacheService.invalidateByKey(
          CacheKeys.REFERRAL_REGISTERED_USERS,
        );
      }

      return await _cacheService.cachedApi(
        CacheKeys.REFERRAL_REGISTERED_USERS,
        TTL.ONE_DAY,
        () => APIService.instance.postData(
          ApiPath.getRegisteredUsers,
          body: {
            'phoneNumbers': phoneNumbers,
          },
          token: bearer,
          cBaseUrl: _baseUrl,
        ),
        (response) {
          return ApiResponse(
              model: RegisteredUser.fromJson(response), code: 200);
        },
      );
    } catch (e) {
      logger.e(e);
      return ApiResponse.withError(e.toString(), 400);
    }
  }
}

// class ReferralResponse {
//   final String code;
//   final String message;
//
//   ReferralResponse(this.code, this.message);
//
//   factory ReferralResponse.fromJson(Map<String, dynamic> data) =>
//       ReferralResponse(data['code'], data['referralMessage']);
// }
