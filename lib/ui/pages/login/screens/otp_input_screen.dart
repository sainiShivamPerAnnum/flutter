import 'package:felloapp/ui/elements/pin_input_custom_text_field.dart';
import 'package:felloapp/ui/pages/login/login_controller.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class OtpInputScreen extends StatefulWidget {
  final VoidCallback otpEntered;
  final VoidCallback resendOtp;
  final VoidCallback changeNumber;
  static const int index = 1; //pager index
  final String mobileNo;

  OtpInputScreen(
      {Key key,
      this.otpEntered,
      this.resendOtp,
      this.changeNumber,
      this.mobileNo})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => OtpInputScreenState();
}

class OtpInputScreenState extends State<OtpInputScreen> {
  Log log = new Log("OtpInputScreen");
  String _otp;
  String _loaderMessage = "Enter the received OTP..";
  bool _otpFieldEnabled = true;
  bool _autoDetectingOtp = true;
  bool _isResendClicked = false;
  bool _isTriesExceeded = false;
  bool showResendOption = false;
  final _pinEditingController = new TextEditingController();
  FocusNode focusNode;
  String mobileNo;

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
  void didChangeDependencies() {
    if (mounted)
      Future.delayed(Duration(seconds: 2), () {
        FocusScope.of(context).requestFocus(focusNode);
      });

    if (mounted)
      Future.delayed(Duration(seconds: 30), () {
        try {
          setState(() {
            showResendOption = true;
          });
        } catch (e) {
          log.error('Screen no longer active');
        }
      });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  "Verify OTP",
                  style: GoogleFonts.manrope(
                    fontWeight: FontWeight.w800,
                    fontSize: SizeConfig.screenWidth * 0.06,
                  ),
                ),
              ),
              Text(
                  "Please enter the 6 digit code sent to your mobile number ******${LoginController.mobileno.substring(6)}"),
              const SizedBox(
                height: 16,
              ),
              _autoDetectingOtp && !_isTriesExceeded
                  ? SizedBox()
                  : InkWell(
                      child: Text(
                        "Change Number ?",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onTap: () {
                        widget.changeNumber();
                      },
                    ),
              const SizedBox(
                height: 24,
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
                    solidColor: UiConstants.primaryColor.withOpacity(0.04),
                    strokeColor: UiConstants.primaryColor,
                    strokeWidth: 1,
                    textStyle: GoogleFonts.montserrat(
                        fontSize: 20, color: Colors.black),
                  ),
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
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              (showResendOption && !_isTriesExceeded)
                  ? Row(
                      children: [
                        Text(
                          "Didn't get an OTP? ",
                          style: TextStyle(
                            color: Colors.black45,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        InkWell(
                          child: Text(
                            " Resend",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          onTap: () {
                            log.debug("Resend action triggered");
                            if (!_isResendClicked) {
                              //ensure that button isnt clicked multiple times
                              if (widget.resendOtp != null) widget.resendOtp();
                            }
                          },
                        ),
                      ],
                    )
                  : SizedBox(),
              (_isTriesExceeded)
                  ? Text(
                      "OTP requests exceeded. Please try again in sometime or contact us.",
                      style: TextStyle(
                        color: Colors.black45,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : SizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  (!showResendOption)
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  25.0, 25.0, 25.0, 25.0),
                              child: SpinKitDoubleBounce(
                                color: UiConstants.spinnerColor,
                                //controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 1200)),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            //Text(_loaderMessage)
                          ],
                        )
                      : Container(),
                  SizedBox(width: SizeConfig.blockSizeHorizontal * 5 + 30),
                  Spacer()
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
      _isTriesExceeded = false;
      _isResendClicked = false;
      _otpFieldEnabled = true;
      _loaderMessage = 'OTP has been successfully resent';
      _autoDetectingOtp = true;
      setState(() {});
    } else {
      //otp tries exceeded
      _isTriesExceeded = true;
      _isResendClicked = true;
      _otpFieldEnabled = true;
      _autoDetectingOtp = false;
      _loaderMessage =
          'OTP requests exceeded. Please try again in sometime or contact us';
      setState(() {});
    }
  }

  String get otp => _pinEditingController.text;
}
