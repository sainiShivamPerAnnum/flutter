import 'package:felloapp/feature/shorts/src/service/video_data.dart';
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
  final List<VideoData> recent;

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
  final String id;
  final List<String> categories;
  final String title;
  final String subtitle;
  final String author;
  final String thumbnail;
  final int liveCount;
  final String advisorCode;
  final String viewerCode;
  final bool isEventLikedByUser;

  LiveStream({
    required this.id,
    required this.categories,
    required this.title,
    required this.subtitle,
    required this.author,
    required this.thumbnail,
    required this.liveCount,
    required this.advisorCode,
    required this.viewerCode,
    required this.isEventLikedByUser,
  });

  factory LiveStream.fromJson(Map<String, dynamic> json) =>
      _$LiveStreamFromJson(json);
}

@_deserializable
class UpcomingStream {
  final String id;
  final List<String> categories;
  final String title;
  final String subtitle;
  final String author;
  final String thumbnail;
  final String startTime;
  final String advisorCode;
  final String viewerCode;

  UpcomingStream({
    required this.id,
    required this.categories,
    required this.title,
    required this.subtitle,
    required this.author,
    required this.thumbnail,
    required this.startTime,
    required this.advisorCode,
    required this.viewerCode,
  });

  factory UpcomingStream.fromJson(Map<String, dynamic> json) =>
      _$UpcomingStreamFromJson(json);
}