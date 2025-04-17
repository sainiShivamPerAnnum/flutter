import 'package:felloapp/util/stac/lib/stac.dart';
import 'package:flutter/material.dart';

class StacFlexibleSpaceBarParser extends StacParser<StacFlexibleSpaceBar> {
  const StacFlexibleSpaceBarParser();

  @override
  String get type => 'flexibleSpaceBar';

  @override
  StacFlexibleSpaceBar getModel(Map<String, dynamic> json) =>
      StacFlexibleSpaceBar.fromJson(json);

  @override
  Widget parse(BuildContext context, StacFlexibleSpaceBar model) {
    Widget? titleWidget;

    // Parse title if it's a string or a widget
    if (model.title != null) {
      titleWidget = Text(
        model.title!,
        style: const TextStyle(color: Colors.white),
      );
    }

    return FlexibleSpaceBar(
      title: titleWidget,
      background: model.background != null
          ? Stac.fromJson(model.background, context)
          : null,
      centerTitle: model.centerTitle,
      collapseMode: model.collapseMode,
      stretchModes: model.stretchModes,
      titlePadding: model.titlePadding.parse,
      expandedTitleScale: model.expandedTitleScale ? 1.5 : 1.0,
    );
  }
}
