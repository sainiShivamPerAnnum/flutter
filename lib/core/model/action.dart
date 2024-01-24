// ignore_for_file: constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'action.g.dart';

enum ActionType {
  DEEP_LINK,
  LAUNCH_EXTERNAL_APPLICATION,
  LAUNCH_WEBVIEW,
  POP,
  SHARE;
}

@JsonSerializable()
class Action {
  final ActionType type;
  final Map<String, dynamic> payload;
  final Map<String, dynamic> events;

  const Action({
    required this.type,
    this.payload = const {},
    this.events = const {},
  });

  factory Action.fromJson(Map<String, dynamic> json) => _$ActionFromJson(json);

  Map<String, dynamic> toJson() => _$ActionToJson(this);
}
