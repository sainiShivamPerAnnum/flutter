// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'instant_save_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstantSaveResponse _$InstantSaveCardResponseFromJson(
        Map<String, dynamic> json) =>
    InstantSaveResponse(
      data:
          InstantSaveCardConfig.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String? ?? '',
    );

InstantSaveCardConfig _$InstantSaveCardConfigFromJson(
        Map<String, dynamic> json) =>
    InstantSaveCardConfig(
      leftImg: json['leftImg'] == null
          ? null
          : ImageConfig.fromJson(json['leftImg'] as Map<String, dynamic>),
      rightImg: json['rightImg'] == null
          ? null
          : ImageConfig.fromJson(json['rightImg'] as Map<String, dynamic>),
    );

ImageConfig _$ImageConfigFromJson(Map<String, dynamic> json) => ImageConfig(
      imgUrl: json['imgUrl'] as String? ?? '',
      actionUri: json['actionUri'] as String? ?? '',
      bgColor: json['bgColor'] as String? ?? '#01656B',
    );
