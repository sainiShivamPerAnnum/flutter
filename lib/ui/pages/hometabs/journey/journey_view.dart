import 'dart:developer';

import 'package:felloapp/core/enums/journey_service_enum.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/journey/components/journey_appbar/journey_appbar_view.dart';
import 'package:felloapp/ui/pages/hometabs/journey/components/journey_banners/journey_banners_view.dart';
import 'package:felloapp/ui/pages/hometabs/journey/elements/avatar.dart';
import 'package:felloapp/ui/pages/hometabs/journey/elements/focus_ring.dart';
import 'package:felloapp/ui/pages/hometabs/journey/elements/help_fab.dart';
import 'package:felloapp/ui/pages/hometabs/journey/elements/indicators.dart';
import 'package:felloapp/ui/pages/hometabs/journey/elements/jAssetPath.dart';
import 'package:felloapp/ui/pages/hometabs/journey/elements/jBackground.dart';
import 'package:felloapp/ui/pages/hometabs/journey/elements/jMilestones.dart';
import 'package:felloapp/ui/pages/hometabs/journey/elements/jTooltip.dart';
import 'package:felloapp/ui/pages/hometabs/journey/elements/journey_error_view.dart';
import 'package:felloapp/ui/pages/hometabs/journey/elements/level_blur_view.dart';
import 'package:felloapp/ui/pages/hometabs/journey/elements/level_up_animation.dart';
import 'package:felloapp/ui/pages/hometabs/journey/elements/unscratched_gt_tooltips.dart';
import 'package:felloapp/ui/pages/hometabs/journey/journey_vm.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/dynamic_ui_utils.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:provider/provider.dart';

class JourneyView extends StatefulWidget {
  @override
  State<JourneyView> createState() => _JourneyViewState();
}

class _JourneyViewState extends State<JourneyView>
    with TickerProviderStateMixin {
  JourneyPageViewModel? modelInstance;

  @override
  Widget build(BuildContext context) {
    log("ROOT: Journey view build called");
    return PropertyChangeProvider<JourneyService, JourneyServiceProperties>(
      value: locator<JourneyService>(),
      child: BaseView<JourneyPageViewModel>(
        onModelReady: (model) async {
          modelInstance = model;
          await model.init(this);
        },
        onModelDispose: (model) {
          model.dump();
        },
        builder: (ctx, model, child) {
          return Consumer<JourneyService>(
            builder: (context, service, child) => Scaffold(
              key: ValueKey(Constants.JOURNEY_SCREEN_TAG),
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.black,
              body: service.isLoading && model.pages == null
                  ? JourneyErrorScreen()
                  : Stack(
                      children: [
                        SizedBox(
                          height: SizeConfig.screenHeight,
                          width: SizeConfig.screenWidth,
                          child: SingleChildScrollView(
                            controller: model.mainController,
                            physics: const BouncingScrollPhysics(),
                            reverse: true,
                            child: Container(
                              height: model.currentFullViewHeight,
                              width: SizeConfig.screenWidth,
                              child: Stack(
                                children: [
                                  Background(model: model),
                                  const ActiveMilestoneBackgroundGlow(),
                                  JourneyAssetPath(model: model),
                                  if (model.avatarPath != null)
                                    AvatarPathPainter(model: model),
                                  const ActiveMilestoneBaseGlow(),
                                  Milestones(model: model),
                                  if (service.showFocusRing) const FocusRing(),
                                  const LevelBlurView(),
                                  PrizeToolTips(model: model),
                                  MilestoneTooltip(model: model),
                                  Avatar(model: model),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (DynamicUiUtils.helpFab.actionUri.isNotEmpty)
                          const HelpFab(),
                        const JourneyAppBar(),
                        const JourneyBannersView(),
                        if (model.isRefreshing || service.isRefreshing)
                          const JRefreshIndicator(),
                        JPageLoader(model: model),
                        const LevelUpAnimation(),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }
}
