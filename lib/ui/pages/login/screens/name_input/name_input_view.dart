import 'package:felloapp/core/base_remote_config.dart';
import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/login/login_controller_vm.dart';
import 'package:felloapp/ui/pages/login/screens/name_input/name_input_vm.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui' as ui;

class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
    );
  }
}

class LoginNameInputView extends StatefulWidget {
  static const int index = 2;
  final LoginControllerViewModel loginModel;
  const LoginNameInputView({Key key, @required this.loginModel})
      : super(key: key);
  @override
  State<LoginNameInputView> createState() => LoginUserNameViewState();
}

class LoginUserNameViewState extends State<LoginNameInputView> {
  LoginNameInputViewModel model;
  @override
  Widget build(BuildContext context) {
    return BaseView<LoginNameInputViewModel>(
      onModelReady: (model) {
        this.model = model;
        model.init();
      },
      onModelDispose: (model) => model.disposeModel(),
      builder: (ctx, model, child) {
        return ListView(
          // mainAxisAlignment: MainAxisAlignment.start,
          controller: widget.loginModel.nameViewScrollController,
          shrinkWrap: true,
          children: [
          SizedBox(height: SizeConfig.padding64),
           Padding(
             padding: EdgeInsets.all(SizeConfig.padding12),
             child: Container(
                decoration: BoxDecoration(
                    color: UiConstants.kDarkBackgroundColor,
                    borderRadius: BorderRadius.circular(SizeConfig.roundness5)),
                height: SizeConfig.screenHeight * 0.3,
                width: SizeConfig.navBarWidth,
                child: Center(
                    child: BaseRemoteConfig.remoteConfig
                                .getString(BaseRemoteConfig.LOGIN_ASSET_URL) !=
                            ''
                        ? SvgPicture.network(
                            BaseRemoteConfig.remoteConfig
                                .getString(BaseRemoteConfig.LOGIN_ASSET_URL),
                            height: SizeConfig.onboardingAssetsDimens,
                            width: SizeConfig.onboardingAssetsDimens,
                          )
                        : Container()),
              ),
           ),
            SizedBox(
              child: Padding(padding: EdgeInsets.all(SizeConfig.padding4)),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Enter Name',
                style: TextStyles.rajdhaniB.title2,
              ),
            ),
            SizedBox(height: SizeConfig.padding20),

            //input
            Form(
              key: model.formKey,
              child: AppTextField(
                textEditingController: model.nameController,
                isEnabled: model.enabled,
                margin: EdgeInsets.symmetric(
                  horizontal: SizeConfig.pageHorizontalMargins * 2,
                ),
                hintText: "Enter your name as per your PAN",
                focusNode: model.nameFocusNode,
                textCapitalization: TextCapitalization.words,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[a-zA-Z ]'),
                  ),
                ],
                onSubmit: (_) => widget.loginModel.processScreenInput(2),
                // suffix: SizedBox(),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    // model.hasInputError = false;
                    return null;
                  } else {
                    // model.hasInputError = true;
                    return 'Please enter your name as per PAN';
                  }
                },
              ),
            ),
            SizedBox(height: SizeConfig.padding20),
            model.hasReferralCode
                ? AppTextField(
                    textEditingController: model.referralCodeController,
                    onChanged: (val) {},
                    margin: EdgeInsets.symmetric(
                        horizontal: SizeConfig.pageHorizontalMargins * 2),
                    maxLength: 6,
                    isEnabled: true,
                    scrollPadding:
                        EdgeInsets.only(bottom: SizeConfig.padding80),
                    hintText: "Enter your referral code here",
                    textAlign: TextAlign.left,
                    onSubmit: (_) => widget.loginModel.processScreenInput(2),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Z0-9]'),
                      )
                    ],
                    validator: (val) {
                      if (val.trim().length == 0 || val == null) return null;
                      if (val.trim().length < 6 || val.trim().length > 10)
                        return "Invalid referral code";
                      return null;
                    },
                  )
                : TextButton(
                    onPressed: () {
                      if (widget.loginModel.state == ViewState.Busy) return;
                      model.hasReferralCode = true;
                    },
                    child: Center(
                      child: Text(
                        "Have a referral code?",
                        style: TextStyles.body2.bold
                            .colour(UiConstants.kPrimaryColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 100),
          ],
        );
      },
    );
  }
}

