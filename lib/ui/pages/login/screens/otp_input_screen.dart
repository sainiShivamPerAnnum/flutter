import 'package:felloapp/base_util.dart';
import 'package:felloapp/ui/elements/pin_input_custom_text_field.dart';
import 'package:felloapp/ui/pages/login/login_controller.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  final pinEditingController = new TextEditingController();
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
          if (mounted)
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
    S locale = S.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: SizeConfig.blockSizeVertical * 5),

              SvgPicture.asset(
                Assets.otpAuth,
                width: SizeConfig.screenHeight * 0.16,
              ),
              SizedBox(height: SizeConfig.blockSizeVertical * 5),
              Text(
                locale.obOtpLabel,
                style: TextStyles.title4.bold,
              ),
              SizedBox(height: SizeConfig.padding12),
              Text(
                locale.obOtpDesc(LoginController.mobileno.substring(6)),
                textAlign: TextAlign.center,
                style: TextStyles.body2,
              ),
              SizedBox(height: SizeConfig.padding40),
              // _autoDetectingOtp && !_isTriesExceeded
              //     ? SizedBox()
              //     : InkWell(
              //         child: Text(
              //           "Change Number ?",
              //           style: TextStyle(
              //             color: Theme.of(context).primaryColor,
              //             fontWeight: FontWeight.w700,
              //           ),
              //         ),
              //         onTap: () {
              //           widget.changeNumber();
              //         },
              //       ),
              // const SizedBox(
              //   height: 24,
              // ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.pageHorizontalMargins,
                ),
                child: PinInputTextField(
                  enabled: _otpFieldEnabled,
                  autoFocus: true,
                  focusNode: focusNode,
                  pinLength: 6,
                  decoration: BoxLooseDecoration(
                    enteredColor: UiConstants.primaryColor,
                    solidColor: UiConstants.primaryColor.withOpacity(0.04),
                    strokeColor: UiConstants.primaryColor,
                    strokeWidth: 0,
                    textStyle: TextStyles.body2.bold.colour(Colors.black),
                  ),
                  controller: pinEditingController,
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
              SizedBox(
                height: SizeConfig.padding16,
              ),

              (showResendOption && !_isTriesExceeded)
                  ? Padding(
                      padding: EdgeInsets.all(SizeConfig.padding4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            locale.obDidntGetOtp,
                            style: TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          InkWell(
                            child: Text(
                              locale.obResend,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            onTap: () {
                              log.debug("Resend action triggered");
                              FocusScope.of(context).unfocus();
                              BaseUtil.showPositiveAlert(
                                  "OTP resent successfully",
                                  "Please wait for the new otp");
                              if (!_isResendClicked) {
                                //ensure that button isnt clicked multiple times
                                if (widget.resendOtp != null)
                                  widget.resendOtp();
                              }
                            },
                          ),
                        ],
                      ),
                    )
                  : SizedBox(),
              (_isTriesExceeded)
                  ? Text(
                      locale.obOtpTryExceed,
                      style: TextStyles.body2.colour(
                        Colors.red[400],
                      ),
                    )
                  : SizedBox(),
              (!showResendOption)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Didn't get an OTP? request in ",
                            style: TextStyles.body3),
                        TweenAnimationBuilder<Duration>(
                            duration: Duration(seconds: 30),
                            tween: Tween(
                                begin: Duration(seconds: 30),
                                end: Duration.zero),
                            onEnd: () {
                              print('Timer ended');
                            },
                            builder: (BuildContext context, Duration value,
                                Widget child) {
                              final minutes =
                                  (value.inMinutes).toString().padLeft(2, '0');
                              final seconds = (value.inSeconds % 60)
                                  .toString()
                                  .padLeft(2, '0');

                              return Text(
                                "$minutes:$seconds",
                                style: TextStyles.body3.bold
                                    .colour(UiConstants.primaryColor),
                              );
                            }),
                      ],
                    )
                  : Container(),
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

  String get otp => pinEditingController.text;
}
