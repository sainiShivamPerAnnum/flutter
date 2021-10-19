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

  Future<void> addKycName({String userUid, String upstreamKycName}) async {
    try {
      Map<String, dynamic> _data = {'mKycName': upstreamKycName};
      await _api.addKycName(userUid, _data);
      _logger.d("Kyc name successfully added to firestore");
    } catch (e) {
      _logger.e(e);
      throw e;
    }
  }
}
