import 'package:flutter/material.dart';
import 'package:felloapp/util/stac/lib/src/framework/framework.dart';
import 'package:felloapp/util/stac/lib/src/parsers/stac_sized_box/stac_sized_box.dart';
import 'package:felloapp/util/stac/lib/src/utils/widget_type.dart';
import 'package:felloapp/util/stac_framework/lib/stac_framework.dart';

class StacSizedBoxParser extends StacParser<StacSizedBox> {
  const StacSizedBoxParser();

  @override
  StacSizedBox getModel(Map<String, dynamic> json) =>
      StacSizedBox.fromJson(json);

  @override
  String get type => WidgetType.sizedBox.name;

  @override
  Widget parse(BuildContext context, StacSizedBox model) {
    return SizedBox(
      width: model.width,
      height: model.height,
      child: Stac.fromJson(model.child, context),
    );
  }
}
