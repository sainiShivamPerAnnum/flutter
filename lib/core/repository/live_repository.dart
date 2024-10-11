import 'dart:developer';

import 'package:felloapp/core/model/live/live_home.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/flavor_config.dart';

class LiveRepository extends BaseRepo {
  static const _live = 'live';

  final _baseUrl = FlavorConfig.isDevelopment()
      ? 'https://d65113af-eecb-4123-ba2b-16cd3f277974.mock.pstmn.io/liveHome'
      : 'https://yg58g0feo0.execute-api.ap-south-1.amazonaws.com/prod';

  Future<ApiResponse<LiveHome>> getLiveHomeData() async {
    try {
      final String? uid = userService.baseUser!.uid;

      final response = await APIService.instance.getData(
        '',
        cBaseUrl: _baseUrl,
        apiName: '$_live/getLiveHomeData',
      );
      // final responseData = response["data"];
      final responseData = response;
      log("Live data: $responseData");
      return ApiResponse<LiveHome>(
        model: LiveHome.fromJson(responseData),
        code: 200,
      );
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }
}
