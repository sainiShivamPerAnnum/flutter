// import 'dart:developer';

// import 'package:felloapp/base_util.dart';
// import 'package:felloapp/core/enums/screen_item_enum.dart';
// import 'package:felloapp/core/service/paytm_service.dart';
// import 'package:felloapp/navigator/app_state.dart';
// import 'package:felloapp/ui/pages/static/fello_appbar.dart';
// import 'package:felloapp/ui/widgets/buttons/fello_button/large_button.dart';
// import 'package:felloapp/util/custom_logger.dart';
// import 'package:felloapp/util/haptic.dart';
// import 'package:felloapp/util/locator.dart';
// import 'package:felloapp/util/styles/size_config.dart';
// import 'package:felloapp/util/styles/textStyles.dart';
// import 'package:felloapp/util/styles/ui_constants.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:shimmer_animation/shimmer_animation.dart';

// class CustomSubscriptionModal extends StatefulWidget {
//   @override
//   State<CustomSubscriptionModal> createState() =>
//       _CustomSubscriptionModalState();
// }

// class _CustomSubscriptionModalState extends State<CustomSubscriptionModal> {
//   final _paytmService = locator<PaytmService>();
//   final _logger = locator<CustomLogger>();

//   bool _isSubscriptionInProgress = false;

//   bool _isLoaderUiInView = false;

//   get isLoaderUiInView => this._isLoaderUiInView;

//   set isLoaderUiInView(bool value) {
//     setState(() {
//       this._isLoaderUiInView = value;
//     });
//   }

//   TextEditingController vpaController =
//       new TextEditingController(text: "7777777777");
//   bool get isSubscriptionInProgress => this._isSubscriptionInProgress;

//   set isSubscriptionInProgress(bool value) {
//     setState(() {
//       this._isSubscriptionInProgress = value;
//     });
//   }

//   initiateCustomSubscription() async {
//     isSubscriptionInProgress = true;
//     PaytmResponse response =
//         await _paytmService.initiateCustomSubscription(vpaController.text);
//     isSubscriptionInProgress = false;
//     if (response.status)
//       updateModelUiToLoader(response);
//     else
//       switch (response.errorCode) {
//         case INVALID_VPA_DETECTED:
//           BaseUtil.showNegativeAlert(
//             response.reason,
//             'Please enter a valid vpa address',
//           );
//           break;
//         default:
//           BaseUtil.showNegativeAlert(
//             response.reason,
//             'Please try again',
//           );
//           break;
//       }
//   }

//   updateModelUiToLoader(PaytmResponse response) {
//     _logger.d(response.reason);
//     AppState.screenStack.removeLast();
//     AppState.screenStack.add(ScreenItem.loader);
//     isLoaderUiInView = true;
//     Future.delayed(Duration(seconds: 30), () {
//       AppState.screenStack.removeLast();
//       AppState.screenStack.add(ScreenItem.dialog);
//       AppState.backButtonDispatcher.didPopRoute();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.all(SizeConfig.pageHorizontalMargins),
//       child: isLoaderUiInView
//           ? Wrap(
//               children: [
//                 Center(
//                   child: SpinKitThreeBounce(
//                     color: UiConstants.primaryColor,
//                     size: SizeConfig.padding40,
//                   ),
//                 ),
//               ],
//             )
//           : Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   padding: EdgeInsets.only(bottom: SizeConfig.padding12),
//                   child: Row(
//                     children: [
//                       Text(
//                         "Setup UPI AutoSave",
//                         textAlign: TextAlign.center,
//                         style: TextStyles.title3.bold
//                             .colour(UiConstants.primaryColor),
//                       ),
//                       Spacer(),
//                       CircleAvatar(
//                         backgroundColor: Colors.black,
//                         child: IconButton(
//                           onPressed: () {
//                             AppState.backButtonDispatcher.didPopRoute();
//                           },
//                           icon: Icon(
//                             Icons.close,
//                             size: SizeConfig.iconSize1,
//                             color: Colors.white,
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//                 TextFieldLabel("Enter your UPI Id"),
//                 TextField(
//                   controller: vpaController,
//                   autofocus: true,
//                   decoration:
//                       InputDecoration(hintText: "Enter your upi address"),
//                 ),
//                 SizedBox(
//                   height: SizeConfig.padding16,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     upichips('@paytm'),
//                     upichips('@apl'),
//                     upichips('@fbl'),
//                     upichips('@okicici'),
//                     upichips('@okhdfc'),
//                   ],
//                 ),
//                 SizedBox(
//                   height: SizeConfig.padding24,
//                 ),
//                 FelloButtonLg(
//                   child: isSubscriptionInProgress
//                       ? SpinKitThreeBounce(
//                           color: Colors.white,
//                           size: 20,
//                         )
//                       : Text(
//                           "SUBSCRIBE",
//                           style: TextStyles.body2.colour(Colors.white).bold,
//                         ),
//                   onPressed: () async {
//                     initiateCustomSubscription();
//                     FocusScope.of(context).unfocus();
//                   },
//                 ),
//                 SizedBox(height: SizeConfig.padding16),
//                 RichText(
//                   text: new TextSpan(
//                     children: [
//                       new TextSpan(
//                         text: 'Does your bank supports Autosave? ',
//                         style: TextStyles.body3.colour(Colors.black45),
//                       ),
//                       new TextSpan(
//                         text: 'Check here',
//                         style: TextStyles.body3
//                             .colour(UiConstants.primaryColor)
//                             .bold,
//                         recognizer: new TapGestureRecognizer()
//                           ..onTap = () {
//                             Haptic.vibrate();
//                             BaseUtil.launchUrl(
//                                 'https://www.npci.org.in/what-we-do/autosave/list-of-banks-and-apps-live-on-autosave');
//                           },
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: MediaQuery.of(context).viewInsets.bottom)
//               ],
//             ),
//     );
//   }

//   upichips(String suffix) {
//     return InkWell(
//       onTap: () {
//         vpaController.text =
//             vpaController.text.trim().split('@').first + suffix;
//       },
//       child: Chip(label: Text(suffix)),
//     );
//   }
// }
