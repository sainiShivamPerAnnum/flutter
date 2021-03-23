
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/ui/elements/aboutus_dialog.dart';
import 'package:felloapp/ui/elements/confirm_action_dialog.dart';
import 'package:felloapp/ui/elements/contact_dialog.dart';
import 'package:felloapp/ui/elements/feedback_dialog.dart';
import 'package:felloapp/ui/pages/edit_profile_page.dart';
import 'package:felloapp/ui/pages/onboarding/kyc/kyc_onboarding_controller.dart';
import 'package:felloapp/ui/pages/root.dart';
import 'package:felloapp/util/constants.dart';
import 'package:felloapp/util/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({this.onPush});
  final ValueChanged<String> onPush;
  @override
  State createState() {
    return _OptionsList(onPush: onPush);
  }
}

class _OptionsList extends State<SettingsPage> {
  _OptionsList({this.onPush});
  final ValueChanged<String> onPush;
  Log log = new Log('SettingsPage');
  BaseUtil baseProvider;
  DBModel reqProvider;
  static List<OptionDetail> _optionsList;

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context,listen:false);
    reqProvider = Provider.of<DBModel>(context,listen:false);
    _optionsList = _loadOptionsList();
    return new Scaffold(
        appBar: BaseUtil.getAppBar(),
        bottomSheet: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 5),
              child: InkWell(
                child: Text(
                  'Terms of Service',
                  style: TextStyle(
                      color: Colors.grey, decoration: TextDecoration.underline),
                ),
                onTap: () {
                  HapticFeedback.vibrate();
                  Navigator.of(context).pushNamed('/tnc');
                },
              ),
            ),
            Text(
              '•',
              style: TextStyle(color: Colors.grey),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 5),
              child: InkWell(
                child: Text(
                  'Referral Policy',
                  style: TextStyle(
                      color: Colors.grey, decoration: TextDecoration.underline),
                ),
                onTap: () {
                  HapticFeedback.vibrate();
                  Navigator.of(context).pushNamed('/refpolicy');
                },
              ),
            )
          ],
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemBuilder: /*1*/ (context, i) {
            if (i.isOdd) return Divider(); /*2*/
            final index = i ~/ 2; /*3*/
            return _buildRow(_optionsList[index]);
          },
          itemCount: _optionsList.length * 2,
        ));
  }

  Widget _buildRow(OptionDetail option) {
    return ListTile(
        title: Text(option.value,
            style: (option.isEnabled)
                ? TextStyle(fontSize: 18.0, color: Colors.black)
                : TextStyle(fontSize: 18.0, color: Colors.grey[400])),
        onTap: () {
          HapticFeedback.vibrate();
          if (option.isEnabled) _routeOptionRequest(option.key);
        });
  }

  _routeOptionRequest(String key) {
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
      case 'editProf':
        {
          HapticFeedback.lightImpact();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditProfile()),
          );
          break;
        }
      case 'ui2':
        {
          HapticFeedback.vibrate();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Root()),
          );
          break;
        }
      case 'kyc':
        {
          HapticFeedback.vibrate();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => KycOnboardController()),
          );
          break;
        }
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
                          log.debug('Sign out process complete');
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
                          log.error('Sign out process failed');
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
          HapticFeedback.lightImpact();
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
                    if (flag) {
                      baseProvider.showPositiveAlert(
                          'Thank You', 'We appreciate your feedback!', context);
                    }
                  });
                  Navigator.of(context).pop();
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
      new OptionDetail(
          key: 'editProf', value: 'Update Details', isEnabled: true),
      // new OptionDetail(key: 'kyc', value: 'KYC',isEnabled: true),
      new OptionDetail(key: "ui2", value: "UI 2.0", isEnabled: true),
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
