// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MlSteps {
  final String? title;
  final String? subtitle;
  MlSteps({
    required this.title,
    required this.subtitle,
  });

  MlSteps copyWith({
    String? title,
    String? subtitle,
  }) {
    return MlSteps(
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

  factory MlSteps.fromMap(Map<String, dynamic> map) {
    return MlSteps(
      title: map['title'] as String?,
      subtitle: map['subtitle'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory MlSteps.fromJson(String source) =>
      MlSteps.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'MlSteps(title: $title, subtitle: $subtitle)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MlSteps &&
        other.title == title &&
        other.subtitle == subtitle;
  }

  @override
  int get hashCode => title.hashCode ^ subtitle.hashCode;
}
