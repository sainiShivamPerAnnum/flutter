import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stac/src/parsers/stac_box_constraints/stac_box_constraints.dart';
import 'package:stac/stac.dart';

part 'responsive_container_widget.freezed.dart';
part 'responsive_container_widget.g.dart';

@freezed
class ResponsiveContainer with _$ResponsiveContainer {
  const factory ResponsiveContainer({
    StacAlignment? alignment,
    StacEdgeInsets? padding,
    StacBoxDecoration? decoration,
    StacBoxDecoration? foregroundDecoration,
    String? color,
    double? width,
    double? height,
    String? widthScaling,
    String? heightScaling,
    StacBoxConstraints? constraints,
    StacEdgeInsets? margin,
    Map<String, dynamic>? child,
    @Default(Clip.none) Clip clipBehavior,
  }) = _ResponsiveContainer;

  factory ResponsiveContainer.fromJson(Map<String, dynamic> json) =>
      _$ResponsiveContainerFromJson(json);
}
