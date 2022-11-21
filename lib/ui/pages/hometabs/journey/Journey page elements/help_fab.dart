import 'dart:developer';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/screen_item_enum.dart';
import 'package:felloapp/core/service/analytics/analyticsProperties.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/service_elements/username_input/username_input_view.dart';
import 'package:felloapp/util/dynamic_ui_utils.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HelpFab extends StatefulWidget {
  const HelpFab({Key? key}) : super(key: key);

  @override
  State<HelpFab> createState() => _HelpFabState();
}

class _HelpFabState extends State<HelpFab> {
  final UserService _userService = locator<UserService>();
  final AnalyticsService? _analyticsService = locator<AnalyticsService>();

  double width = SizeConfig.padding90;
  bool isOpen = true;
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
    _analyticsService!.track(
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
      child: InkWell(
        onTap: () {
          isOpen ? collapseFab() : expandFab();
          AppState.screenStack.add(ScreenItem.dialog);
          trackHelpTappedEvent();
          AppState.delegate!
              .parseRoute(Uri.parse(DynamicUiUtils.helpFab.actionUri));
        },
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding12),
            height: SizeConfig.avatarRadius * 2.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: Colors.white, width: 1),
              color: Colors.black,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.network(
                  DynamicUiUtils.helpFab.iconUri,
                  // height: SizeConfig.avatarRadius * 1.8,
                  width: SizeConfig.avatarRadius * 1.8,
                ),
                SizedBox(width: SizeConfig.padding4),
                Container(
                  child: Text(
                    " ${DynamicUiUtils.helpFab.title}",
                    style: TextStyles.sourceSansSB.body3,
                  ),
                )
              ],
            )),
      ),
    );
  }
}
