import 'package:json_annotation/json_annotation.dart';

part 'video_data.g.dart'; // This is the generated file for JSON serialization

@JsonSerializable()
class VideoData {
  final String id;
  final String thumbnail;
  final String url;
  final int viewCount;
  final String timeStamp;
  final List<String> category;
  final String title;
  final String author;
  final String subtitle;
  final num views;
  final String duration;
  final bool isVideoLikedByUser;

  VideoData({
    required this.id,
    required this.thumbnail,
    required this.url,
    required this.viewCount,
    required this.timeStamp,
    required this.category,
    required this.title,
    required this.author,
    required this.subtitle,
    required this.views,
    required this.duration,
    this.isVideoLikedByUser = false,
  });

  // Method to generate VideoData instance from JSON
  factory VideoData.fromJson(Map<String, dynamic> json) => _$VideoDataFromJson(json);

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
      isVideoLikedByUser: isVideoLikedByUser ?? this.isVideoLikedByUser,
    );
  }
}
