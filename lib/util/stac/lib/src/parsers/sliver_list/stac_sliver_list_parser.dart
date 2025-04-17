// stac_sliver_list_parser.dart
import 'package:felloapp/util/stac/lib/src/utils/widget_type.dart';
import 'package:felloapp/util/stac/lib/stac.dart';
import 'package:flutter/material.dart';

import 'stac_sliver_list.dart';

class StacSliverListParser extends StacParser<StacSliverList> {
  const StacSliverListParser();

  @override
  String get type => WidgetType.sliverList.name;

  @override
  StacSliverList getModel(Map<String, dynamic> json) =>
      StacSliverList.fromJson(json);

  @override
  Widget parse(BuildContext context, StacSliverList model) {
    final children = model.children
            ?.map((child) =>
                Stac.fromJson(child, context) ?? const SizedBox.shrink())
            .toList(growable: false) ??
        [];

    return SliverList(
      key: model.key != null ? Key(model.key!) : null,
      delegate: SliverChildListDelegate(
        children,
        addAutomaticKeepAlives: model.addAutomaticKeepAlives,
        addRepaintBoundaries: model.addRepaintBoundaries,
        addSemanticIndexes: model.addSemanticIndexes,
        semanticIndexOffset: model.semanticIndexOffset ?? 0,
      ),
    );
  }
}
