import 'package:felloapp/core/enums/view_state_enum.dart';
import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/login/login_components/login_image.dart';
import 'package:felloapp/ui/pages/login/login_controller_vm.dart';
import 'package:felloapp/ui/pages/login/screens/mobile_input/mobile_input_vm.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/locator.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginMobileView extends StatefulWidget {
  static const int index = 0; //pager index
  const LoginMobileView({
    required this.loginModel,
    super.key,
  });
  final LoginControllerViewModel loginModel;

  @override
  State<LoginMobileView> createState() => LoginMobileViewState();
}

class LoginMobileViewState extends State<LoginMobileView> {
  late LoginMobileViewModel model;
  S locale = locator<S>();

  static TextSpan renderedWidget(String paragraph) {
    if (paragraph.isEmpty ||
        !paragraph.contains("*") ||
        !paragraph.contains("_")) {
      return const TextSpan();
    }

    String snip = '';
    List<TextSpan> groups = [];
    bool isBoldOn = false;
    bool isItalicsOn = false;
    for (final element in paragraph.runes) {
      var character = String.fromCharCode(element);
      print('We\'re at: $character');
      if (character == '*' || character == '_') {
        if (snip == '') {
          //this is the start of a text span
          if (character == '*') isBoldOn = true;
          if (character == '_') isItalicsOn = true;
        } else {
          //this is the end of either a bold text or an italics text
          if (isBoldOn) {
            print('Groupd added: bold');
            isBoldOn = false;
            groups.add(TextSpan(
              text: snip,
              style: TextStyles.sourceSans.body3.colour(UiConstants.kTextColor),
            ));
          } else if (isItalicsOn) {
            print('Groupd added: italic');
            isItalicsOn = false;
            groups.add(TextSpan(
              text: snip,
              style:
                  TextStyles.sourceSans.body3.colour(UiConstants.kTextColor3),
            ));
          } else {
            print('Groupd added: non bol;d non italic');
            groups.add(TextSpan(
              text: snip,
              style:
                  TextStyles.sourceSans.body3.colour(UiConstants.kTextColor2),
            ));
            if (character == '*') isBoldOn = true;
            if (character == '_') isItalicsOn = true;
          }
          snip = '';
        }
      } else {
        snip = snip + character;
      }
    }

    print('Children created: $groups');
    return TextSpan(children: groups);
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginMobileViewModel>(
      onModelReady: (model) {
        this.model = model;
      },
      onModelDispose: (model) {},
      builder: (ctx, model, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // SizedBox(height: SizeConfig.screenHeight! * 0.10),
            const LoginImage(),
            SizedBox(height: SizeConfig.padding8),
            Text(
              locale.obLoginHeading,
              style: TextStyles.rajdhaniB.title2,
            ),
            SizedBox(height: SizeConfig.padding20),
            // Text(
            //   'Enter mobile number to sign up',
            //   style: TextStyles.sourceSans.body3.colour(Color(0xFFBDBDBE)),
            // ),
            // SizedBox(height: SizeConfig.padding40),
            //input
            Form(
              key: model.formKey,
              child: AppTextField(
                hintText: locale.obEnterMobile,
                isEnabled: widget.loginModel.state == ViewState.Idle &&
                    widget.loginModel.loginUsingTrueCaller == false,
                focusNode: model.mobileFocusNode,
                key: model.phoneFieldKey,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                maxLength: 10,
                prefixText: "+91 ",
                onSubmit: (val) => widget.loginModel.processScreenInput(0),
                prefixTextStyle: TextStyles.sourceSans.body3,
                scrollPadding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom >
                            SizeConfig.screenHeight! / 3
                        ? SizeConfig.screenHeight! * 0.1
                        : 0),
                textStyle: TextStyles.sourceSans.body3,
                suffixIcon: model.showTickCheck
                    ? Icon(
                        Icons.done,
                        color: UiConstants.primaryColor,
                        size: SizeConfig.iconSize0,
                      )
                    : const SizedBox.shrink(),
                textEditingController: model.mobileController,
                onChanged: (value) => model.upDateCheckTick(),
                onTap: () {
                  if (widget.loginModel.loginUsingTrueCaller) return;
                  model.showAvailablePhoneNumbers();
                },
                validator: (value) => model.validateMobile(),
                margin: EdgeInsets.symmetric(
                    horizontal: SizeConfig.pageHorizontalMargins * 2),
              ),
            ),
          ],
        );
      },
    );
  }
}

class SignupHeroAsset extends StatelessWidget {
  final String asset;

  const SignupHeroAsset({
    required this.asset,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth! * 0.54,
      height: SizeConfig.screenWidth! * 0.54,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            UiConstants.tertiarySolid.withOpacity(0.6),
            UiConstants.primaryColor.withOpacity(0.4),
            UiConstants.primaryColor.withOpacity(0.2),
            UiConstants.primaryColor.withOpacity(0.05),
            Colors.transparent
          ],
          center: Alignment.center,
          tileMode: TileMode.clamp,
        ),
      ),
      alignment: Alignment.center,
      child: SvgPicture.asset(
        asset,
        height: SizeConfig.onboardingAssetsDimens,
        width: SizeConfig.onboardingAssetsDimens,
      ),
    );
  }
}

class BankingLogo extends StatelessWidget {
  final String? asset;

  const BankingLogo({
    super.key,
    this.asset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: SizeConfig.padding12),
      height: SizeConfig.screenWidth! * 0.085,
      width: SizeConfig.screenWidth! * 0.085,
      decoration: const BoxDecoration(
        color: Color(0xFF39393C),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Image.asset(
          asset!,
          height: SizeConfig.screenWidth! * 0.053,
          width: SizeConfig.screenWidth! * 0.053,
        ),
      ),
    );
  }
}
