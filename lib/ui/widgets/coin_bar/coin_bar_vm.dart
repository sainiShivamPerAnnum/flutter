import 'package:felloapp/core/service/user_coin_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/locator.dart';

class FelloCoinBarViewModel extends BaseModel {
  final _userCoinService = locator<UserCoinService>();

  bool _isLoadingFlc = true;
  get isLoadingFlc => _isLoadingFlc;

  getFlc() async {
    _isLoadingFlc = true;
    await _userCoinService?.getUserCoinBalance();
    _isLoadingFlc = false;
    notifyListeners();
  }
}
