// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoData _$VideoDataFromJson(Map<String, dynamic> json) => VideoData(
      id: json['id'] as String,
      thumbnail: json['thumbnail'] as String,
      url: json['url'] as String,
      timeStamp: json['timeStamp'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      views: json['views'] as num,
      duration: json['duration'] as String,
      description: json['description'] as String,
      advisorId: json['advisorId'] as String,
      author: json['author'] as String? ?? '',
      categoryV1: json['categoryV1'] as String? ?? '',
      category: (json['category'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isVideoLikedByUser: json['isVideoLikedByUser'] as bool? ?? false,
      advisorImg: json['advisorImg'] as String? ?? '',
      isSaved: json['isSaved'] as bool? ?? false,
      isFollowed: json['isFollowed'] as bool? ?? false,
      isVideoSeenByUser: json['isVideoSeenByUser'] as bool? ?? false,
    );

Map<String, dynamic> _$VideoDataToJson(VideoData instance) => <String, dynamic>{
      'id': instance.id,
      'thumbnail': instance.thumbnail,
      'url': instance.url,
      'timeStamp': instance.timeStamp,
      'category': instance.category,
      'title': instance.title,
      'author': instance.author,
      'subtitle': instance.subtitle,
      'description': instance.description,
      'advisorId': instance.advisorId,
      'views': instance.views,
      'duration': instance.duration,
      'isVideoLikedByUser': instance.isVideoLikedByUser,
      'categoryV1': instance.categoryV1,
      'advisorImg': instance.advisorImg,
      'isSaved': instance.isSaved,
      'isFollowed': instance.isFollowed,
      'isVideoSeenByUser': instance.isVideoSeenByUser,
    };
