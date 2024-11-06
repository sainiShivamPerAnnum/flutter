// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_home.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LiveHome _$LiveHomeFromJson(Map<String, dynamic> json) => LiveHome(
      sections: Section.fromJson(json['sections'] as Map<String, dynamic>),
      live: (json['live'] as List<dynamic>)
          .map((e) => LiveStream.fromJson(e as Map<String, dynamic>))
          .toList(),
      upcoming: (json['upcoming'] as List<dynamic>)
          .map((e) => UpcomingStream.fromJson(e as Map<String, dynamic>))
          .toList(),
      recent: (json['recent'] as List<dynamic>)
          .map((e) => RecentStream.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Section _$SectionFromJson(Map<String, dynamic> json) => Section(
      live: SectionContent.fromJson(json['live'] as Map<String, dynamic>),
      upcoming:
          SectionContent.fromJson(json['upcoming'] as Map<String, dynamic>),
      recent: SectionContent.fromJson(json['recent'] as Map<String, dynamic>),
    );

SectionContent _$SectionContentFromJson(Map<String, dynamic> json) =>
    SectionContent(
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      viewAll: json['viewAll'] as bool,
    );

LiveStream _$LiveStreamFromJson(Map<String, dynamic> json) => LiveStream(
      categories: (json['categories'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      author: json['author'] as String,
      thumbnail: json['thumbnail'] as String,
      liveCount: json['liveCount'] as int,
      advisorCode: json['advisorCode'] as String,
      viewerCode: json['viewerCode'] as String,
    );

UpcomingStream _$UpcomingStreamFromJson(Map<String, dynamic> json) =>
    UpcomingStream(
      categories: (json['categories'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      author: json['author'] as String,
      thumbnail: json['thumbnail'] as String,
      startTime: json['startTime'] as String,
      advisorCode: json['advisorCode'] as String,
      viewerCode: json['viewerCode'] as String,
    );

RecentStream _$RecentStreamFromJson(Map<String, dynamic> json) => RecentStream(
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      author: json['author'] as String,
      thumbnail: json['thumbnail'] as String,
      duration: json['duration'] as int,
      views: json['views'] as int,
      categories: (json['categories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );
