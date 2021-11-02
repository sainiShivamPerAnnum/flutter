// import 'dart:async';

// import 'package:felloapp/base_util.dart';
// import 'package:felloapp/core/model/UserAugmontDetail.dart';
// import 'package:felloapp/core/ops/augmont_ops.dart';
// import 'package:felloapp/core/ops/db_ops.dart';
// import 'package:felloapp/core/ops/http_ops.dart';
// import 'package:felloapp/core/ops/icici_ops.dart';
// import 'package:felloapp/main.dart';
// import 'package:felloapp/navigator/app_state.dart';
// import 'package:felloapp/ui/dialogs/augmont_confirm_register_dialog.dart';
// import 'package:felloapp/ui/dialogs/augmont_regn_security_dialog.dart';
// import 'package:felloapp/ui/dialogs/more_info_dialog.dart';
// import 'package:felloapp/ui/pages/onboarding/icici/input-elements/input_field.dart';
// import 'package:felloapp/util/assets.dart';
// import 'package:felloapp/util/augmont_state_list.dart';
// import 'package:felloapp/util/fail_types.dart';
// import 'package:felloapp/util/haptic.dart';
// import 'package:felloapp/util/icici_api_util.dart';
// import 'package:felloapp/util/logger.dart';
// import 'package:felloapp/util/palettes.dart';
// import 'package:felloapp/util/size_config.dart';
// import 'package:felloapp/util/ui_constants.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:lottie/lottie.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';

// class AugmontOnboarding extends StatefulWidget {
//   AugmontOnboarding({Key key}) : super(key: key);

//   @override
//   State createState() => AugmontOnboardingState();
// }

// class AugmontOnboardingState extends State<AugmontOnboarding> {
//   final Log log = new Log('AugmontOnboarding');
//   BaseUtil baseProvider;
//   AugmontModel augmontProvider;
//   ICICIModel iProvider;
//   DBModel dbProvider;
//   HttpModel httpProvider;
//   AppState appState;
//   double _width;

//   static TextEditingController _panInput = new TextEditingController();
//   static TextEditingController _panHolderNameInput =
//       new TextEditingController();

//   // static TextEditingController _bankHolderNameInput =
//   //     new TextEditingController();
//   // static TextEditingController _bankAccountNumberInput =
//   //     new TextEditingController();
//   // static TextEditingController _reenterbankAccountNumberInput =
//   //     new TextEditingController();
//   // static TextEditingController _bankIfscInput = new TextEditingController();
//   bool _isInit = false;
//   static String stateChosenValue;

//   @override
//   Widget build(BuildContext context) {
//     _width = MediaQuery.of(context).size.width;
//     baseProvider = Provider.of<BaseUtil>(context, listen: false);
//     dbProvider = Provider.of<DBModel>(context, listen: false);
//     iProvider = Provider.of<ICICIModel>(context, listen: false);
//     augmontProvider = Provider.of<AugmontModel>(context, listen: false);
//     httpProvider = Provider.of<HttpModel>(context, listen: false);
//     appState = Provider.of<AppState>(context, listen: false);
//     if (!_isInit) {
//       _panInput.text = baseProvider.userRegdPan ?? '';
//       _isInit = true;
//     }
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//         title: Image(
//           image: AssetImage('images/aug-logo.png'),
//           height: SizeConfig.blockSizeVertical * 3,
//           fit: BoxFit.contain,
//         ),
//         shadowColor: augmontGoldPalette.primaryColor.withOpacity(0.5),
//         centerTitle: true,
//       ),
//       body: _bodyContent(context),
//     );
//   }

