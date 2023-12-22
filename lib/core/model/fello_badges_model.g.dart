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
      'data': instance.data.toJson(),
    };

FelloBadgesData _$FelloBadgesDataFromJson(Map<String, dynamic> json) =>
    FelloBadgesData(
      superFelloWorks: SuperFelloWorks.fromJson(
          json['superFelloWorks'] as Map<String, dynamic>),
      otherBadges: (json['otherBadges'] as List<dynamic>?)
              ?.map((e) =>
                  BadgeLevelInformation.fromJson(e as Map<String, dynamic>))
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
      'levels': instance.levels.map((e) => e.toJson()).toList(),
      'superFelloWorks': instance.superFelloWorks.toJson(),
      'otherBadges': instance.otherBadges.map((e) => e.toJson()).toList(),
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
      badgeUrl: json['badgeUrl'] as String? ?? '',
      lvlData: (json['lvl_data'] as List<dynamic>?)
              ?.map((e) =>
                  BadgeLevelInformation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      levelTitle: json['lvl_title'] as String? ?? '',
      isCompleted: json['isCompleted'] as bool? ?? false,
      levelUnlocked: json['levelUnlocked'] as bool? ?? false,
      isOnGoing: json['isOnGoing'] as bool? ?? false,
    );

Map<String, dynamic> _$LevelToJson(Level instance) => <String, dynamic>{
      'badgeUrl': instance.badgeUrl,
      'benefits': instance.benefits.toJson(),
      'lvl_data': instance.lvlData.map((e) => e.toJson()).toList(),
      'lvl_title': instance.levelTitle,
      'level': _$SuperFelloLevelEnumMap[instance.level]!,
      'isCompleted': instance.isCompleted,
      'isOnGoing': instance.isOnGoing,
      'levelUnlocked': instance.levelUnlocked,
    };

const _$SuperFelloLevelEnumMap = {
  SuperFelloLevel.NEW_FELLO: 'NEW_FELLO',
  SuperFelloLevel.GOOD: 'GOOD',
  SuperFelloLevel.WISE: 'WISE',
  SuperFelloLevel.SUPER_FELLO: 'SUPER_FELLO',
};

BadgeLevelInformation _$BadgeLevelInformationFromJson(
        Map<String, dynamic> json) =>
    BadgeLevelInformation(
      achieve: json['achieve'] as num? ?? 0.0,
      title: json['title'] as String? ?? '',
      barHeading: json['barHeading'] as String? ?? '',
      badgeUrl: json['badgeUrl'] as String? ?? '',
      referText: json['referText'] as String? ?? '',
      bottomSheetText: json['bottomSheetText'] as String? ?? '',
      bottomSheetCta: json['bottomSheetCta'] as String? ?? '',
      ctaAction: json['ctaAction'] == null
          ? null
          : Action.fromJson(json['ctaAction'] as Map<String, dynamic>),
      id: json['id'] as String? ?? '',
      isBadgeAchieved: json['isBadgeAchieved'] as bool? ?? false,
      progressInfo: json['progressInfo'] as String? ?? '',
    );

Map<String, dynamic> _$BadgeLevelInformationToJson(
        BadgeLevelInformation instance) =>
    <String, dynamic>{
      'achieve': instance.achieve,
      'title': instance.title,
      'barHeading': instance.barHeading,
      'badgeUrl': instance.badgeUrl,
      'referText': instance.referText,
      'bottomSheetText': instance.bottomSheetText,
      'bottomSheetCta': instance.bottomSheetCta,
      'ctaAction': instance.ctaAction?.toJson(),
      'id': instance.id,
      'isBadgeAchieved': instance.isBadgeAchieved,
      'progressInfo': instance.progressInfo,
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
