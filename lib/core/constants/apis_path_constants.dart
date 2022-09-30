import 'package:felloapp/util/flavor_config.dart';

class ApiPath {
  final String stage = FlavorConfig.getStage();

  ApiPath();

  //Augmont Ops
  get kGetGoldRates => "/gold/rates";

  //User Ops Apis
  get kAddNewUser => "/v2/new";
  get kUpdateUserAppflyer => "/userOps/api/v3/user/appflyer";
  get kAddBankAccount => "/bank";
  static String kGetBankAccountDetails(String uid) => '/$uid/bank';
  get kVerifyPan => "/verify/pan";
  static String kGetPan(String uid) => "/$uid/pan";
  static String kUpdateBankDetails(String uid) => '/user/$uid/bank';
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
  static String kVerifyVPAAddress(uid) => '/vpa?uid=$uid';
  static String sendOtp = '/auth/otp';
  static String verifyOtp = '/auth/verify/otp';
  static String fecthLatestTxnDetails(uid) => "/$uid/transaction/rewards";
  static String logOut(String uid) => "/user/$uid/logout";
  static String userBootUp(String uid) => "/user/$uid/bootup/alerts";
  static String goldenTickets(uid) => '/user/$uid/golden_tickets';

  //GT Rewards
  get kRedeemGtReward => "/gtRewardsOps/$stage/v2/api/redeemGtReward";

  //Fello Coupons
  static const kFelloCoupons = "/eligible";

  //DeviceInfo
  get kSetUserDeviceId => "/setUserDeviceId";
  static const kCreatePaytmTransaction = "/transaction";
  static const kProcessPaytmTransaction = "/process";
  get kCreateSubscription => "/subscription";
  get kPauseSubscription => "/subscription/pause";
  get kResumeSubscription => "/subscription/resume";
  get kValidateVpa => "/subscription/vpa";
  get kProcessSubscription => "/process";
  get kActiveSubscription => "/subscription";
  get kNextDebitDate => "/debit";
  static const kOngoingCampaigns = "/campaigns";

  //tambola game Apis
  static String tambolaTickets(String uid) => "/user/$uid/tickets";
  static String buyTambolaTicket(String uid) => "/user/$uid/tickets";
  static String ticketCount(String uid) => "/user/$uid/tickets/count";
  static const String dailyPicks = '/picks';

  static String kSingleTransactions(String uid) => "/users/$uid/payments";

  // Golden Ticket rewards Apis
  static const String prizes = '/prizes';
  static String getGoldenTicketById(String uid, String goldenTicketId) =>
      "/user/$uid/gt/$goldenTicketId";
  static String getMilestone(String uid) => "/user/$uid/milestones";
  static prizeBySubtype(String uid) => '/user/$uid/gt';

  // Payment Apis
  static String get validateVPA => "/vpa";
  static String get vpa => "/vpa";
  static String get withdrawal => "/withdrawal";
  static String getWithdrawableGoldQuantity(String uid) =>
      "/user/$uid/gold/instant/withdrawable";

  // Getter Apis
  static const String amountChips = "/amount/chips/";
  static const String faqs = "/faqs";
  static const String statistics = '/statistics';
  static String getWinners(String type, String freq) =>
      "/leaderboard/type/$type/freq/$freq";
  static String pastWinners(String type, String freq) =>
      "/leaderboard/past/type/$type/freq/$freq";

  // Internal Ops
  static const String failureReport = '/fail/report';

  /// Subscription Apis
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
  static const kJourney = "/journey";
  static String kJourneyLevel = '/levels';
  static String getJourney(int page) => "/journey/$page";
  static String journeyStats(String uid) => "/user/$uid/journey/stats";
  static String kSkipMilestone(String uid) => "/user/$uid/skip/milestone";

  // lendbox
  static String lendboxWithdrawal(String uid) => "/user/$uid/withdrawal";
}
