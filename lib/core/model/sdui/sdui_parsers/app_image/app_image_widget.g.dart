// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_image_widget.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AppImageWidgetImpl _$$AppImageWidgetImplFromJson(Map<String, dynamic> json) =>
    _$AppImageWidgetImpl(
      image: json['image'] as String,
      fit: json['fit'] as String?,
      height: (json['height'] as num?)?.toDouble(),
      width: (json['width'] as num?)?.toDouble(),
      color: json['color'] as String?,
    );

Map<String, dynamic> _$$AppImageWidgetImplToJson(
        _$AppImageWidgetImpl instance) =>
    <String, dynamic>{
      'image': instance.image,
      'fit': instance.fit,
      'height': instance.height,
      'width': instance.width,
      'color': instance.color,
    };
