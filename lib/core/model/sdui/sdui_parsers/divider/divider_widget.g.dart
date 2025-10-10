// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'divider_widget.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DividerWidgetImpl _$$DividerWidgetImplFromJson(Map<String, dynamic> json) =>
    _$DividerWidgetImpl(
      height: (json['height'] as num?)?.toDouble(),
      thickness: (json['thickness'] as num?)?.toDouble(),
      indent: (json['indent'] as num?)?.toDouble(),
      endIndent: (json['endIndent'] as num?)?.toDouble(),
      color: json['color'] as String?,
    );

Map<String, dynamic> _$$DividerWidgetImplToJson(_$DividerWidgetImpl instance) =>
    <String, dynamic>{
      'height': instance.height,
      'thickness': instance.thickness,
      'indent': instance.indent,
      'endIndent': instance.endIndent,
      'color': instance.color,
    };
