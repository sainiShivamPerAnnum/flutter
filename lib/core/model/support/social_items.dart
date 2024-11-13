import 'package:json_annotation/json_annotation.dart';

part 'social_items.g.dart';

const _deserializable = JsonSerializable(
  createToJson: false,
);

@_deserializable
class SocialItems {
  final String name;
  final String icon;
  final String link;

  SocialItems({
    required this.name,
    required this.icon,
    required this.link,
  });

  factory SocialItems.fromJson(Map<String, dynamic> json) =>
      _$SocialItemsFromJson(json);
}

@_deserializable
class SocialVideo {
  final String title;
  final String bgImage;
  final String duration;

  SocialVideo({
    required this.title,
    required this.bgImage,
    required this.duration,
  });

  factory SocialVideo.fromJson(Map<String, dynamic> json) =>
      _$SocialVideoFromJson(json);
}
