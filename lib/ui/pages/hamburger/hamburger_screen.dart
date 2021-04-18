import 'dart:ui';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/ui/dialogs/aboutus_dialog.dart';
import 'package:felloapp/ui/dialogs/feedback_dialog.dart';
import 'package:felloapp/ui/elements/confirm_action_dialog.dart';
import 'package:felloapp/ui/elements/contact_dialog.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HamburgerMenu extends StatelessWidget {
  static List<OptionDetail> _optionsList;
  BaseUtil baseProvider;
  DBModel reqProvider;

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    reqProvider = Provider.of<DBModel>(context, listen: false);
    _optionsList = _loadOptionsList();

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: dialogContent(context),
      ),
    );
  }

  dialogContent(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text(
            //   "Menu",
            //   style: GoogleFonts.montserrat(
            //     color: Colors.black,
            //     fontWeight: FontWeight.w700,
            //     fontSize: SizeConfig.largeTextSize,
            //   ),
            // ),
            // Divider(),
            Container(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(16.0),
                itemBuilder: /*1*/ (context, i) {
                  if (i.isOdd) return Divider();
                  /*2*/
                  final index = i ~/ 2; /*3*/
                  return _buildRow(_optionsList[index], context);
                },
                itemCount: _optionsList.length * 2,
              ),
            ),
            Container(
              width: SizeConfig.screenHeight * 0.1,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 2,
                    color: Colors.white,
                  )),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.cancel_rounded,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRow(OptionDetail option, BuildContext context) {
    return ListTile(
        title: Text(option.value,
            textAlign: TextAlign.center,
            style: (option.isEnabled)
                ? GoogleFonts.montserrat(
                    fontSize: 24.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w500)
                : TextStyle(fontSize: 18.0, color: Colors.grey[400])),
        onTap: () {
          HapticFeedback.vibrate();
          if (option.isEnabled) _routeOptionRequest(option.key, context);
        });
  }

  _routeOptionRequest(String key, BuildContext context) {
    switch (key) {
      case 'upAddress':
        {
          // if(BaseUtil.isDeviceOffline)
          //   baseProvider.showNoInternetAlert(context);
          // else
          //   Navigator.of(context).pushNamed('/updateAddress');
          break;
        }
      case 'abUs':
        {
          showDialog(
              context: context,
              builder: (BuildContext context) => AboutUsDialog());
          break;
        }
      case 'faq':
        {
          HapticFeedback.vibrate();
          Navigator.of(context).pushNamed('/faq');
          break;
        }
      case 'tnc':
        {
          HapticFeedback.vibrate();
          Navigator.of(context).pushNamed('/tnc');
          break;
        }
      case 'contUs':
        {
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
                        reqProvider
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
          break;
        }
      // case 'kyc':
      //   {
      //     HapticFeedback.vibrate();
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => KycOnboardController()),
      //     );
      //     break;
      //   }
      case 'signOut':
        {
          showDialog(
              context: context,
              builder: (BuildContext dialogContext) => ConfirmActionDialog(
                    title: 'Confirm',
                    description: 'Are you sure you want to sign out?',
                    buttonText: 'Yes',
                    confirmAction: () {
                      HapticFeedback.vibrate();
                      baseProvider.signOut().then((flag) {
                        if (flag) {
                          //log.debug('Sign out process complete');

                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Navigator.of(context)
                              .pushReplacementNamed('/launcher');
                          baseProvider.showPositiveAlert(
                              'Signed out', 'Hope to see you soon', context);
                        } else {
                          Navigator.of(context).pop();
                          baseProvider.showNegativeAlert('Sign out failed',
                              'Couldn\'t signout. Please try again', context);
                          //log.error('Sign out process failed');
                        }
                      });
                    },
                    cancelAction: () {
                      HapticFeedback.vibrate();
                      Navigator.of(context).pop();
                    },
                  ));
          break;
        }
      case 'fdbk':
        {
          showDialog(
            context: context,
            builder: (BuildContext context) => FeedbackDialog(
              title: "Tell us what you think",
              description: "We'd love to hear from you",
              buttonText: "Submit",
              dialogAction: (String fdbk) {
                if (fdbk != null && fdbk.isNotEmpty) {
                  //feedback submission allowed even if user not signed in
                  reqProvider
                      .submitFeedback(
                          (baseProvider.firebaseUser == null ||
                                  baseProvider.firebaseUser.uid == null)
                              ? 'UNKNOWN'
                              : baseProvider.firebaseUser.uid,
                          fdbk)
                      .then((flag) {
                    Navigator.of(context).pop();
                    if (flag) {
                      baseProvider.showPositiveAlert(
                          'Thank You', 'We appreciate your feedback!', context);
                    }
                  });
                }
              },
            ),
          );
        }
    }
  }

  List<OptionDetail> _loadOptionsList() {
    return [
      new OptionDetail(
          key: 'abUs', value: 'About ${Constants.APP_NAME}', isEnabled: true),
      new OptionDetail(key: 'fdbk', value: 'Feedback', isEnabled: true),
      new OptionDetail(key: 'faq', value: 'FAQs', isEnabled: true),
      new OptionDetail(key: 'contUs', value: 'Contact Us', isEnabled: true),
      new OptionDetail(
          key: 'signOut',
          value: 'Sign Out',
          isEnabled: (baseProvider.isSignedIn())),
      // new OptionDetail(key: 'tnc', value: 'Terms of Service', isEnabled: true),
      // new OptionDetail(key: 'refpolicy', value: 'Referral Policy', isEnabled: true),
    ];
  }
}

class OptionDetail {
  final String key;
  final String value;
  final bool isEnabled;
  OptionDetail({this.key, this.value, this.isEnabled});
}
