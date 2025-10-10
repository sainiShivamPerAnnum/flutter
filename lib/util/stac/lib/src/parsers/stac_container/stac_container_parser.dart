import 'package:felloapp/util/stac/lib/stac.dart';
import 'package:flutter/cupertino.dart';
import 'package:felloapp/util/stac/lib/src/parsers/stac_box_constraints/stac_box_constraints.dart';
import 'package:felloapp/util/stac/lib/src/utils/widget_type.dart';

class StacContainerParser extends StacParser<StacContainer> {
  const StacContainerParser();

  @override
  String get type => WidgetType.container.name;

  @override
  StacContainer getModel(Map<String, dynamic> json) =>
      StacContainer.fromJson(json);

  @override
  Widget parse(BuildContext context, StacContainer model) {
    return Container(
      alignment: model.alignment?.value,
      padding: model.padding?.parse,
      color: model.color.toColor(context),
      decoration: model.decoration?.parse(context),
      foregroundDecoration: model.foregroundDecoration?.parse(context),
      width: model.width,
      height: model.height,
      constraints: model.constraints?.parse,
      margin: model.margin?.parse,
      clipBehavior: model.clipBehavior,
      child: Stac.fromJson(model.child, context),
    );
  }
}
