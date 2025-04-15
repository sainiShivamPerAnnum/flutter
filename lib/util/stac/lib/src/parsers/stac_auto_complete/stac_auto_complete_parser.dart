import 'package:flutter/material.dart';
import 'package:felloapp/util/stac/lib/src/framework/framework.dart';
import 'package:felloapp/util/stac/lib/src/parsers/stac_auto_complete/stac_auto_complete.dart';
import 'package:felloapp/util/stac/lib/src/utils/widget_type.dart';
import 'package:felloapp/util/stac_framework/lib/stac_framework.dart';

class StacAutoCompleteParser extends StacParser<StacAutoComplete> {
  const StacAutoCompleteParser();

  @override
  String get type => WidgetType.autocomplete.name;

  @override
  StacAutoComplete getModel(Map<String, dynamic> json) =>
      StacAutoComplete.fromJson(json);

  @override
  Widget parse(BuildContext context, StacAutoComplete model) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return model.options.where((String option) {
          return option.contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String val) =>
          Stac.onCallFromJson(model.onSelected, context),
      optionsMaxHeight: model.optionsMaxHeight,
      optionsViewOpenDirection: model.optionsViewOpenDirection,
      initialValue: model.initialValue != null
          ? TextEditingValue(text: model.initialValue!)
          : null,
    );
  }
}
