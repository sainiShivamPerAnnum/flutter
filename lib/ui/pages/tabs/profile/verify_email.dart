import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/main.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
  final formKey = GlobalKey<FormState>();
  Timer timer;
  bool isGmailVerifying = false;
  BaseUtil baseProvider;
  DBModel dbProvider;
  bool _isVerifying = false;
  bool _isVerified = false;
  bool _isContinueWithGoogle = false;
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
                          _isVerifying = true;
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
                            _isVerified = true;
                            _isVerifying = false;
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
                      title: Text("continue with another email"),
                      onTap: () {
                        setState(() {
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

  verifyEmail() async {
    if (formKey.currentState.validate() && _isVerifying != true) {
      String emailAddress = email.text.trim();
      await baseProvider.firebaseUser.updateEmail(emailAddress);
      await baseProvider.firebaseUser.sendEmailVerification();
      setState(() {
        _isVerifying = true;
      });
      timer = Timer.periodic(Duration(seconds: 5), (t) {
        baseProvider.firebaseUser.reload().then((_) {
          print("Waiting for response");
          if (baseProvider.firebaseUser.emailVerified) {
            timer.cancel();
            print("Email verified successfully");
            baseProvider.myUser.email = emailAddress;
            baseProvider.myUser.isEmailVerified = true;
            baseProvider.isLoginNextInProgress = false;
            setState(() {
              _isVerifying = false;
              _isVerified = true;
            });
          }
        });
      });
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
                        if (val == null) {
                          return "Please enter an email";
                        } else if (!RegExp(
                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                            .hasMatch(val)) {
                          return "Enter a valid email";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: baseProvider.myUser.email,
                        prefixIcon: Icon(Icons.email_rounded),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                      "We'll send you a confirmation link. click on the link to verify your account"),
                ),
                SizedBox(
                  height: 24,
                ),
                Spacer(),
                InkWell(
                  onTap: verifyEmail,
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
          _isVerifying
              ? Container(
                  color: Colors.white.withOpacity(0.5),
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      Text("Email verifying, please don't press back")
                    ],
                  ),
                )
              : SizedBox(),
          _isVerified
              ? Container(
                  color: Colors.white.withOpacity(0.8),
                  padding: EdgeInsets.all(SizeConfig.screenWidth * 0.25),
                  width: SizeConfig.screenWidth,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.verified_rounded,
                        color: Colors.green,
                        size: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text("Email verified successfully."),
                      ),
                      InkWell(
                        onTap: () => backButtonDispatcher.didPopRoute(),
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
                          child: Text(
                            "Close",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
