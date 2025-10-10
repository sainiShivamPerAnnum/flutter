import 'package:flutter/material.dart';
import 'package:felloapp/util/stac/lib/src/framework/framework.dart';
import 'package:felloapp/util/stac/lib/src/parsers/stac_limited_box/stac_limited_box.dart';
import 'package:felloapp/util/stac/lib/src/utils/widget_type.dart';
import 'package:felloapp/util/stac_framework/lib/stac_framework.dart';

class StacLimitedBoxParser extends StacParser<StacLimitedBox> {
  const StacLimitedBoxParser();

  @override
  String get type => WidgetType.limitedBox.name;

  @override
  StacLimitedBox getModel(Map<String, dynamic> json) =>
      StacLimitedBox.fromJson(json);

  @override
  Widget parse(BuildContext context, StacLimitedBox model) {
    return LimitedBox(
      maxHeight: model.maxHeight,
      maxWidth: model.maxWidth,
      child: Stac.fromJson(model.child, context),
    );
  }
}
