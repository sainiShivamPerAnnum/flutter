// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'advisor_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdvisorDetails _$AdvisorDetailsFromJson(Map<String, dynamic> json) =>
    AdvisorDetails(
      id: json['id'] as String,
      topic: json['topic'] as String,
      description: json['description'] as String,
      categories: (json['categories'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      type: json['type'] as String,
      coverImage: json['coverImage'] as String,
      eventTimeSlot: json['eventTimeSlot'] as String,
      duration: (json['duration'] as num).toInt(),
      advisorId: json['advisorId'] as String,
      status: json['status'] as String,
      totalLiveCount: (json['totalLiveCount'] as num).toInt(),
      currentLiveCount: (json['currentLiveCount'] as num).toInt(),
      broadcasterCode: json['broadcasterCode'] as String,
      viewerCode: json['viewerCode'] as String,
      roomId: json['roomId'] as String,
    );
