// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carousel_widget.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CarouselWidgetImpl _$$CarouselWidgetImplFromJson(Map<String, dynamic> json) =>
    _$CarouselWidgetImpl(
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      height: (json['height'] as num?)?.toDouble() ?? 400,
      aspectRatio: (json['aspectRatio'] as num?)?.toDouble() ?? 16 / 9,
      viewportFraction: (json['viewportFraction'] as num?)?.toDouble() ?? 0.8,
      initialPage: (json['initialPage'] as num?)?.toInt() ?? 0,
      enableInfiniteScroll: json['enableInfiniteScroll'] as bool? ?? true,
      reverse: json['reverse'] as bool? ?? false,
      autoPlay: json['autoPlay'] as bool? ?? true,
      autoPlayIntervalSeconds:
          (json['autoPlayIntervalSeconds'] as num?)?.toInt() ?? 3,
      autoPlayAnimationMills:
          (json['autoPlayAnimationMills'] as num?)?.toInt() ?? 800,
      enlargeCenterPage: json['enlargeCenterPage'] as bool? ?? true,
      enlargeFactor: (json['enlargeFactor'] as num?)?.toDouble() ?? 0.3,
      scrollDirection:
          $enumDecodeNullable(_$AxisEnumMap, json['scrollDirection']) ??
              Axis.vertical,
    );

Map<String, dynamic> _$$CarouselWidgetImplToJson(
        _$CarouselWidgetImpl instance) =>
    <String, dynamic>{
      'items': instance.items,
      'height': instance.height,
      'aspectRatio': instance.aspectRatio,
      'viewportFraction': instance.viewportFraction,
      'initialPage': instance.initialPage,
      'enableInfiniteScroll': instance.enableInfiniteScroll,
      'reverse': instance.reverse,
      'autoPlay': instance.autoPlay,
      'autoPlayIntervalSeconds': instance.autoPlayIntervalSeconds,
      'autoPlayAnimationMills': instance.autoPlayAnimationMills,
      'enlargeCenterPage': instance.enlargeCenterPage,
      'enlargeFactor': instance.enlargeFactor,
      'scrollDirection': _$AxisEnumMap[instance.scrollDirection]!,
    };

const _$AxisEnumMap = {
  Axis.horizontal: 'horizontal',
  Axis.vertical: 'vertical',
};
