class GameDataModel {
  GameDataModel({
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
    this.gameCode,
    this.isGOW,
    this.isTrending,
  });

  String id;
  int order;
  String route;
  String thumbnailUri;
  String gameCode;
  String shadowColor;
  String code;
  int prizeAmount;
  String event;
  int playCost;
  String gameName;
  bool isGOW;
  bool isTrending;

  factory GameDataModel.fromJson(Map<String, dynamic> json) => GameDataModel(
        id: json["id"],
        order: json["order"],
        route: json["route"],
        gameCode: json['gameCode'],
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
        'gameCode': gameCode,
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
