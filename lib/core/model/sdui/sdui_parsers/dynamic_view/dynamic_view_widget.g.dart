// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dynamic_view_widget.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DynamicViewWidgetImpl _$$DynamicViewWidgetImplFromJson(
        Map<String, dynamic> json) =>
    _$DynamicViewWidgetImpl(
      request:
          StacNetworkRequest.fromJson(json['request'] as Map<String, dynamic>),
      targetPath: json['targetPath'] as String? ?? '',
      template: json['template'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$$DynamicViewWidgetImplToJson(
        _$DynamicViewWidgetImpl instance) =>
    <String, dynamic>{
      'request': instance.request,
      'targetPath': instance.targetPath,
      'template': instance.template,
    };
