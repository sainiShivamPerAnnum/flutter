import 'package:felloapp/util/flavor_config.dart';

class ApiPath {
  final String stage = FlavorConfig.getStage();

  ApiPath();

  //felloCoins Apis
  get kSubstractFlcPreGameApi =>
      "/felloCoins/$stage/api/felloCoin/updateWallet/preGame";
  get kGetCoinBalance => "/felloCoins/$stage/api/felloCoin/balance";

  //userFinanceV2Ops Apis
  get kCreateTranId => "/userFinanceV2Ops/$stage/api/transaction/id";
  get kDepositComplete => "/userFinanceV2Ops/$stage/api/v2/deposit/complete";
  get kDepositPending => "/userFinanceV2Ops/$stage/api/v2/deposit/pending";
  get kDepositCancelled => "/userFinanceV2Ops/$stage/api/v2/deposit/cancelled";
  get kWithdrawlComplete => "/userFinanceV2Ops/$stage/api/v2/withdraw/complete";
  get kWithdrawlCancelled =>
      "/userFinanceV2Ops/$stage/api/v2/withdraw/cancelled";

  //prizingOps Apis
  get kTopWinners => "/prizingOps/$stage/api/reward/current-top-winners";

  //Augmont Ops
  get kCreateSimpleUser => "/augmontOps/$stage/api/v2/create-simple-user";
  get kGetGoldRates => "/augmontOps/$stage/api/rates";

  //User Ops Apis
  get kAddNewUser => "/api/v3/newuser";
  get kUpdateUserAppflyer => "/userOps/api/v3/user/appflyer";
  get kAmountTransfer => "/userOps/api/v3/accountTransfer";
  get kVerifyTransfer => "/userOps/api/v3/verifyTransfer";
  get kVerifyPan => "/userOps/api/v3/verifyPan";
  get kCustomAuthToken => "/userOps/api/v3/trucallerAuthToken";
  static const acquisitionTracking = "/userOps/api/v3/opt-analytics";

  static String getUserIdByRefCode(String code) => "/referral/$code";
  static String getReferralCode(String uid) => "/user/referral/$uid";
  static String getLatestNotication(String uid) =>
      "/user/$uid/notification/latest";
  static String getNotications(uid) => "/user/$uid/notifications";
  static const kDeviceId = "/device";

  //GT Rewards
  get kRedeemGtReward => "/gtRewardsOps/$stage/v2/api/redeemGtReward";

  //Fello Coupons
  get kFelloCoupons => "/eligible";
  //"/felloCoupons/$stage/api/eligible";

  //DeviceInfo
  get kSetUserDeviceId => "/setUserDeviceId";
  static const kCreatePaytmTransaction = "/transaction";
  get kCreateSubscription => "/subscription";
  get kPauseSubscription => "/subscription/pause";
  get kResumeSubscription => "/subscription/resume";
  get kValidateVpa => "/subscription/vpa";
  get kProcessSubscription => "/process";
  get kActiveSubscription => "/subscription";
  get kNextDebitDate => "/debit";
  get kOngoingCampaigns => "/$stage/campaigns";

  //tambola game Apis
  static String tambolaTickets(String uid) => "/user/$uid/tickets";
  static String buyTambolaTicket(String uid) => "/user/$uid/tickets";
  static String ticketCount(String uid) => "/user/$uid/tickets/count";
  static const String dailyPicks = '/picks';

  get kSingleTransactions => "/payments";

  // Golden Ticket rewards Apis
  static String getGoldenTicketById(String uid, String goldenTicketId) =>
      "/user/$uid/gt/$goldenTicketId";
  static String getMilestone(String uid) => "/user/$uid/milestones";
  static const String prizes = '/prizes';

  //User Ops Apis
  static String getAugmontDetail(String uid) => "/user/$uid/augmont";
  static String kGetUserById(String id) => "/$id";

  // Payment Apis
  static String getWithdrawableGoldQuantity(String uid) =>
      "/user/$uid/gold/withdrawable";

  // Getter Apis
  static const String statistics = '/statistics';
  static String getwinner(String type, String freq) =>
      "/leaderboard/type/$type/freq/$freq";
  static String pastWinners(String type, String freq) =>
      "/leaderboard/past/type/$type/freq/$freq";
  static const String amountChips = "/amount/chips/";

  // Internal Ops
  static const String failureReport = '/fail/report/';

  /// Subcription Apis
  String getTransaction(String uid) => "/user/$uid/transactions";
  static const String kPromos = "/promos";

  //Game Apis
  static const String getGames = "/games";

  // Coupon Apis
  static const String getCoupons = "/coupons";
}
