// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fractional_translation_widget.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FractionalTranslationWidgetImpl _$$FractionalTranslationWidgetImplFromJson(
        Map<String, dynamic> json) =>
    _$FractionalTranslationWidgetImpl(
      dx: (json['dx'] as num?)?.toDouble() ?? 0,
      dy: (json['dy'] as num?)?.toDouble() ?? 0,
      child: json['child'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$FractionalTranslationWidgetImplToJson(
        _$FractionalTranslationWidgetImpl instance) =>
    <String, dynamic>{
      'dx': instance.dx,
      'dy': instance.dy,
      'child': instance.child,
    };
