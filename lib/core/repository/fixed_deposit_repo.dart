import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/fixedDeposit/fd_deposit.dart';
import 'package:felloapp/core/model/fixedDeposit/fd_home.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';

import '../../util/custom_logger.dart';

class FdRepository extends BaseRepo {
  final CustomLogger _logger = locator<CustomLogger>();
  final String _baseUrl = FlavorConfig.isDevelopment()
      ? "https://2fb48b39-dc60-4458-8004-8dcfb41d5ab6.mock.pstmn.io"
      : "https://sdypt3fcnh.execute-api.ap-south-1.amazonaws.com/prod";

  static const _fd = 'fd';

  Future<ApiResponse<List<AllFdsData>>> getAllFdsData() async {
    try {
      final response = await APIService.instance.getData(
        ApiPath.fdHome,
        cBaseUrl: _baseUrl,
        apiName: '$_fd/getAllFdsData',
      );
      if (response['data'] == null) {
        return const ApiResponse.withError(
          'No Data',
          500,
        );
      } else if (response['data'] != null) {
        try {
          final List<AllFdsData> fdData = (response['data'] as List)
              .map(
                (item) => AllFdsData.fromJson(
                  item,
                ),
              )
              .toList();
          return ApiResponse<List<AllFdsData>>(
            model: fdData,
            code: 200,
          );
        } catch (e) {
          return ApiResponse.withError(
            e.toString(),
            400,
          );
        }
      }
      return const ApiResponse.withError("No data found", 400);
    } catch (e) {
      _logger.e("getAllFdsData => ${e.toString()}");
      return ApiResponse.withError(
        e.toString(),
        400,
      );
    }
  }

  Future<ApiResponse<FdCalculator>> individualFdData() async {
    try {
      final response = await APIService.instance.getData(
        ApiPath.fbDetails,
        cBaseUrl: _baseUrl,
        apiName: '$_fd/individualFdData',
      );
      // final responseData = response["data"];
      return ApiResponse<FdCalculator>(
        model: FdCalculator.fromJson(response),
        code: 200,
      );
    } catch (e) {
      _logger.e("individualFdData => ${e.toString()}");
      return ApiResponse.withError(
        e.toString(),
        400,
      );
    }
  }

  Future<ApiResponse<FdCalculator>> myFds() async {
    try {
      final response = await APIService.instance.getData(
        ApiPath.myFds,
        cBaseUrl: _baseUrl,
        apiName: '$_fd/myFds',
      );
      // final responseData = response["data"];
      return ApiResponse<FdCalculator>(
        model: FdCalculator.fromJson(response),
        code: 200,
      );
    } catch (e) {
      _logger.e("myFds => ${e.toString()}");
      return ApiResponse.withError(
        e.toString(),
        400,
      );
    }
  }
}
