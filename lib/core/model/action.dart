// ignore_for_file: constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'action.g.dart';

enum ActionType {
  DEEP_LINK,
  LAUNCH_EXTERNAL_APPLICATION,
  LAUNCH_WEBVIEW,
  SHARE;
}

@JsonSerializable()
class Action {
  final ActionType type;
  final Map<String, dynamic> payload;

  const Action({
    required this.type,
    this.payload = const {},
  });

  factory Action.fromJson(Map<String, dynamic> json) => _$ActionFromJson(json);

  Map<String, dynamic> toJson() => _$ActionToJson(this);
}
