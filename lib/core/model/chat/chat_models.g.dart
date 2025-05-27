// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => ChatMessage(
      id: json['id'] as String,
      sessionId: json['sessionId'] as String,
      senderId: json['senderId'] as String,
      receiverId: json['receiverId'] as String,
      message: json['message'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      handler: json['handler'] as String,
      read: json['read'] as bool? ?? false,
      mongoId: json['_id'] as String?,
      version: (json['__v'] as num?)?.toInt(),
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
      '_id': instance.mongoId,
      '__v': instance.version,
    };

ConsultationOffer _$ConsultationOfferFromJson(Map<String, dynamic> json) =>
    ConsultationOffer(
      id: json['id'] as String,
      advisorName: json['advisorName'] as String,
      price: json['price'] as String,
      duration: json['duration'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$ConsultationOfferToJson(ConsultationOffer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'advisorName': instance.advisorName,
      'price': instance.price,
      'duration': instance.duration,
      'description': instance.description,
    };

ChatSession _$ChatSessionFromJson(Map<String, dynamic> json) => ChatSession(
      id: json['id'] as String,
      messages: (json['messages'] as List<dynamic>)
          .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: $enumDecode(_$ChatStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      humanAdvisorId: json['humanAdvisorId'] as String?,
      humanAdvisorName: json['humanAdvisorName'] as String?,
      currentPage: (json['currentPage'] as num?)?.toInt() ?? 0,
      hasMoreMessages: json['hasMoreMessages'] as bool? ?? false,
    );

Map<String, dynamic> _$ChatSessionToJson(ChatSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'messages': instance.messages,
      'status': _$ChatStatusEnumMap[instance.status]!,
      'humanAdvisorId': instance.humanAdvisorId,
      'humanAdvisorName': instance.humanAdvisorName,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'currentPage': instance.currentPage,
      'hasMoreMessages': instance.hasMoreMessages,
    };

const _$ChatStatusEnumMap = {
  ChatStatus.ai: 'ai',
  ChatStatus.human: 'human',
  ChatStatus.ended: 'ended',
};
