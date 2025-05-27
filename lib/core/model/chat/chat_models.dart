import 'package:json_annotation/json_annotation.dart';

part 'chat_models.g.dart';

enum MessageType { ai, advisor, consultation, handover }

@JsonSerializable()
class ChatMessage {
  final String id;
  final String sessionId;
  final String senderId; // uuid of user or advisor// if system then ai
  final String receiverId; // uuid
  final String message;
  final DateTime timestamp;
  final bool read;
  final String handler; // ai or advisor
  final MessageType messageType;
  @JsonKey(name: '_id')
  final String? mongoId;
  @JsonKey(name: '__v')
  final int? version;

  ChatMessage({
    required this.id,
    required this.sessionId,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    required this.handler,
    required this.messageType,
    this.read = false,
    this.mongoId,
    this.version,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);

  ChatMessage copyWith({
    String? id,
    String? sessionId,
    String? senderId,
    String? receiverId,
    String? message,
    DateTime? timestamp,
    bool? read,
    String? handler,
    String? mongoId,
    int? version,
    MessageType? messageType,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      read: read ?? this.read,
      handler: handler ?? this.handler,
      mongoId: mongoId ?? this.mongoId,
      version: version ?? this.version,
      messageType: messageType ?? this.messageType,
    );
  }

  String get content => message;
  bool get isRead => read;
}

@JsonSerializable()
class ConsultationOffer {
  final String id;
  final String advisorName;
  final String price;
  final String duration;
  final String description;

  ConsultationOffer({
    required this.id,
    required this.advisorName,
    required this.price,
    required this.duration,
    required this.description,
  });

  factory ConsultationOffer.fromJson(Map<String, dynamic> json) =>
      _$ConsultationOfferFromJson(json);

  Map<String, dynamic> toJson() => _$ConsultationOfferToJson(this);
}

@JsonSerializable()
class ChatSession {
  final String id;
  final List<ChatMessage> messages;
  final String? humanAdvisorId;
  final String? humanAdvisorName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int currentPage;
  final bool hasMoreMessages;

  ChatSession({
    required this.id,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
    this.humanAdvisorId,
    this.humanAdvisorName,
    this.currentPage = 0,
    this.hasMoreMessages = false,
  });

  factory ChatSession.fromJson(Map<String, dynamic> json) =>
      _$ChatSessionFromJson(json);

  Map<String, dynamic> toJson() => _$ChatSessionToJson(this);

  ChatSession copyWith({
    String? id,
    List<ChatMessage>? messages,
    String? humanAdvisorId,
    String? humanAdvisorName,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? currentPage,
    bool? hasMoreMessages,
  }) {
    return ChatSession(
      id: id ?? this.id,
      messages: messages ?? this.messages,
      humanAdvisorId: humanAdvisorId ?? this.humanAdvisorId,
      humanAdvisorName: humanAdvisorName ?? this.humanAdvisorName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      currentPage: currentPage ?? this.currentPage,
      hasMoreMessages: hasMoreMessages ?? this.hasMoreMessages,
    );
  }
}
