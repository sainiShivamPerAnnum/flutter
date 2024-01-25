import 'dart:convert';
import 'dart:developer';

import 'package:felloapp/core/enums/bank_and_pan_enum.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/bank_and_pan_service.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/home/card_actions_notifier.dart';
import 'package:felloapp/ui/pages/hometabs/home/cards_home.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/ui/pages/root/root_controller.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:provider/provider.dart';

import '../../../../util/styles/styles.dart';
import 'new_user_save_view/new_user_save_view.dart';

const HtmlEscape htmlEscape = HtmlEscape();

GlobalKey saveViewScrollKey = GlobalKey();

class Save extends StatelessWidget {
  const Save({super.key});

  @override
  Widget build(BuildContext context) {
    return PropertyChangeProvider<BankAndPanService,
        BankAndPanServiceProperties>(
      value: locator<BankAndPanService>(),
      child: BaseView<SaveViewModel>(
        onModelReady: (model) => model.init(),
        onModelDispose: (model) => model.dump(),
        builder: (ctx, model, child) {
          log("ROOT: Save view baseview build called");
          return SaveViewWrapper(model: model);
        },
      ),
    );
  }
}

class SaveViewWrapper extends StatelessWidget {
  const SaveViewWrapper({required this.model, Key? key}) : super(key: key);
  final SaveViewModel model;

  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<UserService, UserServiceProperties>(
      properties: const [UserServiceProperties.mySegments],
      builder: (_, prop, ___) {
        return (!prop!.userSegments.contains("NEW_USER"))
            ? Stack(
                children: [
                  SingleChildScrollView(
                    controller: RootController.controller,
                    child: Stack(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: model.getSaveViewItems(model),
                        ),
                        const Cards(),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    child: Consumer<CardActionsNotifier>(
                      builder: (context, cardActions, child) => cardActions
                              .isVerticalView
                          ? SizedBox(
                              height: SizeConfig.screenHeight,
                              width: SizeConfig.screenWidth,
                              child: Column(
                                children: [
                                  IgnorePointer(
                                    child: AnimatedContainer(
                                      curve: Curves.easeIn,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      height: SizeConfig.screenWidth! * 1.54,
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        if (cardActions.isVerticalView) {
                                          cardActions.isVerticalView = false;
                                        }
                                      },
                                      onVerticalDragUpdate: (details) {
                                        if (details.delta.dy < 30) {
                                          if (cardActions.isVerticalView) {
                                            cardActions.isVerticalView = false;
                                          }
                                        }
                                      },
                                      child: Container(
                                          color: Colors.black.withOpacity(0.2)),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox(),
                    ),
                  ),
                ],
              )
            : NewUserSaveView(
                data: locator(),
              );
      },
    );
  }
}
