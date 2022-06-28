import 'dart:convert';
import 'package:felloapp/core/model/tambola_board_model.dart';
import 'package:felloapp/core/model/timestamp_model.dart';
import 'package:flutter/foundation.dart';

import 'helper_model.dart';

class TambolaModel {
  final String id;
  final int matchCount;
  final String val;
  final int weekCode;
  final List<String> matches;
  final TimestampModel assignedTime;
  static final helper =
      HelperModel<TambolaModel>((map) => TambolaModel.fromMap(map));
  final TambolaBoard board;

  TambolaModel({
    @required this.id,
    @required this.matchCount,
    @required this.val,
    @required this.weekCode,
    @required this.matches,
    @required this.assignedTime,
    @required this.board,
  });

  TambolaModel copyWith({
    String id,
    int matchCount,
    String val,
    int weekCode,
    List<String> matches,
    TimestampModel assignedTime,
  }) {
    return TambolaModel(
      id: id ?? this.id,
      matchCount: matchCount ?? this.matchCount,
      val: val ?? this.val,
      weekCode: weekCode ?? this.weekCode,
      matches: matches ?? this.matches,
      assignedTime: assignedTime ?? this.assignedTime,
      board: board ?? this.board,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'matchCount': matchCount,
      'val': val,
      'weekCode': weekCode,
      'matches': matches,
      'assignedTime': assignedTime.toMap(),
    };
  }

  factory TambolaModel.fromMap(Map<String, dynamic> map) {
    return TambolaModel(
      id: map['id'] ?? 0,
      matchCount: map['matchCount'] ?? 0,
      val: map['val'] ?? '',
      weekCode: map['week_code'] ?? 0,
      matches: List<String>.from(map['matches'] ?? []),
      assignedTime: TimestampModel.fromMap(map['assigned_time']),
      board: TambolaBoard.fromMap(map),
    );
  }

  String toJson() => json.encode(toMap());

  factory TambolaModel.fromJson(String source) =>
      TambolaModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TambolaModel(id: $id, matchCount: $matchCount, val: $val, weekCode: $weekCode, matches: $matches, assignedTime: $assignedTime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TambolaModel &&
        other.id == id &&
        other.matchCount == matchCount &&
        other.val == val &&
        other.weekCode == weekCode &&
        listEquals(other.matches, matches) &&
        other.assignedTime == assignedTime;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        matchCount.hashCode ^
        val.hashCode ^
        weekCode.hashCode ^
        matches.hashCode ^
        assignedTime.hashCode;
  }
}
