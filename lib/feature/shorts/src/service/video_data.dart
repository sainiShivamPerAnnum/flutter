import 'package:json_annotation/json_annotation.dart';

part 'video_data.g.dart'; // This is the generated file for JSON serialization

@JsonSerializable()
class VideoData {
  final String id;
  final String thumbnail;
  final String url;
  final int viewCount;
  final String timeStamp;
  final List<String>? category;
  final String title;
  final String author;
  final String subtitle;
  final String description;
  final String advisorId;
  final num views;
  final String duration;
  final bool isVideoLikedByUser;

  VideoData({
    required this.id,
    required this.thumbnail,
    required this.url,
    required this.viewCount,
    required this.timeStamp,
    required this.title,
    required this.author,
    required this.subtitle,
    required this.views,
    required this.duration,
    required this.description,
    required this.advisorId,
    this.category =const [],
    this.isVideoLikedByUser = false,
  });

  // Method to generate VideoData instance from JSON
  factory VideoData.fromJson(Map<String, dynamic> json) =>
      _$VideoDataFromJson(json);

  // Method to convert VideoData instance to JSON
  Map<String, dynamic> toJson() => _$VideoDataToJson(this);
  VideoData copyWith({
    String? id,
    String? thumbnail,
    String? url,
    int? viewCount,
    String? timeStamp,
    List<String>? category,
    String? title,
    String? author,
    String? subtitle,
    num? views,
    String? duration,
    bool? isVideoLikedByUser,
    String? description,
    String? advisorId,
  }) {
    return VideoData(
      id: id ?? this.id,
      thumbnail: thumbnail ?? this.thumbnail,
      url: url ?? this.url,
      viewCount: viewCount ?? this.viewCount,
      timeStamp: timeStamp ?? this.timeStamp,
      category: category ?? this.category,
      title: title ?? this.title,
      author: author ?? this.author,
      subtitle: subtitle ?? this.subtitle,
      views: views ?? this.views,
      duration: duration ?? this.duration,
      description: description ?? this.description,
      advisorId: advisorId ?? this.advisorId,
      isVideoLikedByUser: isVideoLikedByUser ?? this.isVideoLikedByUser,
    );
  }
}
