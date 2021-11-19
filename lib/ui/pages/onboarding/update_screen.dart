import 'dart:io';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/fail_types.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:provider/provider.dart';

class UpdateRequiredScreen extends StatefulWidget {
  @override
  _UpdateRequiredScreenState createState() => _UpdateRequiredScreenState();
}

class _UpdateRequiredScreenState extends State<UpdateRequiredScreen> {
  final Log log = Log('Update Screen');
  BaseUtil baseProvider;
  DBModel dbProvider;
  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    dbProvider = Provider.of<DBModel>(context, listen: false);

    return Scaffold(
      body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        SafeArea(
            child: GestureDetector(
          onTap: () {
            if (Platform.isIOS) {
              AppState.backButtonDispatcher.didPopRoute();
            } else if (Platform.isAndroid) {
              SystemNavigator.pop();
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Icon(
                  Icons.close,
                  size: SizeConfig.blockSizeVertical * 4,
                )),
          ),
        )),
        SizedBox(
          height: SizeConfig.blockSizeVertical * 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "images/update_alert.svg",
              height: SizeConfig.blockSizeVertical * 35,
            ),
          ],
        ),
        SizedBox(height: SizeConfig.blockSizeVertical * 8),
        Center(
            child: Text(
          'New Update Available!',
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
            'We have updated the app to ensure that we deliver the best experience to you. Please update the app to proceed.',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: SizeConfig.cardTitleTextSize * 0.65,
                color: UiConstants.textColor),
          ),
        ),
        SizedBox(height: SizeConfig.blockSizeVertical * 5),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.07,
              decoration: BoxDecoration(color: UiConstants.primaryColor),
              alignment: Alignment.bottomCenter,
              child: new Material(
                child: MaterialButton(
                  child: Center(
                    child: Text(
                      'Update',
                      style: Theme.of(context).textTheme.button.copyWith(
                          color: Colors.white,
                          fontSize: SizeConfig.largeTextSize,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  highlightColor: Colors.white30,
                  splashColor: Colors.white30,
                  onPressed: () {
                    if (Platform.isIOS) {
                      BaseUtil.launchUrl(
                          'https://apps.apple.com/in/app/fello-save-play-win/id1558445254');
                    } else if (Platform.isAndroid) {
                      // BaseUtil.launchUrl('https://play.google.com/store/apps/details?id=in.fello.felloapp');
                      autoUpdate();
                    }
                  },
                ),
                color: Colors.transparent,
                borderRadius: new BorderRadius.circular(30.0),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Future<void> autoUpdate() async {
    AppUpdateInfo updateInfo;
    try {
      updateInfo = await InAppUpdate.checkForUpdate();
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        InAppUpdate.performImmediateUpdate().catchError((err) {
          BaseUtil.showNegativeAlert(
            'Update Error',
            'Oops! Something went wrong while updating your app',
          );
          log.error(err);
          dbProvider.logFailure(
              baseProvider.myUser.uid, FailType.AndroidInAppUpdateFailed, {
            'cause':
                'InAppUpdate did not work, ${err.toString().substring(0, 80)}'
          });
          BaseUtil.launchUrl(
              'https://play.google.com/store/apps/details?id=in.fello.felloapp');
        });
      }
    } catch (e) {
      BaseUtil.showNegativeAlert(
          'Update Error', 'Oops! Something went wrong while updating your app');
      log.error(e);
      dbProvider.logFailure(
          baseProvider.myUser.uid, FailType.AndroidInAppUpdateFailed, {
        'cause': 'InAppUpdate did not work, ${e.toString().substring(0, 80)}'
      });
      BaseUtil.launchUrl(
          'https://play.google.com/store/apps/details?id=in.fello.felloapp');
    }
  }
}
