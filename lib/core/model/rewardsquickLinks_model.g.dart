// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rewardsquickLinks_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RewardsQuickLinksModel _$RewardsQuickLinksModelFromJson(
        Map<String, dynamic> json) =>
    RewardsQuickLinksModel(
      title: json['title'] as String? ?? '',
      subTitle: json['subTitle'] as String? ?? '',
      rewardText: json['rewardText'] as String? ?? '',
      rewardType:
          $enumDecodeNullable(_$RewardsTypeEnumMap, json['rewardType']) ??
              RewardsType.ticket,
      rewardCount: json['rewardCount'] as int? ?? 0,
      imageUrl: json['imageUrl'] as String? ?? '',
      cta: (json['cta'] as List<dynamic>?)
              ?.map((e) => RewardsCta.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

const _$RewardsTypeEnumMap = {
  RewardsType.ticket: 'ticket',
  RewardsType.rupee: 'rupee',
};
