class ApiPath {
  final String stage;

  ApiPath({this.stage = "dev"});

  get kSubstractFlcPreGameApi =>
      "/felloCoins/$stage/api/felloCoin/updateWallet/preGame";

  get kGetCoinBalance => "/felloCoins/$stage/api/felloCoin/balance";

  get kDepositComplete => "/userFinanceOps/$stage/api/deposit/complete";
  get kDepositPending => "/userFinanceOps/$stage/api/deposit/pending";
  get kDepositCancelled => "/userFinanceOps/$stage/api/deposit/cancelled";
  get kWithdrawlComplete => "/userFinanceOps/$stage/api/withdraw/complete";
  get kWithdrawlCancelled => "/userFinanceOps/$stage/api/withdraw/cancelled";
}
