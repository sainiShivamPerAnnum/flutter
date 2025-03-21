// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shorts_home.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShortsHome _$ShortsHomeFromJson(Map<String, dynamic> json) => ShortsHome(
      allCategories: (json['allCategories'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      shorts: (json['shorts'] as List<dynamic>)
          .map((e) => ShortsThemeData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

ShortsThemeData _$ShortsThemeDataFromJson(Map<String, dynamic> json) =>
    ShortsThemeData(
      videos: (json['videos'] as List<dynamic>)
          .map((e) => VideoData.fromJson(e as Map<String, dynamic>))
          .toList(),
      theme: json['theme'] as String,
      themeName: json['themeName'] as String,
      total: json['total'] as num,
      categories: (json['categories'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      page: json['page'] as num,
      totalPages: json['totalPages'] as int,
      isNotificationOn: json['isNotificationOn'] as bool? ?? false,
      isNotificationAllowed: json['isNotificationAllowed'] as bool? ?? false,
    );

SavedShorts _$SavedShortsFromJson(Map<String, dynamic> json) => SavedShorts(
      videos: (json['videos'] as List<dynamic>)
          .map((e) => VideoData.fromJson(e as Map<String, dynamic>))
          .toList(),
      theme: json['theme'] as String,
      themeName: json['themeName'] as String,
      total: json['total'] as num,
      page: json['page'] as num,
      totalPages: json['totalPages'] as int,
      isNotificationOn: json['isNotificationOn'] as bool? ?? false,
      isNotificationAllowed: json['isNotificationAllowed'] as bool? ?? false,
    );

PaginatedShorts _$PaginatedShortsFromJson(Map<String, dynamic> json) =>
    PaginatedShorts(
      videos: (json['videos'] as List<dynamic>)
          .map((e) => VideoData.fromJson(e as Map<String, dynamic>))
          .toList(),
      theme: json['theme'] as String,
      themeName: json['themeName'] as String,
      total: json['total'] as num,
      page: json['page'] as num,
      totalPages: json['totalPages'] as num,
    );
