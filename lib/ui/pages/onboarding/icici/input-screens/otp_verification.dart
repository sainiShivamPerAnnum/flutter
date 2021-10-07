import 'package:felloapp/ui/elements/pin_input_custom_text_field.dart';
import 'package:felloapp/ui/pages/onboarding/icici/input-elements/data_provider.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class OtpVerification extends StatefulWidget {
  static const int index = 4;

  OtpVerification({this.action});

  final Function action;

  @override
  State createState() => OtpVerificationState();
}

class OtpVerificationState extends State<OtpVerification> {
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Container(
        padding: EdgeInsets.symmetric(horizontal: _width * 0.04),
        width: _width,
        height: _height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ONE FINAL",
                    style: TextStyle(
                      fontSize: 50,
                      color: Colors.black87,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    "STEP",
                    style: TextStyle(
                      fontSize: 50,
                      color: UiConstants.primaryColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    "Please enter the OTP sent to your ${IDP.otpChannels}",
                    style: TextStyle(
                      fontSize: 20,
                      color: UiConstants.accentColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                      padding:
                          const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 18.0),
                      child: PinInputTextField(
                        enabled: true,
                        pinLength: 5,
                        decoration: UnderlineDecoration(
                            color: Colors.grey,
                            textStyle:
                                TextStyle(fontSize: 20, color: Colors.black)),
                        controller: IDP.otpInput,
                        autoFocus: true,
                        textInputAction: TextInputAction.go,
                        onSubmit: (pin) {
                          print("Pressed submit for pin: " +
                              pin.toString() +
                              "\n  No action taken.");
                        },
                      )),
                  // Wrap(
                  //   spacing: 20,
                  //   children: [
                  //     Chip(
                  //       label: Text("What is a PAN?"),
                  //       backgroundColor: UiConstants.chipColor,
                  //     ),
                  //     Chip(
                  //       label: Text("Why do I need to give my PAN Number?"),
                  //       backgroundColor: UiConstants.chipColor,
                  //     ),
                  //     Chip(
                  //       label: Text("Where can I get my PAN?"),
                  //       backgroundColor: UiConstants.chipColor,
                  //     ),
                  //     Chip(
                  //       label: Text("How does a PAN look like?"),
                  //       backgroundColor: UiConstants.chipColor,
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
            SizedBox(),
          ],
        ));
  }
}
