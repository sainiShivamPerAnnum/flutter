import 'package:flutter/material.dart';
import 'package:felloapp/util/stac/lib/src/framework/framework.dart';
import 'package:felloapp/util/stac/lib/src/utils/widget_type.dart';
import 'package:felloapp/util/stac_framework/lib/stac_framework.dart';

import 'stac_flexible.dart';

class StacFlexibleParser extends StacParser<StacFlexible> {
  const StacFlexibleParser();

  @override
  String get type => WidgetType.flexible.name;

  @override
  StacFlexible getModel(Map<String, dynamic> json) =>
      StacFlexible.fromJson(json);

  @override
  Widget parse(BuildContext context, StacFlexible model) {
    return Flexible(
      fit: model.fit,
      flex: model.flex,
      child: Stac.fromJson(model.child, context) ?? const SizedBox(),
    );
  }
}
