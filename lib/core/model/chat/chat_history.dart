import 'package:json_annotation/json_annotation.dart';

part 'chat_history.g.dart';

@JsonSerializable()
class ChatHistory {
  final String sessionId;
  final String advisorId;
  final String lastMessage;
  final String lastMessageTimestamp;
  final int unreadCount;
  final AdvisorMetadata metadata;

  ChatHistory({
    required this.sessionId,
    required this.advisorId,
    required this.lastMessage,
    required this.lastMessageTimestamp,
    required this.unreadCount,
    required this.metadata,
  });

  factory ChatHistory.fromJson(Map<String, dynamic> json) =>
      _$ChatHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$ChatHistoryToJson(this);
}

@JsonSerializable()
class AdvisorMetadata {
  final String id;
  final String advisorName;
  final String advisorProfilePhoto;
  final String price;
  final String duration;
  final String description;
  final List<String> expertise;
  final String? userName;
  final String? userImage;

  AdvisorMetadata({
    required this.id,
    required this.advisorName,
    required this.advisorProfilePhoto,
    required this.price,
    required this.duration,
    required this.description,
    required this.expertise,
    this.userName,
    this.userImage,
  });

  factory AdvisorMetadata.fromJson(Map<String, dynamic> json) =>
      _$AdvisorMetadataFromJson(json);

  Map<String, dynamic> toJson() => _$AdvisorMetadataToJson(this);
}
