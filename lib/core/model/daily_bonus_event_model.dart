// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:felloapp/core/model/timestamp_model.dart';

class DailyAppCheckInEventModel {
  final String title;
  final String subtitle;
  final TimestampModel startedOn;
  final TimestampModel streakStart;
  final TimestampModel streakEnd;
  final int currentDay;
  DailyAppCheckInEventModel({
    required this.title,
    required this.subtitle,
    required this.startedOn,
    required this.streakStart,
    required this.streakEnd,
    required this.currentDay,
  });

  DailyAppCheckInEventModel copyWith({
    String? title,
    String? subtitle,
    TimestampModel? startedOn,
    TimestampModel? streakStart,
    TimestampModel? streakEnd,
    int? cuurentDay,
  }) {
    return DailyAppCheckInEventModel(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      startedOn: startedOn ?? this.startedOn,
      streakStart: streakStart ?? this.streakStart,
      streakEnd: streakEnd ?? this.streakEnd,
      currentDay: cuurentDay ?? this.currentDay,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'subtitle': subtitle,
      'startedOn': startedOn.toMap(),
      'streakStart': streakStart.toMap(),
      'streakEnd': streakEnd.toMap(),
      'currentDay': currentDay,
    };
  }

  factory DailyAppCheckInEventModel.fromMap(Map<String, dynamic> map) {
    return DailyAppCheckInEventModel(
      title: (map['title'] ?? "Daily Bonus") as String,
      subtitle: (map['subtitle'] ??
          "Open the app everyday for a week and win assured rewards") as String,
      startedOn:
          TimestampModel.fromMap(map['startedOn'] as Map<String, dynamic>),
      streakStart:
          TimestampModel.fromMap(map['streakStart'] as Map<String, dynamic>),
      streakEnd:
          TimestampModel.fromMap(map['streakEnd'] as Map<String, dynamic>),
      currentDay: map['currentDay'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory DailyAppCheckInEventModel.fromJson(String source) =>
      DailyAppCheckInEventModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DailyAppCheckInEventModel(title: $title, subtitle: $subtitle, startedOn: $startedOn, streakStart: $streakStart, streakEnd: $streakEnd, currentDay: $currentDay)';
  }

  @override
  bool operator ==(covariant DailyAppCheckInEventModel other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.subtitle == subtitle &&
        other.startedOn == startedOn &&
        other.streakStart == streakStart &&
        other.streakEnd == streakEnd &&
        other.currentDay == currentDay;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        subtitle.hashCode ^
        startedOn.hashCode ^
        streakStart.hashCode ^
        streakEnd.hashCode ^
        currentDay.hashCode;
  }
}
