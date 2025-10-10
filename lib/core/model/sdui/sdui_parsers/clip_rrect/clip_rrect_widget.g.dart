// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clip_rrect_widget.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ClipRRectWidgetImpl _$$ClipRRectWidgetImplFromJson(
        Map<String, dynamic> json) =>
    _$ClipRRectWidgetImpl(
      borderRadius: json['borderRadius'] == null
          ? null
          : BorderRadiusModel.fromJson(
              json['borderRadius'] as Map<String, dynamic>),
      clipBehavior: json['clipBehavior'] as String?,
      child: json['child'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$ClipRRectWidgetImplToJson(
        _$ClipRRectWidgetImpl instance) =>
    <String, dynamic>{
      'borderRadius': instance.borderRadius,
      'clipBehavior': instance.clipBehavior,
      'child': instance.child,
    };

_$BorderRadiusModelImpl _$$BorderRadiusModelImplFromJson(
        Map<String, dynamic> json) =>
    _$BorderRadiusModelImpl(
      all: (json['all'] as num?)?.toDouble(),
      topLeft: (json['topLeft'] as num?)?.toDouble(),
      topRight: (json['topRight'] as num?)?.toDouble(),
      bottomLeft: (json['bottomLeft'] as num?)?.toDouble(),
      bottomRight: (json['bottomRight'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$BorderRadiusModelImplToJson(
        _$BorderRadiusModelImpl instance) =>
    <String, dynamic>{
      'all': instance.all,
      'topLeft': instance.topLeft,
      'topRight': instance.topRight,
      'bottomLeft': instance.bottomLeft,
      'bottomRight': instance.bottomRight,
    };
