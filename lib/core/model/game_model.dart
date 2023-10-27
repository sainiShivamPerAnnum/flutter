// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:felloapp/core/model/helper_model.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:flutter/material.dart';
import 'package:felloapp/util/styles/ui_constants.dart';

class GameModel {
  final String? id;
  final String? route;
  final String? gameUri;
  final int? playCost;
  final Color? shadowColor;
  final String? event;
  final String? gameName;
  final bool? isGOW;
  final int? prizeAmount;
  final int? order;
  final bool? isTrending;
  final String? code;
  final String? gameCode;
  final String? thumbnailUri;
  final String? analyticEvent;
  final String? icon;
  final String? description;
  final String? walkThroughUri;
  final String? highLight;
  final String? rewardCriteria;

  static final helper = HelperModel<GameModel>(
    (map) => GameModel.fromMap(map),
  );
  GameModel(
      {this.id,
      this.gameName,
      this.gameUri,
      this.thumbnailUri,
      this.playCost,
      this.prizeAmount,
      this.shadowColor,
      this.route,
      this.rewardCriteria,
      this.event,
      this.isGOW,
      this.order,
      this.isTrending,
      this.highLight,
      this.walkThroughUri,
      this.gameCode,
      this.code,
      this.analyticEvent,
      this.icon,
      this.description});

  GameModel copyWith(
      {String? gameName,
      String? tag,
      String? gameUri,
      String? thumbnailUri,
      PageConfiguration? pageConfig,
      String? playCost,
      String? prizeAmount,
      String? analyticEvent,
      Color? shadowColor,
      String? route,
      String? gameCode,
      String? code,
      String? icon,
      String? description}) {
    return GameModel(
        id: id ?? id,
        gameUri: gameUri ?? this.gameUri,
        gameName: gameName ?? this.gameName,
        thumbnailUri: thumbnailUri ?? this.thumbnailUri,
        playCost: playCost as int? ?? this.playCost,
        prizeAmount: prizeAmount as int? ?? this.prizeAmount,
        analyticEvent: analyticEvent ?? this.analyticEvent,
        shadowColor: shadowColor ?? this.shadowColor,
        route: route ?? this.route,
        gameCode: gameCode ?? this.gameCode,
        code: code ?? this.code,
        isGOW: isGOW ?? isGOW,
        order: order ?? order,
        isTrending: isTrending ?? isTrending,
        event: event ?? event,
        icon: icon ?? this.icon,
        rewardCriteria: rewardCriteria ?? rewardCriteria,
        description: description ?? this.description);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'gameName': gameName,
      'gameUri': gameUri,
      'thumbnailUri': thumbnailUri,
      'playCost': playCost,
      'prizeAmount': prizeAmount,
      'shadowColor': shadowColor!.value,
      'route': route,
      'event': event,
      'isGOW': isGOW,
      'order': order,
      'isTrending': isTrending,
      'gameCode': gameCode,
      'code': code,
      'analyticEvent': analyticEvent,
      'icon': icon,
      'description': description
    };
  }

  factory GameModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return GameModel(
        id: map['id'] ?? '',
        gameName: map['gameName'] ?? '',
        gameUri: map['gameUri'] ?? '',
        thumbnailUri: map['thumbnailUri'] ?? '',
        playCost: map['playCost'] ?? 0,
        prizeAmount: map['prizeAmount'] ?? 0,
        analyticEvent: map['analyticEvent'] ?? '',
        shadowColor: (map['shadowColor'] ?? '#000000').toString().toColor(),
        route: map['route'] ?? '',
        gameCode: map['gameCode'] ?? '',
        code: map['code'] ?? '',
        isGOW: map['isGOW'] ?? false,
        order: map['order'] ?? 0,
        icon: map['icon'] ?? '',
        isTrending: map['isTrending'] ?? false,
        highLight: map['highlight'] ?? '',
        walkThroughUri: map['walkthroughUri'] ?? '',
        event: map['event'] ?? '',
        rewardCriteria: map["rewardCriteria"] ?? "",
        description: map['description'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory GameModel.fromJson(String source) =>
      GameModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GameModel(id: $id, gameUri: $gameUri gameName: $gameName, thumbnailUri: $thumbnailUri, playCost: $playCost, prizeAmount: $prizeAmount, shadowColor: $shadowColor, route: $route, event: $event, isGOW: $isGOW, order: $order, isTrending: $isTrending, gameCode: $gameCode, code: $code, analyticEvent: $analyticEvent, icon: $icon, description: $description)';
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
        other.icon == icon &&
        other.analyticEvent == analyticEvent &&
        other.description == description;
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
        icon.hashCode ^
        gameCode.hashCode ^
        code.hashCode ^
        analyticEvent.hashCode ^
        description.hashCode;
  }
}
