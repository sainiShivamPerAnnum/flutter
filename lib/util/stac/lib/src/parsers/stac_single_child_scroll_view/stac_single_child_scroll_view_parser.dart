import 'package:flutter/material.dart';
import 'package:felloapp/util/stac/lib/src/framework/framework.dart';
import 'package:felloapp/util/stac/lib/src/parsers/stac_edge_insets/stac_edge_insets.dart';
import 'package:felloapp/util/stac/lib/src/parsers/stac_single_child_scroll_view/stac_single_child_scroll_view.dart';
import 'package:felloapp/util/stac/lib/src/utils/widget_type.dart';
import 'package:felloapp/util/stac_framework/lib/stac_framework.dart';

class StacSingleChildScrollViewParser
    extends StacParser<StacSingleChildScrollView> {
  const StacSingleChildScrollViewParser();

  @override
  StacSingleChildScrollView getModel(Map<String, dynamic> json) =>
      StacSingleChildScrollView.fromJson(json);

  @override
  String get type => WidgetType.singleChildScrollView.name;

  @override
  Widget parse(BuildContext context, StacSingleChildScrollView model) {
    return SingleChildScrollView(
      scrollDirection: model.scrollDirection,
      reverse: model.reverse,
      padding: model.padding?.parse,
      primary: model.primary,
      physics: model.physics?.parse,
      dragStartBehavior: model.dragStartBehavior,
      clipBehavior: model.clipBehavior,
      restorationId: model.restorationId,
      keyboardDismissBehavior: model.keyboardDismissBehavior,
      child: Stac.fromJson(model.child, context),
    );
  }
}
