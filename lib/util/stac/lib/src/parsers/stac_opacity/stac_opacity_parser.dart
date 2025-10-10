import 'package:flutter/material.dart';
import 'package:felloapp/util/stac/lib/src/framework/framework.dart';
import 'package:felloapp/util/stac/lib/src/parsers/stac_opacity/stac_opacity.dart';
import 'package:felloapp/util/stac/lib/src/utils/widget_type.dart';
import 'package:felloapp/util/stac_framework/lib/stac_framework.dart';

class StacOpacityParser extends StacParser<StacOpacity> {
  const StacOpacityParser();

  @override
  String get type => WidgetType.opacity.name;

  @override
  StacOpacity getModel(Map<String, dynamic> json) => StacOpacity.fromJson(json);

  @override
  Widget parse(BuildContext context, StacOpacity model) {
    return Opacity(
      opacity: model.opacity,
      child: Stac.fromJson(model.child, context),
    );
  }
}
