import 'package:felloapp/core/model/ui_config_models/ui_config_models.dart';

class ApiPath {
  const ApiPath();

  //Analytics
  String get kSetInstallInfo => "/set-install-info";

  //Augmont Ops
  String get kGetGoldRates => "/gold/rates";

  static String get happyHour => "/happy-hours/active";

  //User Ops Apis
  String get kAddNewUser => "/v2/new";

  String get kUpdateUserAppflyer => "/appflyer";

  static const String kAddBankAccount = "/bank";

  static String kGetBankAccountDetails(String? uid) => '/$uid/bank';

  String get kVerifyPan => "/verify/pan";

  static String getGameStats(String uid) => "/user/$uid/game/stats";

  static String kGetSignedImageUrl(String uid) => "/upload/$uid/image";

  static String kForgeryUpload(String uid) => "/forgery/$uid/image";

  static String kGetPan(String uid) => "/$uid/pan";

  String get kCustomAuthToken => "/api/v3/trucallerAuthToken";
  static const acquisitionTracking = "/userOps/api/v3/opt-analytics";
  static const String updateFcm = '/fcm/client_token';

  static String getAugmontDetail(String? uid) => "/user/$uid/augmont";

  static String kGetUserById(String? id) => "/$id";

  static String getLatestNotification(String? uid) =>
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

  static String logOut(String? uid) => "/user/$uid/logout";

  static String userBootUp(String? uid) => "/user/$uid/bootup/alerts";

  static String scratchCards(uid) => '/user/$uid/golden_tickets';

  static String isEmailRegistered(uid) => '/user/$uid/email/registered';

  static String get dynamicUi => '/ui/dynamic';

  static String get isUsernameAvailable => "/username/availability";

  static String getSubCombosChips(String freq) => "/subs/$freq/config";

  //GT Rewards
  static const kRedeemGtReward = "/gt/redeem";

  //Fello Coupons
  static String kFelloCoupons = "/eligible";

  //DeviceInfo
  String get kSetUserDeviceId => "/setUserDeviceId";
  static const kCreatePaytmTransaction = "/transaction";
  static const kProcessPaytmTransaction = "/process";

  String get kCreateSubscription => "/subscription";

  String get kPauseSubscription => "/subscription/pause";

  String get kResumeSubscription => "/subscription/resume";

  String get kValidateVpa => "/subscription/vpa";

  String get kProcessSubscription => "/process";

  String get kActiveSubscription => "/subscription";

  String get kNextDebitDate => "/debit";
  static const kOngoingCampaigns = "/campaigns";
  static const kFelloFacts = "/fello/facts";

  //tambola game Apis
  static String tambolaTickets(String? uid) => "/$uid/tickets";

  static String tambolaBestTickets(String uid) => "/$uid/winning-tickets";

  static String buyTambolaTicket(String uid) => "/user/$uid/tickets";

  static String ticketCount(String? uid) => "/user/$uid/tickets/count";
  static const String dailyPicks = '/daily/picks';

  static String kSingleTransactions(String? uid) => "/users/$uid/payments";

  // Scratch Card rewards Apis
  static const String prizes = '/prizes';

  static String getScratchCardById(String? uid, String? scratchCardId) =>
      "/user/$uid/gt/$scratchCardId";

  static String getMilestone(String uid) => "/user/$uid/milestones";

  static String prizeBySubtype(String? uid) => '/user/$uid/gt';

  static String getScratchCard(String? uid) => '/user/$uid/golden_tickets';

  // Payment Apis
  static String get validateVPA => "/vpa";

  static String get vpa => "/vpa";

  static String get withdrawal => "/withdrawal";

  static String getWithdrawableGoldQuantity(String? uid) =>
      "/user/$uid/gold/instant/withdrawable";

  // Getter Apis
  static const String amountChips = "/amount/chips/";
  static const String faqs = "/faqs";
  static const String statistics = '/statistics';

  static String getWinners(String? type, String? freq) =>
      "/leaderboard/type/$type/freq/$freq";

  static String pastWinners(String? type, String? freq) =>
      "/leaderboard/past/type/$type/freq/$freq";

  static String getAssetOptions() => '/asset/options';

  // Internal Ops
  static const String failureReport = '/fail/report';

  /// Subscription Apis
  static String getTransaction(String? uid) => "/user/$uid/transactions";
  static const String kPromos = "/promos";
  static const String kStory = "/story";

  //Game Apis
  static const String getGames = "/games";

  // Coupon Apis
  static String getCoupons = "/coupons";

  static String getGameByCode(String gameCode) => "/game/$gameCode";

  // referral
  static const String createReferral = "/referral";

  static String getUserIdByRefCode(String code) => "/referral/$code";

  static String getReferralCode(String? uid) => "/user/referral/$uid";

  static String getReferralHistory(String? uid) => "/referrals/$uid";

  //Journey
  static const kJourney = "/journey";

  static String journeyStats(String? uid) => "/user/$uid/journey/stats";

  static String kSkipMilestone(String? uid) => "/user/$uid/skip/milestone";

  // lendbox
  static String createLbWithdrawal(String? uid) => "/user/$uid/withdrawal";

  static String lbWithdrawableQuantity(String? uid) =>
      "/user/$uid/lb/withdrawable";

  // prizes
  static const String claimPrize = '/prize/claim';

  // static String get getAppConfig => '/app/config';

  //marketing events
  static String kDailyAppBonusEvent(String uid) => "/user/$uid/daily-bonus";

  //phonepe subscriptions
  static String subscription(String uid) => "/$uid/sub";
  static const pauseSubscription = "/sub/pause";
  static const resumeSubscription = "/sub/resume";

  static String txnsSubscription(String uid) => "/$uid/sub/txns";

  static String powerPlayMatches(String status, int limit, int offset) =>
      '/powerplay/matches/$status?limit=$limit&offset=$offset';

  static String matchStats(String matchId) => '/powerplay/match/$matchId/stats';

  static String powerPlayWinnersLeaderboard(String matchId) =>
      "/powerplay/match/$matchId/leaderboard";

  static String get seasonLeaderboard => "/powerplay/global/leaderboard";

  static const String powerPlayReward = "/powerplay/rewards";

  static const String lastWeekRecap = "/recap";

  static const String quickSave = "/global/quick_save";

  static const String investmentPrefs = "/lb/investment-prefs";

  static String portfolio(String uid) => "/$uid/portfolio";

  static String incentives = "/app/incentives";

  static String subscribeGoldPriceAlert = "/gold-price-alert/subscribe";

  static String augmontReport(String txnId) => "/aug/$txnId/txn";

  static String getRegisteredUsers = '/check';

  static String get verifyAugmontKyc => "/pan/re-verify";

  static String get goldProScheme => "/fd/scheme";

  static String get Fd => "/fd";

  static String getFds(String uid) => "/$uid/fd";

  static String get goldRatesGraph => "/gold-rates/graph";

  static String get tambolaOffers => "/tambola/offers";
  static String get homeScreenCarouselItems => "/home_screen";

  static String lbMaturity(String? uid) => "/lb/fd/maturities?uid=$uid";

  static String get goldProConfig => "/gold_pro";

  static String getComponent(ComponentType componentType) =>
      '/component/${componentType.value}';

  static const String felloBadges = "/super-fello";

  static const String badgesLeaderBoard = "/super-fello/leaderboard";
}
