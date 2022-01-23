import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/service/user_coin_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/custom_logger.dart';

class FelloCoinBarViewModel extends BaseModel {
  final _userCoinService = locator<UserCoinService>();
  final _logger = locator<CustomLogger>();

  bool _isLoadingFlc = true;
  get isLoadingFlc => _isLoadingFlc;

  getFlc() async {
    _isLoadingFlc = true;
    notifyListeners();
    _logger.d(
        "Inside get FLC -  new user : ${BaseUtil.isNewUser} and first fetch done: ${BaseUtil.isFirstFetchDone}");
    if (BaseUtil.isNewUser && !BaseUtil.isFirstFetchDone) {
      _logger.d("New user flc loading");
      await Future.delayed(const Duration(seconds: 7));
      await _userCoinService
          ?.getUserCoinBalance()
          ?.onError((error, stackTrace) => _logger.e(error))
          ?.then((value) => BaseUtil.isFirstFetchDone = true);
    } else {
      _logger.d("Old user flc loading");
      await _userCoinService
          ?.getUserCoinBalance()
          ?.onError((error, stackTrace) => _logger.e(error));
    }
    _isLoadingFlc = false;
    notifyListeners();
  }
}
