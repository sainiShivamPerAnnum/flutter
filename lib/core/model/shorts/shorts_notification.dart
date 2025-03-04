import 'package:json_annotation/json_annotation.dart';

part 'shorts_notification.g.dart';

const _deserializable = JsonSerializable(
  createToJson: false,
);

@_deserializable
class ShortsNotification {
  final List<Notification> notifications;
  final int totalPages;
  final int page;

  ShortsNotification({
    required this.notifications,
    required this.totalPages,
    required this.page,
  });

  factory ShortsNotification.fromJson(Map<String, dynamic> json) =>
      _$ShortsNotificationFromJson(json);
}

@_deserializable
class Notification {
  final bool isSeen;
  final String title;
  final String subtitle;
  final String advisorProfilePhoto;
  final String duration;
  final String categoryV1;
  final String advisorId;
  final String videoId;
  final String createdAt;
  final bool isSaved;
  final bool isFollowed;
  final String theme;
  final String author;
  final String videoUrl;

  Notification({
    required this.isSeen,
    required this.title,
    required this.subtitle,
    required this.advisorProfilePhoto,
    required this.duration,
    required this.categoryV1,
    required this.advisorId,
    required this.videoId,
    required this.createdAt,
    required this.isSaved,
    required this.theme,
    required this.author,
    required this.isFollowed,
    required this.videoUrl,
  });

  factory Notification.fromJson(Map<String, dynamic> json) =>
      _$NotificationFromJson(json);
}
