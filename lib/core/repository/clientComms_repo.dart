import 'package:felloapp/core/constants/apis_path_constants.dart';
import 'package:felloapp/core/repository/base_repo.dart';
import 'package:felloapp/core/service/api_service.dart';
import 'package:felloapp/util/flavor_config.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class ClientCommsRepo extends BaseRepo {
  final _baseUrl = FlavorConfig.isDevelopment()
      ? 'https://2i7p0mi89b.execute-api.ap-south-1.amazonaws.com/dev'
      : 'https://7ljkkapvw7.execute-api.ap-south-1.amazonaws.com/prod';

  Future<void> subscribeGoldPriceAlert(int flag) async {
    try {
      final token = await getBearerToken();

      String? fcmToken = await FirebaseMessaging.instance.getToken();

      var map = {
        "flag": flag.toString(),
      };

      await APIService.instance.postData(
        ApiPath.subscribeGoldPriceAlert,
        cBaseUrl: _baseUrl,
        token: token,
        queryParams: map,
        headers: {'fcmToken': fcmToken ?? ""},
      );

      // logger.d(response);
    } catch (e) {
      logger.e(e.toString());
    }
  }
}
