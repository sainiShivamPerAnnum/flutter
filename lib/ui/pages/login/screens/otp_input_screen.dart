import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/size_config.dart';
import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';

class OtpInputScreen extends StatefulWidget {
  final VoidCallback otpEntered;
  final VoidCallback resendOtp;
  static const int index = 1; //pager index
  OtpInputScreen({Key key, this.otpEntered, this.resendOtp}) : super(key: key);

  @override
  State<StatefulWidget> createState() => OtpInputScreenState();
}

class OtpInputScreenState extends State<OtpInputScreen> {
  Log log = new Log("OtpInputScreen");
  String _otp;
  String _loaderMessage = "Enter the received otp..";
  bool _otpFieldEnabled = true;
  bool _autoDetectingOtp = true;
  bool _isResendClicked = false;
  final _pinEditingController = new TextEditingController();
  FocusNode focusNode;

  @override
  void initState() {
    focusNode = new FocusNode();
    focusNode.addListener(
        () => print('focusNode updated: hasFocus: ${focusNode.hasFocus}'));

    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (mounted) {
      FocusScope.of(context).requestFocus(focusNode);
    }

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
            margin: EdgeInsets.symmetric(
                horizontal: SizeConfig.blockSizeHorizontal * 5),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: SizeConfig.screenHeight * 0.04,
                ),
                Image.asset(
                  "images/otp.png",
                  height: SizeConfig.screenHeight * 0.16,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Code Sent",
                  style: GoogleFonts.montserrat(
                    fontSize: SizeConfig.mediumTextSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 18.0, 0, 18.0),
                    child: PinInputTextField(
                      enabled: _otpFieldEnabled,
                      autoFocus: true,
                      focusNode: focusNode,
                      pinLength: 6,
                      decoration: BoxLooseDecoration(
                          enteredColor: UiConstants.primaryColor,
                          solidColor: UiConstants.primaryColor.withOpacity(0.1),
                          strokeColor: UiConstants.primaryColor,
                          strokeWidth: 2,
                          textStyle: GoogleFonts.montserrat(
                              fontSize: 20, color: Colors.black)),
                      controller: _pinEditingController,
                      onChanged: (value) {
                        if (value.length == 6) {
                          if (widget.otpEntered != null) widget.otpEntered();
                        }
                      },
                      onSubmit: (pin) {
                        log.debug("Pressed submit for pin: " +
                            pin.toString() +
                            "\n  No action taken.");
                      },
                    )),
                SizedBox(height: 16.0),
                (_autoDetectingOtp)
                    ? Padding(
                        padding:
                            const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 25.0),
                        child: SpinKitDoubleBounce(
                          color: UiConstants.spinnerColor,
                          //controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
                        ),
                      )
                    : Container(),
                (_autoDetectingOtp) ? SizedBox(height: 5.0) : Container(),
                Text(
                  _loaderMessage,
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .copyWith(color: Colors.grey[800]),
                  textAlign: TextAlign.center,
                ),
                (!_autoDetectingOtp)
                    ? TextButton(
                        child: Text('Resend'),
                        onPressed: () {
                          log.debug("Resend action triggered");
                          if (!_isResendClicked) {
                            //ensure that button isnt clicked multiple times
                            if (widget.resendOtp != null) widget.resendOtp();
                          }
                        },
                      )
                    : Container()
              ],
            )));
  }

  onOtpReceived() {
    setState(() {
      _otpFieldEnabled = false;
      _loaderMessage = "Signing in..";
    });
  }

  onOtpAutoDetectTimeout() {
    setState(() {
      _otpFieldEnabled = true;
      _autoDetectingOtp = false;
      _loaderMessage = "Please enter the received otp or request another";
    });
  }

  onOtpResendConfirmed(bool flag) {
    if (flag) {
      //otp successfully resent
      _isResendClicked = false;
      _otpFieldEnabled = true;
      _loaderMessage = 'OTP has been successfully resent';
      _autoDetectingOtp = true;
      setState(() {});
    }else{
      //otp tries exceeded
      _isResendClicked = true;
      _otpFieldEnabled = true;
      _autoDetectingOtp = false;
      _loaderMessage = 'OTP requests exceeded. Please try again in sometime or contact us';
      setState(() {});
    }
  }

  String get otp => _pinEditingController.text;
}
