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
  });

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
  final String name;
  final String imageUrl;
  final DateTime issueDate;
  final String credentials;

  License({
    required this.name,
    required this.imageUrl,
    required this.issueDate,
    required this.credentials,
  });

  factory License.fromJson(Map<String, dynamic> json) =>
      _$LicenseFromJson(json);
}

@_deserializable
class Social {
  final String platform;
  final String url;
  final String iconUrl;

  Social({
    required this.platform,
    required this.url,
    this.iconUrl ='',
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
    this.avatarId ='AV1',
  });

  factory UserRating.fromJson(Map<String, dynamic> json) =>
      _$UserRatingFromJson(json);
}
