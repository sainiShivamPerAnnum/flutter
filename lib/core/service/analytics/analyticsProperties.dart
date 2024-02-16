import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/referral_details_model.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/core/service/notifier_services/transaction_history_service.dart';
import 'package:felloapp/core/service/notifier_services/user_coin_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/feature/tambola/tambola.dart';
import 'package:felloapp/util/locator.dart';

class AnalyticsProperties {
  //Required depedencies
  static final UserService _userService = locator<UserService>();
  static final UserCoinService _userCoinService = locator<UserCoinService>();
  static final JourneyService _journeyService = locator<JourneyService>();
  static final TxnHistoryService _txnHistoryService =
      locator<TxnHistoryService>();
  static final BaseUtil _baseUtil = locator<BaseUtil>();

  static getTotalReferralCount() {
    if (!_baseUtil.referralsFetched!) {
      return 0;
    } else {
      return _baseUtil.userReferralsList?.length;
    }
  }

  static getSuccessReferralCount() {
    if (!_baseUtil.referralsFetched!) {
      return 0;
    } else {
      int counter = 0;
      for (ReferralDetail r in _baseUtil.userReferralsList!) {
        if (r.isRefereeBonusUnlocked) counter++;
      }
      return counter;
    }
  }

  static getPendingReferalCount() {
    int? pendingCount = 0;
    if (getTotalReferralCount() >= getSuccessReferralCount()) {
      pendingCount = getTotalReferralCount() - getSuccessReferralCount();
    }
    return pendingCount;
  }

  static int getSucessTxnCount() {
    int count = 0;
    for (UserTransaction ut in _txnHistoryService.txnList!) {
      if (ut.tranStatus == UserTransaction.TRAN_STATUS_COMPLETE) count++;
    }

    return count;
  }

  static int getPendingTxnCount() {
    int count = 0;
    for (UserTransaction ut in _txnHistoryService.txnList!) {
      if (ut.tranStatus == UserTransaction.TRAN_STATUS_PENDING) count++;
    }

    return count;
  }

  static int getFailedTxnCount() {
    int count = 0;
    for (UserTransaction ut in _txnHistoryService.txnList!) {
      if (ut.tranStatus == UserTransaction.TRAN_STATUS_FAILED) count++;
    }

    return count;
  }

  static double getGoldInvestedAmount() {
    return _userService.userFundWallet?.augGoldPrinciple ?? 0;
  }

  static double getGoldQuantityInGrams() {
    return _userService.userFundWallet?.augGoldQuantity ?? 0;
  }

  static double getFelloFloAmount() {
    return _userService.userFundWallet?.wLbPrinciple ?? 0;
  }

  static bool isKYCVerified() {
    return _userService.baseUser!.isSimpleKycVerified ?? false;
  }

  static int getCurrentLevel() {
    return _userService?.userJourneyStats?.level ?? -1;
  }

  static int getCurrentMilestone() {
    return _userService?.userJourneyStats?.mlIndex ?? -1;
  }

  static int getMileStonesCompleted() {
    if ((_userService?.userJourneyStats?.mlIndex ?? 0) > 1) {
      return _userService.userJourneyStats!.mlIndex! - 1;
    } else {
      return 0;
    }
  }

  static int getTokens() {
    return _userCoinService?.flcBalance ?? 0;
  }

  static double getUserCurrentWinnings() {
    double currentWinning = _userService.userFundWallet?.unclaimedBalance ?? 0;
    return currentWinning;
  }

  static String getJouneryCapsuleText() {
    return _journeyService
            .currentMilestoneList[_userService.userJourneyStats!.mlIndex! - 1]
            .tooltip ??
        "null";
  }

  static String getJourneyMileStoneText() {
    return _journeyService
            .currentMilestoneList[_userService.userJourneyStats!.mlIndex! - 1]
            .steps[0]
            .title ??
        "null";
  }

  static String getJourneyMileStoneSubText() {
    return _journeyService
            .currentMilestoneList[_userService.userJourneyStats!.mlIndex! - 1]
            .steps[0]
            .subtitle ??
        "null";
  }

  static String getTimeLeftForTambolaDraw() {
    DateTime currentTime = DateTime.now();
    DateTime drawTime = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, 18, 00, 10);
    Duration timeDiff = drawTime.difference(currentTime);

    if (timeDiff.inSeconds <= 0) {
      return "Drawn";
    } else {
      return timeDiff.inMinutes.toString();
    }
  }

  static int getTambolaTicketCount() {
    return TambolaService.ticketCount ?? 0;
  }

  static Map<String, dynamic> getDefaultPropertiesMap(
      {Map<String, dynamic>? extraValuesMap}) {
    Map<String, dynamic> defaultProperties = {
      "Total Invested Amount": getGoldInvestedAmount() + getFelloFloAmount(),
      "Amount Invested in Gold": getGoldInvestedAmount(),
      "Grams of Gold owned": getGoldQuantityInGrams(),
      "Amount Invested in Flo": getFelloFloAmount(),
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
