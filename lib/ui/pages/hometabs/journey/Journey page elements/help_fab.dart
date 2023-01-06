import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/service/analytics/analyticsProperties.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/util/dynamic_ui_utils.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/preference_helper.dart';
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
  bool isOpen = true;
  expandFab() {
    setState(() {
      isOpen = true;
    });
  }

  collapseFab() {
    setState(() {
      isOpen = false;
    });
  }

  trackHelpTappedEvent() {
    _analyticsService!.track(
        eventName: AnalyticsEvents.journeyFloatingIconTapped,
        properties: AnalyticsProperties.getDefaultPropertiesMap());
  }

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      if (DynamicUiUtils.helpFab.isCollapse) collapseFab();
    });
    super.initState();
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
          // PreferenceHelper.remove(
          //     PreferenceHelper.CACHE_LAST_DAILY_APP_BONUS_REWARD_CLAIM_DAY);
          PreferenceHelper.setInt(
              PreferenceHelper.CACHE_LAST_DAILY_APP_BONUS_REWARD_CLAIM_DAY,
              DateTime.now().subtract(Duration(days: 1)).day);
          print(
              "DAILY APP BOUNUS: claimed day cached is ${DateTime.now().subtract(Duration(days: 1)).day}");
          // clearCache();
          // trackHelpTappedEvent();
          // AppState.delegate!
          //     .parseRoute(Uri.parse(DynamicUiUtils.helpFab.actionUri));
        },
        child: AnimatedContainer(
            duration: Duration(seconds: 1),
            curve: Curves.easeIn,
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
                  width: SizeConfig.avatarRadius * 1.8,
                  height: SizeConfig.avatarRadius * 1.8,
                  fit: BoxFit.contain,
                ),
                if (isOpen) SizedBox(width: SizeConfig.padding4),
                if (isOpen)
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

// class HelpFabUI {
//   factory HelpFabUI(SingleInfo fabData) {
//     if (fabData.iconUri.isEmpty && fabData.title.isEmpty)
//       return NoFabUI();
//     else
//       return FabUI();
//   }
// }

// class NoFabUI implements HelpFabUI {}

// class FabUI implements HelpFabUI {
//   Widget build() {
//     return FloatingActionButton(onPressed: onPressed);
//   }
// }
