import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/elements/pin_input_custom_text_field.dart';
import 'package:felloapp/ui/pages/login/login_components/login_image.dart';
import 'package:felloapp/ui/pages/login/login_controller_vm.dart';
import 'package:felloapp/ui/pages/login/screens/name_input/name_input_view.dart';
import 'package:felloapp/ui/pages/login/screens/otp_input/otp_input_vm.dart';
import 'package:felloapp/util/custom_logger.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class LoginOtpView extends StatefulWidget {
  final VoidCallback? otpEntered;
  final VoidCallback? resendOtp;
  final VoidCallback? changeNumber;
  static const int index = 1; //pager index
  final String? mobileNo;
  final LoginControllerViewModel loginModel;

  const LoginOtpView({
    required this.loginModel,
    Key? key,
    this.otpEntered,
    this.resendOtp,
    this.changeNumber,
    this.mobileNo,
  }) : super(key: key);

  @override
  State<LoginOtpView> createState() => LoginOtpViewState();
}

class LoginOtpViewState extends State<LoginOtpView> {
  LoginOtpViewModel? model;

  @override
  Widget build(BuildContext context) {
    S? locale = S.of(context);
    final baseProvider = Provider.of<BaseUtil>(context, listen: true);
    final CustomLogger logger = locator<CustomLogger>();
    return BaseView<LoginOtpViewModel>(
      onModelReady: (model) {
        this.model = model;
        model.parentModelInstance = widget.loginModel;
        model.mobileNo = model.parentModelInstance.userMobile;
        model.init();
      },
      onModelDispose: (model) {
        this.model = model;
        model.exit();
      },
      builder: (ctx, model, child) {
        return ListView(
          // mainAxisAlignment: MainAxisAlignment.start,
          controller: widget.loginModel.otpScrollController,
          shrinkWrap: true,
          children: [
            const LoginImage(),
            SizedBox(height: SizeConfig.padding68),
            Container(
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.padding25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Enter OTP',
                        style: TextStyles.sourceSansSB.body1,
                      ),
                      if (model.showResendOption && !model.isTriesExceeded)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (BaseUtil.showNoInternetAlert()) return;
                                model.log.debug("Resend action triggered");
                                // FocusScope.of(context).unfocus();

                                model.showResendOption = false;

                                if (!model.isResendClicked) {
                                  //ensure that button isnt clicked multiple times
                                  if (widget.resendOtp != null)
                                    widget.resendOtp!();
                                }

                                if (baseProvider.isOtpResendCount < 2) {
                                  baseProvider.isOtpResendCount++;
                                  logger.d(baseProvider.isOtpResendCount);
                                  BaseUtil.showPositiveAlert(
                                    locale.otpSentSuccess,
                                    locale.waitForNewOTP,
                                  );
                                }
                              },
                              child: Text(
                                'RESEND OTP',
                                key: const ValueKey("OtpResend"),
                                style: TextStyles.sourceSansM.body3.colour(
                                  UiConstants.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      if (model.isTriesExceeded)
                        Text(
                          'RESEND OTP',
                          textAlign: TextAlign.center,
                          style: TextStyles.sourceSansM.body3.colour(
                            UiConstants.kProfileBorderColor,
                          ),
                        ),
                      if (!model.showResendOption && !model.isTriesExceeded)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Resend OTP in ',
                              style: TextStyles.sourceSans.body3.colour(
                                UiConstants.kTextFieldTextColor,
                              ),
                            ),
                            TweenAnimationBuilder<Duration>(
                              duration: const Duration(seconds: 30),
                              tween: Tween(
                                begin: const Duration(seconds: 30),
                                end: Duration.zero,
                              ),
                              onEnd: () {
                                print('Timer ended');
                                model.showResendOption = true;
                              },
                              builder: (
                                context,
                                value,
                                child,
                              ) {
                                final minutes = (value.inMinutes)
                                    .toString()
                                    .padLeft(2, '0');
                                final seconds = (value.inSeconds % 60)
                                    .toString()
                                    .padLeft(2, '0');
                                return Text(
                                  "$minutes:$seconds",
                                  style: TextStyles.sourceSansB.body3
                                      .colour(UiConstants.primaryColor),
                                );
                              },
                            ),
                          ],
                        ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.padding14),
                  PinInputTextField(
                    key: ValueKey("otpTextField"),
                    //key: K.otpTextFieldKey,
                    enabled: model.otpFieldEnabled,
                    controller: model.pinEditingController,
                    autoFocus: true,
                    pinLength: 6,
                    focusNode: model.otpFocusNode,
                    keyboardType: TextInputType.number,
                    decoration: BoxLooseDecoration(
                      solidColor: UiConstants.greyVarient,
                      strokeColor: UiConstants.grey6,
                      strokeWidth: 1,
                      gapSpace: SizeConfig.padding12,
                      textStyle: TextStyles.sourceSansSB.body1.colour(
                        const Color(0xFFFFFFFF),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.length == 6) {
                        if (widget.otpEntered != null) widget.otpEntered!();
                      }
                    },
                    onSubmit: (pin) {
                      model.log.debug(
                        "Pressed submit for pin: $pin\n  No action taken.",
                      );
                      widget.loginModel.processScreenInput(1);
                    },
                  ),
                  SizedBox(height: SizeConfig.padding14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        locale.obLoginAsText(model.mobileNo!),
                        style: TextStyles.sourceSans.body3.colour(
                          UiConstants.kProfileBorderColor,
                        ),
                      ),
                      SizedBox(
                        width: SizeConfig.padding12,
                      ),
                      ListenableBuilder(
                        listenable: model.parentModelInstance,
                        builder: (context, child) {
                          final isBusy =
                              model.parentModelInstance.state == ViewState.Busy;
                          return GestureDetector(
                            onTap: () {
                              if (isBusy || BaseUtil.showNoInternetAlert()) {
                                return;
                              }

                              model.parentModelInstance.editPhone();
                            },
                            child: Text(
                              'Change',
                              style: TextStyles.sourceSans.body3.colour(
                                isBusy
                                    ? UiConstants.kTextFieldTextColor
                                    : UiConstants.primaryColor,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.padding30),
                  Consumer<LoginControllerViewModel>(
                    builder: (context, model, child) {
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () =>
                              model.processScreenInput(model.currentPage),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(
                                SizeConfig.padding325, SizeConfig.padding48),
                            backgroundColor: UiConstants.kTextColor,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(SizeConfig.roundness8),
                            ),
                          ),
                          child: model.state == ViewState.Busy
                              ? SizedBox(
                                  width: SizeConfig.padding32,
                                  child: SpinKitThreeBounce(
                                    color: UiConstants.kTextColor4,
                                    size: SizeConfig.padding20,
                                  ),
                                )
                              : Text(
                                  model.currentPage == LoginNameInputView.index
                                      ? locale.obFinish
                                      : locale.obNext,
                                  style: TextStyles.sourceSansSB.body3
                                      .colour(UiConstants.kTextColor4),
                                ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 100),
          ],
        );
      },
    );
  }
}
