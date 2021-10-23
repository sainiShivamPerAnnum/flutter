import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/service/user_coin_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/locator.dart';
import 'package:logger/logger.dart';

class FelloCoinBarViewModel extends BaseModel {
  final _userCoinService = locator<UserCoinService>();
  final _baseUtil = locator<BaseUtil>();
  final _logger = locator<Logger>();

  bool _isLoadingFlc = true;
  get isLoadingFlc => _isLoadingFlc;

  getFlc() async {
    _isLoadingFlc = true;
    notifyListeners();
    if (_baseUtil.isNewUser && !_baseUtil.isFirstFetchDone) {
      await Future.delayed(const Duration(seconds: 5));
      await _userCoinService
          ?.getUserCoinBalance()
          ?.onError((error, stackTrace) => _logger.e(error))
          ?.then((value) => _baseUtil.isFirstFetchDone = true);
    } else {
      await _userCoinService
          ?.getUserCoinBalance()
          ?.onError((error, stackTrace) => _logger.e(error));
    }
    _isLoadingFlc = false;
    notifyListeners();
  }
}
