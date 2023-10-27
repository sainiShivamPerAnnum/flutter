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
  final ImageConfig? leftImg;
  final ImageConfig? rightImg;

  const InstantSaveCardConfig({
    this.leftImg,
    this.rightImg,
  });

  factory InstantSaveCardConfig.fromJson(Map<String, dynamic> json) =>
      _$InstantSaveCardConfigFromJson(json);
}

@_deserializable
class ImageConfig {
  final String imgUrl;
  final String actionUri;
  final String bgColor;

  const ImageConfig({
    this.imgUrl = '',
    this.actionUri = '',
    this.bgColor = '#01656B',
  });

  factory ImageConfig.fromJson(Map<String, dynamic> json) =>
      _$ImageConfigFromJson(json);
}
