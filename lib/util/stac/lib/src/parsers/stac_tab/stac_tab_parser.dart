import 'package:flutter/material.dart';
import 'package:felloapp/util/stac/lib/src/framework/framework.dart';
import 'package:felloapp/util/stac/lib/src/parsers/stac_edge_insets/stac_edge_insets.dart';
import 'package:felloapp/util/stac/lib/src/parsers/stac_tab/stac_tab.dart';
import 'package:felloapp/util/stac/lib/src/utils/widget_type.dart';
import 'package:felloapp/util/stac_framework/lib/stac_framework.dart';

class StacTabParser extends StacParser<StacTab> {
  const StacTabParser();

  @override
  StacTab getModel(Map<String, dynamic> json) => StacTab.fromJson(json);

  @override
  Widget parse(BuildContext context, StacTab model) {
    return Tab(
      text: model.text,
      icon: Stac.fromJson(model.icon, context),
      iconMargin: model.iconMargin.parse,
      height: model.height,
      child: Stac.fromJson(model.child, context),
    );
  }

  @override
  String get type => WidgetType.tab.name;
}
