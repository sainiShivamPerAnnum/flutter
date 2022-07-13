import 'dart:developer';

import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/referral_details_model.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/preference_helper.dart';

import 'base_repo.dart';

class ReferralRepo extends BaseRepo {
  final _baseUrl = FlavorConfig.isDevelopment()
      ? "https://2k3cus82jj.execute-api.ap-south-1.amazonaws.com/dev"
      : "";

  Future<ApiResponse<String>> getReferralCode() async {
    try {
      final code = PreferenceHelper.getString(PreferenceHelper.REFERRAL_CODE);

      if (code != null && code != '') {
        return ApiResponse<String>(
          model: code,
          code: 200,
        );
      }

      final String bearer = await getBearerToken();
      final response = await APIService.instance.getData(
        ApiPath.getReferralCode(this.userService.baseUser.uid),
        token: bearer,
        cBaseUrl: _baseUrl,
      );

      final data = response['data']['code'];
      PreferenceHelper.setString(PreferenceHelper.REFERRAL_CODE, data);
      return ApiResponse<String>(
        model: data,
        code: 200,
      );
    } catch (e) {
      logger.e('getReferralCode $e ${this.userService.baseUser.uid}');
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
      logger.e('getUserIdByRefCode $e');
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<List<ReferralDetail>>> getReferralHistory() async {
    List<ReferralDetail> referralHistory = [];
    try {
      final String bearer = await getBearerToken();
      final response = await APIService.instance.getData(
        ApiPath.getReferralHistory(userService.baseUser.uid),
        token: bearer,
        cBaseUrl: _baseUrl,
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
}
