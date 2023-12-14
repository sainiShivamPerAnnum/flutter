import 'package:felloapp/core/constants/analytics_events_constants.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/enums/user_service_enum.dart';
import 'package:felloapp/core/service/analytics/analyticsProperties.dart';
import 'package:felloapp/core/service/analytics/analytics_service.dart';
import 'package:felloapp/core/service/journey_service.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class FelloAppBar extends StatelessWidget {
  final Widget? leading;
  final List<Widget>? actions;
  final String? title;
  final bool showAppBar;

  const FelloAppBar(
      {this.leading,
      this.actions,
      this.title,
      this.showAppBar = true,
      Key? key,
      int? elevation,
      Color? backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight! / 8,
        color: showAppBar ? UiConstants.kBackgroundColor : Colors.transparent,
        child: AppBar(
          elevation: 0,
          leading: leading ?? Container(),
          centerTitle: true,
          title: title != null
              ? FittedBox(
                  child: Text(
                  title!,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  style: TextStyles.rajdhaniSB.title4,
                ))
              : const Text(''),
          backgroundColor: showAppBar
              ? UiConstants.kSecondaryBackgroundColor
              : Colors.transparent,
          actions: actions ?? [Container()],
        ));
  }
}

class NotificationButton extends StatelessWidget {
  final AnalyticsService _analytics = locator<AnalyticsService>();

  NotificationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<UserService, UserServiceProperties>(
        properties: const [UserServiceProperties.myNotificationStatus],
        builder: (context, model, property) => InkWell(
              onTap: () {
                if (JourneyService.isAvatarAnimationInProgress) return;

                Haptic.vibrate();
                _analytics.track(
                    eventName: AnalyticsEvents.notificationsClicked,
                    properties: AnalyticsProperties.getDefaultPropertiesMap());
                model.hasNewNotifications = false;

                AppState.delegate!.appState.currentAction = PageAction(
                  state: PageState.addPage,
                  page: NotificationsConfig,
                );
              },
              child: Stack(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.1),
                    radius: SizeConfig.avatarRadius * 1.1,
                    child: Padding(
                      padding: EdgeInsets.all(SizeConfig.padding12),
                      child: SvgPicture.asset(
                        Assets.alerts,
                      ),
                    ),
                  ),
                  if (model!.hasNewNotifications)
                    Positioned(
                      right: 2,
                      top: 2,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: SizeConfig.iconSize4 / 1.4,
                          backgroundColor: Colors.red,
                        ),
                      ),
                    )
                ],
              ),
            ));
  }
}

class TextFieldLabel extends StatelessWidget {
  final String text;

  const TextFieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: SizeConfig.padding6,
        top: SizeConfig.padding16,
      ),
      child: Text(
        text,
        style: TextStyles.body3.colour(Colors.grey),
      ),
    );
  }
}
