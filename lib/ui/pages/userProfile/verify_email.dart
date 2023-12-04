import 'dart:async';
import 'dart:math' as math;

import 'package:felloapp/base_util.dart';
import 'package:felloapp/core/enums/faqTypes.dart';
import 'package:felloapp/core/model/base_user_model.dart';
import 'package:felloapp/core/ops/db_ops.dart';
import 'package:felloapp/core/repository/user_repo.dart';
import 'package:felloapp/core/service/notifier_services/user_service.dart';
import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/ui/elements/appbar/appbar.dart';
import 'package:felloapp/ui/elements/pin_input_custom_text_field.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/ui/pages/static/loader_widget.dart';
import 'package:felloapp/ui/pages/userProfile/userProfile/components/sign_in_options.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class VerifyEmail extends StatefulWidget {
  static const int index = 3;

  const VerifyEmail({Key? key}) : super(key: key);

  @override
  VerifyEmailState createState() => VerifyEmailState();
}

class VerifyEmailState extends State<VerifyEmail> {
  S locale = locator<S>();
  TextEditingController email = TextEditingController();
  TextEditingController otp = TextEditingController();
  final UserService _userService = locator<UserService>();

  // final baseProvider = locator<BaseUtil>();
  final formKey = GlobalKey<FormState>();
  final UserRepository _userRepo = locator<UserRepository>();

  Timer? timer;
  bool isGmailVerifying = false;
  late BaseUtil baseProvider;
  late DBModel dbProvider;
  String? generatedOTP;
  final bool _isContinueWithGoogle = false;

  //bool baseProvider.isGoogleSignInProgress = false;
  FocusNode? focusNode;
  bool _isOtpSent = false;
  bool _isProcessing = false;
  bool _isVerifying = false;
  final bool _isEmailEnabled = false;
  final bool _isSessionExpired = false;
  bool _isOtpIncorrect = false;

