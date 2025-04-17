import 'package:felloapp/util/stac/lib/src/framework/framework.dart';
import 'package:felloapp/util/stac/lib/src/parsers/stac_edge_insets/stac_edge_insets.dart';
import 'package:felloapp/util/stac/lib/src/parsers/stac_grid_view/stac_grid_view.dart';
import 'package:felloapp/util/stac/lib/src/utils/widget_type.dart';
import 'package:felloapp/util/stac_framework/lib/stac_framework.dart';
import 'package:flutter/material.dart';

class StacGridViewParser extends StacParser<StacGridView> {
  const StacGridViewParser();

  @override
  String get type => WidgetType.gridView.name;

  @override
  StacGridView getModel(Map<String, dynamic> json) =>
      StacGridView.fromJson(json);

  @override
  Widget parse(BuildContext context, StacGridView model) {
    return GridView.builder(
      scrollDirection: model.scrollDirection,
      reverse: model.reverse,
      primary: model.primary,
      physics: model.physics?.parse,
      shrinkWrap: model.shrinkWrap,
      padding: model.padding.parse,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: model.crossAxisCount ?? 0,
        mainAxisSpacing: model.mainAxisSpacing,
        crossAxisSpacing: model.crossAxisSpacing,
        childAspectRatio: model.childAspectRatio,
      ),
      addAutomaticKeepAlives: model.addAutomaticKeepAlives,
      addRepaintBoundaries: model.addRepaintBoundaries,
      addSemanticIndexes: model.addSemanticIndexes,
      cacheExtent: model.cacheExtent,
      itemBuilder: (context, index) =>
          Stac.fromJson(model.children[index], context),
      itemCount: model.children.length,
      semanticChildCount: model.semanticChildCount,
      dragStartBehavior: model.dragStartBehavior,
      keyboardDismissBehavior: model.keyboardDismissBehavior,
      restorationId: model.restorationId,
      clipBehavior: model.clipBehavior,
    );
  }
}
