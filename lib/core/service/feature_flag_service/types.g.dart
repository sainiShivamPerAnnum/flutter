// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Features _$FeaturesFromJson(Map<String, dynamic> json) => Features(
      (json['features'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, Feature.fromJson(e as Map<String, dynamic>)),
      ),
    );

Feature _$FeatureFromJson(Map<String, dynamic> json) => Feature(
      rules: (json['rules'] as List<dynamic>?)
              ?.map((e) => Rule.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      defaultValue: json['defaultValue'],
    );

Rule _$RuleFromJson(Map<String, dynamic> json) => Rule(
      json['condition'],
    );
