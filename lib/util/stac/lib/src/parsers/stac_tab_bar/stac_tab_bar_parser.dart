import 'package:flutter/material.dart';
import 'package:felloapp/util/stac/lib/src/framework/framework.dart';
import 'package:felloapp/util/stac/lib/src/parsers/stac_edge_insets/stac_edge_insets.dart';
import 'package:felloapp/util/stac/lib/src/parsers/stac_tab_bar/stac_tab_bar.dart';
import 'package:felloapp/util/stac/lib/src/parsers/stac_text_style/stac_text_style.dart';
import 'package:felloapp/util/stac/lib/src/utils/color_utils.dart';
import 'package:felloapp/util/stac/lib/src/utils/widget_type.dart';
import 'package:felloapp/util/stac_framework/lib/stac_framework.dart';

class StacTabBarParser extends StacParser<StacTabBar> {
  const StacTabBarParser({this.controller});

  final TabController? controller;

  @override
  StacTabBar getModel(Map<String, dynamic> json) => StacTabBar.fromJson(json);

  @override
  String get type => WidgetType.tabBar.name;

  @override
  Widget parse(BuildContext context, StacTabBar model) {
    return TabBar(
      controller: controller,
      tabs: model.tabs
          .map((tab) => Stac.fromJson(tab, context) ?? const SizedBox())
          .toList(),
      isScrollable: model.isScrollable,
      padding: model.padding?.parse,
      indicatorColor: model.indicatorColor?.toColor(context),
      automaticIndicatorColorAdjustment:
          model.automaticIndicatorColorAdjustment,
      indicatorWeight: model.indicatorWeight,
      indicatorPadding: model.indicatorPadding.parse,
      indicatorSize: model.indicatorSize,
      labelColor: model.labelColor.toColor(context),
      labelStyle: model.labelStyle?.parse(context),
      labelPadding: model.labelPadding.parse,
      unselectedLabelColor: model.unselectedLabelColor.toColor(context),
      unselectedLabelStyle: model.unselectedLabelStyle?.parse(context),
      dragStartBehavior: model.dragStartBehavior,
      enableFeedback: model.enableFeedback,
      onTap: (_) {},
      physics: model.physics?.parse,
      tabAlignment: model.tabAlignment,
    );
  }
}
