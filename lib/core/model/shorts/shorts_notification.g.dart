// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shorts_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShortsNotification _$ShortsNotificationFromJson(Map<String, dynamic> json) =>
    ShortsNotification(
      notifications: (json['notifications'] as List<dynamic>)
          .map((e) => Notification.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPages: json['totalPages'] as int,
      page: json['page'] as int,
    );

Notification _$NotificationFromJson(Map<String, dynamic> json) => Notification(
      isSeen: json['isSeen'] as bool,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      advisorProfilePhoto: json['advisorProfilePhoto'] as String,
      duration: json['duration'] as String,
      categoryV1: json['categoryV1'] as String,
      advisorId: json['advisorId'] as String,
      videoId: json['videoId'] as String,
      createdAt: json['createdAt'] as String,
    );
