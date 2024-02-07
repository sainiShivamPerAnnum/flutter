// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'select_asset_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssetOptions _$AssetOptionsFromJson(Map<String, dynamic> json) => AssetOptions(
      title: json['title'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      subText: json['subText'] as String? ?? '',
      defaultSelected: json['defaultSelected'] as bool? ?? false,
      type: $enumDecodeNullable(_$SIPAssetTypesEnumMap, json['type'],
              unknownValue: SIPAssetTypes.UNKNOWN) ??
          SIPAssetTypes.UNKNOWN,
      interest: json['interest'] as num? ?? 8,
    );

const _$SIPAssetTypesEnumMap = {
  SIPAssetTypes.UNI_FLEXI: 'UNI_FLEXI',
  SIPAssetTypes.UNI_FIXED_3: 'UNI_FIXED_3',
  SIPAssetTypes.UNI_FIXED_6: 'UNI_FIXED_6',
  SIPAssetTypes.AUGGOLD99: 'AUGGOLD99',
  SIPAssetTypes.BOTH: 'BOTH',
  SIPAssetTypes.UNKNOWN: 'UNKNOWN',
};
