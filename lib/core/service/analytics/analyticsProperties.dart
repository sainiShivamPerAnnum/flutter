import 'package:felloapp/core/enums/investment_type.dart';
import 'package:felloapp/core/model/tambola_board_model.dart';
import 'package:felloapp/core/model/user_transaction_model.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/core/service/notifier_services/tambola_service.dart';
import 'package:felloapp/core/service/notifier_services/transaction_history_service.dart';
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
  static final _journeyService = locator<JourneyService>();
  static final _tambolaService = locator<TambolaService>();
  static final _txnHistoryService = locator<TransactionHistoryService>();

  init() async {
    await _paytmService.init();
    await _tambolaService.init();
    await _txnHistoryService.updateTransactions(InvestmentType.AUGGOLD99);
  }

  static int getSucessTxnCount() {
    int count = 0;
    for (UserTransaction ut in _txnHistoryService.txnList) {
      if (ut.tranStatus == UserTransaction.TRAN_STATUS_COMPLETE) count++;
    }

    return count;
  }

  static int getPendingTxnCount() {
    int count = 0;
    for (UserTransaction ut in _txnHistoryService.txnList) {
      if (ut.tranStatus == UserTransaction.TRAN_STATUS_PENDING) count++;
    }

    return count;
  }

  static int getFailedTxnCount() {
    int count = 0;
    for (UserTransaction ut in _txnHistoryService.txnList) {
      if (ut.tranStatus == UserTransaction.TRAN_STATUS_FAILED) count++;
    }

    return count;
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

  static double getUserCurrentWinnings() {
    double currentWinning = _userService.userFundWallet?.unclaimedBalance ?? 0;
    return currentWinning;
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

  static String getJouneryCapsuleText() {
    return _journeyService
        .currentMilestoneList[_userService.userJourneyStats.mlIndex - 1]
        .tooltip;
  }

  static String getJourneyMileStoneText() {
    return _journeyService
        .currentMilestoneList[_userService.userJourneyStats.mlIndex - 1]
        .steps[0]
        .title;
  }

  static String getJourneyMileStoneSubText() {
    return _journeyService
        .currentMilestoneList[_userService.userJourneyStats.mlIndex - 1]
        .steps[0]
        .subtitle;
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

  static int getTabolaTicketCount() {
    return _tambolaService.ticketCount ?? 0;
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
