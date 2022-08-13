import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../util/haptic.dart';
import '../static/new_square_background.dart';

class UpdateRequiredScreen extends StatelessWidget {
  const UpdateRequiredScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                'assets/svg/flag_svg.svg',
                width: SizeConfig.screenWidth * 0.5,
              )),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'App Update Required',
                style: TextStyles.rajdhaniB.title2,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: SizeConfig.padding24),
              Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: SizeConfig.padding44),
                  child: Text(
                    "We have come up with critical features and experience improvements that require an update of the application",
                    style: TextStyles.rajdhani.colour(Colors.grey),
                    textAlign: TextAlign.center,
                  )),
              Padding(
                padding: EdgeInsets.all(SizeConfig.padding34),
                child: AppPositiveBtn(
                  btnText: "Update Now".toUpperCase(),
                  onPressed: () {
                    try {
                      if (Platform.isIOS)
                        BaseUtil.launchUrl(
                            'https://apps.apple.com/in/app/fello-save-play-win/id1558445254');
                      else if (Platform.isAndroid)
                        BaseUtil.launchUrl(
                            'https://play.google.com/store/apps/details?id=in.fello.felloapp');
                    } catch (e) {
                      Log(e.toString());
                      BaseUtil.showNegativeAlert(
                          "Something went wrong", "Please try again");
                    }
                  },
                  width: SizeConfig.screenWidth * 0.8,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
