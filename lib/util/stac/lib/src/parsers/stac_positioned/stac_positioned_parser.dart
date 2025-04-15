import 'package:flutter/cupertino.dart';
import 'package:felloapp/util/stac/lib/src/framework/framework.dart';
import 'package:felloapp/util/stac/lib/src/parsers/stac_positioned/stac_positioned.dart';
import 'package:felloapp/util/stac/lib/src/parsers/stac_rect/stac_rect.dart';
import 'package:felloapp/util/stac/lib/src/utils/widget_type.dart';
import 'package:felloapp/util/stac_framework/lib/stac_framework.dart';

class StacPositionedParser extends StacParser<StacPositioned> {
  const StacPositionedParser();

  @override
  StacPositioned getModel(Map<String, dynamic> json) =>
      StacPositioned.fromJson(json);

  @override
  String get type => WidgetType.positioned.name;

  @override
  Widget parse(BuildContext context, StacPositioned model) {
    switch (model.positionedType) {
      case StacPositionedType.directional:
        return Positioned.directional(
            textDirection: model.textDirection,
            top: model.top,
            bottom: model.bottom,
            height: model.height,
            width: model.width,
            start: model.start,
            end: model.end,
            child: Stac.fromJson(model.child, context) ?? const SizedBox());
      case StacPositionedType.fill:
        return Positioned.fill(
            left: model.left,
            top: model.top,
            right: model.right,
            bottom: model.bottom,
            child: Stac.fromJson(model.child, context) ?? const SizedBox());
      case StacPositionedType.fromRect:
        return Positioned.fromRect(
            rect: model.rect?.parse ?? Rect.zero,
            child: Stac.fromJson(model.child, context) ?? const SizedBox());
      default:
        return Positioned(
            left: model.left,
            top: model.top,
            right: model.right,
            bottom: model.bottom,
            height: model.height,
            width: model.width,
            child: Stac.fromJson(model.child, context) ?? const SizedBox());
    }
  }
}
