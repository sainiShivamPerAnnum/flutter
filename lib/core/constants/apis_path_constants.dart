class ApiPath {
  final String stage;

  ApiPath({this.stage = "dev"});

  get kSubstractFlcPreGameApi =>
      "/felloCoins/$stage/api/felloCoin/updateWallet/preGame";

  get kGetCoinBalance => "/felloCoins/$stage/api/felloCoin/balance";
}
