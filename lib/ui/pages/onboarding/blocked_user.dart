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
                  children: [
                    SizedBox(
                      height: SizeConfig.navBarHeight,
                    ),
                    Spacer(),
                    Image.asset(
                      Assets.blocked,
                      width: SizeConfig.screenWidth * 0.7,
                      height: SizeConfig.blockSizeVertical * 35,
                    ),
                    Spacer(),
                    Text(
                      locale.obBlockedTitle,
                      style: TextStyles.title3.bold
                          .colour(UiConstants.tertiarySolid),
                    ),
                    SizedBox(height: SizeConfig.padding12),
                    RichText(
                      textAlign: TextAlign.center,
                      text: new TextSpan(
                        text: locale.obBlockedSubtitle1,
                        style: TextStyles.body2.colour(Colors.grey),
                        children: [
                          new TextSpan(
                            text: 'Terms of use',
                            style: TextStyles.body2.underline,
                            recognizer: new TapGestureRecognizer()
                              ..onTap = () {
                                Haptic.vibrate();
                                Haptic.vibrate();
                                try {
                                  Haptic.vibrate();
                                  BaseUtil.launchUrl(
                                      'https://fello.in/policy/tnc');
                                } catch (e) {
                                  BaseUtil.showNegativeAlert(
                                    'Error',
                                    'Something went wrong, could not launch T&C right now. Please try again later',
                                  );
                                }
                              },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.navBarHeight,
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
}
