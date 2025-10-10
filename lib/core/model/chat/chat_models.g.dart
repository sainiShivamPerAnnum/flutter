// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => ChatMessage(
      sessionId: json['sessionId'] as String,
      senderId: json['senderId'] as String,
      receiverId: json['receiverId'] as String,
      message: json['message'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      handler: json['handler'] as String,
      id: json['id'] as String?,
      messageType:
          $enumDecodeNullable(_$MessageTypeEnumMap, json['messageType']) ??
              MessageType.ai,
      read: json['read'] as bool? ?? false,
    );

Map<String, dynamic> _$ChatMessageToJson(ChatMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sessionId': instance.sessionId,
      'senderId': instance.senderId,
      'receiverId': instance.receiverId,
      'message': instance.message,
      'timestamp': instance.timestamp.toIso8601String(),
      'read': instance.read,
      'handler': instance.handler,
      'messageType': _$MessageTypeEnumMap[instance.messageType],
    };

const _$MessageTypeEnumMap = {
  MessageType.ai: 'ai',
  MessageType.advisor: 'advisor',
  MessageType.consultation: 'consultation',
  MessageType.handover: 'handover',
  MessageType.user: 'user',
};

ConsultationOffer _$ConsultationOfferFromJson(Map<String, dynamic> json) =>
    ConsultationOffer(
      advisorName: json['advisorName'] as String,
      price: json['price'] as String,
      duration: json['duration'] as String,
      description: json['description'] as String,
      id: json['id'] as String,
      advisorProfileImage: json['advisorProfileImage'] as String,
    );

Map<String, dynamic> _$ConsultationOfferToJson(ConsultationOffer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'advisorName': instance.advisorName,
      'advisorProfileImage': instance.advisorProfileImage,
      'price': instance.price,
      'duration': instance.duration,
      'description': instance.description,
    };

ChatSession _$ChatSessionFromJson(Map<String, dynamic> json) => ChatSession(
      sessionId: json['sessionId'] as String,
      advisorId: json['advisorId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      status: json['status'] as String?,
      isExisting: json['isExisting'] as bool,
    );

Map<String, dynamic> _$ChatSessionToJson(ChatSession instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'advisorId': instance.advisorId,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
      'isExisting': instance.isExisting,
    };

ChatSessionWithMessages _$ChatSessionWithMessagesFromJson(
        Map<String, dynamic> json) =>
    ChatSessionWithMessages(
      session: ChatSession.fromJson(json['session'] as Map<String, dynamic>),
      messages: (json['messages'] as List<dynamic>)
          .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
          .toList(),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ChatSessionWithMessagesToJson(
        ChatSessionWithMessages instance) =>
    <String, dynamic>{
      'session': instance.session,
      'messages': instance.messages,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
