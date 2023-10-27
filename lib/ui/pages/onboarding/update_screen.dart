import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../static/new_square_background.dart';

class UpdateRequiredScreen extends StatelessWidget {
  const UpdateRequiredScreen({Key? key}) : super(key: key);

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
                locale.obAppUpdate,
                style: TextStyles.rajdhaniB.title2,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: SizeConfig.padding24),
              Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: SizeConfig.padding44),
                  child: Text(
                    locale.obCritialFeaturesUpdate,
                    style: TextStyles.rajdhani.colour(Colors.grey),
                    textAlign: TextAlign.center,
                  )),
              Padding(
                padding: EdgeInsets.all(SizeConfig.padding34),
                child: AppPositiveBtn(
                  btnText: locale.updateNow.toUpperCase(),
                  onPressed: () {
                    try {
                      if (Platform.isIOS) {
                        BaseUtil.launchUrl(Constants.APPLE_STORE_APP_LINK);
                      } else if (Platform.isAndroid) {
                        BaseUtil.launchUrl(Constants.PLAY_STORE_APP_LINK);
                      }
                    } catch (e) {
                      Log(e.toString());
                      BaseUtil.showNegativeAlert(
                          locale.obSomeThingWentWrong, locale.obPleaseTryAgain);
                    }
                  },
                  width: SizeConfig.screenWidth! * 0.8,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
