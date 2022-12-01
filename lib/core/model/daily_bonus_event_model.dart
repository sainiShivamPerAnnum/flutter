// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DailyAppCheckInEventModel {
  final String title;
  final String subtitle;
  DailyAppCheckInEventModel({
    required this.title,
    required this.subtitle,
  });

  DailyAppCheckInEventModel copyWith({
    String? title,
    String? subtitle,
  }) {
    return DailyAppCheckInEventModel(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'subtitle': subtitle,
    };
  }

  factory DailyAppCheckInEventModel.fromMap(Map<String, dynamic> map) {
    return DailyAppCheckInEventModel(
      title: map['title'] as String,
      subtitle: map['subtitle'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DailyAppCheckInEventModel.fromJson(String source) =>
      DailyAppCheckInEventModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'DailyAppCheckInEventModel(title: $title, subtitle: $subtitle)';

  @override
  bool operator ==(covariant DailyAppCheckInEventModel other) {
    if (identical(this, other)) return true;

    return other.title == title && other.subtitle == subtitle;
  }

  @override
  int get hashCode => title.hashCode ^ subtitle.hashCode;
}
