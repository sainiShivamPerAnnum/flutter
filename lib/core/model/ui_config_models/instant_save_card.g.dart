// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instant_save_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstantSaveCardResponse _$InstantSaveCardResponseFromJson(
        Map<String, dynamic> json) =>
    InstantSaveCardResponse(
      data:
          InstantSaveCardConfig.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String? ?? '',
    );

InstantSaveCardConfig _$InstantSaveCardConfigFromJson(
        Map<String, dynamic> json) =>
    InstantSaveCardConfig(
      background: json['background'] == null
          ? null
          : ImageConfig.fromJson(json['background'] as Map<String, dynamic>),
      foreground: json['foreground'] == null
          ? null
          : ImageConfig.fromJson(json['foreground'] as Map<String, dynamic>),
      aspectRatio: json['aspectRatio'] as num? ?? 2.7,
    );

ImageConfig _$ImageConfigFromJson(Map<String, dynamic> json) => ImageConfig(
      imgUrl: json['imgUrl'] as String? ?? '',
      actionUri: json['actionUri'] as String? ?? '',
    );
