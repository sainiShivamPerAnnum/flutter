import 'package:felloapp/core/service/analytics/analytics_events.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:flutter/foundation.dart';

class GameModel {
  final String gameName;
  final String tag;
  final String thumbnailUri;
  final PageConfiguration pageConfig;
  final String playCost;
  final String prizeAmount;
  final String analyticEvent;

  GameModel({
    this.gameName,
    this.pageConfig,
    this.tag,
    this.thumbnailUri,
    this.playCost,
    this.prizeAmount,
    @required this.analyticEvent,
  });
}
