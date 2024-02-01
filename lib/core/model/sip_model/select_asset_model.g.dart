// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'select_asset_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SelectAssetScreen _$SelectAssetScreenFromJson(Map<String, dynamic> json) =>
    SelectAssetScreen(
      title: json['title'] as String?,
      subTitle: json['subTitle'] as String?,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => AssetOptions.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
