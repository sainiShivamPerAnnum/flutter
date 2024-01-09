// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_page_sections.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PageData _$PageDataFromJson(Map<String, dynamic> json) => PageData(
      styles: Styles.fromJson(json['styles'] as Map<String, dynamic>),
      screens: ScreenData.fromJson(json['screens'] as Map<String, dynamic>),
    );

ScreenData _$ScreenDataFromJson(Map<String, dynamic> json) => ScreenData(
      home: HomePageScreenData.fromJson(json['home'] as Map<String, dynamic>),
      assetPreference: AssetPreferenceData.fromJson(
          json['assetPreference'] as Map<String, dynamic>),
    );

AssetPreferenceData _$AssetPreferenceDataFromJson(Map<String, dynamic> json) =>
    AssetPreferenceData(
      notSure:
          BottomSheetData.fromJson(json['notSure'] as Map<String, dynamic>),
      skipToHome:
          BottomSheetData.fromJson(json['skipToHome'] as Map<String, dynamic>),
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      options: (json['options'] as List<dynamic>?)
              ?.map((e) => AssetPrefOption.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

AssetPrefOption _$AssetPrefOptionFromJson(Map<String, dynamic> json) =>
    AssetPrefOption(
      assetType:
          $enumDecodeNullable(_$AssetPrefTypeEnumMap, json['assetType']) ??
              AssetPrefType.GOLD,
      icon: json['icon'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      info: (json['info'] as List<dynamic>?)
              ?.map((e) => AssetOptionInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

const _$AssetPrefTypeEnumMap = {
  AssetPrefType.P2P: 'P2P',
  AssetPrefType.GOLD: 'GOLD',
  AssetPrefType.NONE: 'NONE',
};

AssetOptionInfo _$AssetOptionInfoFromJson(Map<String, dynamic> json) =>
    AssetOptionInfo(
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
    );

BottomSheetData _$BottomSheetDataFromJson(Map<String, dynamic> json) =>
    BottomSheetData(
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      image: json['image'] as String? ?? '',
      cta: (json['cta'] as List<dynamic>?)
              ?.map((e) => Cta.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Cta _$CtaFromJson(Map<String, dynamic> json) => Cta(
      label: json['label'] as String? ?? '',
      type: $enumDecodeNullable(_$CTATypeEnumMap, json['type']) ??
          CTAType.secondary,
      action: json['action'] == null
          ? null
          : Action.fromJson(json['action'] as Map<String, dynamic>),
    );

const _$CTATypeEnumMap = {
  CTAType.secondary: 'secondary',
  CTAType.secondaryOutline: 'secondaryOutline',
};

HomePageScreenData _$HomePageScreenDataFromJson(Map<String, dynamic> json) =>
    HomePageScreenData(
      sections: json['sections'] == null
          ? const {}
          : const SectionsConverter()
              .fromJson(json['sections'] as Map<String, dynamic>),
      sectionOrder: (json['sectionOrder'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

QuickActionsCardsData _$QuickActionsCardsDataFromJson(
        Map<String, dynamic> json) =>
    QuickActionsCardsData(
      title: json['title'] as String,
      cards: (json['cards'] as List<dynamic>?)
              ?.map((e) => QuickActionCard.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

QuickActionCard _$QuickActionCardFromJson(Map<String, dynamic> json) =>
    QuickActionCard(
      style: json['style'] as String,
      icon: json['icon'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      action: json['action'] == null
          ? null
          : Action.fromJson(json['action'] as Map<String, dynamic>),
    );

ImageSectionData _$ImageSectionDataFromJson(Map<String, dynamic> json) =>
    ImageSectionData(
      action: json['action'] == null
          ? null
          : Action.fromJson(json['action'] as Map<String, dynamic>),
      url: json['url'] as String? ?? '',
    );

StoriesData _$StoriesDataFromJson(Map<String, dynamic> json) => StoriesData(
      stories: (json['stories'] as List<dynamic>?)
              ?.map((e) => Story.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Story _$StoryFromJson(Map<String, dynamic> json) => Story(
      cta: (json['cta'] as List<dynamic>?)
              ?.map((e) => Cta.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      thumbnail: json['thumbnail'] as String? ?? '',
      blurHash: json['blurHash'] as String? ?? '',
      story: json['story'] as String? ?? '',
    );

StepsData _$StepsDataFromJson(Map<String, dynamic> json) => StepsData(
      title: json['title'] as String? ?? '',
      steps: (json['steps'] as List<dynamic>?)
              ?.map((e) => Step.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Step _$StepFromJson(Map<String, dynamic> json) => Step(
      style: json['style'] as String,
      cta: Cta.fromJson(json['cta'] as Map<String, dynamic>),
      icon: json['icon'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      ctaLabel: json['ctaLabel'] as String? ?? '',
    );

Styles _$StylesFromJson(Map<String, dynamic> json) => Styles(
      steps: json['steps'] == null
          ? const {}
          : const StepStyleConverter()
              .fromJson(json['steps'] as Map<String, dynamic>),
      infoCards: (json['infoCards'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry(k, InfoCardStyle.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
    );

StepStyle _$StepStyleFromJson(Map<String, dynamic> json) => StepStyle(
      json['shadowColor'] as String,
      json['ctaBgColor'] as String,
      json['ctaColor'] as String,
    );

Map<String, dynamic> _$StepStyleToJson(StepStyle instance) => <String, dynamic>{
      'shadowColor': instance.shadowColor,
      'ctaColor': instance.ctaColor,
      'ctaBgColor': instance.ctaBgColor,
    };

InfoCardStyle _$InfoCardStyleFromJson(Map<String, dynamic> json) =>
    InfoCardStyle(
      bgColor: json['bgColor'] as String? ?? '',
    );

Map<String, dynamic> _$InfoCardStyleToJson(InfoCardStyle instance) =>
    <String, dynamic>{
      'bgColor': instance.bgColor,
    };

_$StoriesSectionImpl _$$StoriesSectionImplFromJson(Map<String, dynamic> json) =>
    _$StoriesSectionImpl(
      StoriesData.fromJson(json['data'] as Map<String, dynamic>),
      $type: json['type'] as String?,
    );

_$StepsSectionImpl _$$StepsSectionImplFromJson(Map<String, dynamic> json) =>
    _$StepsSectionImpl(
      StepsData.fromJson(json['data'] as Map<String, dynamic>),
      $type: json['type'] as String?,
    );

_$QuickActionsImpl _$$QuickActionsImplFromJson(Map<String, dynamic> json) =>
    _$QuickActionsImpl(
      QuickActionsCardsData.fromJson(json['data'] as Map<String, dynamic>),
      $type: json['type'] as String?,
    );

_$ImageSectionImpl _$$ImageSectionImplFromJson(Map<String, dynamic> json) =>
    _$ImageSectionImpl(
      ImageSectionData.fromJson(json['data'] as Map<String, dynamic>),
      $type: json['type'] as String?,
    );

_$NudgeSectionImpl _$$NudgeSectionImplFromJson(Map<String, dynamic> json) =>
    _$NudgeSectionImpl(
      $type: json['type'] as String?,
    );
