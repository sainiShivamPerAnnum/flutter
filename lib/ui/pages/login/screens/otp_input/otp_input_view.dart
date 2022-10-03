import 'package:felloapp/base_util.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/pin_input_custom_text_field.dart';
import 'package:felloapp/ui/pages/login/login_controller_view.dart';
import 'package:felloapp/ui/pages/login/login_controller_vm.dart';
import 'package:felloapp/ui/pages/login/screens/mobile_input/mobile_input_view.dart';
import 'package:felloapp/ui/pages/login/screens/otp_input/otp_input_vm.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class LoginOtpView extends StatefulWidget {
  final VoidCallback otpEntered;
  final VoidCallback resendOtp;
  final VoidCallback changeNumber;
  static const int index = 1; //pager index
  final String mobileNo;
  final LoginControllerViewModel loginModel;

  LoginOtpView({
    Key key,
    this.otpEntered,
    this.resendOtp,
    this.changeNumber,
    this.mobileNo,
    @required this.loginModel,
  }) : super(key: key);

  @override
  State<LoginOtpView> createState() => LoginOtpViewState();
}

class LoginOtpViewState extends State<LoginOtpView> {
  LoginOtpViewModel model;

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    final baseProvider = Provider.of<BaseUtil>(context, listen: true);
    final logger = locator<CustomLogger>();
    return BaseView<LoginOtpViewModel>(
      onModelReady: (model) {
        this.model = model;
        model.parentModelInstance = widget.loginModel;
        model.init(context);
      },
      builder: (ctx, model, child) {
        return ListView(
          shrinkWrap: true,
          children: [
            SizedBox(height: SizeConfig.padding80),
            SignupHeroAsset(asset: Assets.flatIsland),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Verify OTP',
                style: TextStyles.rajdhaniB.title2,
              ),
            ),
            SizedBox(height: SizeConfig.padding32),
            //input
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.pageHorizontalMargins * 2,
              ),
              child: PinInputTextField(
                enabled: model.otpFieldEnabled,
                controller: model.pinEditingController,
                autoFocus: true,
                pinLength: 6,
                focusNode: model.otpFocusNode,
                keyboardType: TextInputType.number,
                decoration: BoxLooseDecoration(
                  solidColor: UiConstants.kTextFieldColor,
                  strokeColor: UiConstants.primaryColor,
                  strokeWidth: 1,
                  gapSpace: SizeConfig.padding12,
                  textStyle: TextStyles.sourceSansSB.body1.colour(
                    Color(0xFFFFFFFF),
                  ),
                ),
                onChanged: (value) {
                  if (value.length == 6) {
                    if (widget.otpEntered != null) widget.otpEntered();
                  }
                },
                onSubmit: (pin) {
                  model.log.debug(
                    "Pressed submit for pin: " +
                        pin.toString() +
                        "\n  No action taken.",
                  );
                  widget.loginModel.processScreenInput(1);
                },
              ),
            ),
            SizedBox(height: SizeConfig.padding40),
            if ((model.showResendOption && !model.isTriesExceeded))
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Didn\’t receive?',
                    style: TextStyles.sourceSans.body3.colour(
                      UiConstants.kTextFieldTextColor,
                    ),
                  ),
                  SizedBox(
                    width: SizeConfig.padding4,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (BaseUtil.showNoInternetAlert()) return;
                      model.log.debug("Resend action triggered");
                      // FocusScope.of(context).unfocus();

                      model.showResendOption = false;

                      if (!model.isResendClicked) {
                        //ensure that button isnt clicked multiple times
                        if (widget.resendOtp != null) widget.resendOtp();
                      }

                      if (baseProvider.isOtpResendCount < 2) {
                        baseProvider.isOtpResendCount++;
                        logger.d(baseProvider.isOtpResendCount);
                        BaseUtil.showPositiveAlert(
                          "OTP resent successfully",
                          "Please wait for the new otp",
                        );
                      }
                    },
                    child: Text(
                      'RESEND',
                      style: TextStyles.sourceSans.body2.colour(
                        Color(0xFF34C3A7),
                      ),
                    ),
                  ),
                ],
              ),
            if (model.isTriesExceeded)
              Text(
                locale.obOtpTryExceed,
                textAlign: TextAlign.center,
                style: TextStyles.body2.colour(
                  Colors.red[400],
                ),
              ),
            if (!model.showResendOption && !model.isTriesExceeded)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't get an OTP? Request in ",
                    style: TextStyles.sourceSans.body3.colour(
                      UiConstants.kTextFieldTextColor,
                    ),
                  ),
                  TweenAnimationBuilder<Duration>(
                    duration: Duration(seconds: 30),
                    tween: Tween(
                      begin: Duration(seconds: 30),
                      end: Duration.zero,
                    ),
                    onEnd: () {
                      print('Timer ended');
                      model.showResendOption = true;
                    },
                    builder: (
                      BuildContext context,
                      Duration value,
                      Widget child,
                    ) {
                      final minutes =
                          (value.inMinutes).toString().padLeft(2, '0');
                      final seconds =
                          (value.inSeconds % 60).toString().padLeft(2, '0');
                      return Text(
                        "$minutes:$seconds",
                        style: TextStyles.sourceSansB.body3
                            .colour(UiConstants.primaryColor),
                      );
                    },
                  ),
                ],
              ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 100),
          ],
        );
      },
    );
  }
}
