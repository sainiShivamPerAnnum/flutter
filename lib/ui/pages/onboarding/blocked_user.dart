import 'package:felloapp/base_util.dart';
import 'package:felloapp/util/assets.dart';

import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../static/new_square_background.dart';

class BlockedUserView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          NewSquareBackground(),
          Positioned(
            top: 0,
            child: Container(
              height: SizeConfig.screenHeight * 0.5,
              width: SizeConfig.screenWidth,
              decoration: BoxDecoration(
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
              top: SizeConfig.screenHeight * 0.35,
              child: SvgPicture.asset(
                Assets.flatIsland,
                width: SizeConfig.screenWidth * 0.5,
              )),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Your account has been blocked',
                style: TextStyles.rajdhaniB.title2,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: SizeConfig.padding24),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding44),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: new TextSpan(
                    text: locale.obBlockedSubtitle1,
                    style: TextStyles.rajdhani.colour(Colors.grey),
                    children: [
                      new TextSpan(
                        text: 'Terms of use',
                        style: TextStyles.rajdhani.underline,
                        recognizer: new TapGestureRecognizer()
                          ..onTap = () {
                            Haptic.vibrate();
                            Haptic.vibrate();
                            try {
                              Haptic.vibrate();
                              BaseUtil.launchUrl('https://fello.in/policy/tnc');
                            } catch (e) {
                              BaseUtil.showNegativeAlert(
                                'Something went wrong',
                                'Could not launch T&C right now. Please try again later',
                              );
                            }
                          },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: SizeConfig.padding34),
            ],
          ),
        ],
      ),
    );
  }
}
