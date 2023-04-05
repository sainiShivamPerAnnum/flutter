// ignore_for_file: public_member_api_docs, sort_constructors_first
// To parse this JSON data, do
//
//     final matchesModel = matchesModelFromJson(jsonString);

import 'dart:convert';

import 'package:felloapp/core/model/timestamp_model.dart';

MatchesModel matchesModelFromJson(String str) =>
    MatchesModel.fromJson(json.decode(str));

class MatchesModel {
  MatchesModel({
    this.message,
    this.data,
  });

  final String? message;
  final List<MatchData>? data;

  MatchesModel copyWith({
    String? message,
    List<MatchData>? data,
  }) =>
      MatchesModel(
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory MatchesModel.fromJson(Map<String, dynamic> json) => MatchesModel(
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<MatchData>.from(
                json["data"]!.map((x) => MatchData.fromJson(x))),
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MatchesModel &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          data == other.data;

  @override
  int get hashCode => message.hashCode ^ data.hashCode;
}

class MatchData {
  MatchData({
    this.id,
    this.currentScore,
    this.endsAt,
    this.id3P,
    this.matchTitle,
    this.scheduledTaskId,
    this.startsAt,
    this.status,
    this.teams,
    this.teamLogoMap,
    this.headsUpText,
    this.verdictText,
    this.matchStats,
    this.target,
  });

  final String? id;
  final Map<String, int>? currentScore;
  final TimestampModel? endsAt;
  final String? id3P;
  final String? matchTitle;
  final String? scheduledTaskId;
  final TimestampModel? startsAt;
  final String? status;
  final List<String>? teams;
  final Map<String, String>? teamLogoMap;
  final String? headsUpText;
  final String? verdictText;
  final MatchStats? matchStats;
  final int? target;

  factory MatchData.fromJson(Map<String, dynamic> json) => MatchData(
        id: json["_id"],
        currentScore: Map.from(json["currentScore"]!)
            .map((k, v) => MapEntry<String, int>(k, v)),
        endsAt: TimestampModel.fromMap(json['endsAt']),
        id3P: json["id3P"],
        matchTitle: json["matchTitle"],
        scheduledTaskId: json["scheduledTaskId"],
        startsAt: TimestampModel.fromMap(json['startsAt']),
        status: json["status"],
        teams: json["teams"] == null
            ? []
            : List<String>.from(json["teams"]!.map((x) => x)),
        teamLogoMap: Map.from(json["teamLogoMap"]!)
            .map((k, v) => MapEntry<String, String>(k, v)),
        headsUpText: json["headsUpText"],
        verdictText: json['verdictText'],
        matchStats: MatchStats.fromMap(json['matchStats'] ?? {}),
        target: json['target'] ?? 0,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MatchData &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          currentScore == other.currentScore &&
          endsAt == other.endsAt &&
          id3P == other.id3P &&
          matchTitle == other.matchTitle &&
          scheduledTaskId == other.scheduledTaskId &&
          startsAt == other.startsAt &&
          status == other.status &&
          teams == other.teams &&
          headsUpText == other.headsUpText;

  @override
  int get hashCode =>
      id.hashCode ^
      currentScore.hashCode ^
      endsAt.hashCode ^
      id3P.hashCode ^
      matchTitle.hashCode ^
      scheduledTaskId.hashCode ^
      startsAt.hashCode ^
      status.hashCode ^
      teams.hashCode ^
      headsUpText.hashCode;
}

class MatchStats {
  int count;
  bool didWon;
  MatchStats({
    required this.count,
    required this.didWon,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'count': count,
      'didWon': didWon,
    };
  }

  factory MatchStats.fromMap(Map<String, dynamic> map) {
    return MatchStats(
      count: map['count'] ?? 0,
      didWon: map['didWon'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory MatchStats.fromJson(String source) =>
      MatchStats.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'MatchStats(count: $count, didWon: $didWon)';

  @override
  bool operator ==(covariant MatchStats other) {
    if (identical(this, other)) return true;

    return other.count == count && other.didWon == didWon;
  }

  @override
  int get hashCode => count.hashCode ^ didWon.hashCode;
}
