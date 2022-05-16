import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:flutter/material.dart';

class GameModel {
  final String gameName;
  final String tag;
  final String thumbnailUri;
  final PageConfiguration pageConfig;
  final String playCost;
  final String prizeAmount;
  final String analyticEvent;
  final Color shadowColor;
  final String route;
  final String gameCode;

  GameModel({
    this.gameName,
    this.pageConfig,
    this.tag,
    this.thumbnailUri,
    this.playCost,
    this.route,
    this.gameCode,
    this.prizeAmount,
    this.shadowColor,
    @required this.analyticEvent,
  });
}
