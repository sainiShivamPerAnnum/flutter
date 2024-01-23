import 'dart:convert';

import 'package:felloapp/core/model/helper_model.dart';
import 'package:felloapp/core/model/timestamp_model.dart';
import 'package:felloapp/feature/tambola/src/models/tambola_best_tickets_model.dart';

class WinnersModel {
  String? id;
  String? freq;
  List<Winners>? winners;
  String? code;
  TimestampModel? timestamp;
  TimestampModel? createdOn;
  TimestampModel? updatedOn;
  String? gametype;
  static final helper = HelperModel<WinnersModel>(
    WinnersModel.fromMap,
  );

  WinnersModel({
    this.id,
    this.freq,
    this.winners,
    this.code,
    this.timestamp,
    this.createdOn,
    this.updatedOn,
    this.gametype,
  });

  WinnersModel copyWith({
    String? id,
    String? freq,
    List<Winners>? winners,
    String? code,
    TimestampModel? timestamp,
    TimestampModel? createdOn,
    TimestampModel? updatedOn,
    String? gametype,
  }) {
    return WinnersModel(
      id: id ?? this.id,
      freq: freq ?? this.freq,
      winners: winners ?? this.winners,
      code: code ?? this.code,
      timestamp: timestamp ?? this.timestamp,
      createdOn: createdOn ?? this.createdOn,
      updatedOn: updatedOn ?? this.updatedOn,
      gametype: gametype ?? this.gametype,
    );
  }

  WinnersModel.base() {
    id = '';
    freq = '';
    winners = [];
    code = '';
    timestamp = TimestampModel.currentTimeStamp();
    createdOn = TimestampModel.currentTimeStamp();
    updatedOn = TimestampModel.currentTimeStamp();
    gametype = '';
  }

  factory WinnersModel.fromMap(Map<String, dynamic> map) {
    return WinnersModel(
      id: map['id'] as String?,
      freq: map['freq'] as String?,
      winners: List<Winners>.from(
        (map["winners"] ?? []).map(
          (x) => Winners.fromMap(x, map['gametype']),
        ),
      ),
      code: map['code'] as String?,
      timestamp: TimestampModel.fromMap(map['timestamp']),
      createdOn: TimestampModel.fromMap(map['createdOn']),
      updatedOn: TimestampModel.fromMap(map['updatedOn']),
      gametype: map['gametype'] as String?,
    );
  }

  factory WinnersModel.fromJson(String source) =>
      WinnersModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'WinnersModel(id: $id, freq: $freq, winners: $winners, code: $code, timestamp: $timestamp, gametype: $gametype)';
  }
}

class Winners {
  final int? amount;
  final bool? isMockUser;
  final String? username;
  final int? flc;
  final String? userid;
  final String? gameType;
  final double? score;
  final String? displayScore;
  final List<TicketStatsModel>? matchMap;
  final int? ticketOwned;
  final int? totalTickets;

  Winners(
      {this.amount,
      this.isMockUser,
      this.username,
      this.flc,
      this.userid,
      this.score,
      this.gameType,
      this.matchMap,
      this.displayScore,
      this.ticketOwned,
      this.totalTickets});

  Winners copyWith(
      {int? amount,
      bool? isMockUser,
      String? username,
      int? flc,
      String? userid,
      double? score,
      String? gameType,
      List<TicketStatsModel>? matchMap,
      String? displayScore,
      int? ticketOwned,
      int? totalTickets}) {
    return Winners(
        amount: amount ?? this.amount,
        isMockUser: isMockUser ?? this.isMockUser,
        username: username ?? this.username,
        flc: flc ?? this.flc,
        userid: userid ?? this.userid,
        score: score ?? this.score,
        gameType: gameType ?? this.gameType,
        matchMap: matchMap ?? this.matchMap,
        displayScore: displayScore ?? this.displayScore,
        ticketOwned: ticketOwned ?? this.ticketOwned,
        totalTickets: totalTickets ?? this.totalTickets);
  }

  factory Winners.fromMap(Map<String, dynamic> map, String? gameType) {
    return Winners(
      amount: map['amount'] ?? 0,
      isMockUser: map['isMockUser'] ?? false,
      username: map['username'] ?? '',
      flc: map['flc'] ?? 0,
      userid: map['userid'] ?? '',
      score: (map['score'] ?? 0).toDouble(),
      gameType: gameType ?? '',
      matchMap: (map['matchMap'] != null)
          ? TicketStatsModel.parseTicketsStats(map['matchMap'])
          : TicketStatsModel.getBaseTicketsStats(),
      displayScore: map['displayScore'] ?? '',
      ticketOwned: map['totalTickets'] ?? 0,
      totalTickets: map['totalTickets'] ?? 0,
    );
  }

  factory Winners.fromJson(String source, String gameType) =>
      Winners.fromMap(json.decode(source) as Map<String, dynamic>, gameType);

  @override
  String toString() {
    return 'Winners{amount: $amount, isMockUser: $isMockUser, username: $username, flc: $flc, userid: $userid, gameType: $gameType, score: $score, displayScore: $displayScore, matchMap: $matchMap, ticketOwned: $ticketOwned}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Winners &&
          runtimeType == other.runtimeType &&
          amount == other.amount &&
          isMockUser == other.isMockUser &&
          username == other.username &&
          flc == other.flc &&
          userid == other.userid &&
          gameType == other.gameType &&
          score == other.score &&
          displayScore == other.displayScore &&
          matchMap == other.matchMap &&
          ticketOwned == other.ticketOwned &&
          totalTickets == other.totalTickets;

  @override
  int get hashCode =>
      amount.hashCode ^
      isMockUser.hashCode ^
      username.hashCode ^
      flc.hashCode ^
      userid.hashCode ^
      gameType.hashCode ^
      score.hashCode ^
      displayScore.hashCode ^
      matchMap.hashCode ^
      ticketOwned.hashCode ^
      totalTickets.hashCode;
}

class MatchMap {
  MatchMap({
    this.oneRow,
    this.twoRows,
    this.fullHouse,
    this.corners,
  });

  final int? oneRow;
  final int? twoRows;
  final int? fullHouse;
  final int? corners;

  MatchMap copyWith({
    int? oneRow,
    int? twoRows,
    int? fullHouse,
    int? corners,
  }) =>
      MatchMap(
        oneRow: oneRow ?? this.oneRow,
        twoRows: twoRows ?? this.twoRows,
        fullHouse: fullHouse ?? this.fullHouse,
        corners: corners ?? this.corners,
      );

  factory MatchMap.fromMap(Map<String, dynamic> json) => MatchMap(
        oneRow: json["oneRow"] ?? 0,
        twoRows: json["twoRows"] ?? 0,
        fullHouse: json["fullHouse"] ?? 0,
        corners: json["corners"] ?? 0,
      );

  Map<String, dynamic> toMap() => {
        "oneRow": oneRow,
        "twoRows": twoRows,
        "fullHouse": fullHouse,
        "corners": corners,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MatchMap &&
          runtimeType == other.runtimeType &&
          oneRow == other.oneRow &&
          twoRows == other.twoRows &&
          fullHouse == other.fullHouse &&
          corners == other.corners;

  @override
  int get hashCode =>
      oneRow.hashCode ^
      twoRows.hashCode ^
      fullHouse.hashCode ^
      corners.hashCode;

  @override
  String toString() {
    return 'MatchMap{oneRow: $oneRow, twoRows: $twoRows, fullHouse: $fullHouse, corners: $corners}';
  }
}
