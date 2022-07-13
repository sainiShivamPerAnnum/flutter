// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/helper_model.dart';
import 'package:flutter/material.dart';

import 'package:felloapp/navigator/router/ui_pages.dart';

class GameModel {
  final String id;
  final String route;
  final int playCost;
  final Color shadowColor;
  final String event;
  final String gameName;
  final bool isGOW;
  final int prizeAmount;
  final int order;
  final bool isTrending;
  final String code;
  final String gameCode;
  final String thumbnailUri;
  final String analyticEvent;

  static final helper = HelperModel<GameModel>(
    (map) => GameModel.fromMap(map),
  );
  GameModel({
    this.id,
    this.gameName,
    this.thumbnailUri,
    this.playCost,
    this.prizeAmount,
    this.shadowColor,
    this.route,
    this.event,
    this.isGOW,
    this.order,
    this.isTrending,
    this.gameCode,
    this.code,
    this.analyticEvent,
  });

  GameModel copyWith({
    String gameName,
    String tag,
    String thumbnailUri,
    PageConfiguration pageConfig,
    String playCost,
    String prizeAmount,
    String analyticEvent,
    Color shadowColor,
    String route,
    String gameCode,
    String code,
  }) {
    return GameModel(
      id: id ?? this.id,
      gameName: gameName ?? this.gameName,
      thumbnailUri: thumbnailUri ?? this.thumbnailUri,
      playCost: playCost ?? this.playCost,
      prizeAmount: prizeAmount ?? this.prizeAmount,
      analyticEvent: analyticEvent ?? this.analyticEvent,
      shadowColor: shadowColor ?? this.shadowColor,
      route: route ?? this.route,
      gameCode: gameCode ?? this.gameCode,
      code: code ?? this.code,
      isGOW: isGOW ?? this.isGOW,
      order: order ?? this.order,
      isTrending: isTrending ?? this.isTrending,
      event: event ?? this.event,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'gameName': gameName,
      'thumbnailUri': thumbnailUri,
      'playCost': playCost,
      'prizeAmount': prizeAmount,
      'shadowColor': shadowColor.value,
      'route': route,
      'event': event,
      'isGOW': isGOW,
      'order': order,
      'isTrending': isTrending,
      'gameCode': gameCode,
      'code': code,
      'analyticEvent': analyticEvent,
    };
  }

  factory GameModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return GameModel(
      id: map['id'],
      gameName: map['gameName'],
      thumbnailUri: map['thumbnailUri'],
      playCost: map['playCost'],
      prizeAmount: map['prizeAmount'],
      analyticEvent: map['analyticEvent'],
      shadowColor: BaseUtil.fromColorString(map['shadowColor']),
      route: map['route'],
      gameCode: map['gameCode'],
      code: map['code'],
      isGOW: map['isGOW'],
      order: map['order'],
      isTrending: map['isTrending'],
      event: map['event'],
    );
  }

  String toJson() => json.encode(toMap());

  factory GameModel.fromJson(
          String source, PageConfiguration pageConfiguration) =>
      GameModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GameModel(id: $id, gameName: $gameName, thumbnailUri: $thumbnailUri, playCost: $playCost, prizeAmount: $prizeAmount, shadowColor: $shadowColor, route: $route, event: $event, isGOW: $isGOW, order: $order, isTrending: $isTrending, gameCode: $gameCode, code: $code, analyticEvent: $analyticEvent)';
  }

  @override
  bool operator ==(covariant GameModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.gameName == gameName &&
        other.thumbnailUri == thumbnailUri &&
        other.playCost == playCost &&
        other.prizeAmount == prizeAmount &&
        other.shadowColor == shadowColor &&
        other.route == route &&
        other.event == event &&
        other.isGOW == isGOW &&
        other.order == order &&
        other.isTrending == isTrending &&
        other.gameCode == gameCode &&
        other.code == code &&
        other.analyticEvent == analyticEvent;
  }

  @override
  int get hashCode {
    return gameName.hashCode ^
        thumbnailUri.hashCode ^
        playCost.hashCode ^
        prizeAmount.hashCode ^
        shadowColor.hashCode ^
        route.hashCode ^
        event.hashCode ^
        isGOW.hashCode ^
        order.hashCode ^
        isTrending.hashCode ^
        gameCode.hashCode ^
        code.hashCode ^
        analyticEvent.hashCode;
  }
}
