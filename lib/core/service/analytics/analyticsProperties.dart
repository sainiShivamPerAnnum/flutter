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

  init() async {
    await _paytmService.init();
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
    return _userCoinService?.flcBalance ?? 0;
  }

  static bool isAutoSIPActive() {
    if (_paytmService.activeSubscription == null) {
      return false;
    } else {
      return _paytmService.activeSubscription.status ==
              Constants.SUBSCRIPTION_ACTIVE
          ? true
          : false;
    }
  }

  static double getAutoSIPAmount() {
    if (_paytmService.activeSubscription == null)
      return 0.0;
    else
      return _paytmService.activeSubscription.autoAmount;
  }

  static Map<String, dynamic> getDefaultPropertiesMap(
      {Map<String, dynamic> extraValuesMap}) {
    Map<String, dynamic> defaultProperties = {
      "Total Invested Amount": getGoldInvestedAmount() + getFelloFloAmount(),
      "Amount Invested in Gold": getGoldInvestedAmount(),
      "Grams of Gold owned": getGoldQuantityInGrams(),
      "Amount Invested in Flo": getFelloFloAmount(),
      "Auto SIP done": isAutoSIPActive(),
      "Auto SIP amount": getAutoSIPAmount(),
      "KYC Verified": isKYCVerified(),
      "Level": getCurrentLevel(),
      "MileStones Completed": getMileStonesCompleted(),
      "Current Milestone": getCurrentMilestone(),
      "Token Balance": getTokens(),
    };

    if (extraValuesMap != null) {
      defaultProperties.addAll(extraValuesMap);
    }

    return defaultProperties;
  }
}
