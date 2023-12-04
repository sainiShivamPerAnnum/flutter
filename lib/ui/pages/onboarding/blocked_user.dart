import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/page_state_enum.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/navigator/router/ui_pages.dart';
import 'package:felloapp/ui/elements/appbar/appbar.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../static/new_square_background.dart';

class BlockedUserView extends StatelessWidget {
  const BlockedUserView({
    super.key,
    this.isStateRestricted = false,
    this.isMaintenanceMode = false,
    this.blockTitle = '',
    this.blockSubtitle = '',
  });

  final bool isStateRestricted;
  final bool isMaintenanceMode;
  final String blockTitle;
  final String blockSubtitle;

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          const NewSquareBackground(),
          Positioned(
            top: 0,
            child: Container(
              height: SizeConfig.screenHeight! * 0.5,
              width: SizeConfig.screenWidth,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xff135756),
                    UiConstants.kBackgroundColor,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
              top: SizeConfig.screenHeight! * 0.35,
              child: SvgPicture.asset(
                Assets.flatIsland,
                width: SizeConfig.screenWidth! * 0.5,
              )),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                getTitle(locale),
                style: TextStyles.rajdhaniB.title2,
                textAlign: TextAlign.center,
              ),
              Container(
                  margin: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
                  child: getSubTitle(locale)),
              SizedBox(height: SizeConfig.navBarHeight / 2),
            ],
          ),
          if (isStateRestricted || isMaintenanceMode)
            Align(
              child: FAppBar(
                  title: null,
                  showAvatar: false,
                  showCoinBar: false,
                  showHelpButton: false,
                  action: Container(
                    height: SizeConfig.avatarRadius * 2,
                    padding:
                        EdgeInsets.symmetric(horizontal: SizeConfig.padding2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: Colors.white,
                        ),
                        color: UiConstants.kBackgroundColor),
                    child: TextButton(
                      child: Text(
                        'Need help?',
                        style: TextStyles.sourceSans.body3,
                      ),
                      onPressed: () {
                        Haptic.vibrate();
                        AppState.delegate!.appState.currentAction = PageAction(
                          state: PageState.addPage,
                          page: FreshDeskHelpPageConfig,
                        );
                      },
                    ),
                  )),
            ),
          SizedBox(height: SizeConfig.padding34),
        ],
      ),
    );
  }

  String getTitle(S locale) {
    if (blockTitle.isNotEmpty) {
      return blockTitle;
    }
    if (isMaintenanceMode) {
      return "App under maintenance";
    }
    if (isStateRestricted) {
      return "Fello is not available in your state";
    }
    return locale.obBlockedTitle;
  }

  Widget getSubTitle(S locale) {
    if (blockSubtitle.isNotEmpty) {
      return Text(
        blockSubtitle,
        style: TextStyles.rajdhani.colour(Colors.grey),
        textAlign: TextAlign.center,
      );
    }
    if (isMaintenanceMode) {
      return Text(
        "Fello is under maintenance. We'll be back again very soon!\nDon't worry, your investments are safe with us",
        style: TextStyles.rajdhani.colour(Colors.grey),
        textAlign: TextAlign.center,
      );
    }
    if (isStateRestricted) {
      return GestureDetector(
        onTap: () async {
          Haptic.vibrate();
          try {
            await BaseUtil.launchUrl('https://fello.in/policy/tnc');
          } catch (e) {
            BaseUtil.showNegativeAlert(
              locale.obSomeThingWentWrong,
              locale.obCouldNotLaunch,
            );
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.padding44, vertical: SizeConfig.padding24),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'Please read our ',
              style: TextStyles.rajdhani.colour(Colors.grey),
              children: [
                TextSpan(
                  text: locale.termsOfService,
                  style: TextStyles.rajdhani.underline,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () async {
        Haptic.vibrate();
        try {
          await BaseUtil.launchUrl('https://fello.in/policy/tnc');
        } catch (e) {
          BaseUtil.showNegativeAlert(
            locale.obSomeThingWentWrong,
            locale.obCouldNotLaunch,
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.padding44, vertical: SizeConfig.padding24),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: "${locale.obBlockedSubtitle1} ",
            style: TextStyles.rajdhani.colour(Colors.grey),
            children: [
              TextSpan(
                text: locale.termsOfService,
                style: TextStyles.rajdhani.underline,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
