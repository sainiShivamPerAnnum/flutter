import 'package:flutter/material.dart';
import 'package:felloapp/util/stac/lib/src/framework/framework.dart';
import 'package:felloapp/util/stac/lib/src/parsers/stac_fractionally_sized_box/stac_fractionally_sized_box.dart';
import 'package:felloapp/util/stac/lib/src/utils/widget_type.dart';
import 'package:felloapp/util/stac_framework/lib/stac_framework.dart';

class StacFractionallySizedBoxParser
    extends StacParser<StacFractionallySizedBox> {
  const StacFractionallySizedBoxParser();

  @override
  StacFractionallySizedBox getModel(Map<String, dynamic> json) =>
      StacFractionallySizedBox.fromJson(json);

  @override
  String get type => WidgetType.fractionallySizedBox.name;

  @override
  Widget parse(BuildContext context, StacFractionallySizedBox model) {
    return FractionallySizedBox(
      alignment: model.alignment?.value ?? Alignment.center,
      widthFactor: model.widthFactor,
      heightFactor: model.heightFactor,
      child: Stac.fromJson(model.child, context),
    );
  }
}
