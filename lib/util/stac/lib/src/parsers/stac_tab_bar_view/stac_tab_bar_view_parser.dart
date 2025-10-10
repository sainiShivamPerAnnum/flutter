import 'package:flutter/material.dart';
import 'package:felloapp/util/stac/lib/src/framework/framework.dart';
import 'package:felloapp/util/stac/lib/src/parsers/stac_tab_bar_view/stac_tab_bar_view.dart';
import 'package:felloapp/util/stac/lib/src/utils/widget_type.dart';
import 'package:felloapp/util/stac_framework/lib/stac_framework.dart';

class StacTabBarViewParser extends StacParser<StacTabBarView> {
  const StacTabBarViewParser({this.controller});

  final TabController? controller;

  @override
  StacTabBarView getModel(Map<String, dynamic> json) =>
      StacTabBarView.fromJson(json);

  @override
  String get type => WidgetType.tabBarView.name;

  @override
  Widget parse(BuildContext context, StacTabBarView model) {
    return TabBarView(
      controller: controller,
      physics: model.physics?.parse,
      dragStartBehavior: model.dragStartBehavior,
      viewportFraction: model.viewportFraction,
      clipBehavior: model.clipBehavior,
      children: model.children
          .map((child) => Stac.fromJson(child, context) ?? const SizedBox())
          .toList(),
    );
  }
}
