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
        'https://mocki.io/v1/3d355d03-da34-4a9c-a53f-04529d114410',
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