//   _bodyContent(BuildContext context) {
//     return Theme(
//       data: ThemeData.light().copyWith(
//         textTheme: GoogleFonts.montserratTextTheme(),
//         colorScheme:
//             ColorScheme.light(primary: augmontGoldPalette.primaryColor),
//       ),
//       child: Stack(alignment: Alignment.topCenter, children: <Widget>[
//         if (WidgetsBinding.instance.window.viewInsets.bottom == 0.0)
//           AugInfoTiles(),
//         Opacity(
//           child: _formContent(context),
//           opacity: (baseProvider.isAugmontRegnInProgress ||
//                   baseProvider.isAugmontRegnCompleteAnimateInProgress)
//               ? 0.3
//               : 1,
//         ),
//         // Row(
//         //   children: [
//         //     IconButton(
//         //       onPressed: () => backButtonDispatcher.didPopRoute(),
//         //       icon: Icon(Icons.arrow_back_rounded),
//         //     ),
//         //   ],
//         // ),
//         (baseProvider.isAugmontRegnCompleteAnimateInProgress)
//             ? Align(
//                 alignment: Alignment.center,
//                 child: Container(
//                   height: 100,
//                   width: 100,
//                   child: Lottie.asset(Assets.checkmarkLottie),
//                 ),
//               )
//             : Container(),
//         (baseProvider.isAugmontRegnInProgress)
//             ? Align(
//                 alignment: Alignment.center,
//                 child: Padding(
//                     padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Container(
//                             height: 4,
//                             width: double.infinity,
//                             child: LinearProgressIndicator(
//                               backgroundColor: Colors.blueGrey[200],
//                               valueColor: AlwaysStoppedAnimation(
//                                   augmontGoldPalette.primaryColor),
//                               minHeight: 4,
//                             )),
//                         Padding(
//                             padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
//                             child: Text(
//                               'Processing',
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                   color: UiConstants.accentColor, fontSize: 20),
//                             ))
//                       ],
//                     )),
//               )
//             : Container()
//       ]),
//     );
//   }

//   Widget _formContent(BuildContext context) {
//     return SingleChildScrollView(
//       physics: BouncingScrollPhysics(),
//       child: Padding(
//         padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 5),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: Text(
//                 'Digital Gold Registration',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.w700,
//                   color: augmontGoldPalette.primaryColor,
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 24,
//             ),

//             TextFormField(
//               decoration:
//                   augmontFieldInputDecoration(baseProvider.myUser.mobile),
//               enabled: false,
//             ),

//             SizedBox(height: 16),
//             TextFormField(
//               cursorColor: augmontGoldPalette.primaryColor,
//               decoration: augmontFieldInputDecoration("PAN Card Number"),
//               controller: _panInput,
//               autofocus: false,
//               textCapitalization: TextCapitalization.characters,
//               enabled: true,
//             ),

//             SizedBox(height: 16),

//             TextFormField(
//               decoration:
//                   augmontFieldInputDecoration('Your name as per your PAN Card'),
//               controller: _panHolderNameInput,
//               keyboardType: TextInputType.name,
//               textCapitalization: TextCapitalization.characters,
//               enabled: true,
//               autofocus: false,
//               validator: (value) {
//                 return null;
//               },
//             ),
//             SizedBox(height: 16),
//             // Padding(
//             //   padding: EdgeInsets.only(left: 10),
//             //   child: Text("Residential State"),
//             // ),
//             Container(
//               padding: EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 4,
//               ),
//               decoration: BoxDecoration(
//                 border: Border.all(color: augmontGoldPalette.primaryColor),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: DropdownButtonFormField(
//                 decoration: InputDecoration(
//                   border: InputBorder.none,
//                 ),
//                 menuMaxHeight: SizeConfig.screenHeight * 0.5,
//                 iconEnabledColor: augmontGoldPalette.primaryColor,
//                 hint: Text("Which state do you live in?"),
//                 value: stateChosenValue,
//                 onChanged: (String newVal) {
//                   setState(() {
//                     stateChosenValue = newVal;
//                     print(newVal);
//                   });
//                 },
//                 items: AugmontResources.augmontStateList
//                     .map(
//                       (e) => DropdownMenuItem(
//                         value: e["id"],
//                         child: Text(
//                           e["name"],
//                         ),
//                       ),
//                     )
//                     .toList(),
//               ),
//             ),

