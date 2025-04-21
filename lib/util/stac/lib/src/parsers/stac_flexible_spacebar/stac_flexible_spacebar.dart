import 'package:felloapp/util/stac/lib/stac.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

export 'stac_flexible_spacebar_parser.dart';

part 'stac_flexible_spacebar.freezed.dart';
part 'stac_flexible_spacebar.g.dart';

@freezed
class StacFlexibleSpaceBar with _$StacFlexibleSpaceBar {
  const factory StacFlexibleSpaceBar({
    String? title,
    Map<String, dynamic>? background,
    @Default(CollapseMode.parallax) CollapseMode collapseMode,
    @Default(true) bool centerTitle,
    @Default([StretchMode.zoomBackground]) List<StretchMode> stretchModes,
    StacEdgeInsets? titlePadding,
    @Default(false) bool expandedTitleScale,
  }) = _StacFlexibleSpaceBar;

  factory StacFlexibleSpaceBar.fromJson(Map<String, dynamic> json) =>
      _$StacFlexibleSpaceBarFromJson(json);
}

// Custom JSON converter for CollapseMode enum
class CollapseModeConverter implements JsonConverter<CollapseMode, String> {
  const CollapseModeConverter();

  @override
  CollapseMode fromJson(String json) {
    switch (json) {
      case 'pin':
        return CollapseMode.pin;
      case 'none':
        return CollapseMode.none;
      case 'parallax':
      default:
        return CollapseMode.parallax;
    }
  }

  @override
  String toJson(CollapseMode mode) {
    switch (mode) {
      case CollapseMode.pin:
        return 'pin';
      case CollapseMode.none:
        return 'none';
      case CollapseMode.parallax:
        return 'parallax';
    }
  }
}

// Custom JSON converter for StretchMode enum
class StretchModeConverter
    implements JsonConverter<List<StretchMode>, List<dynamic>> {
  const StretchModeConverter();

  @override
  List<StretchMode> fromJson(List<dynamic> json) {
    if (json.isEmpty) {
      return [StretchMode.zoomBackground];
    }

    return json.map((mode) {
      switch (mode.toString()) {
        case 'zoomBackground':
          return StretchMode.zoomBackground;
        case 'blurBackground':
          return StretchMode.blurBackground;
        case 'fadeTitle':
          return StretchMode.fadeTitle;
        default:
          return StretchMode.zoomBackground;
      }
    }).toList();
  }

  @override
  List<String> toJson(List<StretchMode> modes) {
    return modes.map((mode) {
      switch (mode) {
        case StretchMode.zoomBackground:
          return 'zoomBackground';
        case StretchMode.blurBackground:
          return 'blurBackground';
        case StretchMode.fadeTitle:
          return 'fadeTitle';
      }
    }).toList();
  }
}
