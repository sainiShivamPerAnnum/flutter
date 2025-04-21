// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bordered_text_widget.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BorderedTextWidgetImpl _$$BorderedTextWidgetImplFromJson(
        Map<String, dynamic> json) =>
    _$BorderedTextWidgetImpl(
      text: json['text'] as String,
      fontSize: (json['fontSize'] as num?)?.toDouble(),
      strokeCap: json['strokeCap'] as String?,
      strokeJoin: json['strokeJoin'] as String?,
      strokeWidth: (json['strokeWidth'] as num?)?.toDouble(),
      strokeColor: json['strokeColor'] as String?,
      gradient: json['gradient'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$BorderedTextWidgetImplToJson(
        _$BorderedTextWidgetImpl instance) =>
    <String, dynamic>{
      'text': instance.text,
      'fontSize': instance.fontSize,
      'strokeCap': instance.strokeCap,
      'strokeJoin': instance.strokeJoin,
      'strokeWidth': instance.strokeWidth,
      'strokeColor': instance.strokeColor,
      'gradient': instance.gradient,
    };
