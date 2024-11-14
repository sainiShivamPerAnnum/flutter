// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'experts_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExpertDetails _$ExpertDetailsFromJson(Map<String, dynamic> json) =>
    ExpertDetails(
      name: json['name'] as String,
      image: json['image'] as String,
      description: json['description'] as String,
      isLive: json['isLive'] as bool,
      experience: json['experience'] as String,
      sessionCount: json['sessionCount'] as int,
      rating: (json['rating'] as num).toDouble(),
      QuickActions: (json['QuickActions'] as List<dynamic>)
          .map((e) => QuickAction.fromJson(e as Map<String, dynamic>))
          .toList(),
      licenses: (json['licenses'] as List<dynamic>)
          .map((e) => License.fromJson(e as Map<String, dynamic>))
          .toList(),
      social: (json['social'] as List<dynamic>)
          .map((e) => Social.fromJson(e as Map<String, dynamic>))
          .toList(),
      ratingInfo:
          RatingInfo.fromJson(json['ratingInfo'] as Map<String, dynamic>),
    );

QuickAction _$QuickActionFromJson(Map<String, dynamic> json) => QuickAction(
      heading: json['heading'] as String,
      subheading: json['subheading'] as String,
      buttonText: json['buttonText'] as String,
      buttonCTA: json['buttonCTA'] as String,
    );

License _$LicenseFromJson(Map<String, dynamic> json) => License(
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      issueDate: DateTime.parse(json['issueDate'] as String),
      credentials: json['credentials'] as String,
      id: json['_id'] as String? ?? '',
    );

Social _$SocialFromJson(Map<String, dynamic> json) => Social(
      platform: json['platform'] as String,
      url: json['url'] as String,
      icon: json['icon'] as String? ?? '',
    );

RatingInfo _$RatingInfoFromJson(Map<String, dynamic> json) => RatingInfo(
      overallRating: (json['overallRating'] as num).toDouble(),
      userRatings: (json['userRatings'] as List<dynamic>)
          .map((e) => UserRating.fromJson(e as Map<String, dynamic>))
          .toList(),
      ratingCount: json['ratingCount'] as int,
    );

UserRating _$UserRatingFromJson(Map<String, dynamic> json) => UserRating(
      userName: json['userName'] as String,
      userId: json['userId'] as String,
      createdAt: json['createdAt'] as String,
      rating: json['rating'] as num,
      comments: json['comments'] as String,
      avatarId: json['avatarId'] as String? ?? 'AV1',
    );
