import 'package:felloapp/base_util.dart';
import 'package:felloapp/ui/architecture/base_vm.dart';
import 'package:felloapp/util/locator.dart';

class SaveViewModel extends BaseModel {
  BaseUtil _baseUtil = locator<BaseUtil>();

  getGoldBalance() {
    return _baseUtil.userFundWallet?.augGoldQuantity ?? 0.0;
  }

  getUnclaimedPrizeBalance() {
    return _baseUtil.userFundWallet?.prizeLifetimeWin ?? 0.0;
  }
}
