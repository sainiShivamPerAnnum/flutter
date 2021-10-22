import 'package:felloapp/navigator/router/ui_pages.dart';

class GameModel {
  final String gameName;
  final String tag;
  final String thumbnailImage;
  final PageConfiguration pageConfig;
  final int playCost;
  final double prizeAmount;

  GameModel({
    this.gameName,
    this.pageConfig,
    this.tag,
    this.thumbnailImage,
    this.playCost,
    this.prizeAmount,
  });
}
