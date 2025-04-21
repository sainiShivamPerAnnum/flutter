import 'package:flutter/material.dart';
import 'package:felloapp/util/stac/lib/src/parsers/stac_spacer/stac_spacer.dart';
import 'package:felloapp/util/stac/lib/src/utils/widget_type.dart';
import 'package:felloapp/util/stac_framework/lib/stac_framework.dart';

class StacSpacerParser extends StacParser<StacSpacer> {
  const StacSpacerParser();

  @override
  StacSpacer getModel(Map<String, dynamic> json) => StacSpacer.fromJson(json);

  @override
  String get type => WidgetType.spacer.name;

  @override
  Widget parse(BuildContext context, StacSpacer model) {
    return Spacer(flex: model.flex);
  }
}
