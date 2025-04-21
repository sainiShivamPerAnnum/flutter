import 'package:flutter/material.dart';
import 'package:felloapp/util/stac/lib/src/framework/framework.dart';
import 'package:felloapp/util/stac/lib/src/parsers/stac_aspect_ratio/stac_aspect_ratio.dart';
import 'package:felloapp/util/stac/lib/src/utils/widget_type.dart';
import 'package:felloapp/util/stac_framework/lib/stac_framework.dart';

class StacAspectRatioParser extends StacParser<StacAspectRatio> {
  const StacAspectRatioParser();

  @override
  String get type => WidgetType.aspectRatio.name;

  @override
  StacAspectRatio getModel(Map<String, dynamic> json) =>
      StacAspectRatio.fromJson(json);

  @override
  Widget parse(BuildContext context, StacAspectRatio model) {
    return AspectRatio(
      aspectRatio: model.aspectRatio,
      child: Stac.fromJson(model.child, context),
    );
  }
}
