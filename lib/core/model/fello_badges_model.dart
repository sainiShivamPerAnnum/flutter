// To parse this JSON data, do
//
//     final felloBadgesModel = felloBadgesModelFromJson(jsonString);

import 'dart:convert';

FelloBadgesModel felloBadgesModelFromJson(String str) =>
    FelloBadgesModel.fromJson(json.decode(str));

String felloBadgesModelToJson(FelloBadgesModel data) =>
    json.encode(data.toJson());

class FelloBadgesModel {
  final String? message;
  final FelloBadgesData? data;

  FelloBadgesModel({
    this.message,
    this.data,
  });

  factory FelloBadgesModel.fromJson(Map<String, dynamic> json) =>
      FelloBadgesModel(
        message: json["message"],
        data: json["data"] == null
            ? null
            : FelloBadgesData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data?.toJson(),
      };
}

class FelloBadgesData {
  final String? title;
  final String? titleColor;
  final int? currentLevel;
  final List<LevelDetails>? levels;
  final SuperFelloWorks? superFelloWorks;

  FelloBadgesData(
      {this.title,
      this.levels,
      this.superFelloWorks,
      this.currentLevel,
      this.titleColor});

  factory FelloBadgesData.fromJson(Map<String, dynamic> json) =>
      FelloBadgesData(
        title: json["title"],
        currentLevel: json["currentLevel"],
        titleColor: json["titleColor"],
        levels: json["levels"] == null
            ? []
            : List<LevelDetails>.from(
                json["levels"]!.map((x) => LevelDetails.fromJson(x))),
        superFelloWorks: json["superFelloWorks"] == null
            ? null
            : SuperFelloWorks.fromJson(json["superFelloWorks"]),
      );

  Map<String, dynamic> toJson() =>
      {
        "title": title,
        "titleColor": titleColor,
        "currentLevel": currentLevel,
        "levels": levels == null
            ? []
            : List<dynamic>.from(levels!.map((x) => x.toJson())),
        "superFelloWorks": superFelloWorks?.toJson(),
      };
}

class LevelDetails {
  final String? badgeUrl;
  final List<String>? benefits;
  final int? badgeLevel;
  final bool? isCompleted;
  final List<LvlDatum>? lvlData;

  LevelDetails({
    this.badgeUrl,
    this.benefits,
    this.badgeLevel,
    this.isCompleted,
    this.lvlData,
  });

  factory LevelDetails.fromJson(Map<String, dynamic> json) => LevelDetails(
        badgeUrl: json["badgeUrl"],
        benefits: json["benefits"] == null
            ? []
            : List<String>.from(json["benefits"]!.map((x) => x)),
        badgeLevel: json["badgeLevel"],
        isCompleted: json["isCompleted"],
        lvlData: json["lvl_data"] == null
            ? []
            : List<LvlDatum>.from(
                json["lvl_data"]!.map((x) => LvlDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() =>
      {
        "badgeUrl": badgeUrl,
        "benefits":
            benefits == null ? [] : List<dynamic>.from(benefits!.map((x) => x)),
        "badgeLevel": badgeLevel,
        "isCompleted": isCompleted,
        "lvl_data": lvlData == null
            ? []
            : List<dynamic>.from(lvlData!.map((x) => x.toJson())),
      };
}

class LvlDatum {
  final int? value;
  final int? achieve;
  final String? title;
  final String? barHeading;
  final String? badgeUrl;
  final String? barheading;

  LvlDatum({
    this.value,
    this.achieve,
    this.title,
    this.barHeading,
    this.badgeUrl,
    this.barheading,
  });

  factory LvlDatum.fromJson(Map<String, dynamic> json) => LvlDatum(
        value: json["value"],
        achieve: json["achieve"],
        title: json["title"],
        barHeading: json["barHeading"],
        badgeUrl: json["badgeUrl"],
        barheading: json["barheading"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "achieve": achieve,
        "title": title,
        "barHeading": barHeading,
        "badgeUrl": badgeUrl,
        "barheading": barheading,
      };
}

class SuperFelloWorks {
  final String? title;
  final List<String>? list;

  SuperFelloWorks({
    this.title,
    this.list,
  });

  factory SuperFelloWorks.fromJson(Map<String, dynamic> json) =>
      SuperFelloWorks(
        title: json["title"],
        list: json["list"] == null
            ? []
            : List<String>.from(json["list"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "list": list == null ? [] : List<dynamic>.from(list!.map((x) => x)),
      };
}
