import 'dart:async';
import 'dart:math' as math;
import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/main.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
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

  bool _isContinueWithGoogle = false;
  bool _isOtpSent = false;
  bool _isProcessing = false;
  bool _isVerifying = false;
  bool _isEmailEnabled = false;
  bool _isSessionExpired = false;
  bool _isOtpIncorrect = false;
  @override
  void initState() {
    email = TextEditingController();
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
                    Text(
                      "Choose an email option",
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                      ),
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
                      subtitle: Text("No verification requried"),
                      onTap: verifyGmail,
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(
                        Icons.alternate_email,
                        color: UiConstants.primaryColor,
                      ),
                      title: Text("continue with an email"),
                      onTap: () {
                        setState(() {
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
    var rnd = new math.Random();
    var next = rnd.nextDouble() * 1000000;
    while (next < 100000) {
      next *= 10;
    }
    generatedOTP = next.toInt().toString();
  }

  sendEmail() {
    if (formKey.currentState.validate()) {
      dbProvider
          .sendEmailToVerifyEmail(
              email.text, generatedOTP, baseProvider.myUser.name)
          .then((res) {
        if (res) {
          setState(() {
            _isOtpSent = true;
          });
        } else {
          baseProvider.showNegativeAlert(
              "Oops, we ran into trouble",
              "Email cannot be verified at the moment, please try in sometime.",
              context);
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
      baseProvider.myUser.isEmailVerified = true;
      bool res = await dbProvider.updateUser(baseProvider.myUser);
      if (res) {
        setState(() {
          _isVerifying = false;
        });
        baseProvider.showPositiveAlert("Success",
            "Email Verified,refresh your app once to unlock features", context);
        backButtonDispatcher.didPopRoute();
      } else {
        baseProvider.showNegativeAlert("Oops! we ran into problem",
            "Email cannot be verified at the moment", context);
      }
    } else {}
  }

  verifyGmail() async {
    setState(() {
      _isProcessing = true;
    });
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    if (googleUser != null) {
      email.text = googleUser.email;
      baseProvider.myUser.email = googleUser.email;
      baseProvider.myUser.isEmailVerified = true;
      baseProvider.myUserDpUrl = googleUser.photoUrl;
      bool res = await dbProvider.updateUser(baseProvider.myUser);
      if (res) {
        setState(() {
          _isProcessing = false;
        });
        baseProvider.showPositiveAlert("Success",
            "Email Verified,refresh your app once to unlock features", context);
        Navigator.pop(context);

        backButtonDispatcher.didPopRoute();
      } else {
        baseProvider.showNegativeAlert("Oops! we ran into problem",
            "Email cannot be verified at the moment", context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    baseProvider = Provider.of<BaseUtil>(context, listen: false);
    dbProvider = Provider.of<DBModel>(context, listen: false);
    return Scaffold(
      appBar: BaseUtil.getAppBar(context),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: kToolbarHeight,
                ),
                Text(
                  "Let's verify your email",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: SizeConfig.cardTitleTextSize),
                ),
                SizedBox(
                  height: 24,
                ),
                Text(
                    "Enter the email which you'd like to link with your fello account"),
                Form(
                  key: formKey,
                  child: Container(
                    padding: EdgeInsets.only(top: 30, bottom: 10),
                    child: TextFormField(
                      controller: email,
                      enabled: _isEmailEnabled,
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
                  child: Text(
                      "We'll send you a 6 digits OTP (one time password) on this email. enter the OTP here to verify your email"),
                ),
                SizedBox(
                  height: 24,
                ),
                _isProcessing
                    ? Container(
                        child: Column(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(
                              height: 8,
                            ),
                            Text("Sending OTP,please wait")
                          ],
                        ),
                      )
                    : SizedBox(),
                _isOtpSent
                    ? Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Enter the OTP",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  .copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            SizedBox(
                              height: 24,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(0, 18.0, 0, 18.0),
                              child: PinInputTextField(
                                autoFocus: true,
                                pinLength: 6,
                                decoration: BoxLooseDecoration(
                                  enteredColor: UiConstants.primaryColor,
                                  solidColor: UiConstants.primaryColor
                                      .withOpacity(0.04),
                                  strokeColor: UiConstants.primaryColor,
                                  strokeWidth: 1,
                                  textStyle: GoogleFonts.montserrat(
                                      fontSize: 20, color: Colors.black),
                                ),
                                controller: otp,
                                onChanged: (value) {
                                  print(value);
                                  if (value.length == 6) {
                                    verifyOtp();
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
                                        begin: Duration(minutes: 15),
                                        end: Duration.zero),
                                    onEnd: () {
                                      print('Timer ended');
                                      baseProvider.showNegativeAlert(
                                          "Session Expired!",
                                          "Please try again",
                                          context);
                                      backButtonDispatcher.didPopRoute();
                                    },
                                    builder: (BuildContext context,
                                        Duration value, Widget child) {
                                      final minutes = value.inMinutes;
                                      final seconds = value.inSeconds % 60;
                                      return Text(
                                        '$minutes:$seconds',
                                        style: TextStyle(
                                          color: UiConstants.primaryColor,
                                          fontWeight: FontWeight.bold,
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
                    ? Text(
                        "OTP is incorrect,please try again",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    : SizedBox(),
                Spacer(),
                InkWell(
                  onTap: generateOtp,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 24),
                    width: SizeConfig.screenWidth -
                        SizeConfig.blockSizeHorizontal * 5,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: UiConstants.primaryColor,
                    ),
                    alignment: Alignment.center,
                    child: _isVerifying
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            "Verify",
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
