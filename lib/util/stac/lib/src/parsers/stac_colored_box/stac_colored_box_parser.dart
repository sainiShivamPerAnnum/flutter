import 'package:flutter/cupertino.dart';
import 'package:felloapp/util/stac/lib/src/framework/framework.dart';
import 'package:felloapp/util/stac/lib/src/parsers/stac_colored_box/stac_colored_box.dart';
import 'package:felloapp/util/stac/lib/src/utils/color_utils.dart';
import 'package:felloapp/util/stac/lib/src/utils/widget_type.dart';
import 'package:felloapp/util/stac_framework/lib/stac_framework.dart';

class StacColoredBoxParser extends StacParser<StacColoredBox> {
  const StacColoredBoxParser();

  @override
  String get type => WidgetType.coloredBox.name;

  @override
  StacColoredBox getModel(Map<String, dynamic> json) =>
      StacColoredBox.fromJson(json);

  @override
  Widget parse(BuildContext context, StacColoredBox model) {
    return ColoredBox(
      color: model.color.toColor(context)!,
      child: Stac.fromJson(model.child, context),
    );
  }
}
