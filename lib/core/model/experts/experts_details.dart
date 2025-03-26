import 'package:felloapp/feature/shorts/src/service/video_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'experts_details.g.dart';

const _deserializable = JsonSerializable(
  createToJson: false,
);

@_deserializable
class ExpertDetails {
  final String name;
  final String image;
  final String description;
  final bool isLive;
  final String experience;
  final int sessionCount;
  final double rating;
  final List<QuickAction> QuickActions;
  final List<License> licenses;
  final List<Social> social;
  final RatingInfo ratingInfo;
  final bool isFollowed;
  final List<VideoData> shorts;

  ExpertDetails({
    required this.name,
    required this.image,
    required this.description,
    required this.isLive,
    required this.experience,
    required this.sessionCount,
    required this.rating,
    required this.QuickActions,
    required this.licenses,
    required this.social,
    required this.ratingInfo,
    required this.isFollowed,
    required this.shorts,
  });
  ExpertDetails copyWith({
    String? name,
    String? image,
    String? description,
    bool? isLive,
    String? experience,
    int? sessionCount,
    double? rating,
    List<QuickAction>? quickActions,
    List<License>? licenses,
    List<Social>? social,
    RatingInfo? ratingInfo,
    bool? isFollowed,
    List<VideoData>? shorts,
  }) {
    return ExpertDetails(
      name: name ?? this.name,
      image: image ?? this.image,
      description: description ?? this.description,
      isLive: isLive ?? this.isLive,
      experience: experience ?? this.experience,
      sessionCount: sessionCount ?? this.sessionCount,
      rating: rating ?? this.rating,
      QuickActions: quickActions ?? this.QuickActions,
      licenses: licenses ?? this.licenses,
      social: social ?? this.social,
      ratingInfo: ratingInfo ?? this.ratingInfo,
      isFollowed: isFollowed ?? this.isFollowed,
      shorts: shorts ?? this.shorts,
    );
  }

  factory ExpertDetails.fromJson(Map<String, dynamic> json) =>
      _$ExpertDetailsFromJson(json);
}

@_deserializable
class QuickAction {
  final String heading;
  final String subheading;
  final String buttonText;
  final String buttonCTA;

  QuickAction({
    required this.heading,
    required this.subheading,
    required this.buttonText,
    required this.buttonCTA,
  });

  factory QuickAction.fromJson(Map<String, dynamic> json) =>
      _$QuickActionFromJson(json);
}

@_deserializable
class License {
  @JsonKey(name: "_id")
  final String id;
  final String name;
  final String imageUrl;
  final DateTime issueDate;
  final String credentials;

  License({
    required this.name,
    required this.imageUrl,
    required this.issueDate,
    required this.credentials,
    this.id = '',
  });

  factory License.fromJson(Map<String, dynamic> json) =>
      _$LicenseFromJson(json);
}

@_deserializable
class Social {
  final String platform;
  final String url;
  final String icon;

  Social({
    required this.platform,
    required this.url,
    this.icon = '',
  });

  factory Social.fromJson(Map<String, dynamic> json) => _$SocialFromJson(json);
}

@_deserializable
class RatingInfo {
  final double overallRating;
  final List<UserRating> userRatings;
  final int ratingCount;

  RatingInfo({
    required this.overallRating,
    required this.userRatings,
    required this.ratingCount,
  });

  factory RatingInfo.fromJson(Map<String, dynamic> json) =>
      _$RatingInfoFromJson(json);
}

@_deserializable
class UserRating {
  final String userName;
  final String avatarId;
  final String userId;
  final String createdAt;
  final num rating;
  final String comments;

  UserRating({
    required this.userName,
    required this.userId,
    required this.createdAt,
    required this.rating,
    required this.comments,
    this.avatarId = 'AV1',
  });

  factory UserRating.fromJson(Map<String, dynamic> json) =>
      _$UserRatingFromJson(json);
}
