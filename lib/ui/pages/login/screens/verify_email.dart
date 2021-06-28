import 'dart:async';

import 'package:felloapp/base_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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

  // @override
  // void initState() {
  //   baseProvider = Provider.of<BaseUtil>(context);
  //   email = TextEditingController(text: baseProvider.myUser.email);
  //   super.initState();
  // }

  @override
  void dispose() {
    if (timer != null) timer.cancel();
    print("disposed");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.text,
                    validator: (val) {
                      if (val == null || val == "") {
                        return "Please enter an email";
                      } else if (!RegExp(
                              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                          .hasMatch(val)) {
                        return "Enter a valid email";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        labelText: "email",
                        prefixIcon: Icon(Icons.email_rounded)),
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
            ],
          ),
        ),
        // _isVerifying
        //     ? Container(
        //         color: Colors.white.withOpacity(0.5),
        //         child: Center(
        //           child: CircularProgressIndicator(),
        //         ),
        //       )
        //     : SizedBox(),
        // _isVerified
        //     ? Container(
        //         color: Colors.white.withOpacity(0.8),
        //         padding: EdgeInsets.all(SizeConfig.width * 0.25),
        //         width: SizeConfig.width,
        //         child: Column(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           crossAxisAlignment: CrossAxisAlignment.center,
        //           children: [
        //             Icon(
        //               Icons.verified_rounded,
        //               color: Colors.green,
        //               size: 50,
        //             ),
        //             Padding(
        //               padding: const EdgeInsets.all(20.0),
        //               child: Text("Email verified successfully."),
        //             ),
        //             FRaisedButton(
        //                 child: Text(
        //                   "Next",
        //                   style:
        //                       Theme.of(context).textTheme.headline5.copyWith(
        //                             color: Colors.white,
        //                           ),
        //                 ),
        //                 onPressed: () {
        //                   Navigator.pushReplacement(
        //                     context,
        //                     MaterialPageRoute(
        //                       builder: (ctx) => Username(),
        //                     ),
        //                   );
        //                 })
        //           ],
        //         ),
        //       )
        //     : SizedBox(),
      ],
    );
  }
}
