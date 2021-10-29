import 'package:felloapp/navigator/router/ui_pages.dart';

class GameModel {
  final String gameName;
  final String tag;
  final String thumbnailUri;
  final PageConfiguration pageConfig;
  final String playCost;
  final String prizeAmount;

  GameModel({
    this.gameName,
    this.pageConfig,
    this.tag,
    this.thumbnailUri,
    this.playCost,
    this.prizeAmount,
  });
}
