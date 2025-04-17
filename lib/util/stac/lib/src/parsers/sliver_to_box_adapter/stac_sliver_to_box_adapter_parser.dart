// stac_sliver_to_box_adapter_parser.dart
import 'package:felloapp/util/stac/lib/src/utils/widget_type.dart';
import 'package:felloapp/util/stac/lib/stac.dart';
import 'package:flutter/material.dart';

import 'stac_sliver_to_box_adapter.dart';

class StacSliverToBoxAdapterParser extends StacParser<StacSliverToBoxAdapter> {
  const StacSliverToBoxAdapterParser();

  @override
  String get type => WidgetType.sliverToBoxAdapter.name;

  @override
  StacSliverToBoxAdapter getModel(Map<String, dynamic> json) =>
      StacSliverToBoxAdapter.fromJson(json);

  @override
  Widget parse(BuildContext context, StacSliverToBoxAdapter model) {
    return SliverToBoxAdapter(
      key: model.key != null ? Key(model.key!) : null,
      child: Stac.fromJson(model.child, context),
    );
  }
}
