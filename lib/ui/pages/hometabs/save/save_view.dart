import 'dart:convert';
import 'dart:developer';

import 'package:felloapp/core/enums/bank_and_pan_enum.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/bank_and_pan_service.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_components/new_user_save.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/ui/pages/root/root_vm.dart';
import 'package:felloapp/ui/shared/spotlight_controller.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:showcaseview/showcaseview.dart';

const HtmlEscape htmlEscape = HtmlEscape();

class Save extends StatelessWidget {
  const Save({super.key});

  @override
  Widget build(BuildContext context) {
    return PropertyChangeProvider<BankAndPanService,
        BankAndPanServiceProperties>(
      value: locator<BankAndPanService>(),
      child: BaseView<SaveViewModel>(
        onModelReady: (model) => model.init(),
        builder: (ctx, model, child) {
          log("ROOT: Save view baseview build called");
          return ShowCaseWidget(
            enableAutoScroll: true,
            onFinish: () {
              SpotLightController.instance.completer.complete();
              SpotLightController.instance.isTourStarted = false;
              SpotLightController.instance.startShowCase = false;
            },
            onSkipButtonClicked: () {
              SpotLightController.instance.isSkipButtonClicked = true;
              SpotLightController.instance.startShowCase = false;
            },
            builder: Builder(builder: (context) {
              SpotLightController.instance.saveViewContext = context;
              return SaveViewWrapper(model: model);
            }),
          );
        },
      ),
    );
  }
}

class SaveViewWrapper extends StatelessWidget {
  const SaveViewWrapper({Key? key, required this.model}) : super(key: key);
  final SaveViewModel model;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      color: UiConstants.primaryColor,
      backgroundColor: Colors.black,
      onRefresh: locator<RootViewModel>().refresh,
      child: PropertyChangeConsumer<UserService, UserServiceProperties>(
        properties: const [UserServiceProperties.mySegments],
        builder: (_, prop, ___) {
          if (prop!.userSegments.contains("NEW_USER")) {
            return NewUserSaveView(
              model: model,
            );
          }
          return SizedBox(
            height: SizeConfig.screenHeight,
            child: Column(
              children: [
                SizedBox(height: SizeConfig.fToolBarHeight),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    cacheExtent: SizeConfig.screenHeight,
                    children: model.getSaveViewItems(model),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
