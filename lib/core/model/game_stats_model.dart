// To parse this JSON data, do
//
//     final gameStats = gameStatsFromJson(jsonString);

import 'dart:convert';

GameStats? gameStatsFromJson(String str) =>
    GameStats.fromJson(json.decode(str));

String gameStatsToJson(GameStats? data) => json.encode(data!.toJson());

class GameStats {
  GameStats({
    required this.message,
    required this.data,
  });

  final String? message;
  final Data? data;

  factory GameStats.fromJson(Map<String, dynamic> json) => GameStats(
        message: json["message"],
        data: json.isEmpty ? null : Data.fromJson(json),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data!.toJson(),
      };
}

class Data {
  Data({
    required this.updatedOn,
    required this.gmPoolClub,
    required this.gmFootballKickoff,
    required this.gmCricketHero,
    required this.gmCandyFiesta,
    required this.gmBottleFlip,
    required this.gmBowling,
    required this.gmTambola2020,
    required this.gmKnifeHit,
    required this.gmRallyVertex,
  });

  final UpdatedOn? updatedOn;
  final Gm? gmPoolClub;
  final Gm? gmFootballKickoff;
  final Gm? gmCricketHero;
  final Gm? gmCandyFiesta;
  final Gm? gmBottleFlip;
  final Gm? gmBowling;
  final Gm? gmKnifeHit;
  final Gm? gmRallyVertex;
  final GmTambola2020? gmTambola2020;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
      updatedOn: UpdatedOn.fromJson(json["updatedOn"]),
      gmPoolClub: json["GM_POOL_CLUB"] != null
          ? Gm.fromJson(json["GM_POOL_CLUB"])
          : null,
      gmFootballKickoff: json["GM_FOOTBALL_KICKOFF"] != null
          ? Gm.fromJson(json["GM_FOOTBALL_KICKOFF"])
          : null,
      gmCricketHero: json["GM_CRICKET_HERO"] != null
          ? Gm.fromJson(json["GM_CRICKET_HERO"])
          : null,
      gmCandyFiesta: json["GM_CANDY_FIESTA"] != null
          ? Gm.fromJson(json["GM_CANDY_FIESTA"])
          : null,
      gmBottleFlip: json["GM_BOTTLE_FLIP"] != null
          ? Gm.fromJson(json["GM_BOTTLE_FLIP"])
          : null,
      gmBowling:
          json["GM_BOWLING"] != null ? Gm.fromJson(json["GM_BOWLING"]) : null,
      gmTambola2020: json["GM_TAMBOLA2020"] != null
          ? GmTambola2020.fromJson(json["GM_TAMBOLA2020"])
          : null,
      gmRallyVertex: json["GM_ROLLY_VORTEX"] != null
          ? Gm.fromJson(json["GM_ROLLY_VORTEX"])
          : null,
      gmKnifeHit: json["GM_KNIFE_HIT"] != null
          ? Gm.fromJson(json["GM_KNIFE_HIT"])
          : null);

  Map<String, dynamic> toJson() => {
        "updatedOn": updatedOn!.toJson(),
        "GM_POOL_CLUB": gmPoolClub!.toJson(),
        "GM_FOOTBALL_KICKOFF": gmFootballKickoff!.toJson(),
        "GM_CRICKET_HERO": gmCricketHero!.toJson(),
        "GM_CANDY_FIESTA": gmCandyFiesta!.toJson(),
        "GM_BOTTLE_FLIP": gmBottleFlip!.toJson(),
        "GM_BOWLING": gmBowling!.toJson(),
        "GM_TAMBOLA2020": gmTambola2020!.toJson(),
      };
}

class Gm {
  Gm(
      {required this.plays,
      required this.netScore,
      required this.topScore,
      required this.totalSeconds,
      required this.firstPlay,
      required this.streakIntervalStart,
      required this.streakIntervalEnd,
      required this.lastScore,
      required this.rewards});

  final int? plays;
  final int? netScore;
  final int? topScore;
  final int? totalSeconds;
  final UpdatedOn? firstPlay;
  final UpdatedOn? streakIntervalStart;
  final UpdatedOn? streakIntervalEnd;
  final Rewards? rewards;
  final int? lastScore;

  factory Gm.fromJson(Map<String, dynamic> json) => Gm(
      plays: json["plays"],
      netScore: json["netScore"],
      topScore: json["topScore"],
      totalSeconds: json["totalSeconds"],
      lastScore: json['lastScore'],
      firstPlay: UpdatedOn.fromJson(json["firstPlay"]),
      streakIntervalStart: UpdatedOn.fromJson(json["streakIntervalStart"]),
      streakIntervalEnd: UpdatedOn.fromJson(json["streakIntervalEnd"]),
      rewards: json["totalRewards"] != null
          ? Rewards.fomJson(json["totalRewards"])
          : null);

  Map<String, dynamic> toJson() => {
        "plays": plays,
        "netScore": netScore,
        "topScore": topScore,
        "totalSeconds": totalSeconds,
        "firstPlay": firstPlay!.toJson(),
        "streakIntervalStart": streakIntervalStart!.toJson(),
        "streakIntervalEnd": streakIntervalEnd!.toJson(),
      };
}

class Rewards {
  final int? amt;
  Rewards(this.amt);
  factory Rewards.fomJson(Map<String, dynamic> json) => Rewards(json["amt"]);
}

class UpdatedOn {
  UpdatedOn({
    required this.seconds,
    required this.nanoseconds,
  });

  final int? seconds;
  final int? nanoseconds;

  factory UpdatedOn.fromJson(Map<String, dynamic> json) => UpdatedOn(
        seconds: json["_seconds"],
        nanoseconds: json["_nanoseconds"],
      );

  Map<String, dynamic> toJson() => {
        "_seconds": seconds,
        "_nanoseconds": nanoseconds,
      };
}

class GmTambola2020 {
  GmTambola2020({
    required this.ticketCount,
  });

  final int? ticketCount;

  factory GmTambola2020.fromJson(Map<String, dynamic> json) => GmTambola2020(
        ticketCount: json["ticketCount"],
      );

  Map<String, dynamic> toJson() => {
        "ticketCount": ticketCount,
      };
}
