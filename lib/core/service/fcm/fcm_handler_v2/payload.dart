// ignore_for_file: one_member_abstracts

import 'package:json_annotation/json_annotation.dart';

part 'payload.g.dart';

const _deserializable = JsonSerializable(
  createToJson: false,
);

enum NotificationType {
  inApp,
}

@_deserializable
class NotificationPayloadV2 {
  const NotificationPayloadV2(
    this.type,
    this.payload,
  );

  final NotificationType type;
  final Map<String, dynamic> payload;

  factory NotificationPayloadV2.fromJson(Map<String, dynamic> json) =>
      _$NotificationPayloadV2FromJson(json);
}
