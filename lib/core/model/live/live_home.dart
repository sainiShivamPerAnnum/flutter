import 'package:json_annotation/json_annotation.dart';

part 'live_home.g.dart';

const _deserializable = JsonSerializable(
  createToJson: false,
);

@_deserializable
class LiveHome {
  final Section sections;
  final List<LiveStream> live;
  final List<UpcomingStream> upcoming;
  final List<RecentStream> recent;

  LiveHome({
    required this.sections,
    required this.live,
    required this.upcoming,
    required this.recent,
  });

  factory LiveHome.fromJson(Map<String, dynamic> json) =>
      _$LiveHomeFromJson(json);
}

@_deserializable
class Section {
  final SectionContent live;
  final SectionContent upcoming;
  final SectionContent recent;

  Section({
    required this.live,
    required this.upcoming,
    required this.recent,
  });

  factory Section.fromJson(Map<String, dynamic> json) =>
      _$SectionFromJson(json);
}

@_deserializable
class SectionContent {
  final String title;
  final String subtitle;
  final bool viewAll;

  SectionContent({
    required this.title,
    required this.subtitle,
    required this.viewAll,
  });

  factory SectionContent.fromJson(Map<String, dynamic> json) =>
      _$SectionContentFromJson(json);
}

@_deserializable
class LiveStream {
  final String category;
  final String title;
  final String subtitle;
  final String author;
  final String thumbnail;
  final int liveCount;
  final String url;

  LiveStream({
    required this.category,
    required this.title,
    required this.subtitle,
    required this.author,
    required this.thumbnail,
    required this.liveCount,
    required this.url,
  });

  factory LiveStream.fromJson(Map<String, dynamic> json) =>
      _$LiveStreamFromJson(json);
}

@_deserializable
class UpcomingStream {
  final String category;
  final String title;
  final String subtitle;
  final String author;
  final String thumbnail;
  final String startTime;
  final String url;

  UpcomingStream({
    required this.category,
    required this.title,
    required this.subtitle,
    required this.author,
    required this.thumbnail,
    required this.startTime,
    required this.url,
  });

  factory UpcomingStream.fromJson(Map<String, dynamic> json) =>
      _$UpcomingStreamFromJson(json);
}

@_deserializable
class RecentStream {
  final String category;
  final String title;
  final String subtitle;
  final String author;
  final String thumbnail;
  final int duration;
  final String url;
  final int views;

  RecentStream({
    required this.category,
    required this.title,
    required this.subtitle,
    required this.author,
    required this.thumbnail,
    required this.duration,
    required this.url,
    required this.views,
  });

  factory RecentStream.fromJson(Map<String, dynamic> json) =>
      _$RecentStreamFromJson(json);
}
