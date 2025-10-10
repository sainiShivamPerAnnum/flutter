import 'package:flutter/material.dart';
import 'package:felloapp/util/stac/lib/src/action_parsers/stac_get_form_value/stac_get_form_value.dart';
import 'package:felloapp/util/stac/lib/src/parsers/stac_form/stac_form_scope.dart';
import 'package:felloapp/util/stac/lib/src/utils/action_type.dart';
import 'package:felloapp/util/stac_framework/lib/stac_framework.dart';

class StacGetFormValueParser extends StacActionParser<StacGetFormValue> {
  const StacGetFormValueParser();

  @override
  String get actionType => ActionType.getFormValue.name;

  @override
  StacGetFormValue getModel(Map<String, dynamic> json) =>
      StacGetFormValue.fromJson(json);

  @override
  String? onCall(BuildContext context, StacGetFormValue model) {
    return StacFormScope.of(context)?.formData[model.id].toString();
  }
}
