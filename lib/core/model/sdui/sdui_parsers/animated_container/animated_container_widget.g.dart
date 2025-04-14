// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'animated_container_widget.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnimatedContainerWidgetImpl _$$AnimatedContainerWidgetImplFromJson(
        Map<String, dynamic> json) =>
    _$AnimatedContainerWidgetImpl(
      durationInMs: (json['durationInMs'] as num?)?.toInt(),
      curve: json['curve'] as String?,
      width: (json['width'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
      padding: json['padding'] as Map<String, dynamic>?,
      margin: json['margin'] as Map<String, dynamic>?,
      alignment: json['alignment'] as String?,
      color: json['color'] as String?,
      decoration: json['decoration'] == null
          ? null
          : ContainerDecorationModel.fromJson(
              json['decoration'] as Map<String, dynamic>),
      transform: json['transform'] == null
          ? null
          : TransformModel.fromJson(json['transform'] as Map<String, dynamic>),
      transformAlignment: json['transformAlignment'] as String?,
      clip: json['clip'] as String?,
      constraints: json['constraints'] == null
          ? null
          : BoxConstraintsModel.fromJson(
              json['constraints'] as Map<String, dynamic>),
      child: json['child'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$AnimatedContainerWidgetImplToJson(
        _$AnimatedContainerWidgetImpl instance) =>
    <String, dynamic>{
      'durationInMs': instance.durationInMs,
      'curve': instance.curve,
      'width': instance.width,
      'height': instance.height,
      'padding': instance.padding,
      'margin': instance.margin,
      'alignment': instance.alignment,
      'color': instance.color,
      'decoration': instance.decoration,
      'transform': instance.transform,
      'transformAlignment': instance.transformAlignment,
      'clip': instance.clip,
      'constraints': instance.constraints,
      'child': instance.child,
    };

_$ContainerDecorationModelImpl _$$ContainerDecorationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ContainerDecorationModelImpl(
      color: json['color'] as String?,
      borderRadius: (json['borderRadius'] as num?)?.toDouble(),
      borderColor: json['borderColor'] as String?,
      borderWidth: (json['borderWidth'] as num?)?.toDouble(),
      shadow: (json['shadow'] as num?)?.toDouble(),
      shadowColor: json['shadowColor'] as String?,
      spreadRadius: (json['spreadRadius'] as num?)?.toDouble(),
      offsetX: (json['offsetX'] as num?)?.toDouble(),
      offsetY: (json['offsetY'] as num?)?.toDouble(),
      gradient: json['gradient'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$ContainerDecorationModelImplToJson(
        _$ContainerDecorationModelImpl instance) =>
    <String, dynamic>{
      'color': instance.color,
      'borderRadius': instance.borderRadius,
      'borderColor': instance.borderColor,
      'borderWidth': instance.borderWidth,
      'shadow': instance.shadow,
      'shadowColor': instance.shadowColor,
      'spreadRadius': instance.spreadRadius,
      'offsetX': instance.offsetX,
      'offsetY': instance.offsetY,
      'gradient': instance.gradient,
    };

_$TransformModelImpl _$$TransformModelImplFromJson(Map<String, dynamic> json) =>
    _$TransformModelImpl(
      translateX: (json['translateX'] as num?)?.toDouble(),
      translateY: (json['translateY'] as num?)?.toDouble(),
      translateZ: (json['translateZ'] as num?)?.toDouble(),
      rotateX: (json['rotateX'] as num?)?.toDouble(),
      rotateY: (json['rotateY'] as num?)?.toDouble(),
      rotateZ: (json['rotateZ'] as num?)?.toDouble(),
      scaleX: (json['scaleX'] as num?)?.toDouble(),
      scaleY: (json['scaleY'] as num?)?.toDouble(),
      scaleZ: (json['scaleZ'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$TransformModelImplToJson(
        _$TransformModelImpl instance) =>
    <String, dynamic>{
      'translateX': instance.translateX,
      'translateY': instance.translateY,
      'translateZ': instance.translateZ,
      'rotateX': instance.rotateX,
      'rotateY': instance.rotateY,
      'rotateZ': instance.rotateZ,
      'scaleX': instance.scaleX,
      'scaleY': instance.scaleY,
      'scaleZ': instance.scaleZ,
    };

_$BoxConstraintsModelImpl _$$BoxConstraintsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$BoxConstraintsModelImpl(
      minWidth: (json['minWidth'] as num?)?.toDouble(),
      maxWidth: (json['maxWidth'] as num?)?.toDouble(),
      minHeight: (json['minHeight'] as num?)?.toDouble(),
      maxHeight: (json['maxHeight'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$BoxConstraintsModelImplToJson(
        _$BoxConstraintsModelImpl instance) =>
    <String, dynamic>{
      'minWidth': instance.minWidth,
      'maxWidth': instance.maxWidth,
      'minHeight': instance.minHeight,
      'maxHeight': instance.maxHeight,
    };
