import 'dart:convert';
import 'dart:developer';

import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/appbar/appbar.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/new_user_save.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

const HtmlEscape htmlEscape = HtmlEscape();

class Save extends StatelessWidget {
  final CustomLogger? logger = locator<CustomLogger>();

  @override
  Widget build(BuildContext context) {
    log("ROOT: Save view build called");
    return BaseView<SaveViewModel>(
      onModelReady: (model) => model.init(),
      builder: (ctx, model, child) {
        log("ROOT: Save view baseview build called");
        return SaveViewWrapper(model: model);
      },
    );
  }
}

class SaveViewWrapper extends StatelessWidget {
  const SaveViewWrapper({Key? key, required this.model}) : super(key: key);
  final SaveViewModel model;
  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<UserService, UserServiceProperties>(
        properties: [UserServiceProperties.mySegments],
        builder: (_, prop, ___) {
          if (locator<UserService>().baseUser!.segments.contains("NEW_USER")) {
            return NewUserSaveView(
              model: model,
            );
          }
          return Scaffold(
            key: ValueKey(Constants.SAVE_SCREEN_TAG),
            backgroundColor: Colors.transparent,
            appBar: FAppBar(
              type: FaqsType.savings,
              backgroundColor: UiConstants.kSecondaryBackgroundColor,
            ),
            body: ListView(
              children: model.getSaveViewItems(model),
            ),
          );
        });
  }
}
