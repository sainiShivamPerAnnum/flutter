// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fello_badges_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FelloBadgesModel _$FelloBadgesModelFromJson(Map<String, dynamic> json) =>
    FelloBadgesModel(
      data: FelloBadgesData.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String? ?? '',
    );

FelloBadgesData _$FelloBadgesDataFromJson(Map<String, dynamic> json) =>
    FelloBadgesData(
      superFelloWorks: SuperFelloWorks.fromJson(
          json['superFelloWorks'] as Map<String, dynamic>),
      otherBadges: (json['otherBadges'] as List<dynamic>?)
              ?.map((e) => OtherBadge.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      levels: (json['levels'] as List<dynamic>?)
              ?.map((e) => Level.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      title: json['title'] as String? ?? '',
    );

LevelBenefit _$LevelBenefitFromJson(Map<String, dynamic> json) => LevelBenefit(
      title: json['title'] as String? ?? '',
      list:
          (json['list'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
    );

Level _$LevelFromJson(Map<String, dynamic> json) => Level(
      benefits: LevelBenefit.fromJson(json['benefits'] as Map<String, dynamic>),
      level: $enumDecode(_$UserBadgeLevelEnumMap, json['level']),
      badgeurl: json['badgeurl'] as String? ?? '',
      lvlData: (json['lvl_data'] as List<dynamic>?)
              ?.map((e) => LevelData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isCompleted: json['isCompleted'] as bool? ?? false,
      levelTitle: json['lvl_title'] as String? ?? '',
    );

const _$UserBadgeLevelEnumMap = {
  UserBadgeLevel.BEGINNER: 'BEGINNER',
  UserBadgeLevel.INTERMEDIATE: 'INTERMEDIATE',
  UserBadgeLevel.SUPERFELLO: 'SUPERFELLO',
};

LevelData _$LevelDataFromJson(Map<String, dynamic> json) => LevelData(
      achieve: json['achieve'] as num? ?? 0.0,
      title: json['title'] as String? ?? '',
      barHeading: json['barHeading'] as String? ?? '',
      badgeurl: json['badgeurl'] as String? ?? '',
      referText: json['referText'] as String? ?? '',
      bottomSheetText: json['bottomSheetText'] as String? ?? '',
      bottomSheetCta: json['bottomSheetCta'] as String? ?? '',
      ctaUrl: json['ctaUrl'] as String? ?? '',
    );

SuperFelloWorks _$SuperFelloWorksFromJson(Map<String, dynamic> json) =>
    SuperFelloWorks(
      mainText: json['main_text'] as String? ?? '',
      subText: (json['sub_text'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

OtherBadge _$OtherBadgeFromJson(Map<String, dynamic> json) => OtherBadge(
      url: json['url'] as String? ?? '',
      title: json['title'] as String? ?? '',
      enable: json['enable'] as bool? ?? false,
      description: json['description'] as String? ?? '',
      action: json['action'] as String? ?? '',
      buttonText: json['buttonText'] as String? ?? '',
      referText: json['referText'] as String? ?? '',
      bottomSheetText: json['bottomSheetText'] as String? ?? '',
      bottomSheetCta: json['bottomSheetCta'] as String? ?? '',
      ctaUrl: json['ctaUrl'] as String? ?? '',
    );
