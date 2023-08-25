import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/lendbox_maturity_response.dart';
import 'package:felloapp/core/model/lendbox_withdrawable_quantity.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/util/api_response.dart';

import '../../util/flavor_config.dart';

class LendboxRepo extends BaseRepo {
  final _baseUrl = FlavorConfig.isDevelopment()
      ? 'https://lczsbr3cjl.execute-api.ap-south-1.amazonaws.com/dev'
      : 'https://sdypt3fcnh.execute-api.ap-south-1.amazonaws.com/prod';

  Future<ApiResponse<String>> createWithdrawal(
    int amount,
    String? payoutSourceId,
  ) async {
    try {
      final uid = userService!.baseUser!.uid;
      final String bearer = await getBearerToken();

      final response = await APIService.instance.postData(
        ApiPath.createLbWithdrawal(uid),
        body: {
          "amount": amount,
          "payoutSourceId": payoutSourceId,
        },
        token: bearer,
        cBaseUrl: _baseUrl,
      );

      final data = response['data'];
      return ApiResponse(model: data['txnId'], code: 200);
    } catch (e) {
      logger!.e(e);
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<LendboxWithdrawableQuantity>>
      getWithdrawableQuantity() async {
    try {
      final uid = userService!.baseUser!.uid;
      final String bearer = await getBearerToken();

      final response = await APIService.instance.getData(
        ApiPath.lbWithdrawableQuantity(uid),
        token: bearer,
        cBaseUrl: _baseUrl,
      );

      final data = response['data'];
      return ApiResponse(
          model: LendboxWithdrawableQuantity.fromMap(data), code: 200);
    } catch (e) {
      logger!.e(e);
      BaseUtil.showNegativeAlert(
          e.toString(), "Please try again after sometime");
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<bool>> updateUserInvestmentPreference(
      String txnId, String pref,
      {bool hasConfirmed = false}) async {
    try {
      final uid = "ipGU7bH4asNlmO0aNypW" ?? userService.baseUser!.uid;
      final String bearer = await getBearerToken();
      final body = {
        "uid": uid,
        "txnId": txnId,
        "maturityPref": pref,
        "hasConfirmed": hasConfirmed,
      };
      final response = await APIService.instance.putData(
          ApiPath.investmentPrefs,
          token: bearer,
          cBaseUrl: _baseUrl,
          body: body);

      final data = response['data'];
      return ApiResponse(model: true, code: 200);
    } catch (e) {
      logger.e(e);
      // BaseUtil.showNegativeAlert(
      //     e.toString(), "Please try again after sometime");
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<LendboxMaturityResponse>> getLendboxMaturity() async {
    try {
      final uid = userService!.baseUser!.uid;
      final String bearer = await getBearerToken();

      final response = await APIService.instance.getData(
        ApiPath.lbMaturity(uid),
        token: bearer,
        cBaseUrl: _baseUrl,
      );

      // final data = response['data'];
      return ApiResponse(
          model: LendboxMaturityResponse.fromJson(response), code: 200);
    } catch (e) {
      logger!.e(e);
      BaseUtil.showNegativeAlert(
          e.toString(), "Please try again after sometime");
      return ApiResponse.withError(e.toString(), 400);
    }
  }
}
