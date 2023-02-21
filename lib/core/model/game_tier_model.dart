import 'dart:convert';

GameTiers gameTiersFromJson(String str) => GameTiers.fromJson(json.decode(str));

String gameTiersToJson(GameTiers data) => json.encode(data.toJson());

class GameTiers {
  GameTiers({
    required this.message,
    required this.data,
  });

  final String message;
  final List<Datum?> data;

  factory GameTiers.fromJson(Map<String, dynamic> json) => GameTiers(
        message: json["message"],
        data: List<Datum?>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x?.toJson())),
      };
}

class Datum {
  Datum({
    required this.minInvestmentToUnlock,
    required this.title,
    required this.subtitle,
    required this.games,
    required this.winningSubtext,
    required this.winningText,
  });

  final double minInvestmentToUnlock;
  final String title;
  final String subtitle;
  final String winningText;
  final String winningSubtext;
  final List<GameModel?> games;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        minInvestmentToUnlock: json["minInvestmentToUnlock"] * 1.0,
        title: json["title"],
        winningSubtext: json['winningSubtext'] ?? "",
        winningText: json['winningText'] ?? "",
        subtitle: json["subtitle"],
        games: List<GameModel?>.from(json["games"].map((x) {
          if (x == null) return null;
          return GameModel.fromJson(x);
        })),
      );

  Map<String, dynamic> toJson() => {
        "minInvestmentToUnlock": minInvestmentToUnlock,
        "title": title,
        "subtitle": subtitle,
        "games": List<dynamic>.from(games.map((x) => x?.toJson())),
      };
}

class GameModel {
  GameModel({
    required this.id,
    required this.code,
    required this.description,
    required this.event,
    required this.gameCode,
    required this.gameName,
    required this.gameUri,
    required this.icon,
    required this.isGow,
    required this.isTrending,
    required this.minScoreForReward,
    required this.order,
    required this.playCost,
    required this.prizeAmount,
    required this.rewardCriteria,
    required this.route,
    required this.shadowColor,
    required this.thumbnailUri,
  });

  final String id;
  final String code;
  final String description;
  final String event;
  final String gameCode;
  final String gameName;
  final String gameUri;
  final String icon;
  final bool isGow;
  final bool isTrending;
  final int? minScoreForReward;
  final int? order;
  final int? playCost;
  final int? prizeAmount;
  final String rewardCriteria;
  final String route;
  final String shadowColor;
  final String thumbnailUri;

  factory GameModel.fromJson(Map<String, dynamic> json) => GameModel(
        id: json["_id"],
        code: json["code"],
        description: json["description"],
        event: json["event"],
        gameCode: json["gameCode"],
        gameName: json["gameName"],
        gameUri: json["gameUri"],
        icon: json["icon"],
        isGow: json["isGOW"],
        isTrending: json["isTrending"],
        minScoreForReward: json["minScoreForReward"],
        order: json["order"],
        playCost: json["playCost"],
        prizeAmount: json["prizeAmount"],
        rewardCriteria: json["rewardCriteria"],
        route: json["route"],
        shadowColor: json["shadowColor"],
        thumbnailUri: json["thumbnailUri"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "code": code,
        "description": description,
        "event": event,
        "gameCode": gameCode,
        "gameName": gameName,
        "gameUri": gameUri,
        "icon": icon,
        "isGOW": isGow,
        "isTrending": isTrending,
        "minScoreForReward": minScoreForReward,
        "order": order,
        "playCost": playCost,
        "prizeAmount": prizeAmount,
        "rewardCriteria": rewardCriteria,
        "route": route,
        "shadowColor": shadowColor,
        "thumbnailUri": thumbnailUri,
      };
}
