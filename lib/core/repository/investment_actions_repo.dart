import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/rsa_encryption.dart';

class InvestmentActionsRepository extends BaseRepo {
  final ApiPath _apiPaths = locator<ApiPath>();
  final CustomLogger _logger = locator<CustomLogger>();
  final _rsaEncryption = RSAEncryption();
  static const _banking = 'bankingOps';

  final _baseUrl = FlavorConfig.isDevelopment()
      ? "https://6iq5sy5tp8.execute-api.ap-south-1.amazonaws.com/dev"
      : "https://szqrjkwkka.execute-api.ap-south-1.amazonaws.com/prod";

  Future<ApiResponse<Map<String, dynamic>>> getGoldRates() async {
    _logger.d("GET_GOLD_RATES::API_CALLED");

    try {
      final response = await APIService.instance.getData(
        _apiPaths.kGetGoldRates,
        cBaseUrl: _baseUrl,
        apiName: "$_banking/goldRates",
      );

      return ApiResponse(model: response['data'], code: 200);
    } catch (e) {
      _logger.e(e);
      return ApiResponse.withError(
          e.toString() ?? "Unable to fetch rates", 400);
    }
  }

  Future<ApiResponse<bool>> withdrawlComplete({
    String? tranDocId,
    double? amount,
    String? userUid,
    Map<String, dynamic>? sellGoldMap,
  }) async {
    String? message = "";
    Map<String, dynamic> _body = {
      "uid": userUid,
      "amount": amount,
      "sellGoldMap": sellGoldMap,
    };

    _logger.d("withdrawComplete:: Pre encryption: $_body");
    if (await _rsaEncryption.init()) {
      _body = _rsaEncryption.encryptRequestBody(_body);
      _logger.d("withdrawComplete:: Post encryption: ${_body.toString()}");
    } else {
      _logger.e("Encryption initialization failed.");
    }
    try {
      final response = await APIService.instance.postData(
        ApiPath.withdrawal,
        body: _body,
        cBaseUrl: FlavorConfig.isDevelopment()
            ? "https://wd7bvvu7le.execute-api.ap-south-1.amazonaws.com/dev"
            : "https://yg58g0feo0.execute-api.ap-south-1.amazonaws.com/prod",
        apiName: 'monoPayment/withdrawal',
      );
      _logger.d("Response from withdrawal: $response");
      message = response["message"];
      return ApiResponse(model: true, code: 200);
    } catch (e) {
      _logger.e(e);
      return ApiResponse.withError(e.toString(), 400);
    }
  }
}
