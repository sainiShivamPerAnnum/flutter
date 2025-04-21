import 'package:flutter/material.dart';
import 'package:felloapp/util/stac/lib/src/framework/framework.dart';
import 'package:felloapp/util/stac/lib/src/parsers/stac_column/stac_column.dart';
import 'package:felloapp/util/stac/lib/src/utils/widget_type.dart';
import 'package:felloapp/util/stac_framework/lib/stac_framework.dart';

class StacColumnParser extends StacParser<StacColumn> {
  const StacColumnParser();

  @override
  StacColumn getModel(Map<String, dynamic> json) => StacColumn.fromJson(json);

  @override
  String get type => WidgetType.column.name;

  @override
  Widget parse(BuildContext context, StacColumn model) {
    return Column(
      mainAxisAlignment: model.mainAxisAlignment,
      crossAxisAlignment: model.crossAxisAlignment,
      mainAxisSize: model.mainAxisSize,
      textDirection: model.textDirection,
      verticalDirection: model.verticalDirection,
      // spacing: model.spacing,
      children: model.children
          .map(
            (value) => Stac.fromJson(value, context) ?? const SizedBox(),
          )
          .toList(),
    );
  }
}
