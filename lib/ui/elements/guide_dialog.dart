import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/model/DailyPick.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/ui/elements/contact_dialog.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GuideDialog extends StatelessWidget {
  final Log log = new Log('GuideDialog');
  BaseUtil baseProvider;
  DBModel dbProvider;
  GuideDialog();

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    dbProvider = Provider.of<DBModel>(context, listen: false);
    return Dialog(
      insetPadding: EdgeInsets.only(left: 20, top: 50, bottom: 80, right: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.white,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
        overflow: Overflow.visible,
        alignment: Alignment.topCenter,
        children: <Widget>[
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
                padding:
                    EdgeInsets.only(top: 30, bottom: 40, left: 15, right: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Save.Grow.Win',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: UiConstants.primaryColor),
                    ),
                    Text(
                      'Fello is process -a',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          fontSize: 18,
                          height: 1.5,
                          fontWeight: FontWeight.w400,
                          color: UiConstants.accentColor),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      child: Image(
                        image: AssetImage(Assets.teachFello[0]),
                        fit: BoxFit.contain,
                      ),
                      width: 160,
                      height: 90,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Fello is bluh process b',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18,
                          height: 1.5,
                          fontWeight: FontWeight.w400,
                          color: UiConstants.accentColor),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      child: Image(
                        image: AssetImage(Assets.teachFello[1]),
                        fit: BoxFit.contain,
                      ),
                      width: 330,
                      height: 200,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Fello is bluh process-c',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          fontSize: 18,
                          height: 1.5,
                          fontWeight: FontWeight.w400,
                          color: UiConstants.accentColor),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      child: Image(
                        image: AssetImage(Assets.teachFello[2]),
                        fit: BoxFit.contain,
                      ),
                      width: 160,
                      height: 90,
                    ),
                    Text(
                      'Fello is bluh process d',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          fontSize: 18,
                          height: 1.5,
                          fontWeight: FontWeight.w400,
                          color: UiConstants.accentColor),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Still need help?',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          fontSize: 18,
                          height: 1.5,
                          fontWeight: FontWeight.w400,
                          color: UiConstants.accentColor),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 50,
                      height: 50.0,
                      decoration: BoxDecoration(
                        gradient: new LinearGradient(
                            colors: [
                              UiConstants.primaryColor,
                              UiConstants.primaryColor.withBlue(200),
                            ],
                            begin: Alignment(0.5, -1.0),
                            end: Alignment(0.5, 1.0)),
                        borderRadius: new BorderRadius.circular(10.0),
                      ),
                      child: Material(
                        child: MaterialButton(
                          child: Text(
                            'Contact Us',
                            style: Theme.of(context)
                                .textTheme
                                .button
                                .copyWith(color: Colors.white),
                          ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext dialogContext) => ContactUsDialog(
                                  isResident: (baseProvider.isSignedIn() &&
                                      baseProvider.isActiveUser()),
                                  isUnavailable: BaseUtil.isDeviceOffline,
                                  onClick: () {
                                    if (BaseUtil.isDeviceOffline) {
                                      baseProvider.showNoInternetAlert(context);
                                      return;
                                    }
                                    if (baseProvider.isSignedIn() &&
                                        baseProvider.isActiveUser()) {
                                      dbProvider
                                          .addCallbackRequest(
                                          baseProvider.firebaseUser.uid,
                                          baseProvider.myUser.name,
                                          baseProvider.myUser.mobile)
                                          .then((flag) {
                                        if (flag) {
                                          Navigator.of(context).pop();
                                          baseProvider.showPositiveAlert(
                                              'Callback placed!',
                                              'We\'ll contact you soon on your registered mobile',
                                              context);
                                        }
                                      });
                                    } else {
                                      baseProvider.showNegativeAlert('Unavailable',
                                          'Callbacks are reserved for active users', context);
                                    }
                                  },
                                ));
                          },
                          highlightColor: Colors.white30,
                          splashColor: Colors.white30,
                        ),
                        color: Colors.transparent,
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                    )
                  ],
                )),
          )
        ]);
  }
}
