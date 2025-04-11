import 'package:felloapp/core/model/sdui/sdui_parsers/spacer/spacer_widget.dart';
import 'package:flutter/material.dart';
import 'package:stac/stac.dart';

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
