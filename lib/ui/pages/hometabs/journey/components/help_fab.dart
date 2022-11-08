import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/model/golden_ticket_model.dart';
import 'package:felloapp/core/repository/golden_ticket_repo.dart';
import 'package:felloapp/core/service/analytics/analyticsProperties.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/golden_ticket_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/pages/others/events/info_stories/info_stories_view.dart';
import 'package:felloapp/ui/pages/others/rewards/golden_scratch_dialog/gt_instant_view.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class HelpFab extends StatefulWidget {
  final String topic;
  const HelpFab({Key key, @required this.topic}) : super(key: key);

  @override
  State<HelpFab> createState() => _HelpFabState();
}

class _HelpFabState extends State<HelpFab> {
  final _userService = locator<UserService>();
  final _analyticsService = locator<AnalyticsService>();
  final _gtRepo = locator<GoldenTicketRepository>();
  final _gtService = locator<GoldenTicketService>();
  double width = SizeConfig.avatarRadius * 2.4;
  bool isOpen = false;
  expandFab() {
    setState(() {
      isOpen = true;
      width = SizeConfig.padding80;
    });
    Future.delayed(Duration(seconds: 5), () {
      collapseFab();
    });
  }

  collapseFab() {
    setState(() {
      isOpen = false;
      width = SizeConfig.avatarRadius * 2.4;
    });
  }

  trackHelpTappedEvent() {
    _analyticsService.track(
        eventName: AnalyticsEvents.journeyHelpTapped,
        properties: AnalyticsProperties.getDefaultPropertiesMap());
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: SizeConfig.navBarHeight +
          kBottomNavigationBarHeight +
          SizeConfig.padding16,
      right: SizeConfig.padding16,
      child: Column(
        children: [
          InkWell(
            onTap: () async {
              final res = await _gtRepo.getUnscratchedGoldenTickets();
              if (res.isSuccess()) {
                _gtService.unscratchedGoldenTickets = res.model;
              }
              GoldenTicketService.currentGT =
                  _gtService.unscratchedGoldenTickets.first;
              Future.delayed(Duration(milliseconds: 200), () {
                AppState.screenStack.add(ScreenItem.dialog);
                Navigator.of(AppState.delegate.navigatorKey.currentContext)
                    .push(
                  PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) => GTInstantView(
                      source: GTSOURCE.prize,
                      title: "Congratulations",
                      amount: 100,
                      showAutosavePrompt: false,
                    ),
                  ),
                );
              });
            },
            child: Container(
              height: SizeConfig.avatarRadius * 2.4,
              width: SizeConfig.avatarRadius * 2.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: Colors.white, width: 1),
                color: Colors.black,
              ),
              padding: EdgeInsets.all(SizeConfig.avatarRadius / 1.5),
              child: SvgPicture.asset(
                Assets.goldenTicketAsset,
              ),
            ),
          ),
          SizedBox(height: SizeConfig.padding16),
          InkWell(
            onTap: () {
              isOpen ? collapseFab() : expandFab();
              AppState.screenStack.add(ScreenItem.dialog);
              trackHelpTappedEvent();
              Navigator.of(AppState.delegate.navigatorKey.currentContext).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, anotherAnimation) {
                    return InfoStories(
                      topic: widget.topic,
                    );
                  },
                  transitionDuration: Duration(milliseconds: 500),
                  transitionsBuilder:
                      (context, animation, anotherAnimation, child) {
                    animation = CurvedAnimation(
                        curve: Curves.easeInCubic, parent: animation);
                    return Align(
                      child: SizeTransition(
                        sizeFactor: animation,
                        child: child,
                        axisAlignment: 0.0,
                      ),
                    );
                  },
                ),
              );
              // BaseUtil.openDialog(
              //     hapticVibrate: true,
              //     addToScreenStack: true,
              //     content: JourneyOnboardingDialog(),
              //     isBarrierDismissable: false);
            },
            child: AnimatedContainer(
                height: SizeConfig.avatarRadius * 2.4,
                duration: Duration(milliseconds: 600),
                width: this.width,
                curve: Curves.easeInOutCubic,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: Colors.white, width: 1),
                  color: Colors.black,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.translate(
                      offset: Offset(0, SizeConfig.padding3),
                      child: SvgPicture.asset(
                        Assets.winScreenReferalAsset,
                        height: SizeConfig.avatarRadius * 1.8,
                        width: SizeConfig.avatarRadius * 1.8,
                      ),
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 600),
                      curve: Curves.easeInOutCubic,
                      width: isOpen ? SizeConfig.padding32 : 0,
                      child: FittedBox(
                        child: Text(
                          " Help",
                          style: TextStyles.sourceSansSB.body3,
                        ),
                      ),
                    )
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
