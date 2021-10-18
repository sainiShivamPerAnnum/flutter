import 'package:felloapp/core/service/api.dart';
import 'package:felloapp/util/locator.dart';
import 'package:logger/logger.dart';

class UserRepository {
  final _logger = locator<Logger>();
  final _api = locator<Api>();

  Future<void> removeUserFCM(String userUid) async {
    try {
      await _api.deleteUserClientToken(userUid);
      _logger.d("Token successfully removed from firestore, on user signout.");
    } catch (e) {
      _logger.e(e);
      throw e;
    }
  }
}
