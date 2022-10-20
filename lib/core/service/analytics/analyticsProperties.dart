import 'package:felloapp/core/service/notifier_services/user_coin_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/paytm_service.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/locator.dart';

class AnalyticsProperties {
  //Required depedencies
  static final _userService = locator<UserService>();
  static final _userCoinService = locator<UserCoinService>();
  static final _paytmService = locator<PaytmService>();

  static double getTotalInvestedAmount() {
    double totalInvestedAmount = _userService.userFundWallet.augGoldPrinciple ??
        0 + _userService.userFundWallet.wLbPrinciple ??
        0;
    return totalInvestedAmount;
  }

  static double getGoldInvestedAmount() {
    return _userService.userFundWallet.augGoldPrinciple;
  }

  static double getGoldQuantityInGrams() {
    return _userService.userFundWallet.augGoldQuantity;
  }

  static double getFelloFloAmount() {
    return _userService.userFundWallet.wLbPrinciple;
  }

  static bool isKYCVerified() {
    return _userService.baseUser.isSimpleKycVerified;
  }

  static int getCurrentLevel() {
    return _userService.userJourneyStats.level;
  }

  static int getCurrentMilestone() {
    return _userService.userJourneyStats.mlIndex;
  }

  static int getMileStonesCompleted() {
    if (_userService.userJourneyStats.mlIndex > 1)
      return (_userService.userJourneyStats.mlIndex) - 1;
    else
      return 0;
  }

  static int getTokens() {
    return _userCoinService.flcBalance;
  }

  static bool isAutoSIPActive() {
    return _paytmService.activeSubscription.status ==
            Constants.SUBSCRIPTION_ACTIVE
        ? true
        : false;
  }

  static double getAutoSIPAmount() {
    return _paytmService.activeSubscription.autoAmount;
  }
}
