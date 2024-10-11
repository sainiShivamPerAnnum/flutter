import 'dart:developer';

import 'package:felloapp/core/model/experts/experts_details.dart';
import 'package:felloapp/core/model/experts/experts_home.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/flavor_config.dart';

class ExpertsRepository extends BaseRepo {
  static const _experts = 'experts';

  final _baseUrl = FlavorConfig.isDevelopment()
      ? 'https://d65113af-eecb-4123-ba2b-16cd3f277974.mock.pstmn.io/expertsHome'
      : 'https://yg58g0feo0.execute-api.ap-south-1.amazonaws.com/prod';

  Future<ApiResponse<ExpertsHome>> getExpertsHomeData() async {
    try {
      final String? uid = userService.baseUser!.uid;

      final response = await APIService.instance.getData(
        '',
        cBaseUrl: _baseUrl,
        apiName: '$_experts/getExpertsHomeData',
      );
      // final responseData = response["data"];
      final responseData = response;
      log("Experts data: $responseData");
      return ApiResponse<ExpertsHome>(
        model: ExpertsHome.fromJson(responseData),
        code: 200,
      );
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }

  Future<ApiResponse<ExpertDetails>> getExperDetailsByID({
    required String advisorId,
  }) async {
    try {
      final String? uid = userService.baseUser!.uid;

      final response = await APIService.instance.getData(
        '',
        cBaseUrl: _baseUrl,
        apiName: '$_experts/getExperDetailsByID',
      );
      // final responseData = response["data"];
      final responseData = response;
      log("Experts data: $responseData");
      return ApiResponse<ExpertDetails>(
        model: ExpertDetails.fromJson(responseData),
        code: 200,
      );
    } catch (e) {
      logger.e(e.toString());
      return ApiResponse.withError(e.toString(), 400);
    }
  }
}
