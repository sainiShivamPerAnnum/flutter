import 'package:json_annotation/json_annotation.dart';

part 'advisor_events.g.dart';

@JsonSerializable()
class AdvisorEvents {
  final String id;
  final String advisorId;
  final String advisorName;
  final String type;
  final String? topic;
  final String? description;
  final String? eventTimeSlot;
  final int? duration;
  final String status;
  final int totalLiveCount;
  final int currentLiveCount;
  final String? broadcasterCode;
  final String? guestCode;
  final String? hostCode;
  final String? roomId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> categories;
  final String? coverImage;
  final String advisorImg;

  AdvisorEvents({
    required this.id,
    required this.advisorId,
    required this.type,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.eventTimeSlot,
    this.duration,
    this.broadcasterCode,
    this.description,
    this.topic,
    this.guestCode,
    this.hostCode,
    this.roomId,
    this.categories = const [],
    this.totalLiveCount = 0,
    this.currentLiveCount = 0,
    this.advisorName = '',
    this.coverImage,
    this.advisorImg = '',
  });

  factory AdvisorEvents.fromJson(Map<String, dynamic> json) =>
      _$AdvisorEventsFromJson(json);

  Map<String, dynamic> toJson() => _$AdvisorEventsToJson(this);
}
