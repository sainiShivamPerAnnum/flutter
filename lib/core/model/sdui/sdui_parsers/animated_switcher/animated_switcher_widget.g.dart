// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'animated_switcher_widget.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnimatedSwitcherWidgetImpl _$$AnimatedSwitcherWidgetImplFromJson(
        Map<String, dynamic> json) =>
    _$AnimatedSwitcherWidgetImpl(
      durationInMs: (json['durationInMs'] as num?)?.toInt(),
      reverseDurationInMs: (json['reverseDurationInMs'] as num?)?.toInt(),
      switchInCurve: json['switchInCurve'] as String?,
      switchOutCurve: json['switchOutCurve'] as String?,
      transitionBuilder: json['transitionBuilder'] as String?,
      layoutBuilder: json['layoutBuilder'] as String?,
      child: json['child'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$AnimatedSwitcherWidgetImplToJson(
        _$AnimatedSwitcherWidgetImpl instance) =>
    <String, dynamic>{
      'durationInMs': instance.durationInMs,
      'reverseDurationInMs': instance.reverseDurationInMs,
      'switchInCurve': instance.switchInCurve,
      'switchOutCurve': instance.switchOutCurve,
      'transitionBuilder': instance.transitionBuilder,
      'layoutBuilder': instance.layoutBuilder,
      'child': instance.child,
    };
