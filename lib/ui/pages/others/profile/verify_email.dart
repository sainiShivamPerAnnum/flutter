import 'dart:async';
import 'dart:math' as math;

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/ops/https/http_ops.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/elements/pin_input_custom_text_field.dart';
import 'package:felloapp/ui/pages/static/fello_appbar.dart';
import 'package:felloapp/ui/pages/static/home_background.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class VerifyEmail extends StatefulWidget {
  static const int index = 3;

  VerifyEmail({Key key}) : super(key: key);

  @override
  VerifyEmailState createState() => VerifyEmailState();
}

class VerifyEmailState extends State<VerifyEmail> {
  TextEditingController email = new TextEditingController();
  TextEditingController otp = new TextEditingController();
  final formKey = GlobalKey<FormState>();
  Timer timer;
  bool isGmailVerifying = false;
  BaseUtil baseProvider;
  DBModel dbProvider;
  String generatedOTP;
  HttpModel httpProvider;
  bool _isContinueWithGoogle = false;
  bool _isGoogleLoginInProcess = false;
  bool _isOtpSent = false;
  bool _isProcessing = false;
  bool _isVerifying = false;
  bool _isEmailEnabled = false;
  bool _isSessionExpired = false;
  bool _isOtpIncorrect = false;

  @override
  void initState() {
    email = TextEditingController(text: "1000");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      showEmailOptions();
    });
    super.initState();
  }

  @override
  void dispose() {
    if (timer != null) timer.cancel();
    print("disposed");
    super.dispose();
  }

  showEmailOptions() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        isDismissible: false,
        context: context,
        builder: (ctx) {
          return Wrap(
            children: [
              Container(
                decoration: BoxDecoration(),
                padding: EdgeInsets.all(
                  SizeConfig.blockSizeHorizontal * 5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Verification option",
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w700,
                            fontSize: 24,
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.close),
                          iconSize: 30,
                          onPressed: () =>
                              AppState.backButtonDispatcher.didPopRoute(),
                        ),
                      ],
                    ),
                    Divider(
                      height: 32,
                      thickness: 2,
                    ),
                    ListTile(
                      leading: SvgPicture.asset(
                        "images/svgs/google.svg",
                        height: 24,
                        width: 24,
                      ),
                      title: Text("Choose a Google account"),
                      subtitle: Text(""),
                      onTap: verifyGmail,
                      trailing: _isGoogleLoginInProcess
                          ? CircularProgressIndicator()
                          : SizedBox(),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(
                        Icons.alternate_email,
                        color: UiConstants.primaryColor,
                      ),
                      title: Text("Receive an OTP on your email"),
                      onTap: () {
                        setState(() {
                          _isGoogleLoginInProcess = false;
                          _isContinueWithGoogle = false;
                          email.text = baseProvider.myUser.email;
                          _isEmailEnabled = true;
                        });
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(
                      height: 24,
                    )
                  ],
                ),
                width: double.infinity,
              ),
            ],
          );
        });
  }

  generateOtp() {
    setState(() {
      _isProcessing = true;
    });
    var rnd = new math.Random();
    var next = rnd.nextDouble() * 1000000;
    while (next < 100000) {
      next *= 10;
    }
    generatedOTP = next.toInt().toString();
    print(generatedOTP);
    sendEmail();
  }

  sendEmail() async {
    if (!await httpProvider.isEmailNotRegistered(
        baseProvider.myUser.uid, email.text.trim())) {
      setState(() {
        _isProcessing = false;
      });
      BaseUtil.showNegativeAlert(
        "Email already registered",
        "Please try with another email",
      );

      return;
    }

    if (formKey.currentState.validate()) {
      dbProvider
          .sendEmailToVerifyEmail(email.text.trim(), generatedOTP)
          .then((res) {
        if (res) {
          setState(() {
            _isOtpSent = true;
            _isProcessing = false;
          });
        } else {
          setState(() {
            _isProcessing = false;
          });
          BaseUtil.showNegativeAlert(
            "Verification failed",
            "Email cannot be verified at the moment, please try again in sometime.",
          );
        }
      });
    }
  }

  verifyOtp() async {
    setState(() {
      _isOtpIncorrect = false;
      _isVerifying = true;
    });
    if (generatedOTP == otp.text) {
      baseProvider.setEmail(email.text.trim());
      baseProvider.setEmailVerified();
      bool res = await dbProvider.updateUser(baseProvider.myUser);
      setState(() {
        _isVerifying = false;
      });
      if (res) {
        BaseUtil.showPositiveAlert(
            "Email verified", "Thank you for verifying your email");
        AppState.backButtonDispatcher.didPopRoute();
      } else {
        BaseUtil.showNegativeAlert(
          "Email verification failed",
          "Please try again in sometime",
        );
      }
    } else {
      setState(() {
        _isOtpIncorrect = true;
        _isVerifying = false;
      });
    }
  }

  verifyGmail() async {
    setState(() {
      _isGoogleLoginInProcess = true;
    });
    final _gSignIn = GoogleSignIn();
    try {
      if (await _gSignIn.isSignedIn()) await _gSignIn.signOut();
      print('Signed out');
    } catch (e) {
      print('Failed to signout: $e');
    }
    final GoogleSignInAccount googleUser = await _gSignIn.signIn();
    if (googleUser != null) {
      if (await httpProvider.isEmailNotRegistered(
          baseProvider.myUser.uid, googleUser.email)) {
        email.text = googleUser.email;
        baseProvider.myUser.email = googleUser.email;
        baseProvider.setEmailVerified();
        bool res = await dbProvider.updateUser(baseProvider.myUser);
        if (res) {
          setState(() {
            _isGoogleLoginInProcess = false;
          });
          BaseUtil.showPositiveAlert("Success", "Email Verified successfully");
          Navigator.pop(context);
          AppState.backButtonDispatcher.didPopRoute();
        } else {
          _isGoogleLoginInProcess = false;
          BaseUtil.showNegativeAlert(
            "Oops! we ran into problem",
            "Email cannot be verified at the moment",
          );
        }
      } else {
        _isGoogleLoginInProcess = false;
        BaseUtil.showNegativeAlert(
          "Email already registered",
          "Please try with another email",
        );
      }
    } else {
      _isGoogleLoginInProcess = false;
      BaseUtil.showNegativeAlert(
        "No account selected",
        "Please choose an account from the list",
      );
    }
    setState(() {});
  }

  confirmAction() async {
    if (!_isVerifying && !_isProcessing) {
      if (_isOtpSent)
        verifyOtp();
      else
        generateOtp();
    }
  }

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    dbProvider = Provider.of<DBModel>(context, listen: false);
    httpProvider = Provider.of<HttpModel>(context, listen: false);
    return Scaffold(
      body: HomeBackground(
        child: Column(
          children: [
            FelloAppBar(
              leading: FelloAppBarBackButton(),
              title: "Verify Email",
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
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(
                          0,
                          0,
                          0,
                          math.min(MediaQuery.of(context).viewInsets.bottom,
                              SizeConfig.screenHeight * 0.09)),
                      width: SizeConfig.screenWidth,
                      // height: SizeConfig.screenHeight,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          //crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: kToolbarHeight,
                            ),
                            Text(
                              "Complete verification",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: SizeConfig.cardTitleTextSize),
                            ),
                            SizedBox(
                              height: 24,
                            ),
                            Text(
                                "Please enter the email where you'd like to receive all transaction related updates"),
                            Form(
                              key: formKey,
                              child: Container(
                                padding: EdgeInsets.only(top: 30, bottom: 10),
                                child: TextFormField(
                                  controller: email,
                                  enabled: _isProcessing || _isOtpSent
                                      ? false
                                      : true,
                                  cursorColor: Colors.black,
                                  keyboardType: TextInputType.text,
                                  validator: (val) {
                                    if (val == "")
                                      return null;
                                    else if (val == null)
                                      return "Please enter an email";
                                    else if (!RegExp(
                                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                        .hasMatch(val)) {
                                      return "Enter a valid email";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.email_rounded),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 24),
                              child: Text((!_isOtpSent)
                                  ? "We will send you a 6 digit code on this email."
                                  : "Please check your inbox folders for the code"),
                            ),
                            SizedBox(
                              height: 24,
                            ),
                            _isProcessing
                                ? Container(
                                    width: SizeConfig.screenWidth,
                                    alignment: Alignment.center,
                                    child: Column(
                                      children: [
                                        CircularProgressIndicator(),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Text("Sending OTP")
                                      ],
                                    ),
                                  )
                                : SizedBox(),
                            _isOtpSent
                                ? Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Enter the OTP",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize:
                                                  SizeConfig.cardTitleTextSize),
                                        ),
                                        SizedBox(
                                          height: 24,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 18.0, 0, 18.0),
                                          child: PinInputTextField(
                                            autoFocus: true,
                                            pinLength: 6,
                                            decoration: BoxLooseDecoration(
                                              enteredColor:
                                                  UiConstants.primaryColor,
                                              solidColor: UiConstants
                                                  .primaryColor
                                                  .withOpacity(0.04),
                                              strokeColor:
                                                  UiConstants.primaryColor,
                                              strokeWidth: 1,
                                              textStyle: GoogleFonts.montserrat(
                                                  fontSize: 20,
                                                  color: Colors.black),
                                            ),
                                            controller: otp,
                                            onChanged: (value) {
                                              print(value);
                                              if (value.length == 6) {
                                                verifyOtp();
                                              } else {
                                                setState(() {
                                                  _isOtpIncorrect = false;
                                                });
                                              }
                                            },
                                            onSubmit: (pin) {
                                              print("Pressed submit for pin: " +
                                                  pin.toString() +
                                                  "\n  No action taken.");
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          height: 24,
                                        ),
                                        Row(
                                          children: [
                                            Text("OTP is only valid for "),
                                            TweenAnimationBuilder<Duration>(
                                                duration: Duration(minutes: 15),
                                                tween: Tween(
                                                    begin:
                                                        Duration(minutes: 15),
                                                    end: Duration.zero),
                                                onEnd: () {
                                                  print('Timer ended');
                                                  BaseUtil.showNegativeAlert(
                                                    "Session Expired!",
                                                    "Please try again",
                                                  );
                                                  AppState.backButtonDispatcher
                                                      .didPopRoute();
                                                },
                                                builder: (BuildContext context,
                                                    Duration value,
                                                    Widget child) {
                                                  final minutes =
                                                      value.inMinutes;
                                                  final seconds =
                                                      value.inSeconds % 60;
                                                  return Text(
                                                    '$minutes:$seconds',
                                                    style: TextStyle(
                                                      color: UiConstants
                                                          .primaryColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  );
                                                }),
                                            // Text(
                                            //   "15:00",
                                            //   style: TextStyle(
                                            //     color: UiConstants.primaryColor,
                                            //     fontWeight: FontWeight.w700,
                                            //   ),
                                            // ),
                                            Text("  minutes.")
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                : SizedBox(),
                            _isOtpIncorrect
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "OTP is incorrect,please try again",
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : SizedBox(),
                            SizedBox(
                              height: SizeConfig.screenHeight * 0.2,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SafeArea(
                        child: InkWell(
                          onTap: confirmAction,
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 24),
                            width: SizeConfig.screenWidth -
                                SizeConfig.pageHorizontalMargins * 2,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: UiConstants.primaryColor,
                            ),
                            alignment: Alignment.center,
                            child: _isVerifying || _isProcessing
                                ? SpinKitThreeBounce(
                                    color: UiConstants.spinnerColor2,
                                    size: 18.0,
                                  )
                                : Text(
                                    _isOtpSent ? "Verify" : "Send OTP",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: SizeConfig.mediumTextSize,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
