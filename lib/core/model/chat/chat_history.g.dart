// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatHistory _$ChatHistoryFromJson(Map<String, dynamic> json) => ChatHistory(
      sessionId: json['sessionId'] as String,
      advisorId: json['advisorId'] as String,
      lastMessage: json['lastMessage'] as String,
      lastMessageTimestamp: json['lastMessageTimestamp'] as String,
      unreadCount: (json['unreadCount'] as num).toInt(),
      metadata:
          AdvisorMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChatHistoryToJson(ChatHistory instance) =>
    <String, dynamic>{
      'sessionId': instance.sessionId,
      'advisorId': instance.advisorId,
      'lastMessage': instance.lastMessage,
      'lastMessageTimestamp': instance.lastMessageTimestamp,
      'unreadCount': instance.unreadCount,
      'metadata': instance.metadata,
    };

AdvisorMetadata _$AdvisorMetadataFromJson(Map<String, dynamic> json) =>
    AdvisorMetadata(
      id: json['id'] as String,
      advisorName: json['advisorName'] as String,
      advisorProfilePhoto: json['advisorProfilePhoto'] as String,
      price: json['price'] as String,
      duration: json['duration'] as String,
      description: json['description'] as String,
      expertise:
          (json['expertise'] as List<dynamic>).map((e) => e as String).toList(),
      userName: json['userName'] as String?,
      userImage: json['userImage'] as String?,
    );

Map<String, dynamic> _$AdvisorMetadataToJson(AdvisorMetadata instance) =>
    <String, dynamic>{
      'id': instance.id,
      'advisorName': instance.advisorName,
      'advisorProfilePhoto': instance.advisorProfilePhoto,
      'price': instance.price,
      'duration': instance.duration,
      'description': instance.description,
      'expertise': instance.expertise,
      'userName': instance.userName,
      'userImage': instance.userImage,
    };
