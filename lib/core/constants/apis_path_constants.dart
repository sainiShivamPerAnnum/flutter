import 'package:felloapp/util/flavor_config.dart';

class ApiPath {
  final String stage = FlavorConfig.getStage();

  ApiPath();

  get kSubstractFlcPreGameApi =>
      "/felloCoins/$stage/api/felloCoin/updateWallet/preGame";

  get kGetCoinBalance => "/felloCoins/$stage/api/felloCoin/balance";

  get kCreateTranId => "/userFinanceOps/$stage/api/transaction/id";
  get kDepositComplete => "/userFinanceOps/$stage/api/deposit/complete";
  get kDepositPending => "/userFinanceOps/$stage/api/deposit/pending";
  get kDepositCancelled => "/userFinanceOps/$stage/api/deposit/cancelled";
  get kWithdrawlComplete => "/userFinanceOps/$stage/api/withdraw/complete";
  get kWithdrawlCancelled => "/userFinanceOps/$stage/api/withdraw/cancelled";
  get kBuyTambola => "/felloCoins/$stage/api/tambola/buy-tambola-tickets";
  get kGenerateTambolaTickets => "/tambolaGame/$stage/api/generate";
  get kTopWinners => "/prizingOps/$stage/api/reward/current-top-winners";
  get kAddNewUser => "/userOps/api/v2/$stage/newuser";

}
