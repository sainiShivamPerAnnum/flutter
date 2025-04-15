import 'package:felloapp/core/model/sdui/sdui_parsers/spacer/spacer_widget.dart';
import 'package:felloapp/util/stac_framework/lib/src/stac_parser.dart';
import 'package:flutter/material.dart';

class SpacerWidgetParser extends StacParser<SpacerWidget> {
  const SpacerWidgetParser();

  @override
  SpacerWidget getModel(Map<String, dynamic> json) =>
      SpacerWidget.fromJson(json);

  @override
  String get type => 'spacer_custom';

  @override
  Widget parse(BuildContext context, SpacerWidget model) {
    return Spacer(flex: model.flex);
  }
}
