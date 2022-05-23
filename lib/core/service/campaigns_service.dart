import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/model/event_model.dart';
import 'package:felloapp/core/model/promo_cards_model.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:felloapp/util/locator.dart';

class CampaignService {
  final _userService = locator<UserService>();
  final _logger = locator<CustomLogger>();

  Future<ApiResponse<List<EventModel>>> getOngoingEvents() async {
    List<EventModel> events = [];
    try {
      final String _uid = _userService.baseUser.uid;
      final _token = await _getBearerToken();
      final _queryParams = {"uid": _uid};
      final response = await APIService.instance.getData(
        ApiPath().kOngoingCampaigns,
        token: _token,
        cBaseUrl: FlavorConfig.isDevelopment()
            ? "https://rco4comkpa.execute-api.ap-south-1.amazonaws.com"
            : "https://l4aighxmj3.execute-api.ap-south-1.amazonaws.com",
        queryParams: _queryParams,
      );

      final responseData = response["data"];
      _logger.d(responseData);
      if (responseData['status'] == true) {
        responseData["campaigns"].forEach((e) {
          events.add(EventModel.fromMap(e));
        });
      }
      return ApiResponse<List<EventModel>>(model: events, code: 200);
    } catch (e) {
      _logger.e(e.toString());
      return ApiResponse.withError("Unable to fetch campaings", 400);
    }
  }

  //promos
  Future<ApiResponse<List<PromoCardModel>>> getPromoCards() async {
    List<PromoCardModel> events = [];
    try {
      final String _uid = _userService.baseUser.uid;
      final _token = await _getBearerToken();
      final _queryParams = {"uid": _uid};
      final response = await APIService.instance.getData(
        ApiPath().kPromos,
        token: _token,
        cBaseUrl: FlavorConfig.isDevelopment()
            ? "https://0mol3kbz59.execute-api.ap-south-1.amazonaws.com"
            : "https://l4aighxmj3.execute-api.ap-south-1.amazonaws.com",
        queryParams: _queryParams,
      );

      final responseData = response["data"];
      _logger.d(responseData);
      if (responseData['status'] == true) {
        responseData["promos"].forEach((e) {
          events.add(PromoCardModel.fromMap(e));
        });
      }
      return ApiResponse<List<PromoCardModel>>(model: events, code: 200);
    } catch (e) {
      _logger.e(e.toString());
      return ApiResponse.withError("Unable to fetch promos", 400);
    }
  }

  Future<String> _getBearerToken() async {
    String token = await _userService.firebaseUser.getIdToken();
    _logger.d(token);
    return token;
  }
}
