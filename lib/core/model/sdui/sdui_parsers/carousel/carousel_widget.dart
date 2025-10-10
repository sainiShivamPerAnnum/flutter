import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'carousel_widget.freezed.dart';
part 'carousel_widget.g.dart';

@freezed
class CarouselWidget with _$CarouselWidget {
  const factory CarouselWidget({
    @Default([]) List<Map<String, dynamic>> items,
    @Default(400) double height,
    @Default(16 / 9) double aspectRatio,
    @Default(0.8) double viewportFraction,
    @Default(0) int initialPage,
    @Default(true) bool enableInfiniteScroll,
    @Default(false) bool reverse,
    @Default(true) bool autoPlay,
    @Default(3) int autoPlayIntervalSeconds,
    @Default(800) int autoPlayAnimationMills,
    @Default(true) bool enlargeCenterPage,
    @Default(0.3) double enlargeFactor,
    @Default(Axis.vertical) Axis scrollDirection,
  }) = _CarouselWidget;

  factory CarouselWidget.fromJson(Map<String, dynamic> json) =>
      _$CarouselWidgetFromJson(json);
}
