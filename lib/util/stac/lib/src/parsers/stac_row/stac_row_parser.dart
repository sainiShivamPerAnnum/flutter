import 'package:flutter/material.dart';
import 'package:felloapp/util/stac/lib/src/framework/framework.dart';
import 'package:felloapp/util/stac/lib/src/parsers/stac_row/stac_row.dart';
import 'package:felloapp/util/stac/lib/src/utils/widget_type.dart';
import 'package:felloapp/util/stac_framework/lib/stac_framework.dart';

class StacRowParser extends StacParser<StacRow> {
  const StacRowParser();

  @override
  StacRow getModel(Map<String, dynamic> json) => StacRow.fromJson(json);

  @override
  String get type => WidgetType.row.name;

  @override
  Widget parse(BuildContext context, StacRow model) {
    return Row(
      mainAxisAlignment: model.mainAxisAlignment,
      crossAxisAlignment: model.crossAxisAlignment,
      mainAxisSize: model.mainAxisSize,
      textDirection: model.textDirection,
      verticalDirection: model.verticalDirection,
      // spacing: model.spacing,
      children: model.children
          .map((value) => Stac.fromJson(value, context) ?? const SizedBox())
          .toList(),
    );
  }
}
