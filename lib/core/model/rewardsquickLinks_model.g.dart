// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rewardsquickLinks_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RewardsQuickLinksModel _$RewardsQuickLinksModelFromJson(
        Map<String, dynamic> json) =>
    RewardsQuickLinksModel(
      title: json['title'] as String?,
      subTitle: json['subTitle'] as String?,
      rewardText: json['rewardText'] as String?,
      rewardType: $enumDecodeNullable(_$RewardsTypeEnumMap, json['rewardType']),
      rewardCount: json['rewardCount'] as int?,
      imageUrl: json['imageUrl'] as String?,
      cta: (json['cta'] as List<dynamic>?)
          ?.map((e) => RewardsCta.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RewardsQuickLinksModelToJson(
        RewardsQuickLinksModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'subTitle': instance.subTitle,
      'rewardText': instance.rewardText,
      'rewardType': _$RewardsTypeEnumMap[instance.rewardType],
      'rewardCount': instance.rewardCount,
      'imageUrl': instance.imageUrl,
      'cta': instance.cta,
    };

const _$RewardsTypeEnumMap = {
  RewardsType.ticket: 'ticket',
  RewardsType.rupee: 'rupee',
};
