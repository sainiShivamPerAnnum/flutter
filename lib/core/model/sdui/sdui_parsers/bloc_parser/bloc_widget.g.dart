// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bloc_widget.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BlocWidgetImpl _$$BlocWidgetImplFromJson(Map<String, dynamic> json) =>
    _$BlocWidgetImpl(
      blocType: json['blocType'] as String,
      initialState: json['initialState'] as Map<String, dynamic>?,
      child: json['child'] as Map<String, dynamic>?,
      events: (json['events'] as List<dynamic>?)
          ?.map((e) => BlocEventModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      builderProperties: json['builderProperties'] as Map<String, dynamic>?,
      widgetType: json['widgetType'] as String? ?? 'provider',
      initialEvent: json['initialEvent'] as Map<String, dynamic>?,
      buildWhen: json['buildWhen'] as String?,
      listenWhen: json['listenWhen'] as String?,
    );

Map<String, dynamic> _$$BlocWidgetImplToJson(_$BlocWidgetImpl instance) =>
    <String, dynamic>{
      'blocType': instance.blocType,
      'initialState': instance.initialState,
      'child': instance.child,
      'events': instance.events,
      'builderProperties': instance.builderProperties,
      'widgetType': instance.widgetType,
      'initialEvent': instance.initialEvent,
      'buildWhen': instance.buildWhen,
      'listenWhen': instance.listenWhen,
    };

_$BlocEventModelImpl _$$BlocEventModelImplFromJson(Map<String, dynamic> json) =>
    _$BlocEventModelImpl(
      type: json['type'] as String,
      payload: json['payload'] as Map<String, dynamic>?,
      trigger: json['trigger'] as String? ?? 'tap',
    );

Map<String, dynamic> _$$BlocEventModelImplToJson(
        _$BlocEventModelImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'payload': instance.payload,
      'trigger': instance.trigger,
    };
