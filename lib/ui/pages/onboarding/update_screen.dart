import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/db_ops.dart';
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

class UpdateRequiredScreen extends StatefulWidget {
  @override
  _UpdateRequiredScreenState createState() => _UpdateRequiredScreenState();
}

class _UpdateRequiredScreenState extends State<UpdateRequiredScreen> {
  final Log log = Log('Update Screen');
  BaseUtil baseProvider;
  DBModel dbProvider;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    dbProvider = Provider.of<DBModel>(context, listen: false);

    return Scaffold(
      backgroundColor: UiConstants.primaryColor,
      body: HomeBackground(
        child: Column(
          children: [
            FelloAppBar(
              title: "App Update",
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: SizeConfig.blockSizeVertical * 5,
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset("images/update_alert.svg",
                            height: SizeConfig.screenHeight * 0.24),
                      ],
                    ),
                    SizedBox(height: SizeConfig.blockSizeVertical * 8),
                    Center(
                        child: Text(
                      'New Update Available!',
                      style: TextStyles.title2.bold
                          .colour(UiConstants.primaryColor),
                    )),
                    SizedBox(height: SizeConfig.blockSizeVertical * 2),
                    Container(
                      padding: EdgeInsets.all(8.0),
                      width: SizeConfig.screenWidth * 0.9,
                      child: Text(
                        'We have updated the app to ensure that we deliver the best experience to you. Please update the app to proceed.',
                        textAlign: TextAlign.center,
                        style: TextStyles.body2,
                      ),
                    ),
                    SizedBox(height: SizeConfig.blockSizeVertical * 5),
                    Spacer(),
                    Container(
                      width: double.infinity,
                      child: FelloButtonLg(
                        child: isLoading
                            ? SpinKitThreeBounce(
                                color: Colors.white,
                                size: SizeConfig.padding16,
                              )
                            : Text(
                                "Update",
                                style:
                                    TextStyles.body2.bold.colour(Colors.white),
                              ),
                        color: UiConstants.primaryColor,
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                          });
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
                          Future.delayed(Duration(seconds: 2), () {
                            setState(() {
                              isLoading = false;
                            });
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.padding24,
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
