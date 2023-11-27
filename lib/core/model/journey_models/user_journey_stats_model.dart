// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserJourneyStatsModel {
  final int? page;
  final int? level;
  final int? mlIndex;
  final String? mlId;
  final String? prizeSubtype;
  final int? skipCount;
  final String version;
  UserJourneyStatsModel(
      {required this.page,
      required this.level,
      required this.mlIndex,
      required this.mlId,
      required this.prizeSubtype,
      required this.skipCount,
      required this.version});

  UserJourneyStatsModel copyWith(
      {int? page,
      int? level,
      int? mlIndex,
      String? mlId,
      String? nextPrizeSubtype,
      String? version,
      int? skipCount}) {
    return UserJourneyStatsModel(
        page: page ?? this.page,
        version: version ?? this.version,
        level: level ?? this.level,
        mlIndex: mlIndex ?? this.mlIndex,
        mlId: mlId ?? this.mlId,
        prizeSubtype: nextPrizeSubtype ?? prizeSubtype,
        skipCount: skipCount ?? this.skipCount);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'page': page,
      'level': level,
      'mlIndex': mlIndex,
      'mlId': mlId,
      'prizeSubtype': prizeSubtype,
      "skipCount": skipCount
    };
  }

  factory UserJourneyStatsModel.fromMap(Map<String, dynamic> map) {
    return UserJourneyStatsModel(
        page: map['page'] as int?,
        level: map['level'] as int?,
        mlIndex: map['mlIndex'] as int?,
        mlId: map['mlId'] as String?,
        skipCount: map["skipCount"] as int?,
        prizeSubtype: map['prizeSubtype'] as String?,
        version: map['version'] ?? 'v1');
  }

  String toJson() => json.encode(toMap());

  factory UserJourneyStatsModel.fromJson(String source) =>
      UserJourneyStatsModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserJourneyStatsModel(page: $page, level: $level, mlIndex: $mlIndex, mlId: $mlId, nextPrizeSubtype: $prizeSubtype)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserJourneyStatsModel &&
        other.page == page &&
        other.level == level &&
        other.mlIndex == mlIndex &&
        other.mlId == mlId &&
        other.prizeSubtype == prizeSubtype;
  }

  @override
  int get hashCode {
    return page.hashCode ^
        level.hashCode ^
        mlIndex.hashCode ^
        mlId.hashCode ^
        prizeSubtype.hashCode;
  }
}
