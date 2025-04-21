import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:felloapp/util/stac/lib/src/utils/action_type.dart';
import 'package:felloapp/util/stac_framework/lib/stac_framework.dart';

class StacNoneActionParser extends StacActionParser<dynamic> {
  const StacNoneActionParser();

  @override
  String get actionType => ActionType.none.name;

  @override
  getModel(Map<String, dynamic> json) => json;

  @override
  FutureOr<dynamic> onCall(BuildContext context, model) {}
}
