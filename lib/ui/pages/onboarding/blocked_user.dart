import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/core/service/mixpanel_service.dart';
import 'package:felloapp/core/service/transaction_service.dart';
import 'package:felloapp/core/service/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/dialogs/confirm_action_dialog.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/ui/widgets/fello_dialog/fello_confirm_dialog.dart';
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
  final BaseUtil _baseUtil = locator<BaseUtil>();
  final _txnService = locator<TransactionService>();
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
                    Image.asset(
                      Assets.blocked,
                      width: SizeConfig.screenWidth * 0.7,
                      height: SizeConfig.blockSizeVertical * 35,
                    ),
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
                    Container(
                      padding: EdgeInsets.all(SizeConfig.padding20),
                      child: Text("OR",
                          style:
                              TextStyles.body3.light.colour(Colors.grey[400])),
                    ),
                    Container(
                      width: SizeConfig.screenWidth / 2,
                      child: FelloButtonLg(
                        onPressed: signout,
                        child: Text(
                          locale.signout,
                          style: TextStyles.body2.bold.colour(Colors.white),
                        ),
                      ),
                    )
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
        eventName: MixpanelEvents.emailInitiated,
        properties: {'userId': _userService.baseUser.uid});
    final Uri emailLaunchUri = Uri(scheme: 'mailto', path: 'hello@fello.in');
    launch(emailLaunchUri.toString());
  }

  signout() async {
    if (await BaseUtil.showNoInternetAlert()) return;
    BaseUtil.openDialog(
      isBarrierDismissable: false,
      addToScreenStack: true,
      content: FelloConfirmationDialog(
          title: 'Confirm',
          subtitle: 'Are you sure you want to sign out?',
          accept: 'Yes',
          acceptColor: UiConstants.primaryColor,
          asset: Assets.signout,
          reject: "No",
          rejectColor: UiConstants.tertiarySolid,
          showCrossIcon: false,
          onAccept: () {
            Haptic.vibrate();

            _mixpanelService.track(eventName: MixpanelEvents.signOut);
            _mixpanelService.signOut();

            _userService.signout().then((flag) {
              if (flag) {
                //log.debug('Sign out process complete');

                _txnService.signOut();
                _baseUtil.signOut();
                AppState.backButtonDispatcher.didPopRoute();
                AppState.delegate.appState.currentAction = PageAction(
                    state: PageState.replaceAll, page: SplashPageConfig);
                BaseUtil.showPositiveAlert(
                  'Signed out',
                  'Hope to see you soon',
                );
              } else {
                BaseUtil.showNegativeAlert(
                    'Sign out failed', 'Couldn\'t signout. Please try again');
                //log.error('Sign out process failed');
              }
            });
          },
          onReject: () {
            AppState.backButtonDispatcher.didPopRoute();
          }),
    );
  }
}
