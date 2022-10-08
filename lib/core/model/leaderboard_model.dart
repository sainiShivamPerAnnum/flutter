// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:felloapp/core/model/scoreboard_model.dart';

import 'package:felloapp/core/model/timestamp_model.dart';

class LeaderboardModel {
  String id;
  String freq;
  String gametype;
  TimestampModel lastupdated;
  List<ScoreBoard> scoreboard;
  String code;
  LeaderboardModel({
    this.id,
    this.freq,
    this.gametype,
    this.lastupdated,
    this.scoreboard,
    this.code,
  });

  LeaderboardModel copyWith({
    String id,
    String freq,
    String gametype,
    TimestampModel lastupdated,
    List<ScoreBoard> scoreboard,
    String code,
  }) {
    return LeaderboardModel(
      id: id ?? this.id,
      freq: freq ?? this.freq,
      gametype: gametype ?? this.gametype,
      lastupdated: lastupdated ?? this.lastupdated,
      scoreboard: scoreboard ?? this.scoreboard,
      code: code ?? this.code,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'freq': freq,
      'gametype': gametype,
      'lastupdated': lastupdated.toMap(),
      'scoreboard': scoreboard,
      'code': code,
    };
  }

  factory LeaderboardModel.fromMap(Map<String, dynamic> map) {
    return LeaderboardModel(
      id: map['id'] ?? '',
      freq: map['freq'] ?? '',
      gametype: map['gametype'] ?? '',
      lastupdated: TimestampModel.fromMap(map['lastupdated']),
      scoreboard: map["scoreboard"] != null
          ? List<ScoreBoard>.from(
              map["scoreboard"].map((x) => ScoreBoard.fromMap(x)),
            )
          : [],
      code: map['code'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory LeaderboardModel.fromJson(String source) =>
      LeaderboardModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'LeaderboardModel(id: $id, freq: $freq, gametype: $gametype, lastupdated: $lastupdated, scoreboard: $scoreboard, code: $code)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is LeaderboardModel &&
        other.id == id &&
        other.freq == freq &&
        other.gametype == gametype &&
        other.lastupdated == lastupdated &&
        listEquals(other.scoreboard, scoreboard) &&
        other.code == code;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        freq.hashCode ^
        gametype.hashCode ^
        lastupdated.hashCode ^
        scoreboard.hashCode ^
        code.hashCode;
  }
}
