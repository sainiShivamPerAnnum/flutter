import 'package:felloapp/util/flavor_config.dart';

class ApiPath {
  final String stage = FlavorConfig.getStage();

  ApiPath();

  get kSubstractFlcPreGameApi =>
      "/felloCoins/$stage/api/felloCoin/updateWallet/preGame";

  get kGetCoinBalance => "/felloCoins/$stage/api/felloCoin/balance";

  get kCreateTranId => "/userFinanceOps/$stage/api/transaction/id";
  get kDepositComplete => "/userFinanceOps/$stage/api/v2/deposit/complete";
  get kDepositPending => "/userFinanceOps/$stage/api/v2/deposit/pending";
  get kDepositCancelled => "/userFinanceOps/$stage/api/v2/deposit/cancelled";
  get kWithdrawlComplete => "/userFinanceOps/$stage/api/v2/withdraw/complete";
  get kWithdrawlCancelled => "/userFinanceOps/$stage/api/v2/withdraw/cancelled";
  get kBuyTambola => "/felloCoins/$stage/api/tambola/buy-tambola-tickets";
  get kGenerateTambolaTickets => "/tambolaGame/$stage/api/generate";
  get kTopWinners => "/prizingOps/$stage/api/reward/current-top-winners";
  get kAddNewUser => "/userOps/$stage/api/v2/newuser";

  //Augmont Ops
  get kCreateSimpleUser => "/augmontOps/$stage/api/v2/create-simple-user";
}
