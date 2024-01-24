// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Action _$ActionFromJson(Map<String, dynamic> json) => Action(
      type: $enumDecode(_$ActionTypeEnumMap, json['type']),
      payload: json['payload'] as Map<String, dynamic>? ?? const {},
      events: json['events'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$ActionToJson(Action instance) => <String, dynamic>{
      'type': _$ActionTypeEnumMap[instance.type]!,
      'payload': instance.payload,
      'events': instance.events,
    };

const _$ActionTypeEnumMap = {
  ActionType.DEEP_LINK: 'DEEP_LINK',
  ActionType.LAUNCH_EXTERNAL_APPLICATION: 'LAUNCH_EXTERNAL_APPLICATION',
  ActionType.LAUNCH_WEBVIEW: 'LAUNCH_WEBVIEW',
  ActionType.POP: 'POP',
  ActionType.SHARE: 'SHARE',
};
