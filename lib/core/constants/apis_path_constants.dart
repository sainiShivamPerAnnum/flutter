import 'package:felloapp/core/enums/stage.dart';

class ApiPath {
  final Stage stage;

  ApiPath({this.stage = Stage.dev});

  get kSubstractFlcPreGameApi =>
      "/felloCoins/${stage.toString()}/api/felloCoin/updateWallet/preGame";
  get kGetCoinBalance =>
      "/felloCoins/${stage.toString()}/api/felloCoin/balance";
}
