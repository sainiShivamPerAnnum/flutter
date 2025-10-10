import 'package:flutter/material.dart';
import 'package:felloapp/util/stac/lib/src/utils/widget_type.dart';
import 'package:felloapp/util/stac/lib/stac.dart';

class StacTableCellParser extends StacParser<StacTableCell> {
  const StacTableCellParser();

  @override
  String get type => WidgetType.tableCell.name;

  @override
  StacTableCell getModel(Map<String, dynamic> json) =>
      StacTableCell.fromJson(json);

  @override
  Widget parse(BuildContext context, StacTableCell model) {
    return TableCell(
      verticalAlignment: model.verticalAlignment,
      child: Stac.fromJson(model.child, context) ?? const SizedBox(),
    );
  }
}
