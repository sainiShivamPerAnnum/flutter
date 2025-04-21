// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translate_widget.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransformWidgetImpl _$$TransformWidgetImplFromJson(
        Map<String, dynamic> json) =>
    _$TransformWidgetImpl(
      dx: (json['dx'] as num?)?.toDouble() ?? 0,
      dy: (json['dy'] as num?)?.toDouble() ?? 0,
      child: json['child'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$TransformWidgetImplToJson(
        _$TransformWidgetImpl instance) =>
    <String, dynamic>{
      'dx': instance.dx,
      'dy': instance.dy,
      'child': instance.child,
    };