  @override
  void initState() {
    email = TextEditingController(text: _userService.baseUser!.email ?? '');
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      baseProvider.isGoogleSignInProgress = false;
      focusNode = FocusNode();
      focusNode!.requestFocus();
      // showEmailOptions();
    });
    super.initState();
  }

  @override
  void dispose() {
    if (timer != null) timer!.cancel();
    print("disposed");
    super.dispose();
  }

  showEmailOptions() {
    baseProvider.isGoogleSignInProgress = false;
    BaseUtil.openModalBottomSheet(
        isBarrierDismissible: false,
        addToScreenStack: false,
        hapticVibrate: true,
        backgroundColor:
            UiConstants.kRechargeModalSheetAmountSectionBackgroundColor,
        borderRadius: BorderRadius.circular(15),
        content: SignInOptions(
          onGoogleSignIn: verifyGmail,
          onEmailSignIn: () {
            baseProvider.isGoogleSignInProgress = false;
            // _isContinueWithGoogle = false;
            email.text = _userService.baseUser!.email!;
            // _isEmailEnabled = true;

            Navigator.pop(context);
            focusNode!.requestFocus();
          },
        ));
  }

  generateOtp() {
    setState(() {
      _isProcessing = true;
    });
    var rnd = math.Random();
    var next = rnd.nextDouble() * 1000000;
    while (next < 100000) {
      next *= 10;
    }
    generatedOTP = next.toInt().toString();
    print(generatedOTP);
    sendEmail();
  }

  sendEmail() async {
    final isEmailRegistered =
        await _userRepo.isEmailRegistered(email.text.trim());

    if (isEmailRegistered.model!) {
      setState(() {
        _isProcessing = false;
      });
      BaseUtil.showNegativeAlert(
          locale.emailAlreadyRegistered, locale.anotherEmail);

      return;
    }

    if (formKey.currentState!.validate()) {
      dbProvider
          .sendEmailToVerifyEmail(email.text.trim(), generatedOTP!)
          .then((res) {
        if (res) {
          setState(() {
            _isOtpSent = true;
            _isProcessing = false;
          });
        } else {
          setState(() {
            _isProcessing = false;
          });
          BaseUtil.showNegativeAlert(
            locale.verificationFailed,
            locale.emailVerifyFailed,
          );
        }
      });
    }
  }

  verifyOtp() async {
    focusNode!.unfocus();
    setState(() {
      _isOtpIncorrect = false;
      _isVerifying = true;
    });
    if (generatedOTP == otp.text) {
      baseProvider.setEmail(email.text.trim());
      baseProvider.setEmailVerified();

      _userService.setEmail(email.text.trim());
      _userService.isEmailVerified = true;
      _userService.baseUser!.isEmailVerified = true;

      ApiResponse<bool> res = await _userRepo.updateUser(
        uid: _userService.baseUser!.uid,
        dMap: {
          BaseUser.fldEmail: _userService.baseUser!.email,
          BaseUser.fldIsEmailVerified: _userService.baseUser!.isEmailVerified,
        },
      );

      setState(() {
        _isVerifying = false;
      });
      if (res.model!) {
        await _userService.setBaseUser();
        while (AppState.screenStack.length > 1) {
          AppState.backButtonDispatcher!.didPopRoute();
        }
        BaseUtil.showPositiveAlert(locale.emailVerified, locale.emailVerified1);
      } else {
        BaseUtil.showNegativeAlert(
          locale.verificationFailed,
          locale.tryLater,
        );
      }
    } else {
      setState(() {
        _isOtpIncorrect = true;
        _isVerifying = false;
      });
    }
  }

  verifyGmail() async {
    baseProvider.isGoogleSignInProgress = true;

    final _gSignIn = GoogleSignIn();
    try {
      if (await _gSignIn.isSignedIn()) await _gSignIn.signOut();
      print('Signed out');
    } catch (e) {
      print('Failed to signout: $e');
    }
    final GoogleSignInAccount? googleUser = await _gSignIn.signIn();
    if (googleUser != null) {
      final isEmailRegistered =
          await _userRepo.isEmailRegistered(googleUser.email);

      if (!isEmailRegistered.model!) {
        email.text = googleUser.email;
        _userService.baseUser!.email = googleUser.email;
        baseProvider.setEmailVerified();
        _userService.isEmailVerified = true;
        _userService.baseUser!.isEmailVerified = true;

        ApiResponse<bool> res = await _userRepo.updateUser(
          uid: _userService.baseUser!.uid,
          dMap: {
            BaseUser.fldEmail: _userService.baseUser!.email,
            BaseUser.fldIsEmailVerified: _userService.baseUser!.isEmailVerified,
          },
        );

        if (res.model!) {
          await _userService.setBaseUser();
          setState(() {
            baseProvider.isGoogleSignInProgress = false;
          });
          Navigator.pop(context);
          AppState.backButtonDispatcher!.didPopRoute();
          BaseUtil.showPositiveAlert(locale.success, locale.emailVerified);
        } else {
          baseProvider.isGoogleSignInProgress = false;
          BaseUtil.showNegativeAlert(
            locale.verificationFailed,
            locale.emailVerifyFailed,
          );
        }
      } else {
        baseProvider.isGoogleSignInProgress = false;
        BaseUtil.showNegativeAlert(
            locale.emailAlreadyRegistered, locale.anotherEmail);
      }
    } else {
      baseProvider.isGoogleSignInProgress = false;
      BaseUtil.showNegativeAlert(
        locale.noAccSelected,
        locale.chooseAnAcc,
      );
    }
    setState(() {});
  }

  confirmAction() async {
    if (!_isVerifying && !_isProcessing) {
      if (_isOtpSent) {
        verifyOtp();
      } else {
        generateOtp();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    baseProvider = Provider.of<BaseUtil>(context);
    dbProvider = Provider.of<DBModel>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: UiConstants.kBackgroundColor,
      body: Column(
        children: [
          FAppBar(
            type: FaqsType.yourAccount,
            title: locale.obVerifyEmail,
            showAvatar: false,
            showCoinBar: false,
            showHelpButton: false,
            backgroundColor: UiConstants.kSecondaryBackgroundColor,
          ),
          Container(
            height: SizeConfig.screenHeight! -
                SizeConfig.viewInsets.top -
                kToolbarHeight,
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.pageHorizontalMargins),
            child: Stack(
              children: [
                ListView(
                  shrinkWrap: true,
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.pageHorizontalMargins),
                  children: [
                    Text(
                      locale.obEmailSub,
                      style: TextStyles.sourceSans.body3,
                    ),
                    Form(
                      key: formKey,
                      child: Container(
                        padding: const EdgeInsets.only(top: 30, bottom: 10),
                        child: AppTextField(
                          focusNode: focusNode,
                          textEditingController: email,
                          isEnabled: _isProcessing || _isOtpSent ? false : true,
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) {
                            if (val == "") {
                              return null;
                            } else if (val == null) {
                              return locale.obEmailHint;
                            } else if (!RegExp(
                                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                .hasMatch(val)) {
                              return locale.obValidEmail;
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: SizeConfig.padding16),
                      child: Text(
                        (!_isOtpSent)
                            ? locale.ob6DigitEmailCode
                            : locale.obCheckSpamFolder,
                        style: TextStyles.sourceSans.body4
                            .colour(UiConstants.kTextColor2),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.padding24,
                    ),
                    _isProcessing
                        ? Container(
                            width: SizeConfig.screenWidth,
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                FullScreenLoader(
                                  size: SizeConfig.padding80,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  locale.obSendingOtp,
                                  style: TextStyles.rajdhani.body3
                                      .colour(UiConstants.primaryColor),
                                )
                              ],
                            ),
                          )
                        : const SizedBox(),
                    _isOtpSent
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                locale.obEnterOTP,
                                style: TextStyles.rajdhaniSB.title2,
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
                                      textStyle: TextStyles.body0),
                                  controller: otp,
                                  onChanged: (value) {
                                    print(value);
                                    if (value.length == 6) {
                                      verifyOtp();
                                    } else {
                                      setState(() {
                                        _isOtpIncorrect = false;
                                      });
                                    }
                                  },
                                  onSubmit: (pin) {
                                    print(
                                        "Pressed submit for pin: $pin\n  No action taken.");
                                  },
                                ),
                              ),
                              SizedBox(
                                height: SizeConfig.padding16,
                              ),
                              Row(
                                children: [
                                  Text(
                                    locale.obOTPValidFor,
                                    style: TextStyles.sourceSans.body3,
                                  ),
                                  TweenAnimationBuilder<Duration>(
                                      duration: const Duration(minutes: 15),
                                      tween: Tween(
                                          begin: const Duration(minutes: 15),
                                          end: Duration.zero),
                                      onEnd: () {
                                        print('Timer ended');
                                        BaseUtil.showNegativeAlert(
                                          locale.obSessionExpired,
                                          locale.obPleaseTryAgain,
                                        );
                                        AppState.backButtonDispatcher!
                                            .didPopRoute();
                                      },
                                      builder: (BuildContext context,
                                          Duration value, Widget? child) {
                                        final minutes = value.inMinutes;
                                        final seconds = value.inSeconds % 60;
                                        return Text(
                                          '$minutes:$seconds',
                                          style: const TextStyle(
                                            color: UiConstants.primaryColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        );
                                      }),
                                  // Text(
                                  //   "15:00",
                                  //   style: TextStyle(
                                  //     color: UiConstants.primaryColor,
                                  //     fontWeight: FontWeight.w700,
                                  //   ),
                                  // ),
                                  Text(
                                    locale.obMinutes,
                                    style: TextStyles.sourceSans.body3,
                                  )
                                ],
                              )
                            ],
                          )
                        : const SizedBox(),
                    _isOtpIncorrect
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  locale.obIncorrectOTP,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(),
                    SizedBox(
                      height: SizeConfig.screenHeight! * 0.5,
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: SizeConfig.viewInsets.bottom == 0
                            ? SizeConfig.padding24
                            : 0,
                      ),
                      child: AppPositiveCustomChildBtn(
                        onPressed: confirmAction,
                        child: _isVerifying || _isProcessing
                            ? SpinKitThreeBounce(
                                color: UiConstants.spinnerColor2,
                                size: 18.0,
                              )
                            : Text(
                                _isOtpSent
                                    ? locale.obVerify.toUpperCase()
                                    : locale.obSendOTP.toUpperCase(),
                                style: TextStyles.rajdhaniB.body0.bold
                                    .colour(Colors.white),
                              ),
                      ),
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
