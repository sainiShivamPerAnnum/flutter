// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_page_sections.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuickActionsCardsData _$QuickActionsCardsDataFromJson(
        Map<String, dynamic> json) =>
    QuickActionsCardsData(
      cards: (json['cards'] as List<dynamic>?)
              ?.map((e) => QuickActionCard.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

QuickActionCard _$QuickActionCardFromJson(Map<String, dynamic> json) =>
    QuickActionCard(
      style: json['style'] as String,
      order: json['order'] as int? ?? 0,
      icon: json['icon'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
    );

QuickActionCardStyle _$QuickActionCardStyleFromJson(
        Map<String, dynamic> json) =>
    QuickActionCardStyle(
      json['bgColor'] as String,
    );

ImageSectionData _$ImageSectionDataFromJson(Map<String, dynamic> json) =>
    ImageSectionData(
      action: Action.fromJson(json['action'] as Map<String, dynamic>),
      url: json['url'] as String? ?? '',
    );

StoriesData _$StoriesDataFromJson(Map<String, dynamic> json) => StoriesData(
      stories: (json['stories'] as List<dynamic>?)
              ?.map((e) => Story.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Story _$StoryFromJson(Map<String, dynamic> json) => Story(
      order: json['order'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      thumbnail: json['thumbnail'] as String? ?? '',
      hash: json['hash'] as String? ?? '',
      story: json['story'] as String? ?? '',
    );

StepsData _$StepsDataFromJson(Map<String, dynamic> json) => StepsData(
      title: json['title'] as String? ?? '',
      steps: (json['steps'] as List<dynamic>?)
              ?.map((e) => Step.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      styles: json['styles'] == null
          ? const {}
          : const StylesConverter()
              .fromJson(json['styles'] as Map<String, dynamic>),
    );

Step _$StepFromJson(Map<String, dynamic> json) => Step(
      action: Action.fromJson(json['action'] as Map<String, dynamic>),
      style: json['style'] as String,
      order: json['order'] as int? ?? 0,
      icon: json['icon'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      ctaLabel: json['ctaLabel'] as String? ?? '',
    );

StepStyle _$StepStyleFromJson(Map<String, dynamic> json) => StepStyle(
      json['backgroundColor'] as String,
      json['ctaLabelColor'] as String,
      json['ctaColor'] as String,
    );

Map<String, dynamic> _$StepStyleToJson(StepStyle instance) => <String, dynamic>{
      'backgroundColor': instance.backgroundColor,
      'ctaLabelColor': instance.ctaLabelColor,
      'ctaColor': instance.ctaColor,
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

_$ImageSectionImpl _$$ImageSectionImplFromJson(Map<String, dynamic> json) =>
    _$ImageSectionImpl(
      ImageSectionData.fromJson(json['data'] as Map<String, dynamic>),
      $type: json['type'] as String?,
    );

_$QuickActionsImpl _$$QuickActionsImplFromJson(Map<String, dynamic> json) =>
    _$QuickActionsImpl(
      ImageSectionData.fromJson(json['data'] as Map<String, dynamic>),
      $type: json['type'] as String?,
    );
