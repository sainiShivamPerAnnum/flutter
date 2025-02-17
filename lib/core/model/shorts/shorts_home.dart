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

  ShortsThemeData({
    required this.videos,
    required this.theme,
    required this.themeName,
    required this.total,
    required this.categories,
    required this.page,
  });

  factory ShortsThemeData.fromJson(Map<String, dynamic> json) =>
      _$ShortsThemeDataFromJson(json);
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