//             SizedBox(height: 24),
//             Container(
//               width: SizeConfig.screenWidth,
//               height: 50.0,
//               decoration: BoxDecoration(
//                 gradient: new LinearGradient(colors: [
//                   augmontGoldPalette.primaryColor,
//                   augmontGoldPalette.primaryColor2
//                   // UiConstants.primaryColor,
//                   // UiConstants.primaryColor.withBlue(200),
//                 ], begin: Alignment(0.5, -1.0), end: Alignment(0.5, 1.0)),
//                 borderRadius: new BorderRadius.circular(10.0),
//               ),
//               child: new Material(
//                 child: MaterialButton(
//                   child: (!baseProvider.isAugmontRegnInProgress &&
//                           !baseProvider.isAugmontRegnCompleteAnimateInProgress)
//                       ? Text(
//                           'REGISTER',
//                           style: Theme.of(context)
//                               .textTheme
//                               .button
//                               .copyWith(color: Colors.white),
//                         )
//                       : SpinKitThreeBounce(
//                           color: UiConstants.spinnerColor2,
//                           size: 18.0,
//                         ),
//                   onPressed: () async {
//                     ///check if all fields are valid
//                     if (_preVerifyInputs()) {
//                       baseProvider.isAugmontRegnInProgress = true;
//                       setState(() {});

//                       ///next get all details required for registration
//                       Map<String, dynamic> veriDetails =
//                           await _getVerifiedDetails(
//                               _panInput.text, _panHolderNameInput.text);
//                       //  _bankIfscInput.text);

//                       if (veriDetails != null &&
//                           veriDetails['flag'] != null &&
//                           veriDetails['flag']) {
//                         AppState.screenStack.add(ScreenItem.dialog);

