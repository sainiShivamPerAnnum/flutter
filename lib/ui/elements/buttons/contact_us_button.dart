import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/ui/dialogs/contact_dialog.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactUsBtn extends StatelessWidget {
  BaseUtil baseProvider;
  DBModel reqProvider;

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    reqProvider = Provider.of<DBModel>(context, listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () => showDialog(
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
                        // reqProvider
                        //     .addCallbackRequest(
                        //         baseProvider.firebaseUser.uid,
                        //         baseProvider.myUser.name,
                        //         baseProvider.myUser.mobile)
                        //     .then((flag) {
                        //   if (flag) {
                        //     Navigator.of(context).pop();
                        //     baseProvider.showPositiveAlert(
                        //         'Callback placed!',
                        //         'We\'ll contact you soon on your registered mobile',
                        //         context);
                        //   }
                        // });
                      } else {
                        baseProvider.showNegativeAlert('Unavailable',
                            'Callbacks are reserved for active users', context);
                      }
                    },
                  )),
          child: Container(
            height: 50,
            width: _width * 0.5,
            margin: EdgeInsets.only(bottom: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              gradient: new LinearGradient(
                colors: [
                  UiConstants.primaryColor,
                  UiConstants.primaryColor.withGreen(900)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              "Contact Us",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }
}
