import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/db_ops.dart';
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

  bool _isContinueWithGoogle = false;
  bool isOtpSent = false;
  bool isProcessing = false;
  bool _isEmailEnabled = false;
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
                      title: Text("Choose a Google instead"),
                      onTap: () async {
                        setState(() {
                          isProcessing = true;
                        });
                        final GoogleSignInAccount googleUser =
                            await GoogleSignIn().signIn();
                        if (googleUser != null) {
                          email.text = googleUser.displayName;
                          baseProvider.myUser.isEmailVerified = true;
                          baseProvider.myUserDpUrl = googleUser.photoUrl;
                          setState(() {
                            _isContinueWithGoogle = true;
                            email.text = googleUser.email;
                            isProcessing = false;
                          });
                          Navigator.pop(context);
                        }
                      },
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

  // verifyEmail() async {
  //   String emailAddress;
  //   if (formKey.currentState.validate() && isProcessing != true) {
  //     if (email.text == null || email.text.isEmpty)
  //       emailAddress = baseProvider.myUser.email;
  //     else
  //       emailAddress = email.text.trim();
  //     // print(baseProvider.firebaseUser.emailVerified.toString());
  //     // await baseProvider.firebaseUser
  //     //     .verifyBeforeUpdateEmail("donewithfinger@gmail.com");
  //     // print("done.........");
  //     // print(baseProvider.firebaseUser.emailVerified.toString());
  //     await baseProvider.firebaseUser.reload();
  //     await baseProvider.firebaseUser.updateEmail(emailAddress);
  //     await baseProvider.firebaseUser.sendEmailVerification();

  //     setState(() {
  //       isProcessing = true;
  //     });
  //     timer = Timer.periodic(Duration(seconds: 5), (t) {
  //       baseProvider.firebaseUser.reload().then((_) {
  //         print("Waiting for response");
  //         if (baseProvider.firebaseUser.emailVerified) {
  //           timer.cancel();
  //           print("Email verified successfully");
  //           baseProvider.myUser.email = emailAddress;
  //           baseProvider.myUser.isEmailVerified = true;
  //           baseProvider.isLoginNextInProgress = false;
  //           setState(() {
  //             isProcessing = false;
  //             _isVerified = true;
  //           });
  //         }
  //       });
  //     });
  //   }
  // }

  sendEmail() {}

  generateOtp() {}

  verifyOtp() {}

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
                  height: kToolbarHeight * 2,
                ),
                Text(
                  "Enter your email",
                  style: Theme.of(context).textTheme.headline4.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                SizedBox(
                  height: 24,
                ),
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
                !isOtpSent
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
                          ],
                        ),
                      )
                    : SizedBox(),
                Spacer(),
                InkWell(
                  //onTap: verifyEmail,
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
                    child: isProcessing
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
