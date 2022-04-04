import 'package:felloapp/util/flavor_config.dart';

class ApiPath {
  final String stage = FlavorConfig.getStage();

  ApiPath();

  //felloCoins Apis
  get kSubstractFlcPreGameApi =>
      "/felloCoins/$stage/api/felloCoin/updateWallet/preGame";
  get kGetCoinBalance => "/felloCoins/$stage/api/felloCoin/balance";
  get kBuyTambola => "/felloCoins/$stage/api/tambola/buy-tambola-tickets";

  //userFinanceV2Ops Apis
  get kCreateTranId => "/userFinanceV2Ops/$stage/api/transaction/id";
  get kDepositComplete => "/userFinanceV2Ops/$stage/api/v2/deposit/complete";
  get kDepositPending => "/userFinanceV2Ops/$stage/api/v2/deposit/pending";
  get kDepositCancelled => "/userFinanceV2Ops/$stage/api/v2/deposit/cancelled";
  get kWithdrawlComplete => "/userFinanceV2Ops/$stage/api/v2/withdraw/complete";
  get kWithdrawlCancelled =>
      "/userFinanceV2Ops/$stage/api/v2/withdraw/cancelled";

  //tambolaGames Apis
  get kGenerateTambolaTickets => "/tambolaGame/$stage/api/generate";

  //prizingOps Apis
  get kTopWinners => "/prizingOps/$stage/api/reward/current-top-winners";

  //Augmont Ops
  get kCreateSimpleUser => "/augmontOps/$stage/api/v2/create-simple-user";
  get kGetGoldRates => "/augmontOps/$stage/api/rates";

  //User Ops Apis
  get kAddNewUser => "/userOps/api/v3/newuser";
  get kAmountTransfer => "/userOps/api/v3/accountTransfer";
  get kVerifyTransfer => "/userOps/api/v3/verifyTransfer";
  get kVerifyPan => "/userOps/api/v3/verifyPan";
  get kCustomAuthToken => "/userOps/api/v3/trucallerAuthToken";
  static const acquisitionTracking = "/userOps/api/v3/opt-analytics";

  //GT Rewards
  get kRedeemGtReward => "/gtRewardsOps/$stage/v2/api/redeemGtReward";

  //Fello Coupons
  get kFelloCoupons => "/felloCoupons/$stage/api/eligible";

  //PaytmApis
  static const kCreatePaytmTransaction = "/paymentOps/transaction";
  get kCreateSubscription => "/subscriptionOps/subscription";
  get kPauseSubscription => "/subscriptionOps/subscription/pause";
  get kResumeSubscription => "/subscriptionOps/subscription/resume";
  get kValidateVpa => "/subscriptionOps/vpa";
}
