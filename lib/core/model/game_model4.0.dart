// To parse this JSON data, do
//
//     final newGameModel = newGameModelFromJson(jsonString);

import 'dart:convert';

NewGameModel newGameModelFromJson(String str) =>
    NewGameModel.fromJson(json.decode(str));

String newGameModelToJson(NewGameModel data) => json.encode(data.toJson());

class NewGameModel {
  NewGameModel({
    this.message,
    this.data,
  });

  String message;
  Data data;

  factory NewGameModel.fromJson(Map<String, dynamic> json) => NewGameModel(
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    this.status,
    this.games,
  });

  bool status;
  List<GameData> games;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        status: json["status"],
        games:
            List<GameData>.from(json["games"].map((x) => GameData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "games": List<dynamic>.from(games.map((x) => x.toJson())),
      };
}

class GameData {
  GameData({
    this.id,
    this.order,
    this.route,
    this.thumbnailUri,
    this.shadowColor,
    this.code,
    this.prizeAmount,
    this.event,
    this.playCost,
    this.gameName,
    this.isGOW,
    this.isTrending,
  });

  String id;
  int order;
  String route;
  String thumbnailUri;
  String shadowColor;
  String code;
  int prizeAmount;
  String event;
  int playCost;
  String gameName;
  bool isGOW;
  bool isTrending;

  factory GameData.fromJson(Map<String, dynamic> json) => GameData(
        id: json["id"],
        order: json["order"],
        route: json["route"],
        thumbnailUri: json["thumbnailUri"],
        shadowColor: json["shadowColor"],
        code: json["code"],
        prizeAmount: json["prizeAmount"],
        event: json["event"],
        playCost: json["playCost"],
        gameName: json["gameName"],
        isGOW: json["isGOW"],
        isTrending: json["isTrending"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order": order,
        "route": route,
        "thumbnailUri": thumbnailUri,
        "shadowColor": shadowColor,
        "code": code,
        "prizeAmount": prizeAmount,
        "event": event,
        "playCost": playCost,
        "gameName": gameName,
        "isGOW": isGOW,
        "isTrending": isTrending,
      };

  String toString() {
    return "game name: $gameName";
  }
}
