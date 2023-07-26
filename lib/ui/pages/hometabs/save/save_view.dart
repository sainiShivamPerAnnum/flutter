import 'dart:convert';
import 'dart:developer';

import 'package:felloapp/core/enums/app_config_keys.dart';
import 'package:felloapp/core/enums/bank_and_pan_enum.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/model/app_config_model.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/core/service/payments/bank_and_pan_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/title_subtitle_container.dart';
import 'package:felloapp/ui/pages/hometabs/home/card_actions_notifier.dart';
import 'package:felloapp/ui/pages/hometabs/home/cards_home.dart';
import 'package:felloapp/ui/pages/hometabs/save/save_viewModel.dart';
import 'package:felloapp/ui/shared/spotlight_controller.dart';
import 'package:felloapp/util/locator.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../../util/styles/styles.dart';

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
        onModelDispose: (model) => model.dump(),
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
    return PropertyChangeConsumer<UserService, UserServiceProperties>(
      properties: const [UserServiceProperties.mySegments],
      builder: (_, prop, ___) {
        return (!prop!.userSegments.contains("NEW_USER"))
            ? Stack(
                children: [
                  SingleChildScrollView(
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
            : ListView(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                cacheExtent: 1000,
                padding: EdgeInsets.zero,
                children: model.getNewUserSaveViewItems(model),
              );
      },
    );
  }
}

class QuizSection extends StatelessWidget {
  const QuizSection({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> quizSectionData =
        AppConfig.getValue(AppConfigKey.quiz_config);

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: SizeConfig.padding14,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleSubtitleContainer(
            title: quizSectionData["title"],
          ),
          SizedBox(
            height: SizeConfig.padding12,
          ),
          GestureDetector(
            onTap: () {
              AppState.delegate!.parseRoute(quizSectionData['deeplink']);
            },
            child: Container(
              height: SizeConfig.screenWidth! * 0.32,
              width: SizeConfig.screenWidth,
              margin: EdgeInsets.symmetric(
                  horizontal: SizeConfig.pageHorizontalMargins),
              decoration: BoxDecoration(
                color: UiConstants.kSecondaryBackgroundColor,
                borderRadius: BorderRadius.circular(SizeConfig.roundness16),
                border: Border.all(color: Colors.white12),
                image: DecorationImage(
                  image: NetworkImage(
                    quizSectionData["image"],
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
