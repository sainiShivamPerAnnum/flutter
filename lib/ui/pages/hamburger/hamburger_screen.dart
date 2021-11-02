// import 'dart:ui';

// import 'package:felloapp/base_util.dart';
// import 'package:felloapp/core/ops/db_ops.dart';
// import 'package:felloapp/main.dart';
// import 'package:felloapp/navigator/app_state.dart';
// import 'package:felloapp/navigator/router/ui_pages.dart';
// import 'package:felloapp/ui/dialogs/confirm_action_dialog.dart';
// import 'package:felloapp/ui/dialogs/feedback_dialog.dart';
// import 'package:felloapp/util/constants.dart';
// import 'package:felloapp/util/haptic.dart';
// import 'package:felloapp/util/size_config.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';

// class HamburgerMenu extends StatelessWidget {
//   static List<OptionDetail> _optionsList;
//   BaseUtil baseProvider;
//   DBModel reqProvider;
//   AppState appstate;

//   @override
//   Widget build(BuildContext context) {
//     baseProvider = Provider.of<BaseUtil>(context, listen: false);
//     reqProvider = Provider.of<DBModel>(context, listen: false);
//     appstate = Provider.of<AppState>(context, listen: false);
//     _optionsList = _loadOptionsList();
//     return BackdropFilter(
//       filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
//       child: Dialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20.0),
//         ),
//         elevation: 0.0,
//         backgroundColor: Colors.transparent,
//         child: dialogContent(context),
//       ),
//     );
//   }

//   dialogContent(BuildContext context) {
//     return Container(
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               child: ListView.builder(
//                 shrinkWrap: true,
//                 padding: const EdgeInsets.all(16.0),
//                 itemBuilder: /*1*/ (context, i) {
//                   if (i.isOdd) return Divider();
//                   /*2*/
//                   final index = i ~/ 2; /*3*/
//                   return _buildRow(_optionsList[index], context);
//                 },
//                 itemCount: _optionsList.length * 2,
//               ),
//             ),
//             Container(
//               width: SizeConfig.screenHeight * 0.08,
//               padding: EdgeInsets.all(5),
//               decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(
//                     width: 2,
//                     color: Colors.white,
//                   )),
//               child: IconButton(
//                 onPressed: () {
//                   backButtonDispatcher.didPopRoute();
//                 },
//                 icon: Icon(
//                   Icons.close,
//                   color: Colors.white,
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildRow(OptionDetail option, BuildContext context) {
//     return ListTile(
//         title: Text(option.value,
//             textAlign: TextAlign.center,
//             style: (option.isEnabled)
//                 ? TextStyle(
//                     fontSize: SizeConfig.largeTextSize,
//                     color: Colors.white,
//                     fontWeight: FontWeight.w500)
//                 : TextStyle(fontSize: 18.0, color: Colors.grey[400])),
//         onTap: () {
//           Haptic.vibrate();
//           if (option.isEnabled) _routeOptionRequest(option.key, context);
//         });
//   }

//   _routeOptionRequest(String key, BuildContext context) {
//     switch (key) {
//       case 'abUs':
//         {
//           delegate.parseRoute(Uri.parse("d-aboutUs"));
//           break;
//         }
//       case 'supp':
//         {
//           appstate.currentAction =
//               PageAction(state: PageState.addPage, page: SupportPageConfig);
//           break;
//         }
//       case 'signOut':
//         {
//           AppState.screenStack.add(ScreenItem.dialog);
//           showDialog(
//             context: context,
//             builder: (BuildContext dialogContext) => WillPopScope(
//               onWillPop: () {
//                 backButtonDispatcher.didPopRoute();
//                 return Future.value(true);
//               },
//               child: ConfirmActionDialog(
//                 title: 'Confirm',
//                 description: 'Are you sure you want to sign out?',
//                 buttonText: 'Yes',
//                 confirmAction: () {
//                   Haptic.vibrate();
//                   baseProvider.signOut().then((flag) {
//                     if (flag) {
//                       //log.debug('Sign out process complete');
//                       backButtonDispatcher.didPopRoute();
//                       backButtonDispatcher.didPopRoute();
//                       appstate.currentAction = PageAction(
//                           state: PageState.replaceAll, page: SplashPageConfig);
//                       BaseUtil.showPositiveAlert(
//                           'Signed out', 'Hope to see you soon', context);
//                     } else {
//                       backButtonDispatcher.didPopRoute();
//                       BaseUtil.showNegativeAlert('Sign out failed',
//                           'Couldn\'t signout. Please try again', context);
//                       //log.error('Sign out process failed');
//                     }
//                   });
//                 },
//                 cancelAction: () {
//                   Haptic.vibrate();
//                   backButtonDispatcher.didPopRoute();
//                 },
//               ),
//             ),
//           );
//           break;
//         }
//       case 'fdbk':
//         {
//           AppState.screenStack.add(ScreenItem.dialog);
//           showDialog(
//             context: context,
//             builder: (BuildContext context) => WillPopScope(
//               onWillPop: () {
//                 backButtonDispatcher.didPopRoute();
//                 return Future.value(true);
//               },
//               child: FeedbackDialog(
//                 title: "Tell us what you think",
//                 description: "We'd love to hear from you",
//                 buttonText: "Submit",
//                 dialogAction: (String fdbk) {
//                   if (fdbk != null && fdbk.isNotEmpty) {
//                     //feedback submission allowed even if user not signed in
//                     reqProvider
//                         .submitFeedback(
//                             (baseProvider.firebaseUser == null ||
//                                     baseProvider.firebaseUser.uid == null)
//                                 ? 'UNKNOWN'
//                                 : baseProvider.firebaseUser.uid,
//                             fdbk)
//                         .then((flag) {
//                       backButtonDispatcher.didPopRoute();
//                       if (flag) {
//                         BaseUtil.showPositiveAlert('Thank You',
//                             'We appreciate your feedback!', context);
//                       }
//                     });
//                   }
//                 },
//               ),
//             ),
//           );
//         }
//     }
//   }

//   List<OptionDetail> _loadOptionsList() {
//     return [
//       new OptionDetail(
//           key: 'abUs', value: 'About ${Constants.APP_NAME}', isEnabled: true),
//       new OptionDetail(key: 'fdbk', value: 'Feedback', isEnabled: true),
//       // new OptionDetail(key: 'faq', value: 'FAQs', isEnabled: true),
//       new OptionDetail(key: 'supp', value: 'Support', isEnabled: true),
//       new OptionDetail(
//           key: 'signOut',
//           value: 'Sign Out',
//           isEnabled: (baseProvider.isSignedIn())),
//       // new OptionDetail(key: 'tnc', value: 'Terms of Service', isEnabled: true),
//       // new OptionDetail(key: 'refpolicy', value: 'Referral Policy', isEnabled: true),
//     ];
//   }
// }

// class OptionDetail {
//   final String key;
//   final String value;
//   final bool isEnabled;

//   OptionDetail({this.key, this.value, this.isEnabled});
// }
