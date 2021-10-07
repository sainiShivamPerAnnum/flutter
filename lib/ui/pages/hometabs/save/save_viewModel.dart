import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/locator.dart';

class SaveViewModel extends BaseModel {
  BaseUtil _baseUtil = locator<BaseUtil>();
  UserService _userService = locator<UserService>();

  getGoldBalance() {
    return _baseUtil.userFundWallet.augGoldQuantity ?? 0.0;
  }

  getUnclaimedPrizeBalance() {
    return _baseUtil.userFundWallet.prizeLifetimeWin ?? 0.0;
  }
}
