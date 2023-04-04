// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:felloapp/core/model/helper_model.dart';
import 'package:felloapp/core/model/timestamp_model.dart';

class MatchWinnersLeaderboardItemModel {
  final String uid;
  final String uname;
  final int? score;
  final int? amt;
  final int? flc;
  final int? tt;
  final TimestampModel timestamp;
  MatchWinnersLeaderboardItemModel({
    required this.uid,
    required this.uname,
    required this.score,
    required this.amt,
    required this.flc,
    required this.tt,
    required this.timestamp,
  });

  static final helper = HelperModel<MatchWinnersLeaderboardItemModel>(
      MatchWinnersLeaderboardItemModel.fromMap);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'uname': uname,
      'score': score ?? 0,
      'amt': amt ?? 0,
      'flc': flc ?? 0,
      'tt': tt ?? 0,
      'timestamp': timestamp.toMap(),
    };
  }

  factory MatchWinnersLeaderboardItemModel.fromMap(Map<String, dynamic> map) {
    return MatchWinnersLeaderboardItemModel(
      uid: map['uid'] as String,
      uname: map['uname'] as String,
      score: map['score'] as int,
      amt: map['amt'] as int,
      flc: map['flc'] as int,
      tt: map['tt'] as int,
      timestamp: TimestampModel.fromMap(map['timestamp']),
    );
  }

  String toJson() => json.encode(toMap());

  factory MatchWinnersLeaderboardItemModel.fromJson(String source) =>
      MatchWinnersLeaderboardItemModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MatchWinnersLeaderboardItemModel(uid: $uid, uname: $uname, score: $score, amt: $amt, flc: $flc, tt: $tt, timestamp: $timestamp)';
  }

  @override
  bool operator ==(covariant MatchWinnersLeaderboardItemModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.uname == uname &&
        other.score == score &&
        other.amt == amt &&
        other.flc == flc &&
        other.tt == tt &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        uname.hashCode ^
        score.hashCode ^
        amt.hashCode ^
        flc.hashCode ^
        tt.hashCode ^
        timestamp.hashCode;
  }
}
