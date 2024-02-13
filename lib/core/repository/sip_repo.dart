import 'package:felloapp/core/model/sip_model/sip_data_model.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/flavor_config.dart';

class SipRepository extends BaseRepo {
  String baseUrl = FlavorConfig.isProduction()
      ? "https://d11q4cti75qmcp.cloudfront.net/sip.json"
      : "https://d18gbwu7fwwwtf.cloudfront.net/sip.json";

  static const _subscription = 'subscription';

  Future<ApiResponse<SipData>> getSipScreenData() async {
    try {
      final response = await APIService.instance.getData(
        baseUrl,
        cBaseUrl: '',
        apiName: _subscription,
      );
      SipData sipModel = SipData.fromJson(response);
      return ApiResponse(model: sipModel, code: 200);
    } catch (e) {
      return ApiResponse.withError(e.toString(), 400);
    }
  }
}
