// To parse this JSON data, do
//
//     final matchesModel = matchesModelFromJson(jsonString);

import 'dart:convert';

MatchesModel matchesModelFromJson(String str) =>
    MatchesModel.fromJson(json.decode(str));

String matchesModelToJson(MatchesModel data) => json.encode(data.toJson());

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

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };

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
  });

  final String? id;
  final Map<String, int>? currentScore;
  final DateTime? endsAt;
  final String? id3P;
  final String? matchTitle;
  final String? scheduledTaskId;
  final DateTime? startsAt;
  final String? status;
  final List<String>? teams;

  MatchData copyWith({
    String? id,
    Map<String, int>? currentScore,
    DateTime? endsAt,
    String? id3P,
    String? matchTitle,
    String? scheduledTaskId,
    DateTime? startsAt,
    String? status,
    List<String>? teams,
  }) =>
      MatchData(
        id: id ?? this.id,
        currentScore: currentScore ?? this.currentScore,
        endsAt: endsAt ?? this.endsAt,
        id3P: id3P ?? this.id3P,
        matchTitle: matchTitle ?? this.matchTitle,
        scheduledTaskId: scheduledTaskId ?? this.scheduledTaskId,
        startsAt: startsAt ?? this.startsAt,
        status: status ?? this.status,
        teams: teams ?? this.teams,
      );

  factory MatchData.fromJson(Map<String, dynamic> json) => MatchData(
        id: json["_id"],
        currentScore: Map.from(json["currentScore"]!)
            .map((k, v) => MapEntry<String, int>(k, v)),
        endsAt: json["endsAt"] == null ? null : DateTime.parse(json["endsAt"]),
        id3P: json["id3P"],
        matchTitle: json["matchTitle"],
        scheduledTaskId: json["scheduledTaskId"],
        startsAt:
            json["startsAt"] == null ? null : DateTime.parse(json["startsAt"]),
        status: json["status"],
        teams: json["teams"] == null
            ? []
            : List<String>.from(json["teams"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "currentScore": Map.from(currentScore!)
            .map((k, v) => MapEntry<String, dynamic>(k, v)),
        "endsAt": endsAt?.toIso8601String(),
        "id3P": id3P,
        "matchTitle": matchTitle,
        "scheduledTaskId": scheduledTaskId,
        "startsAt": startsAt?.toIso8601String(),
        "status": status,
        "teams": teams == null ? [] : List<dynamic>.from(teams!.map((x) => x)),
      };

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
          teams == other.teams;

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
      teams.hashCode;
}
