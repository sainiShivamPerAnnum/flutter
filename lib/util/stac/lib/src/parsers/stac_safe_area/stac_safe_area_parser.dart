import 'package:flutter/widgets.dart';
import 'package:felloapp/util/stac/lib/src/framework/framework.dart';
import 'package:felloapp/util/stac/lib/src/parsers/stac_edge_insets/stac_edge_insets.dart';
import 'package:felloapp/util/stac/lib/src/utils/widget_type.dart';
import 'package:felloapp/util/stac_framework/lib/stac_framework.dart';

import 'stac_safe_area.dart';

class StacSafeAreaParser extends StacParser<StacSafeArea> {
  const StacSafeAreaParser();

  @override
  StacSafeArea getModel(Map<String, dynamic> json) =>
      StacSafeArea.fromJson(json);

  @override
  String get type => WidgetType.safeArea.name;

  @override
  Widget parse(BuildContext context, StacSafeArea model) {
    return SafeArea(
      maintainBottomViewPadding: model.maintainBottomViewPadding,
      left: model.left,
      top: model.top,
      right: model.right,
      bottom: model.bottom,
      minimum: model.minimum.parse,
      child: Stac.fromJson(model.child, context) ?? const SizedBox(),
    );
  }
}
