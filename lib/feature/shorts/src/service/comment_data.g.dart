// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentData _$CommentDataFromJson(Map<String, dynamic> json) => CommentData(
      id: json['_id'] as String,
      videoId: json['videoId'] as String,
      name: json['name'] as String,
      userId: json['userId'] as String,
      comment: json['comment'] as String,
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$CommentDataToJson(CommentData instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'videoId': instance.videoId,
      'name': instance.name,
      'userId': instance.userId,
      'comment': instance.comment,
      'createdAt': instance.createdAt,
    };
