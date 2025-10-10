import 'package:flutter/material.dart';
import 'package:felloapp/util/stac/lib/src/framework/framework.dart';
import 'package:felloapp/util/stac/lib/src/parsers/stac_placeholder/stac_placeholder.dart';
import 'package:felloapp/util/stac/lib/src/utils/utils.dart';
import 'package:felloapp/util/stac/lib/src/utils/widget_type.dart';
import 'package:felloapp/util/stac_framework/lib/stac_framework.dart';

class StacPlaceholderParser extends StacParser<StacPlaceholder> {
  const StacPlaceholderParser();

  @override
  String get type => WidgetType.placeholder.name;

  @override
  StacPlaceholder getModel(Map<String, dynamic> json) =>
      StacPlaceholder.fromJson(json);

  @override
  Widget parse(BuildContext context, StacPlaceholder model) {
    return Placeholder(
      fallbackWidth: model.fallbackWidth,
      fallbackHeight: model.fallbackHeight,
      strokeWidth: model.strokeWidth,
      color: model.color.toColor(context) ?? Color(0xFF455A64),
      child: Stac.fromJson(model.child, context),
    );
  }
}
