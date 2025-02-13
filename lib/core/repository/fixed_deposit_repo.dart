import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/fixedDeposit/fd_calculator.dart';
// import 'package:felloapp/core/model/fixedDeposit/fd_deposit.dart';
import 'package:felloapp/core/model/fixedDeposit/fd_home.dart';
import 'package:felloapp/core/model/fixedDeposit/my_fds.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';

import '../../util/custom_logger.dart';

class FdRepository extends BaseRepo {
  final CustomLogger _logger = locator<CustomLogger>();
  final _baseUrl = FlavorConfig.isDevelopment()
      ? 'https://advisors.fello-dev.net'
      : 'https://advisors.fello-prod.net/';
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

  Future<ApiResponse<FDInterestModel>> fetchFdCalculation({
    required num investmentAmount,
    required num investmentPeriod,
    required bool isSeniorCitizen,
    required String payoutFrequency,
    required bool isFemale,
    required String issuerId,
  }) async {
    try {
      final body = {
        "investmentAmount": investmentAmount,
        "investmentPeriod": investmentPeriod,
        "isSeniorCitizen": isSeniorCitizen,
        "payoutFrequency": payoutFrequency,
        "isFemale": isFemale,
        "issuerId": issuerId,
      };
      final response = await APIService.instance.postData(
        ApiPath.fdCalculation,
        cBaseUrl: _baseUrl,
        body: body,
        apiName: '$_fd/fetchFdCalculation',
      );
      final responseData = response;
      return ApiResponse<FDInterestModel>(
        model: FDInterestModel.fromJson(responseData),
        code: 200,
      );
    } catch (e) {
      _logger.e("fetchFdCalculation => ${e.toString()}");
      return ApiResponse.withError(
        e.toString(),
        400,
      );
    }
  }

  Future<ApiResponse<UserFdPortfolio>> myFds() async {
    try {
      final response = await APIService.instance.getData(
        ApiPath.myFds,
        cBaseUrl: _baseUrl,
        apiName: '$_fd/myFds',
      );
      final responseData = response["data"];
      return ApiResponse<UserFdPortfolio>(
        model: UserFdPortfolio.fromJson(responseData),
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
