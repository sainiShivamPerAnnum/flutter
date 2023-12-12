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

Map<String, dynamic> _$FelloBadgesModelToJson(FelloBadgesModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data,
    };

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

Map<String, dynamic> _$FelloBadgesDataToJson(FelloBadgesData instance) =>
    <String, dynamic>{
      'title': instance.title,
      'levels': instance.levels,
      'superFelloWorks': instance.superFelloWorks,
      'otherBadges': instance.otherBadges,
    };

LevelBenefit _$LevelBenefitFromJson(Map<String, dynamic> json) => LevelBenefit(
      title: json['title'] as String? ?? '',
      list:
          (json['list'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
    );

Map<String, dynamic> _$LevelBenefitToJson(LevelBenefit instance) =>
    <String, dynamic>{
      'title': instance.title,
      'list': instance.list,
    };

Level _$LevelFromJson(Map<String, dynamic> json) => Level(
      benefits: LevelBenefit.fromJson(json['benefits'] as Map<String, dynamic>),
      level: $enumDecode(_$SuperFelloLevelEnumMap, json['level']),
      badgeurl: json['badgeurl'] as String? ?? '',
      lvlData: (json['lvl_data'] as List<dynamic>?)
              ?.map((e) =>
                  BadgeLevelInformation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isCompleted: json['isCompleted'] as bool? ?? false,
      levelTitle: json['lvl_title'] as String? ?? '',
    );

Map<String, dynamic> _$LevelToJson(Level instance) => <String, dynamic>{
      'badgeurl': instance.badgeurl,
      'benefits': instance.benefits,
      'lvl_data': instance.lvlData,
      'isCompleted': instance.isCompleted,
      'lvl_title': instance.levelTitle,
      'level': _$SuperFelloLevelEnumMap[instance.level]!,
    };

const _$SuperFelloLevelEnumMap = {
  SuperFelloLevel.BEGINNER: 'BEGINNER',
  SuperFelloLevel.INTERMEDIATE: 'INTERMEDIATE',
  SuperFelloLevel.SUPERFELLO: 'SUPERFELLO',
};

BadgeLevelInformation _$BadgeLevelInformationFromJson(
        Map<String, dynamic> json) =>
    BadgeLevelInformation(
      achieve: json['achieve'] as num? ?? 0.0,
      title: json['title'] as String? ?? '',
      barHeading: json['barHeading'] as String? ?? '',
      badgeurl: json['badgeurl'] as String? ?? '',
      referText: json['referText'] as String? ?? '',
      bottomSheetText: json['bottomSheetText'] as String? ?? '',
      bottomSheetCta: json['bottomSheetCta'] as String? ?? '',
      ctaUrl: json['ctaUrl'] as String? ?? '',
      id: json['id'] as String? ?? '',
      isBadgeAchieved: json['isBadgeAchieved'] as bool? ?? false,
    );

Map<String, dynamic> _$BadgeLevelInformationToJson(
        BadgeLevelInformation instance) =>
    <String, dynamic>{
      'achieve': instance.achieve,
      'title': instance.title,
      'barHeading': instance.barHeading,
      'badgeurl': instance.badgeurl,
      'referText': instance.referText,
      'bottomSheetText': instance.bottomSheetText,
      'bottomSheetCta': instance.bottomSheetCta,
      'ctaUrl': instance.ctaUrl,
      'id': instance.id,
      'isBadgeAchieved': instance.isBadgeAchieved,
    };

SuperFelloWorks _$SuperFelloWorksFromJson(Map<String, dynamic> json) =>
    SuperFelloWorks(
      mainText: json['main_text'] as String? ?? '',
      subText: (json['sub_text'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$SuperFelloWorksToJson(SuperFelloWorks instance) =>
    <String, dynamic>{
      'main_text': instance.mainText,
      'sub_text': instance.subText,
    };

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

Map<String, dynamic> _$OtherBadgeToJson(OtherBadge instance) =>
    <String, dynamic>{
      'url': instance.url,
      'title': instance.title,
      'enable': instance.enable,
      'description': instance.description,
      'action': instance.action,
      'buttonText': instance.buttonText,
      'referText': instance.referText,
      'bottomSheetText': instance.bottomSheetText,
      'bottomSheetCta': instance.bottomSheetCta,
      'ctaUrl': instance.ctaUrl,
    };
