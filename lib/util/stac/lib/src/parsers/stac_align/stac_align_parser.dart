import 'package:flutter/material.dart';
import 'package:felloapp/util/stac/lib/src/framework/framework.dart';
import 'package:felloapp/util/stac/lib/src/parsers/stac_align/stac_align.dart';
import 'package:felloapp/util/stac/lib/src/utils/widget_type.dart';
import 'package:felloapp/util/stac_framework/lib/stac_framework.dart';

class StacAlignParser extends StacParser<StacAlign> {
  const StacAlignParser();

  @override
  StacAlign getModel(Map<String, dynamic> json) => StacAlign.fromJson(json);

  @override
  String get type => WidgetType.align.name;

  @override
  Widget parse(BuildContext context, StacAlign model) {
    return Align(
      alignment: model.alignment.value,
      heightFactor: model.heightFactor,
      widthFactor: model.widthFactor,
      child: Stac.fromJson(model.child, context),
    );
  }
}
