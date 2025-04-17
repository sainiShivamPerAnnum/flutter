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
      template: json['template'] as Map<String, dynamic>,
      targetPath: json['targetPath'] as String? ?? '',
    );

Map<String, dynamic> _$$DynamicViewWidgetImplToJson(
        _$DynamicViewWidgetImpl instance) =>
    <String, dynamic>{
      'request': instance.request,
      'template': instance.template,
      'targetPath': instance.targetPath,
    };
