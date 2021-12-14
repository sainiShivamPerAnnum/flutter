import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/service/mixpanel_service.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/mixpanel_events.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class BlockedUserView extends StatelessWidget {
  final _mixpanelService = locator<MixpanelService>();
  final _userService = locator<UserService>();

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return Scaffold(
      backgroundColor: UiConstants.primaryColor,
      body: HomeBackground(
        child: Column(
          children: [
            FelloAppBar(
              title: locale.obBlockedAb,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.pageHorizontalMargins),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(SizeConfig.padding40),
                    topRight: Radius.circular(SizeConfig.padding40),
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      Assets.blocked,
                      height: SizeConfig.blockSizeVertical * 35,
                    ),
                    SizedBox(height: SizeConfig.padding24),
                    Center(
                        child: Text(
                      locale.obBlockedTitle,
                      style: TextStyles.title2.bold
                          .colour(UiConstants.tertiarySolid),
                    )),
                    SizedBox(height: SizeConfig.padding8),
                    RichText(
                      textAlign: TextAlign.center,
                      text: new TextSpan(
                        text: locale.obBlockedSubtitle1,
                        style: TextStyles.body2.colour(Colors.black),
                        children: [
                          new TextSpan(
                            text: ' hello@fello.in ',
                            style: TextStyles.body2
                                .colour(UiConstants.primaryColor)
                                .underline,
                            recognizer: new TapGestureRecognizer()
                              ..onTap = () {
                                Haptic.vibrate();
                                Haptic.vibrate();
                                try {
                                  _launchEmail();
                                } catch (e) {
                                  BaseUtil.showNegativeAlert(
                                    'Error',
                                    'Something went wrong, could not launch email right now. Please try again later',
                                  );
                                }
                              },
                          ),
                          new TextSpan(
                            text: locale.obBlockedSubtitle2,
                            style: TextStyles.body2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _launchEmail() {
    _mixpanelService.track(
        MixpanelEvents.emailInitiated, {'userId': _userService.baseUser.uid});
    final Uri emailLaunchUri = Uri(scheme: 'mailto', path: 'hello@fello.in');
    launch(emailLaunchUri.toString());
  }
}
