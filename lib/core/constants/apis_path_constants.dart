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
  get kFelloCoupons => "/$stage/eligible";
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
  static const String dailyPicks = '/picks';

  get kSingleTransactions => "/payments";

  static String getGoldenTicketById(String uid, String goldenTicketId) =>
      "/user/$uid/gt/$goldenTicketId";

  static String getAugmontDetail(String uid) => "/user/$uid/augmont";

  static String getMilestone(String uid) => "/user/$uid/milestones";
}
