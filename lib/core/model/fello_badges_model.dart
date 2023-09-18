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
  final int? level;
  final Beginner? beginner;
  final Intermediate? intermediate;
  final Beginner? superFello;
  final SuperFelloWorks? superFelloWorks;

  FelloBadgesData({
    this.level,
    this.beginner,
    this.intermediate,
    this.superFello,
    this.superFelloWorks,
  });

  factory FelloBadgesData.fromJson(Map<String, dynamic> json) =>
      FelloBadgesData(
        level: json["level"],
        beginner: json["beginner"] == null
            ? null
            : Beginner.fromJson(json["beginner"]),
        intermediate: json["intermediate"] == null
            ? null
            : Intermediate.fromJson(json["intermediate"]),
        superFello: json["superFello"] == null
            ? null
            : Beginner.fromJson(json["superFello"]),
        superFelloWorks: json["superFelloWorks"] == null
            ? null
            : SuperFelloWorks.fromJson(json["superFelloWorks"]),
      );

  Map<String, dynamic> toJson() => {
        "level": level,
        "beginner": beginner?.toJson(),
        "intermediate": intermediate?.toJson(),
        "superFello": superFello?.toJson(),
        "superFelloWorks": superFelloWorks?.toJson(),
      };
}

class Beginner {
  final String? title;
  final String? badgeUrl;
  final List<String>? benefits;
  final List<BeginnerLvlDatum>? lvlData;

  Beginner({
    this.title,
    this.badgeUrl,
    this.benefits,
    this.lvlData,
  });

  factory Beginner.fromJson(Map<String, dynamic> json) => Beginner(
        title: json["title"],
        badgeUrl: json["badgeUrl"],
        benefits: json["benefits"] == null
            ? []
            : List<String>.from(json["benefits"]!.map((x) => x)),
        lvlData: json["lvl_data"] == null
            ? []
            : List<BeginnerLvlDatum>.from(
                json["lvl_data"]!.map((x) => BeginnerLvlDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "badgeUrl": badgeUrl,
        "benefits":
            benefits == null ? [] : List<dynamic>.from(benefits!.map((x) => x)),
        "lvl_data": lvlData == null
            ? []
            : List<dynamic>.from(lvlData!.map((x) => x.toJson())),
      };
}

class BeginnerLvlDatum {
  final int? smartSaver;
  final int? achieve;
  final String? title;
  final String? barHeading;
  final int? ticketWiz;
  final int? achiev;
  final int? referral;

  BeginnerLvlDatum({
    this.smartSaver,
    this.achieve,
    this.title,
    this.barHeading,
    this.ticketWiz,
    this.achiev,
    this.referral,
  });

  factory BeginnerLvlDatum.fromJson(Map<String, dynamic> json) =>
      BeginnerLvlDatum(
        smartSaver: json["smartSaver"],
        achieve: json["achieve"],
        title: json["title"],
        barHeading: json["barHeading"],
        ticketWiz: json["ticketWiz"],
        achiev: json["achiev"],
        referral: json["referral"],
      );

  Map<String, dynamic> toJson() => {
        "smartSaver": smartSaver,
        "achieve": achieve,
        "title": title,
        "barHeading": barHeading,
        "ticketWiz": ticketWiz,
        "achiev": achiev,
        "referral": referral,
      };
}

class Intermediate {
  final String? title;
  final String? badgeUrl;
  final List<String>? benefits;
  final List<IntermediateLvlDatum>? lvlData;

  Intermediate({
    this.title,
    this.badgeUrl,
    this.benefits,
    this.lvlData,
  });

  factory Intermediate.fromJson(Map<String, dynamic> json) => Intermediate(
        title: json["title"],
        badgeUrl: json["badgeUrl"],
        benefits: json["benefits"] == null
            ? []
            : List<String>.from(json["benefits"]!.map((x) => x)),
        lvlData: json["lvl_data"] == null
            ? []
            : List<IntermediateLvlDatum>.from(
                json["lvl_data"]!.map((x) => IntermediateLvlDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "badgeUrl": badgeUrl,
        "benefits":
            benefits == null ? [] : List<dynamic>.from(benefits!.map((x) => x)),
        "lvl_data": lvlData == null
            ? []
            : List<dynamic>.from(lvlData!.map((x) => x.toJson())),
      };
}

class IntermediateLvlDatum {
  final int? proSaver;
  final int? achieve;
  final String? title;
  final String? barHeading;
  final int? ticketWiz;
  final int? achiev;
  final int? playQuiz;
  final String? barheading;

  IntermediateLvlDatum({
    this.proSaver,
    this.achieve,
    this.title,
    this.barHeading,
    this.ticketWiz,
    this.achiev,
    this.playQuiz,
    this.barheading,
  });

  factory IntermediateLvlDatum.fromJson(Map<String, dynamic> json) =>
      IntermediateLvlDatum(
        proSaver: json["proSaver"],
        achieve: json["achieve"],
        title: json["title"],
        barHeading: json["barHeading"],
        ticketWiz: json["ticketWiz"],
        achiev: json["achiev"],
        playQuiz: json["playQuiz"],
        barheading: json["barheading"],
      );

  Map<String, dynamic> toJson() => {
        "proSaver": proSaver,
        "achieve": achieve,
        "title": title,
        "barHeading": barHeading,
        "ticketWiz": ticketWiz,
        "achiev": achiev,
        "playQuiz": playQuiz,
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
