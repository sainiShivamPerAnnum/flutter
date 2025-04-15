import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:flutter/material.dart';
import 'package:felloapp/util/stac/lib/src/action_parsers/stac_modal_bottom_sheet_action/stac_modal_bottom_sheet_action.dart';
import 'package:felloapp/util/stac/lib/src/framework/framework.dart';
import 'package:felloapp/util/stac/lib/src/parsers/stac_box_constraints/stac_box_constraints.dart';
import 'package:felloapp/util/stac/lib/src/utils/action_type.dart';
import 'package:felloapp/util/stac/lib/src/utils/color_utils.dart';
import 'package:felloapp/util/stac_framework/lib/stac_framework.dart';

export 'stac_modal_bottom_sheet_action.dart';

class StacModalBottomSheetActionParser
    extends StacActionParser<StacModalBottomSheetAction> {
  const StacModalBottomSheetActionParser();

  @override
  String get actionType => ActionType.showModalBottomSheet.name;

  @override
  StacModalBottomSheetAction getModel(Map<String, dynamic> json) =>
      StacModalBottomSheetAction.fromJson(json);

  @override
  FutureOr onCall(BuildContext context, model) {
    if (model.widget != null) {
      return _showModalBottomSheet(
        context,
        model,
        Stac.fromJson(model.widget, context) ?? const SizedBox(),
      );
    } else if (model.assetPath?.isNotEmpty ?? false) {
      return _showModalBottomSheet(
        context,
        model,
        Stac.fromAssets(model.assetPath!) ?? const SizedBox(),
      );
    } else if (model.request != null) {
      return _showModalBottomSheet(
        context,
        model,
        Stac.fromNetwork(context: context, request: model.request!),
      );
    }
  }

  Future _showModalBottomSheet(
    BuildContext context,
    StacModalBottomSheetAction model,
    Widget widget,
  ) {
    return BaseUtil.openModalBottomSheet(
      content: widget,
      backgroundColor: model.backgroundColor.toColor(context),
      addToScreenStack: model.addToScreenStack,
      hapticVibrate: model.hapticVibrate,
      // barrierLabel: model.barrierLabel,
      // elevation: model.elevation,
      // shape: model.shape?.parse(context),
      boxContraints: model.constraints?.parse,
      // barrierColor: model.barrierColor.toColor(context),
      isScrollControlled: model.isScrollControlled,
      // useRootNavigator: model.useRootNavigator,
      isBarrierDismissible: model.isDismissible,
      enableDrag: model.enableDrag,
      // showDragHandle: model.showDragHandle,
      // useSafeArea: model.useSafeArea,
    );
  }
}
