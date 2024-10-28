// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'advisor_events.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdvisorEvents _$AdvisorEventsFromJson(Map<String, dynamic> json) =>
    AdvisorEvents(
      id: json['id'] as String,
      advisorId: json['advisorId'] as String,
      type: json['type'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      eventTimeSlot: json['eventTimeSlot'] as String?,
      duration: json['duration'] as int?,
      broadcasterCode: json['broadcasterCode'] as String?,
      description: json['description'] as String?,
      topic: json['topic'] as String?,
      guestCode: json['guestCode'] as String?,
      hostCode: json['hostCode'] as String?,
      roomId: json['roomId'] as String?,
      categories: (json['categories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      totalLiveCount: json['totalLiveCount'] as int? ?? 0,
      currentLiveCount: json['currentLiveCount'] as int? ?? 0,
      coverImage: json['coverImage'] as String?,
    );

Map<String, dynamic> _$AdvisorEventsToJson(AdvisorEvents instance) =>
    <String, dynamic>{
      'id': instance.id,
      'advisorId': instance.advisorId,
      'type': instance.type,
      'topic': instance.topic,
      'description': instance.description,
      'eventTimeSlot': instance.eventTimeSlot,
      'duration': instance.duration,
      'status': instance.status,
      'totalLiveCount': instance.totalLiveCount,
      'currentLiveCount': instance.currentLiveCount,
      'broadcasterCode': instance.broadcasterCode,
      'guestCode': instance.guestCode,
      'hostCode': instance.hostCode,
      'roomId': instance.roomId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'categories': instance.categories,
      'coverImage': instance.coverImage,
    };
