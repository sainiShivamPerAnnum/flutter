import 'package:json_annotation/json_annotation.dart';
part 'advisor_details.g.dart';

const _deserializable = JsonSerializable(
  createToJson: false,
);

@_deserializable
class AdvisorDetails {
  final String id;
  final String topic;
  final String description;
  final List<String> categories;
  final String type;
  final String coverImage;
  final String eventTimeSlot;
  final int duration;
  final String advisorId;
  final String status;
  final int totalLiveCount;
  final int currentLiveCount;
  final String broadcasterCode;
  final String viewerCode;
  final String roomId;

  AdvisorDetails({
    required this.id,
    required this.topic,
    required this.description,
    required this.categories,
    required this.type,
    required this.coverImage,
    required this.eventTimeSlot,
    required this.duration,
    required this.advisorId,
    required this.status,
    required this.totalLiveCount,
    required this.currentLiveCount,
    required this.broadcasterCode,
    required this.viewerCode,
    required this.roomId,
  });

  factory AdvisorDetails.fromJson(Map<String, dynamic> json) =>
      _$AdvisorDetailsFromJson(json);
}
