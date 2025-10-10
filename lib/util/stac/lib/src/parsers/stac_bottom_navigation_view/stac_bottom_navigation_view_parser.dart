import 'package:flutter/material.dart';
import 'package:felloapp/util/stac/lib/src/framework/framework.dart';
import 'package:felloapp/util/stac/lib/src/parsers/stac_bottom_navigation_view/stac_bottom_navigation_view.dart';
import 'package:felloapp/util/stac/lib/src/parsers/stac_default_bottom_navigation_controller/stac_default_bottom_navigation_controller_parser.dart';
import 'package:felloapp/util/stac/lib/src/utils/widget_type.dart';
import 'package:felloapp/util/stac_framework/lib/stac_framework.dart';

class StacBottomNavigationViewParser
    extends StacParser<StacBottomNavigationView> {
  const StacBottomNavigationViewParser();

  @override
  String get type => WidgetType.bottomNavigationView.name;

  @override
  StacBottomNavigationView getModel(Map<String, dynamic> json) =>
      StacBottomNavigationView.fromJson(json);

  @override
  Widget parse(BuildContext context, StacBottomNavigationView model) {
    final controller = BottomNavigationScope.of(context)?.controller;

    final index = controller?.index ?? 0;
    return Stac.fromJson(model.children[index], context) ?? const SizedBox();
  }
}
