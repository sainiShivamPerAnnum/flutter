import 'dart:ui' as ui;

import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/login/login_components/login_image.dart';
import 'package:felloapp/ui/pages/login/login_controller_vm.dart';
import 'package:felloapp/ui/pages/login/screens/name_input/name_input_vm.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/haptic.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

  const LoginNameInputView({required this.loginModel, Key? key})
      : super(key: key);

  @override
  State<LoginNameInputView> createState() => LoginUserNameViewState();
}

class LoginUserNameViewState extends State<LoginNameInputView> {
  late LoginNameInputViewModel model;

  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
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
            const LoginImage(),
            SizedBox(height: SizeConfig.padding8),
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text(
                    locale.obEnterDetails,
                    style: TextStyles.rajdhaniB.title2,
                  ),
                  Text(
                    locale.obEnterDetailsTitle,
                    style: TextStyles.body3.colour(UiConstants.kTextColor2),
                  )
                ],
              ),
            ),

            SizedBox(height: SizeConfig.padding20),

            //input
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: SizeConfig.pageHorizontalMargins * 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextFieldLabel(locale.obNameLabel, leftPadding: 0),
                  Form(
                    key: model.formKey,
                    child: AppTextField(
                      textEditingController: model.nameController,
                      isEnabled: model.enabled,
                      maxLength: 256,
                      hintText: locale.obNameHint,
                      focusNode: model.nameFocusNode,
                      textCapitalization: TextCapitalization.words,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[a-zA-Z ]'),
                        ),
                      ],
                      onSubmit: (_) => widget.loginModel.processScreenInput(2),
                      // suffix: SizedBox(),
                      validator: (value) {
                        if (value != null && value.trim().isNotEmpty) {
                          if (value.trim().length < 3) {
                            return locale.obNameRules;
                          }
                          return null;
                        } else {
                          return locale.obNameAsPerPan;
                        }
                      },
                    ),
                  ),
                  SizedBox(height: SizeConfig.padding20),
                  AppTextFieldLabel(locale.obGenderLabel, leftPadding: 0),
                  Row(
                    children: List.generate(
                      3,
                      (index) {
                        return Expanded(
                          child: Container(
                            margin: index == 0
                                ? EdgeInsets.only(right: SizeConfig.padding8)
                                : index == 1
                                    ? EdgeInsets.symmetric(
                                        horizontal: SizeConfig.padding4)
                                    : EdgeInsets.only(
                                        left: SizeConfig.padding8),
                            child: OutlinedButton(
                              onPressed: () {
                                Haptic.vibrate();
                                setState(() {
                                  model.genderValue = index;
                                });
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  model.genderValue == index
                                      ? UiConstants.primaryColor
                                          .withOpacity(0.1)
                                      : UiConstants.kTextFieldColor,
                                ),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        SizeConfig.roundness8),
                                    side: BorderSide(
                                        style: BorderStyle.solid,
                                        width: 2,
                                        color: (model.genderValue == index)
                                            ? UiConstants.primaryColor
                                            : Colors.black),
                                  ),
                                ),
                              ),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.padding12,
                                  vertical: SizeConfig.padding12,
                                ),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    model.genderOptions[index],
                                    style: TextStyles.sourceSans.body3.colour(
                                      (model.genderValue == index)
                                          ? UiConstants.primaryColor
                                          : UiConstants.kTextColor2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: SizeConfig.padding14),
                  model.hasReferralCode
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: SizeConfig.padding10),
                            AppTextFieldLabel(
                              locale.refCodeOptional,
                              leftPadding: 0,
                            ),
                            AppTextField(
                              textEditingController:
                                  model.referralCodeController,
                              onChanged: (val) {},
                              maxLength: 6,
                              isEnabled: true,
                              scrollPadding:
                                  EdgeInsets.only(bottom: SizeConfig.padding80),
                              hintText: locale.refCodeHint,
                              textAlign: TextAlign.left,
                              onSubmit: (_) =>
                                  widget.loginModel.processScreenInput(2),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[a-zA-Z0-9]'),
                                )
                              ],
                              validator: (val) {
                                if (val!.trim().isEmpty) return null;
                                if (val.trim().length < 6 ||
                                    val.trim().length > 10) {
                                  return locale.refInvalid;
                                }
                                return null;
                              },
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MaterialButton(
                              onPressed: () {
                                if (widget.loginModel.state == ViewState.Busy) {
                                  return;
                                }
                                model.hasReferralCode = true;
                              },
                              child: Padding(
                                padding: EdgeInsets.all(SizeConfig.padding8),
                                child: Text(
                                  locale.refHaveReferral,
                                  style: TextStyles.body2.bold
                                      .colour(UiConstants.kPrimaryColor),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        )
                ],
              ),
            ),

            Container(
              width: SizeConfig.screenWidth,
              margin: EdgeInsets.symmetric(
                  horizontal: SizeConfig.pageHorizontalMargins * 2,
                  vertical: SizeConfig.padding12),
              alignment: Alignment.center,
              child: Text(
                locale.obIsOlder,
                textAlign: TextAlign.center,
                style: TextStyles.body3.colour(
                  UiConstants.kTextColor2,
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
  const FelloUserAvatar({Key? key, this.child}) : super(key: key);
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: SizeConfig.screenWidth! * 0.54,
          height: SizeConfig.screenWidth! * 0.54,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SizeConfig.screenWidth!),
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
          width: SizeConfig.screenWidth! * 0.501,
          height: SizeConfig.screenWidth! * 0.501,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xff737373).withOpacity(0.5),
              width: SizeConfig.border1,
            ),
          ),
        ),
        Container(
          width: SizeConfig.screenWidth! * 0.424, // 142
          height: SizeConfig.screenWidth! * 0.424,
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
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: UiConstants.kTextColor,
            ),
          ),
        ),
        Container(
          width: SizeConfig.screenWidth! * 0.32,
          height: SizeConfig.screenWidth! * 0.32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xffD9D9D9),
              width: SizeConfig.border1,
            ),
          ),
        ),
        child ??
            SvgPicture.asset(
              Assets.cvtar2,
              height: SizeConfig.screenWidth! * 0.3067,
              width: SizeConfig.screenWidth! * 0.3067,
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
        const Offset(0, 0),
        Offset(0, size.height * 0.97),
        [
          const Color(0xff135756),
          UiConstants.kBackgroundColor,
        ],
      );

    final path = Path()
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

    canvas.drawShadow(
        path, const Color(0xff135756), SizeConfig.padding32, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