//                         ///show confirmation dialog to user
//                         showDialog(
//                           context: context,
//                           barrierDismissible: false,
//                           builder: (BuildContext context) =>
//                               AugmontConfirmRegnDialog(
//                             panNumber: _panInput.text,
//                             panName: _panHolderNameInput.text,
//                             bankHolderName: "",
//                             bankBranchName: "",
//                             bankAccNo: "",
//                             bankIfsc: "",
//                             bankName: "",
//                             dialogColor: augmontGoldPalette.primaryColor2,
//                             onAccept: () async {
//                               ///finally now register the augmont user
//                               UserAugmontDetail detail =
//                                   await augmontProvider.createUser(
//                                       baseProvider.myUser.mobile,
//                                       _panInput.text,
//                                       stateChosenValue,
//                                       "",
//                                       "",
//                                       "");
//                               if (detail == null) {
//                                 BaseUtil.showNegativeAlert(
//                                     'Registration Failed',
//                                     'Failed to regsiter at the moment. Please try again.',
//                                     context);
//                                 baseProvider.isAugmontRegnInProgress = false;
//                                 setState(() {});
//                                 return;
//                               } else {
//                                 ///show completion animation
//                                 _regnComplete();
//                               }
//                             },
//                             onReject: () {
//                               BaseUtil.showNegativeAlert(
//                                   'Registration Cancelled',
//                                   'Please try again',
//                                   context);
//                               baseProvider.isAugmontRegnInProgress = false;
//                               setState(() {});
//                               return;
//                             },
//                           ),
//                         );
//                       } else {
//                         print('inside failed name');
//                         if (veriDetails['fail_code'] == 0)
//                           showDialog(
//                               context: context,
//                               builder: (BuildContext context) => MoreInfoDialog(
//                                     text: veriDetails['reason'],
//                                     imagePath: Assets.dummyPanCardShowNumber,
//                                     title: 'Invalid Details',
//                                   ));
//                         else
//                           BaseUtil.showNegativeAlert(
//                               'Registration failed',
//                               veriDetails['reason'] ?? 'Please try again',
//                               context);
//                         baseProvider.isAugmontRegnInProgress = false;
//                         setState(() {});
//                         return;
//                       }
//                     } else
//                       return;
//                   },
//                   highlightColor: Colors.white30,
//                   splashColor: Colors.white30,
//                 ),
//                 color: Colors.transparent,
//                 borderRadius: new BorderRadius.circular(30.0),
//               ),
//             ),
//             SizedBox(
//               height: 30,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   bool _preVerifyInputs() {
//     RegExp panCheck = RegExp(r"[A-Z]{5}[0-9]{4}[A-Z]{1}");
//     if (_panInput.text.isEmpty) {
//       BaseUtil.showNegativeAlert(
//           'Invalid Pan', 'Kindly enter a valid PAN Number', context);
//       return false;
//     } else if (!panCheck.hasMatch(_panInput.text) ||
//         _panInput.text.length != 10) {
//       BaseUtil.showNegativeAlert(
//           'Invalid Pan', 'Kindly enter a valid PAN Number', context);
//       return false;
//     } else if (_panHolderNameInput.text.isEmpty) {
//       BaseUtil.showNegativeAlert('Name missing',
//           'Kindly enter your name as per your pan card', context);
//       return false;
//     } else if (stateChosenValue == null || stateChosenValue.isEmpty) {
//       BaseUtil.showNegativeAlert('State missing',
//           'Kindly enter your current residential state', context);
//       return false;
//     }
//     // else if (_bankHolderNameInput.text.isEmpty) {
//     //   BaseUtil.showNegativeAlert(
//     //       'Name missing', 'Kindly enter your name as per your bank', context);
//     //   return false;
//     // } else if (_bankAccountNumberInput.text.isEmpty) {
//     //   BaseUtil.showNegativeAlert(
//     //       'Account missing', 'Kindly enter your bank account number', context);
//     //   return false;
//     // } else if (_bankAccountNumberInput.text !=
//     //     _reenterbankAccountNumberInput.text) {
//     //   BaseUtil.showNegativeAlert('Account number mismatch',
//     //       'The bank account numbers did not match', context);
//     //   return false;
//     // } else if (_bankIfscInput.text.isEmpty) {
//     //   BaseUtil.showNegativeAlert(
//     //       'Name missing', 'Kindly enter your bank IFSC code', context);
//     //   return false;
//     // }
//     return true;
//   }

//   Future<Map<String, dynamic>> _getVerifiedDetails(
//       String enteredPan, String enteredPanName) async {
//     if (enteredPan == null || enteredPan.isEmpty)
//       return {'flag': false, 'reason': 'Invalid Details'};
//     bool _flag = true;
//     int _failCode = 0;
//     String _reason = '';
//     if (!iProvider.isInit()) await iProvider.init();

//     bool registeredFlag = await httpProvider.isPanRegistered(enteredPan);
//     if (registeredFlag) {
//       _flag = false;
//       _failCode = 1;
//       _reason =
//           'This PAN number is already associated with a different account';
//     }
//     var kObj;
//     if (_flag) {
//       ///test pan number using icici api and verify if the name entered by user matches name fetched
//       kObj = await iProvider.getKycStatus(enteredPan);
//       if (kObj == null ||
//           kObj[QUERY_SUCCESS_FLAG] == QUERY_FAILED ||
//           kObj[GetKycStatus.resStatus] == null ||
//           kObj[GetKycStatus.resName] == null ||
//           kObj[GetKycStatus.resName] == '') {
//         log.error('Couldnt fetch an appropriate response');

