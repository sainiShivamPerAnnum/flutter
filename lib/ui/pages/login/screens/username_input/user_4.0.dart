import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/login/login_components/login_textfield.dart';
import 'package:felloapp/ui/pages/login/screens/username_input/username_input_vm.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
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

class LoginUserNameView extends StatefulWidget {
  static const int index = 2;
  const LoginUserNameView({Key key}) : super(key: key);
  @override
  State<LoginUserNameView> createState() => LoginUserNameViewState();
}

class LoginUserNameViewState extends State<LoginUserNameView> {
  UsernameInputScreenViewModel model;

  @override
  Widget build(BuildContext context) {
    bool isKeyboardOpen =
        MediaQuery.of(context).viewInsets.bottom == SizeConfig.viewInsets.bottom
            ? false
            : true;
    return BaseView<UsernameInputScreenViewModel>(
      onModelReady: (model) => this.model = model,
      onModelDispose: (model) => model.disposeModel(),
      builder: (ctx, model, child) {
        return Stack(
          alignment: AlignmentDirectional.center,
          children: [
            NewSquareBackground(),
            Positioned(
              top: 0,
              child: CustomPaint(
                painter: HeaderPainter(),
                size: Size(
                  SizeConfig.screenWidth,
                  SizeConfig.screenWidth * 0.74,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: SizeConfig.padding80),
                Text(
                  'What do we call you?',
                  style: TextStyles.rajdhaniB.title2,
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  height: SizeConfig.screenWidth * 0.05,
                ),
                Text(
                  'Come up with a unique name to get\nstarted on yoru fello journey',
                  style: TextStyles.sourceSans.body3.colour(Color(0xFFBDBDBE)),
                  textAlign: TextAlign.center,
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  height: isKeyboardOpen
                      ? SizeConfig.screenWidth * 0.03
                      : SizeConfig.screenWidth * 0.186,
                ),
                FelloUserAvatar(),
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  height: isKeyboardOpen
                      ? SizeConfig.screenWidth * 0.023
                      : SizeConfig.screenWidth * 0.101,
                ),
                //input
                Form(
                  key: model.formKey,
                  child: LogInTextField(
                    focusNode: model.focusNode,
                    hintText: 'Your username',
                    textAlign: TextAlign.center,
                    controller: model.usernameController,
                    inputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-z0-9.]'))
                    ],
                    enabled: model.enabled,
                    validator: (val) {
                      if (val == null || val.isEmpty)
                        return "username cannot be empty";
                      return null;
                    },
                    onChanged: (value) {
                      model.validate();
                    },
                  ),
                ),
                SizedBox(height: SizeConfig.padding20),
                Container(
                  margin: EdgeInsets.only(top: SizeConfig.padding16),
                  padding: EdgeInsets.only(
                    bottom: SizeConfig.padding24,
                    left: SizeConfig.padding12,
                  ),
                  child: model.showResult(),
                ),
                Spacer(),
                // model.hasReferralCode
                //     ? TextFormField(
                //         controller: model.referralCodeController,
                //         onChanged: (val) {},
                //         //maxLength: 10,
                //         decoration: InputDecoration(
                //           hintText: "Enter your referral code here",
                //           hintStyle: TextStyles.body3.colour(Colors.grey),
                //         ),
                //         inputFormatters: [
                //           FilteringTextInputFormatter.allow(
                //               RegExp(r'[a-zA-Z0-9]'))
                //         ],
                //         validator: (val) {
                //           if (val.trim().length == 0 || val == null)
                //             return null;
                //           if (val.trim().length < 3 ||
                //               val.trim().length > 10)
                //             return "Invalid referral code";
                //           return null;
                //         },
                //       )
                //     : TextButton(
                //         onPressed: () {
                //           setState(() {
                //             model.hasReferralCode = true;
                //           });
                //         },
                //         child: Center(
                //           child: Text(
                //             "Have a referral code?",
                //             style: TextStyles.body2.bold
                //                 .colour(UiConstants.primaryColor),
                //           ),
                //         ),
                //       ),
                // if (model.hasReferralCode)
                //   Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Text(
                //       "Referral codes are case-sensitive",
                //       textAlign: TextAlign.start,
                //       style: TextStyles.body4.colour(Colors.black54),
                //     ),
                //   ),
                // SizedBox(height: SizeConfig.padding20),
                // Container(
                //   width: SizeConfig.screenWidth * 0.189,
                //   height: SizeConfig.screenWidth * 0.189,
                //   decoration: BoxDecoration(
                //     shape: BoxShape.circle,
                //     color: Color(0xFF919193).withOpacity(0.10),
                //   ),
                //   child: Center(
                //     child: Container(
                //       width: SizeConfig.screenWidth * 0.136,
                //       height: SizeConfig.screenWidth * 0.136,
                //       decoration: BoxDecoration(
                //         shape: BoxShape.circle,
                //         color: Color(0xFF919193).withOpacity(0.20),
                //       ),
                //       child: Center(
                //         child: SvgPicture.asset(
                //           'assets/svg/arrow_svg.svg',
                //           height: SizeConfig.screenWidth * 0.066,
                //           width: SizeConfig.screenWidth * 0.069,
                //           fit: BoxFit.cover,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(height: SizeConfig.padding20),
              ],
            ),
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
          width: SizeConfig.screenWidth * 0.6667,
          height: SizeConfig.screenWidth * 0.5333,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SizeConfig.screenWidth),
            boxShadow: [
              BoxShadow(
                color: Color(0xff135756).withOpacity(0.35),
                blurRadius: SizeConfig.padding46,
                spreadRadius: SizeConfig.padding35,
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
            'assets/svg/user_avatar_svg.svg',
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
