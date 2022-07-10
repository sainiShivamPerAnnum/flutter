// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserJourneyStatsModel {
  final int page;
  final int level;
  final int mlIndex;
  final String mlId;
  final String nextPrizeSubtype;
  UserJourneyStatsModel({
    @required this.page,
    @required this.level,
    @required this.mlIndex,
    @required this.mlId,
    @required this.nextPrizeSubtype,
  });

  UserJourneyStatsModel copyWith({
    int page,
    int level,
    int mlIndex,
    String mlId,
    String nextPrizeSubtype,
  }) {
    return UserJourneyStatsModel(
      page: page ?? this.page,
      level: level ?? this.level,
      mlIndex: mlIndex ?? this.mlIndex,
      mlId: mlId ?? this.mlId,
      nextPrizeSubtype: nextPrizeSubtype ?? this.nextPrizeSubtype,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'page': page,
      'level': level,
      'mlIndex': mlIndex,
      'mlId': mlId,
      'nextPrizeSubtype': nextPrizeSubtype,
    };
  }

  factory UserJourneyStatsModel.fromMap(Map<String, dynamic> map) {
    return UserJourneyStatsModel(
      page: map['page'] as int,
      level: map['level'] as int,
      mlIndex: map['mlIndex'] as int,
      mlId: map['mlId'] as String,
      nextPrizeSubtype: map['nextPrizeSubtype'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserJourneyStatsModel.fromJson(String source) =>
      UserJourneyStatsModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserJourneyStatsModel(page: $page, level: $level, mlIndex: $mlIndex, mlId: $mlId, nextPrizeSubtype: $nextPrizeSubtype)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserJourneyStatsModel &&
        other.page == page &&
        other.level == level &&
        other.mlIndex == mlIndex &&
        other.mlId == mlId &&
        other.nextPrizeSubtype == nextPrizeSubtype;
  }

  @override
  int get hashCode {
    return page.hashCode ^
        level.hashCode ^
        mlIndex.hashCode ^
        mlId.hashCode ^
        nextPrizeSubtype.hashCode;
  }
}