//         ///set name test to true as we couldnt find it in the cams database
//         _flag = true;
//       } else {
//         ///remove all whitespaces before comparing as icici apis returns poorly spaced name values
//         String recvdPanName = kObj[GetKycStatus.resName];
//         String _r = recvdPanName.replaceAll(new RegExp(r"\s"), "");
//         String _e = enteredPanName.replaceAll(new RegExp(r"\s"), "");
//         if (_r.toUpperCase() != _e.toUpperCase()) {
//           await dbProvider.logFailure(
//               baseProvider.myUser.uid, FailType.UserAugmontRegnFailed, {
//             'entered_pan_name': enteredPanName,
//             'recvd_pan_name': recvdPanName,
//             'pan_number': enteredPan
//           });
//           _flag = false;
//           _reason =
//               'The name on your PAN card does not match with the entered name. Please try again.';
//           _failCode = 0;
//         }
//       }
//     }
//     if (!_flag) {
//       print('returning false flag');
//       return {'flag': _flag, 'fail_code': _failCode, 'reason': _reason};
//     }

//     ///test ifsc code using icici api
//     // var bankDetail = await iProvider.getBankInfo(aPan, aIfsc);
//     // if (bankDetail == null ||
//     //     bankDetail[QUERY_SUCCESS_FLAG] == QUERY_FAILED ||
//     //     bankDetail[GetBankDetail.resBankName] == null) {
//     //   log.error('Couldnt fetch an appropriate response');
//     //   _flag = false;
//     //   _reason = 'Invalid IFSC Code';
//     // }
//     // if (!_flag) {
//     //   return {'flag': _flag, 'reason': _reason};
//     // }

//     return {
//       'flag': true,
//       'pan_name': kObj[GetKycStatus.resName],
//       // 'bank_name': bankDetail[GetBankDetail.resBankName],
//       // 'bank_branch': bankDetail[GetBankDetail.resBranchName]
//     };
//   }

//   _regnComplete() {
//     baseProvider.isAugmontRegnInProgress = false;
//     baseProvider.isAugmontRegnCompleteAnimateInProgress = true;
//     setState(() {});
//     new Timer(const Duration(milliseconds: 1000), () {
//       baseProvider.isAugmontRegnCompleteAnimateInProgress = false;
//       setState(() {});
//       backButtonDispatcher.didPopRoute();
//       BaseUtil.showPositiveAlert(
//           'Registration Successful', 'You can now make a deposit!', context);
//     });
//   }
// }

// class AugInfoTiles extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     BaseUtil baseProvider = Provider.of<BaseUtil>(context, listen: false);
//     return Positioned(
//       bottom: 0,
//       child: Container(
//         width: SizeConfig.screenWidth,
//         padding: EdgeInsets.symmetric(vertical: 10),
//         child: IntrinsicHeight(
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               TextButton.icon(
//                 icon: Text("🔒"),
//                 onPressed: () {
//                   Haptic.vibrate();
//                   showDialog(
//                       context: context,
//                       builder: (BuildContext context) =>
//                           AugmontRegnSecurityDialog(
//                             text: Assets.infoAugmontRegnSecurity,
//                             imagePath: 'images/aes256.png',
//                             title: 'Security > Rest',
//                           ));
//                 },
//                 label: Text(
//                   'Note on Security',
//                   style: TextStyle(
//                       fontSize: SizeConfig.smallTextSize * 1.3,
//                       decoration: TextDecoration.underline,
//                       color:
//                           augmontGoldPalette.secondaryColor.withOpacity(0.8)),
//                 ),
//               ),
//               VerticalDivider(
//                 color: Colors.black45,
//               ),
//               TextButton.icon(
//                 icon: Text("💰"),
//                 onPressed: () async {
//                   Haptic.vibrate();
//                   const url = "https://www.augmont.com/about-us";
//                   if (await canLaunch(url))
//                     await launch(url);
//                   else
//                     BaseUtil.showNegativeAlert('Failed to launch URL',
//                         'Please try again in sometime', context);
//                 },
//                 label: Text(
//                   'More about Augmont',
//                   style: TextStyle(
//                       fontSize: SizeConfig.smallTextSize * 1.3,
//                       decoration: TextDecoration.underline,
//                       color:
//                           augmontGoldPalette.secondaryColor.withOpacity(0.8)),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
