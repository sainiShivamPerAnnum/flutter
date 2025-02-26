import 'package:felloapp/feature/shorts/src/service/video_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'shorts_home.g.dart';

const _deserializable = JsonSerializable(
  createToJson: false,
);

@_deserializable
class ShortsHome {
  final List<String> allCategories;
  final List<ShortsThemeData> shorts;

  ShortsHome({required this.allCategories, required this.shorts});

  factory ShortsHome.fromJson(Map<String, dynamic> json) =>
      _$ShortsHomeFromJson(json);
}

@_deserializable
class ShortsThemeData {
  final List<VideoData> videos;
  final String theme;
  final String themeName;
  final num total;
  final List<String> categories;
  final num page;
  final int totalPages;
  final bool isNotificationOn;
  final bool isNotificationAllowed;

  ShortsThemeData({
    required this.videos,
    required this.theme,
    required this.themeName,
    required this.total,
    required this.categories,
    required this.page,
    required this.totalPages,
    this.isNotificationOn = false,
    this.isNotificationAllowed = false,
  });

  factory ShortsThemeData.fromJson(Map<String, dynamic> json) =>
      _$ShortsThemeDataFromJson(json);

  ShortsThemeData copyWith({
    List<VideoData>? videos,
    String? theme,
    String? themeName,
    num? total,
    List<String>? categories,
    num? page,
    int? totalPages,
    bool? isNotificationOn,
    bool? isNotificationAllowed,
  }) {
    return ShortsThemeData(
      videos: videos ?? this.videos,
      theme: theme ?? this.theme,
      themeName: themeName ?? this.themeName,
      total: total ?? this.total,
      categories: categories ?? this.categories,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      isNotificationOn: isNotificationOn ?? this.isNotificationOn,
      isNotificationAllowed:
          isNotificationAllowed ?? this.isNotificationAllowed,
    );
  }
}

@_deserializable
class SavedShorts {
  final List<VideoData> videos;
  final String theme;
  final String themeName;
  final num total;
  final num page;
  final int totalPages;
  final bool isNotificationOn;
  final bool isNotificationAllowed;

  SavedShorts({
    required this.videos,
    required this.theme,
    required this.themeName,
    required this.total,
    required this.page,
    required this.totalPages,
    this.isNotificationOn = false,
    this.isNotificationAllowed = false,
  });

  factory SavedShorts.fromJson(Map<String, dynamic> json) =>
      _$SavedShortsFromJson(json);

  SavedShorts copyWith({
    List<VideoData>? videos,
    String? theme,
    String? themeName,
    num? total,
    num? page,
    int? totalPages,
    bool? isNotificationOn,
    bool? isNotificationAllowed,
  }) {
    return SavedShorts(
      videos: videos ?? this.videos,
      theme: theme ?? this.theme,
      themeName: themeName ?? this.themeName,
      total: total ?? this.total,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      isNotificationOn: isNotificationOn ?? this.isNotificationOn,
      isNotificationAllowed:
          isNotificationAllowed ?? this.isNotificationAllowed,
    );
  }
}

@_deserializable
class PaginatedShorts {
  final List<VideoData> videos;
  final String theme;
  final String themeName;
  final num total;
  final num page;
  final num totalPages;

  PaginatedShorts({
    required this.videos,
    required this.theme,
    required this.themeName,
    required this.total,
    required this.page,
    required this.totalPages,
  });

  factory PaginatedShorts.fromJson(Map<String, dynamic> json) =>
      _$PaginatedShortsFromJson(json);
}
