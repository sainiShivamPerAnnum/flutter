import 'package:flutter/material.dart';
import 'package:felloapp/util/stac/lib/src/framework/framework.dart';
import 'package:felloapp/util/stac/lib/src/parsers/stac_stack/stac_stack.dart';
import 'package:felloapp/util/stac/lib/src/utils/widget_type.dart';
import 'package:felloapp/util/stac_framework/lib/stac_framework.dart';

class StacStackParser extends StacParser<StacStack> {
  const StacStackParser();

  @override
  StacStack getModel(Map<String, dynamic> json) => StacStack.fromJson(json);

  @override
  String get type => WidgetType.stack.name;

  @override
  Widget parse(BuildContext context, StacStack model) {
    return Stack(
      alignment: model.alignment.value,
      clipBehavior: model.clipBehavior,
      fit: model.fit,
      textDirection: model.textDirection,
      children: model.children
          .map((value) => Stac.fromJson(value, context) ?? const SizedBox())
          .toList(),
    );
  }
}
