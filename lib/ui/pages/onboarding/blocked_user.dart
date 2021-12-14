import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BlockedUserView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UiConstants.primaryColor,
      body: HomeBackground(
        child: Column(
          children: [
            FelloAppBar(
              // leading: FelloAppBarBackButton(),
              title: "You seems suspicious!",
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
                      height: SizeConfig.blockSizeVertical * 5,
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     SvgPicture.asset(
                    //       "images/update_alert.svg",
                    //       height: SizeConfig.blockSizeVertical * 35,
                    //     ),
                    //   ],
                    // ),
                    SizedBox(height: SizeConfig.blockSizeVertical * 8),
                    Center(
                        child: Text(
                      'We are sorry but',
                      style: TextStyle(
                          color: UiConstants.primaryColor,
                          fontSize: SizeConfig.cardTitleTextSize,
                          fontWeight: FontWeight.bold),
                    )),
                    SizedBox(height: SizeConfig.blockSizeVertical * 2),
                    Container(
                      padding: EdgeInsets.all(8.0),
                      width: SizeConfig.screenWidth * 0.9,
                      child: Text(
                        'Your account has been disabled. Please write to us at hello@fello.in for more details',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: SizeConfig.cardTitleTextSize * 0.65,
                            color: UiConstants.textColor),
                      ),
                    ),
                    SizedBox(height: SizeConfig.blockSizeVertical * 5),
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
