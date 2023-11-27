import 'package:json_annotation/json_annotation.dart';

part 'instant_save_card.g.dart';

const _deserializable = JsonSerializable(
  createToJson: false,
);

@_deserializable
class InstantSaveCardResponse {
  final String message;
  final InstantSaveCardConfig data;

  const InstantSaveCardResponse({
    required this.data,
    this.message = '',
  });

  factory InstantSaveCardResponse.fromJson(Map<String, dynamic> json) =>
      _$InstantSaveCardResponseFromJson(json);
}

@_deserializable
class InstantSaveCardConfig {
  final ImageConfig? background;
  final ImageConfig? foreground;
  final num aspectRatio;

  const InstantSaveCardConfig({
    this.background,
    this.foreground,
    this.aspectRatio = 2.7,
  });

  factory InstantSaveCardConfig.fromJson(Map<String, dynamic> json) =>
      _$InstantSaveCardConfigFromJson(json);
}

@_deserializable
class ImageConfig {
  final String imgUrl;
  final String actionUri;

  const ImageConfig({
    this.imgUrl = '',
    this.actionUri = '',
  });

  factory ImageConfig.fromJson(Map<String, dynamic> json) =>
      _$ImageConfigFromJson(json);
}
