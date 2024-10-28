import 'package:json_annotation/json_annotation.dart';

part 'comment_data.g.dart'; // This will be generated

@JsonSerializable()
class CommentData {
  @JsonKey(name: '_id')
  final String id; // This corresponds to "_id" in the response
  final String videoId; // The video ID the comment is associated with
  final String name; // The name of the user who commented
  final String userId; // The user ID of the commenter
  final String comment; // The actual comment text
  final String createdAt; // Timestamp of when the comment was created
  final String avatarId;
  final String dpUrl;

  CommentData({
    required this.id,
    required this.videoId,
    required this.name,
    required this.userId,
    required this.comment,
    required this.createdAt,
    this.avatarId = "AV1",
    this.dpUrl = "",
  });

  // Factory method to generate CommentData instance from JSON
  factory CommentData.fromJson(Map<String, dynamic> json) =>
      _$CommentDataFromJson(json);

  // Method to convert CommentData instance to JSON
  Map<String, dynamic> toJson() => _$CommentDataToJson(this);
}
