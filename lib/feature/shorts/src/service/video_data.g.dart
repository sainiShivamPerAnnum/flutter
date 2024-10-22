// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoData _$VideoDataFromJson(Map<String, dynamic> json) => VideoData(
      id: json['id'] as String,
      thumbnail: json['thumbnail'] as String,
      url: json['url'] as String,
      viewCount: json['viewCount'] as int,
      timeStamp: json['timeStamp'] as String,
      category:
          (json['category'] as List<dynamic>).map((e) => e as String).toList(),
      title: json['title'] as String,
      author: json['author'] as String,
      subtitle: json['subtitle'] as String,
      views: json['views'] as num,
      duration: json['duration'] as String,
      isVideoLikedByUser: json['isVideoLikedByUser'] as bool? ?? false,
    );

Map<String, dynamic> _$VideoDataToJson(VideoData instance) => <String, dynamic>{
      'id': instance.id,
      'thumbnail': instance.thumbnail,
      'url': instance.url,
      'viewCount': instance.viewCount,
      'timeStamp': instance.timeStamp,
      'category': instance.category,
      'title': instance.title,
      'author': instance.author,
      'subtitle': instance.subtitle,
      'views': instance.views,
      'duration': instance.duration,
      'isVideoLikedByUser': instance.isVideoLikedByUser,
    };
