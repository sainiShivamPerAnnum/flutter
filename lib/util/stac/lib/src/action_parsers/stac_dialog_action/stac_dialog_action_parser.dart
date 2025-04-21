import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/util/stac/lib/src/action_parsers/stac_dialog_action/stac_dialog_action.dart';
import 'package:felloapp/util/stac/lib/src/framework/framework.dart';
import 'package:felloapp/util/stac/lib/src/utils/action_type.dart';
import 'package:felloapp/util/stac/lib/src/utils/color_utils.dart';
import 'package:felloapp/util/stac_framework/lib/stac_framework.dart';
import 'package:flutter/material.dart';

class StacDialogActionParser extends StacActionParser<StacDialogAction> {
  const StacDialogActionParser();

  @override
  String get actionType => ActionType.showDialog.name;

  @override
  StacDialogAction getModel(Map<String, dynamic> json) =>
      StacDialogAction.fromJson(json);

  @override
  FutureOr onCall(BuildContext context, StacDialogAction model) {
    if (model.widget != null) {
      return _showDialog(
        context,
        model,
        Stac.fromJson(model.widget, context) ?? const SizedBox(),
      );
    } else if (model.assetPath?.isNotEmpty ?? false) {
      return _showDialog(
        context,
        model,
        Stac.fromAssets(model.assetPath!) ?? const SizedBox(),
      );
    } else if (model.request != null) {
      return _showDialog(
        context,
        model,
        Stac.fromNetwork(context: context, request: model.request!),
      );
    }
  }

  Future _showDialog(
    BuildContext context,
    StacDialogAction model,
    Widget widget,
  ) {
    return BaseUtil.openDialog(
      isBarrierDismissible: model.barrierDismissible,
      content: widget,
      barrierColor: model.barrierColor.toColor(context),
      addToScreenStack: model.addToScreenStack,
      hapticVibrate: model.hapticVibrate,
      // barrierLabel: model.barrierLabel,
      // useSafeArea: model.useSafeArea,
      // traversalEdgeBehavior: model.traversalEdgeBehavior,
    );
  }
}
