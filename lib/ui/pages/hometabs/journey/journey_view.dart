import 'dart:developer';

import 'package:felloapp/core/enums/journey_service_enum.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/hometabs/journey/elements/avatar.dart';
import 'package:felloapp/ui/pages/hometabs/journey/elements/focus_ring.dart';
import 'package:felloapp/ui/pages/hometabs/journey/elements/help_fab.dart';
import 'package:felloapp/ui/pages/hometabs/journey/elements/indicators.dart';
import 'package:felloapp/ui/pages/hometabs/journey/elements/jAssetPath.dart';
import 'package:felloapp/ui/pages/hometabs/journey/elements/jMilestones.dart';
import 'package:felloapp/ui/pages/hometabs/journey/elements/jTooltip.dart';
import 'package:felloapp/ui/pages/hometabs/journey/elements/journey_error_view.dart';
import 'package:felloapp/ui/pages/hometabs/journey/elements/level_blur_view.dart';
import 'package:felloapp/ui/pages/hometabs/journey/elements/level_up_animation.dart';
import 'package:felloapp/ui/pages/hometabs/journey/elements/unscratched_gt_tooltips.dart';
import 'package:felloapp/ui/pages/hometabs/journey/journey_vm.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/dynamic_ui_utils.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:provider/provider.dart';

import '../../../../navigator/app_state.dart';
import 'elements/jBackground.dart';

class JourneyView extends StatefulWidget {
  const JourneyView({super.key});

  @override
  State<JourneyView> createState() => _JourneyViewState();
}

class _JourneyViewState extends State<JourneyView>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    log("ROOT: Journey view build called");
    final s = locator<S>();
    return PropertyChangeProvider<JourneyService, JourneyServiceProperties>(
      value: locator<JourneyService>(),
      child: BaseView<JourneyPageViewModel>(
        onModelReady: (model) async {
          await model.init(this);
        },
        onModelDispose: (model) {
          model.dump();
        },
        builder: (ctx, model, child) {
          if (model.state == ViewState.Busy) {
            return const Scaffold(
              body: Center(child: FullScreenLoader()),
              backgroundColor: UiConstants.kBackgroundColor,
            );
          }

          return Consumer<JourneyService>(
            builder: (context, service, child) => Scaffold(
              key: const ValueKey(Constants.JOURNEY_SCREEN_TAG),
              appBar: AppBar(
                backgroundColor: UiConstants.kBackgroundColor,
                surfaceTintColor: UiConstants.kBackgroundColor,
                leading: IconButton(
                  onPressed: AppState.backButtonDispatcher!.didPopRoute,
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                  ),
                ),
                centerTitle: false,
                title: Text(
                  s.navBarJourney,
                  style: TextStyles.rajdhaniSB.title4,
                ),
                actions: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: UiConstants.primaryColor,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(
                            SizeConfig.roundness12,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.padding8,
                          vertical: SizeConfig.padding4,
                        ),
                        child: Row(
                          children: [
                            Transform.translate(
                              offset: Offset(0, -SizeConfig.padding4),
                              child: Lottie.asset(
                                Assets.navJourneyLottie,
                                repeat: false,
                                width: SizeConfig.padding32,
                              ),
                            ),
                            SizedBox(width: SizeConfig.padding8),
                            Text(
                              "Level ${locator<UserService>().userJourneyStats?.level ?? 1}",
                              style: TextStyles.sourceSansSB.body1,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: SizeConfig.pageHorizontalMargins,
                      )
                    ],
                  )
                ],
              ),
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.black,
              body: service.isLoading && model.pages == null
                  ? const JourneyErrorScreen()
                  : Stack(
                      children: [
                        SizedBox(
                          height: SizeConfig.screenHeight,
                          width: SizeConfig.screenWidth,
                          child: RefreshIndicator(
                            onRefresh: service.checkForMilestoneLevelChange,
                            child: SingleChildScrollView(
                              controller: model.mainController,
                              physics: const BouncingScrollPhysics(),
                              reverse: true,
                              child: SizedBox(
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
                                    if (service.showFocusRing)
                                      const FocusRing(),
                                    const LevelBlurView(),
                                    PrizeToolTips(model: model),
                                    MilestoneTooltip(model: model),
                                    Avatar(model: model),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (DynamicUiUtils.helpFab.actionUri.isNotEmpty)
                          const HelpFab(),
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
