// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rewardsCta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RewardsCta _$RewardsCtaFromJson(Map<String, dynamic> json) => RewardsCta(
      label: json['label'] as String?,
      style: json['style'] as String?,
      action: json['action'] == null
          ? null
          : Action.fromJson(json['action'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RewardsCtaToJson(RewardsCta instance) =>
    <String, dynamic>{
      'label': instance.label,
      'style': instance.style,
      'action': instance.action,
    };
