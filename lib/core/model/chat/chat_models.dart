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
  final MessageType? messageType;
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
    this.messageType = MessageType.ai,
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
  final String sessionId;
  final String? advisorId;
  final String? status;
  final DateTime createdAt;
  final bool isExisting;

  ChatSession({
    required this.sessionId,
    required this.advisorId,
    required this.createdAt,
    required this.status,
    required this.isExisting,
  });

  factory ChatSession.fromJson(Map<String, dynamic> json) =>
      _$ChatSessionFromJson(json);

  Map<String, dynamic> toJson() => _$ChatSessionToJson(this);

  ChatSession copyWith({
    String? sessionId,
    String? advisorId,
    String? status,
    DateTime? createdAt,
    bool? isExisting,
  }) {
    return ChatSession(
      sessionId: sessionId ?? this.sessionId,
      advisorId: advisorId ?? this.advisorId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      isExisting: isExisting ?? this.isExisting,
    );
  }
}

/// Extended chat session model that includes messages and UI state
@JsonSerializable()
class ChatSessionWithMessages {
  final ChatSession session;
  final List<ChatMessage> messages;
  final String? humanAdvisorId;
  final String? humanAdvisorName;
  final DateTime updatedAt;

  ChatSessionWithMessages({
    required this.session,
    required this.messages,
    required this.updatedAt,
    this.humanAdvisorId,
    this.humanAdvisorName,
  });

  factory ChatSessionWithMessages.fromJson(Map<String, dynamic> json) =>
      _$ChatSessionWithMessagesFromJson(json);

  Map<String, dynamic> toJson() => _$ChatSessionWithMessagesToJson(this);

  /// Create from basic ChatSession
  factory ChatSessionWithMessages.fromSession(ChatSession session) {
    return ChatSessionWithMessages(
      session: session,
      messages: [],
      updatedAt: DateTime.now(),
    );
  }

  ChatSessionWithMessages copyWith({
    ChatSession? session,
    List<ChatMessage>? messages,
    String? humanAdvisorId,
    String? humanAdvisorName,
    DateTime? updatedAt,
  }) {
    return ChatSessionWithMessages(
      session: session ?? this.session,
      messages: messages ?? this.messages,
      humanAdvisorId: humanAdvisorId ?? this.humanAdvisorId,
      humanAdvisorName: humanAdvisorName ?? this.humanAdvisorName,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Convenience getters
  String get id => session.sessionId;
  String get sessionId => session.sessionId;
  String? get advisorId => session.advisorId;
  String? get status => session.status;
  DateTime get createdAt => session.createdAt;
  bool get isExisting => session.isExisting;
}
