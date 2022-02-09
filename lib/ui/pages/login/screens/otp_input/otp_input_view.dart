import 'package:felloapp/base_util.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/pin_input_custom_text_field.dart';
import 'package:felloapp/ui/pages/login/login_controller_view.dart';
import 'package:felloapp/ui/pages/login/screens/otp_input/otp_input_vm.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/logger.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

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
  OtpInputScreenViewModel model;
  FocusNode focusNode;
  bool showResendOption = false;

  @override
  void initState() {
    focusNode = new FocusNode();
    focusNode.addListener(
        () => print('focusNode updated: hasFocus: ${focusNode.hasFocus}'));
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
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    final baseProvider = Provider.of<BaseUtil>(context, listen: true);
    return BaseView<OtpInputScreenViewModel>(
      onModelReady: (model) => this.model = model,
      builder: (ctx, model, child) => Scaffold(
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
                  locale.obOtpDesc(LoginControllerView.mobileno?.substring(6)),
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
                    enabled: model.otpFieldEnabled,
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
                    controller: model.pinEditingController,
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

                (showResendOption && !model.isTriesExceeded)
                    ? Padding(
                        padding: EdgeInsets.all(SizeConfig.padding4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              locale.obDidntGetOtp,
                              style: TextStyles.body3.colour(Colors.black45),
                            ),
                            InkWell(
                              child: Text(
                                locale.obResend,
                                style: TextStyles.body3
                                    .colour(UiConstants.primaryColor)
                                    .bold,
                              ),
                              onTap: () {
                                log.debug("Resend action triggered");
                                FocusScope.of(context).unfocus();

                                setState(() {
                                  showResendOption = false;
                                });

                                if (!model.isResendClicked) {
                                  //ensure that button isnt clicked multiple times
                                  if (widget.resendOtp != null)
                                    widget.resendOtp();
                                }
                                if (baseProvider.isOtpResendCount < 2) {
                                  BaseUtil.showPositiveAlert(
                                      "OTP resent successfully",
                                      "Please wait for the new otp");
                                }
                              },
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),
                (model.isTriesExceeded)
                    ? Text(
                        locale.obOtpTryExceed,
                        textAlign: TextAlign.center,
                        style: TextStyles.body2.colour(
                          Colors.red[400],
                        ),
                      )
                    : SizedBox(),
                (!showResendOption && !model.isTriesExceeded)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Didn't get an OTP? request in ",
                              style: TextStyles.body3.colour(Colors.black45)),
                          TweenAnimationBuilder<Duration>(
                              duration: Duration(seconds: 30),
                              tween: Tween(
                                  begin: Duration(seconds: 30),
                                  end: Duration.zero),
                              onEnd: () {
                                print('Timer ended');
                                setState(() {
                                  showResendOption = true;
                                });
                              },
                              builder: (BuildContext context, Duration value,
                                  Widget child) {
                                final minutes = (value.inMinutes)
                                    .toString()
                                    .padLeft(2, '0');
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
      ),
    );
  }
}
