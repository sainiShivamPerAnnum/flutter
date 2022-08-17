import 'package:felloapp/util/flavor_config.dart';

class ApiPath {
  final String stage = FlavorConfig.getStage();

  ApiPath();

  //felloCoins Apis
  get kSubstractFlcPreGameApi =>
      "/felloCoins/$stage/api/felloCoin/updateWallet/preGame";

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
  static const String updateFcm = '/fcm/client_token';
  static String getAugmontDetail(String uid) => "/user/$uid/augmont";
  static String kGetUserById(String id) => "/$id";
  static String getLatestNotification(String uid) =>
      "/user/$uid/notifications/latest";
  static String getNotifications(uid) => "/user/$uid/notifications";
  static const kDeviceId = "/device";
  static String getCoinBalance(uid) => "/$uid/wallet/coin";
  static String getFundBalance(uid) => "/$uid/wallet/fund";
  static String getCompleteOnboarding(uid) => "/walkthrough/$uid";
  static String getBlogs(noOfBlogs) =>
      "/blogs?per_page=$noOfBlogs&status=publish&_fields=id,title.rendered,slug,date,yoast_head_json.og_image,acf&orderby=date&order=desc";
  static String kWalkthrough(uid) => "/walkthrough/$uid";
  static String kVerifyVPAAddress(uid) => '/vpa?uid=$uid';
  //GT Rewards
  get kRedeemGtReward => "/gtRewardsOps/$stage/v2/api/redeemGtReward";

  //Fello Coupons
  static const kFelloCoupons = "/eligible";

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

  static String kSingleTransactions(String uid) => "/users/$uid/payments";

  // Golden Ticket rewards Apis
  static String getGoldenTicketById(String uid, String goldenTicketId) =>
      "/user/$uid/gt/$goldenTicketId";
  static String getMilestone(String uid) => "/user/$uid/milestones";
  static const String prizes = '/prizes';

  // Payment Apis
  static String getWithdrawableGoldQuantity(String uid) =>
      "/user/$uid/gold/withdrawable";

  // Getter Apis
  static const String statistics = '/statistics';
  static String getWinners(String type, String freq) =>
      "/leaderboard/type/$type/freq/$freq";

  static String pastWinners(String type, String freq) =>
      "/leaderboard/past/type/$type/freq/$freq";

  static const String amountChips = "/amount/chips/";

  // Internal Ops
  static const String failureReport = '/fail/report';

  /// Subcription Apis
  static String getTransaction(String uid) => "/user/$uid/transactions";
  static const String kPromos = "/promos";

  //Game Apis
  static const String getGames = "/games";

  // Coupon Apis
  static const String getCoupons = "/coupons";
  static String getGameByCode(String gameCode) => "/game/$gameCode";

  // referral
  static String getUserIdByRefCode(String code) => "/referral/$code";
  static String getReferralCode(String uid) => "/user/referral/$uid";
  static String getReferralHistory(String uid) => "/referrals/$uid";

  //Journey
  get kMilestones => '/milestones';
  get kJourney => "/journey";
  static String getJourney(int page) => "/journey/$page";
  static String journeyStats(String uid) => "/user/$uid/journey/stats";
  static String kJourneyLevel = '/levels';
  static String kSkipMilestone(String uid) => "/user/$uid/skip/milestone";
}
