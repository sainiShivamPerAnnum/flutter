// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:felloapp/core/model/timestamp_model.dart';

class DailyAppCheckInEventModel {
  final String title;
  final String subtitle;
  final String postClaimMessage;
  final String streakBreakMessage;
  int currentDay;
  final int totalResetCount;
  final List<int> specialRewardPos;
  final int streakReset;
  final TimestampModel startedOn;
  final TimestampModel streakStart;
  final TimestampModel streakEnd;
  bool showStreakBreakMessage = false;
  DailyAppCheckInEventModel({
    required this.title,
    required this.subtitle,
    required this.postClaimMessage,
    required this.streakBreakMessage,
    required this.currentDay,
    required this.totalResetCount,
    required this.specialRewardPos,
    required this.streakReset,
    required this.startedOn,
    required this.streakStart,
    required this.streakEnd,
  });

  DailyAppCheckInEventModel copyWith({
    String? title,
    String? subtitle,
    String? postClaimMessage,
    String? streakBreakMessage,
    int? currentDay,
    int? totalResetCount,
    List<int>? specialRewardPos,
    int? streakReset,
    TimestampModel? startedOn,
    TimestampModel? streakStart,
    TimestampModel? streakEnd,
  }) {
    return DailyAppCheckInEventModel(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      postClaimMessage: postClaimMessage ?? this.postClaimMessage,
      streakBreakMessage: streakBreakMessage ?? this.streakBreakMessage,
      currentDay: currentDay ?? this.currentDay,
      totalResetCount: totalResetCount ?? this.totalResetCount,
      specialRewardPos: specialRewardPos ?? this.specialRewardPos,
      streakReset: streakReset ?? this.streakReset,
      startedOn: startedOn ?? this.startedOn,
      streakStart: streakStart ?? this.streakStart,
      streakEnd: streakEnd ?? this.streakEnd,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'subtitle': subtitle,
      'postClaimMessage': postClaimMessage,
      'streakBreakMessage': streakBreakMessage,
      'currentDay': currentDay,
      'totalResetCount': totalResetCount,
      'specialRewardPos': specialRewardPos,
      'streakReset': streakReset,
      'startedOn': startedOn.toMap(),
      'streakStart': streakStart.toMap(),
      'streakEnd': streakEnd.toMap(),
    };
  }

  factory DailyAppCheckInEventModel.fromMap(Map<String, dynamic> map) {
    return DailyAppCheckInEventModel(
      title: map['title'] as String,
      subtitle: map['subtitle'] as String,
      postClaimMessage: map['postClaimMessage'] as String,
      streakBreakMessage: map['streakBreakMessage'] as String,
      currentDay: (map['currentDay'] ?? -1) as int,
      totalResetCount: (map['totalResetCount'] ?? 3) as int,
      specialRewardPos:
          List<int>.from((map['specialRewardPos'].cast<int>() as List<int>)),
      streakReset: (map['streakReset'] ?? 0) as int,
      startedOn: TimestampModel.fromMap(map['startedOn']),
      streakStart: TimestampModel.fromMap(map['streakStart']),
      streakEnd: TimestampModel.fromMap(map['streakEnd']),
    );
  }

  String toJson() => json.encode(toMap());

  factory DailyAppCheckInEventModel.fromJson(String source) =>
      DailyAppCheckInEventModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DailyAppCheckInEventModel(title: $title, subtitle: $subtitle, postClaimMessage: $postClaimMessage, streakBreakMessage: $streakBreakMessage, currentDay: $currentDay, totalResetCount: $totalResetCount, specialRewardPos: $specialRewardPos, streakReset: $streakReset, startedOn: $startedOn, streakStart: $streakStart, streakEnd: $streakEnd)';
  }

  @override
  bool operator ==(covariant DailyAppCheckInEventModel other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.subtitle == subtitle &&
        other.postClaimMessage == postClaimMessage &&
        other.streakBreakMessage == streakBreakMessage &&
        other.currentDay == currentDay &&
        other.totalResetCount == totalResetCount &&
        listEquals(other.specialRewardPos, specialRewardPos) &&
        other.streakReset == streakReset &&
        other.startedOn == startedOn &&
        other.streakStart == streakStart &&
        other.streakEnd == streakEnd;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        subtitle.hashCode ^
        postClaimMessage.hashCode ^
        streakBreakMessage.hashCode ^
        currentDay.hashCode ^
        totalResetCount.hashCode ^
        specialRewardPos.hashCode ^
        streakReset.hashCode ^
        startedOn.hashCode ^
        streakStart.hashCode ^
        streakEnd.hashCode;
  }
}

class DailyAppBonusClaimRewardModel {
  bool flag;
  String message;
  String gtId;
  DailyAppBonusClaimRewardModel({
    required this.flag,
    required this.message,
    required this.gtId,
  });

  factory DailyAppBonusClaimRewardModel.fromMap(Map<String, dynamic> map) {
    return DailyAppBonusClaimRewardModel(
      flag: map['flag'] as bool,
      message: map['message'] as String,
      gtId: map['gtId'] as String,
    );
  }
}
