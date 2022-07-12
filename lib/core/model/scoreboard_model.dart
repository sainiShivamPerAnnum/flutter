// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:felloapp/core/model/timestamp_model.dart';

class ScoreBoard {
  bool isUserEligible;
  TimestampModel timestamp;
  String userid;
  String username;
  double score;
  int gameDuration, refCount;

  ScoreBoard(
      {this.isUserEligible,
      this.timestamp,
      this.userid,
      this.username,
      this.score,
      this.gameDuration,
      this.refCount});

  ScoreBoard copyWith({
    bool isUserEligible,
    TimestampModel timestamp,
    String userid,
    String username,
    double score,
    int gameDuration,
    int refCount,
  }) {
    return ScoreBoard(
      isUserEligible: isUserEligible ?? this.isUserEligible,
      timestamp: timestamp ?? this.timestamp,
      userid: userid ?? this.userid,
      username: username ?? this.username,
      score: score ?? this.score,
      gameDuration: gameDuration ?? this.gameDuration,
      refCount: refCount ?? this.refCount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isUserEligible': isUserEligible,
      'timestamp': timestamp.toMap(),
      'userid': userid,
      'username': username,
      'score': score,
      'gameDuration': gameDuration,
      'refCount': refCount,
    };
  }

  factory ScoreBoard.fromMap(Map<String, dynamic> map) {
    return ScoreBoard(
      isUserEligible: map['isUserEligible'] ?? false,
      timestamp: TimestampModel.fromMap(map['timestamp']),
      userid: map['userid'] ?? '',
      username: map['username'] ?? '',
      score: map['score'] ?? 0,
      gameDuration: map['gameDuration'] ?? 0,
      refCount: map['refCount'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ScoreBoard.fromJson(String source) =>
      ScoreBoard.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ScoreBoard(isUserEligible: $isUserEligible, timestamp: $timestamp, userid: $userid, username: $username, score: $score, gameDuration: $gameDuration, refCount: $refCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ScoreBoard &&
        other.isUserEligible == isUserEligible &&
        other.timestamp == timestamp &&
        other.userid == userid &&
        other.username == username &&
        other.score == score &&
        other.gameDuration == gameDuration &&
        other.refCount == refCount;
  }

  @override
  int get hashCode {
    return isUserEligible.hashCode ^
        timestamp.hashCode ^
        userid.hashCode ^
        username.hashCode ^
        score.hashCode ^
        gameDuration.hashCode ^
        refCount.hashCode;
  }
}
