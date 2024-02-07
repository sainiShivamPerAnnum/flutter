import 'package:felloapp/core/model/sip_model/sip_data_model.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/flavor_config.dart';

class SipRepository extends BaseRepo {
  String baseUrl = FlavorConfig.isProduction()
      ? "https://2z48o79cm5.execute-api.ap-south-1.amazonaws.com/prod"
      : "https://2je5zoqtuc.execute-api.ap-south-1.amazonaws.com/dev";

  static const _subscription = 'subscription';

  Future<ApiResponse<SipData>> getSipScreenData() async {
    try {
      final response = await APIService.instance.getData(
        'https://mocki.io/v1/11fd190d-a8af-4baa-8c41-aa041f9657b1',
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
