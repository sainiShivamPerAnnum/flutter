import 'package:json_annotation/json_annotation.dart';

part 'advisor_events.g.dart';

@JsonSerializable()
class AdvisorEvents {
  @JsonKey(name: '_id')
  final String id;
  final String advisorId;
  final String type;
  final String? topic;
  final String? description;
  final String? bookingId;
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

  AdvisorEvents({
    required this.id,
    required this.advisorId,
    required this.type,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.bookingId,
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
  });

  factory AdvisorEvents.fromJson(Map<String, dynamic> json) =>
      _$AdvisorEventsFromJson(json);

  Map<String, dynamic> toJson() => _$AdvisorEventsToJson(this);
}
