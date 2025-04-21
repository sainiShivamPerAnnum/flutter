import 'package:flutter/material.dart';
import 'package:felloapp/util/stac/lib/src/framework/framework.dart';
import 'package:felloapp/util/stac/lib/src/parsers/stac_fitted_box/stac_fitted_box.dart';
import 'package:felloapp/util/stac/lib/src/utils/widget_type.dart';
import 'package:felloapp/util/stac_framework/lib/stac_framework.dart';

class StacFittedBoxParser extends StacParser<StacFittedBox> {
  const StacFittedBoxParser();

  @override
  String get type => WidgetType.fittedBox.name;

  @override
  StacFittedBox getModel(Map<String, dynamic> json) =>
      StacFittedBox.fromJson(json);

  @override
  Widget parse(BuildContext context, StacFittedBox model) {
    return FittedBox(
      fit: model.fit,
      alignment: model.alignment.value,
      clipBehavior: model.clipBehavior,
      child: Stac.fromJson(model.child, context),
    );
  }
}
