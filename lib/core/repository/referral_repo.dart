import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/constants/cache_keys.dart';
import 'package:felloapp/core/enums/ttl.dart';
import 'package:felloapp/core/model/app_environment.dart';
import 'package:felloapp/core/model/referral_details_model.dart';
import 'package:felloapp/core/model/referral_registered_user_model.dart';
import 'package:felloapp/core/model/referral_response_model.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/service/cache_service.dart';
import 'package:felloapp/util/api_response.dart';

import 'base_repo.dart';

class ReferralRepo extends BaseRepo {
  final _cacheService = CacheService();

  static const _referral = 'referral';

  Future<ApiResponse<ReferralResponse>> getReferralCode() async {
    try {
      return await _cacheService.cachedApi(
        CacheKeys.REFERRAL_CODE,
        TTL.ONE_DAY,
        () => APIService.instance.getData(
          ApiPath.getReferralCode(userService.baseUser!.uid),
          cBaseUrl: AppEnvironment.instance.referral,
          apiName: '$_referral/getRefCode',
        ),
        (response) {
          return ApiResponse(
              model: ReferralResponse.fromJson(response), code: 200);
        },
      );
    } catch (e) {
      logger.e('getReferralCode $e ${userService.baseUser!.uid}');
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<String>> getUserIdByRefCode(String code) async {
    try {
      final response = await APIService.instance.getData(
        ApiPath.getUserIdByRefCode(code),
        cBaseUrl: AppEnvironment.instance.referral,
        apiName: '$_referral/getUserIDByRefCode',
      );

      final data = response['data'];
      return ApiResponse<String>(
        model: data['uid'],
        code: 200,
      );
    } catch (e) {
      logger.e('getUserIdByRefCode $e');
      return ApiResponse.withError(e.toString() ?? 'Failed to get user', 400);
    }
  }

  Future<ApiResponse<List<ReferralDetail>>> getReferralHistory(
      {int currentPage = 0}) async {
    // List<ReferralDetail> referralHistory = [];
    try {
      final response = await APIService.instance.getData(
        ApiPath.getReferralHistory(userService.baseUser!.uid),
        queryParams: {
          'offset': (50 * currentPage).toString(),
        },
        cBaseUrl: AppEnvironment.instance.referral,
        apiName: '$_referral/getAllReferrals',
      );

      final data = response['data'];
      logger.d(data);

      return ApiResponse<List<ReferralDetail>>(
        model: ReferralDetail.helper.fromMapArray(data),
        code: 200,
      );
    } catch (e) {
      logger.e('Referral History fetch error $e');
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<bool>> createReferral(
    String? userId,
    String? referee,
  ) async {
    try {
      final response = await APIService.instance.postData(
        ApiPath.createReferral,
        body: {
          'uid': userId,
          'rid': referee,
        },
        cBaseUrl: AppEnvironment.instance.referral,
        apiName: '$_referral/createReferral',
      );

      logger.d(response);
      return ApiResponse(model: true, code: 200);
    } catch (e) {
      logger.e(e);
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<RegisteredUser>> getRegisteredUsers(
      List<String> phoneNumbers,
      {bool forceRefresh = false}) async {
    try {
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
          cBaseUrl: AppEnvironment.instance.referral,
          apiName: '$_referral/getRegisteredUsers',
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
