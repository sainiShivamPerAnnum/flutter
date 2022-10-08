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
          shrinkWrap: true,
          children: [
            SizedBox(height: SizeConfig.padding44),

            FelloUserAvatar(),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Enter Name',
                style: TextStyles.rajdhaniB.title2,
              ),
            ),
            SizedBox(height: SizeConfig.padding32),

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
                    return 'Please enter your name';
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

class FelloUserAvatar extends StatelessWidget {
  const FelloUserAvatar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: SizeConfig.screenWidth * 0.54,
          height: SizeConfig.screenWidth * 0.54,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SizeConfig.screenWidth),
            boxShadow: [
              BoxShadow(
                color: UiConstants.primaryColor.withOpacity(0.2),
                blurRadius: 82,
                spreadRadius: 0,
                offset: Offset(
                  0,
                  SizeConfig.padding32,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: SizeConfig.screenWidth * 0.501,
          height: SizeConfig.screenWidth * 0.501,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Color(0xff737373).withOpacity(0.5),
              width: SizeConfig.border1,
            ),
          ),
        ),
        Container(
          width: SizeConfig.screenWidth * 0.424, // 142
          height: SizeConfig.screenWidth * 0.424,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: SizeConfig.border1,
            ),
          ),
        ),
        Positioned(
          top: SizeConfig.padding80,
          right: SizeConfig.padding54,
          child: Container(
            height: SizeConfig.padding6,
            width: SizeConfig.padding6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: UiConstants.kTextColor,
            ),
          ),
        ),
        Container(
          width: SizeConfig.screenWidth * 0.32,
          height: SizeConfig.screenWidth * 0.32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Color(0xffD9D9D9),
              width: SizeConfig.border1,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: SizeConfig.padding8),
          child: SvgPicture.asset(
            Assets.cvtar2,
            height: SizeConfig.screenWidth * 0.3067,
            width: SizeConfig.screenWidth * 0.3067,
          ),
        ),
      ],
    );
  }
}

class HeaderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..shader = ui.Gradient.linear(
        Offset(0, 0),
        Offset(0, size.height * 0.97),
        [
          Color(0xff135756),
          UiConstants.kBackgroundColor,
        ],
      );

    final path = new Path()
      ..moveTo(
        0,
        0,
      );
    path.lineTo(0, size.height * 1.35);

    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.35,
      size.width,
      size.height * 1.35,
    );
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawShadow(path, Color(0xff135756), SizeConfig.padding32, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
