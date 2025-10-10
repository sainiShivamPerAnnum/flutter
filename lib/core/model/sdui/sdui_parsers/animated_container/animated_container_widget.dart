import 'package:freezed_annotation/freezed_annotation.dart';

part 'animated_container_widget.freezed.dart';
part 'animated_container_widget.g.dart';

@freezed
class AnimatedContainerWidget with _$AnimatedContainerWidget {
  const factory AnimatedContainerWidget({
    int? durationInMs,
    String? curve,
    double? width,
    double? height,
    Map<String, dynamic>? padding,
    Map<String, dynamic>? margin,
    String? alignment,
    String? color,
    ContainerDecorationModel? decoration,
    TransformModel? transform,
    String? transformAlignment,
    String? clip,
    BoxConstraintsModel? constraints,
    Map<String, dynamic>? child,
  }) = _AnimatedContainerWidget;

  factory AnimatedContainerWidget.fromJson(Map<String, dynamic> json) =>
      _$AnimatedContainerWidgetFromJson(json);
}

@freezed
class ContainerDecorationModel with _$ContainerDecorationModel {
  const factory ContainerDecorationModel({
    String? color,
    double? borderRadius,
    String? borderColor,
    double? borderWidth,
    double? shadow,
    String? shadowColor,
    double? spreadRadius,
    double? offsetX,
    double? offsetY,
    Map<String, dynamic>? gradient,
  }) = _ContainerDecorationModel;

  factory ContainerDecorationModel.fromJson(Map<String, dynamic> json) =>
      _$ContainerDecorationModelFromJson(json);
}

@freezed
class TransformModel with _$TransformModel {
  const factory TransformModel({
    double? translateX,
    double? translateY,
    double? translateZ,
    double? rotateX,
    double? rotateY,
    double? rotateZ,
    double? scaleX,
    double? scaleY,
    double? scaleZ,
  }) = _TransformModel;

  factory TransformModel.fromJson(Map<String, dynamic> json) =>
      _$TransformModelFromJson(json);
}

@freezed
class BoxConstraintsModel with _$BoxConstraintsModel {
  const factory BoxConstraintsModel({
    double? minWidth,
    double? maxWidth,
    double? minHeight,
    double? maxHeight,
  }) = _BoxConstraintsModel;

  factory BoxConstraintsModel.fromJson(Map<String, dynamic> json) =>
      _$BoxConstraintsModelFromJson(json);
}
