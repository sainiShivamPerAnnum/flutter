import 'package:felloapp/ui/architecture/base_view.dart';
import 'package:felloapp/ui/pages/login/login_components/login_textfield.dart';
import 'package:felloapp/ui/pages/login/screens/mobile_input/mobile_input_vm.dart';
import 'package:felloapp/ui/pages/static/app_widget.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginMobileView extends StatefulWidget {
  static const int index = 0; //pager index
  const LoginMobileView({Key key}) : super(key: key);
  @override
  State<LoginMobileView> createState() => LoginMobileViewState();
}

class LoginMobileViewState extends State<LoginMobileView> {
  LoginMobileViewModel model;
  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return BaseView<LoginMobileViewModel>(
      onModelReady: (model) {
        this.model = model;
      },
      onModelDispose: (model) {},
      builder: (ctx, model, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: SizeConfig.padding80),
            SignupHeroAsset(asset: 'assets/svg/flag_svg.svg'),
            Text(
              'Login/Signup',
              style: TextStyles.rajdhaniB.title2,
            ),
            SizedBox(height: SizeConfig.padding32),
            // Text(
            //   'Enter mobile number to sign up',
            //   style: TextStyles.sourceSans.body3.colour(Color(0xFFBDBDBE)),
            // ),
            // SizedBox(height: SizeConfig.padding40),
            //input
            Form(
              key: model.formKey,
              child: AppTextField(
                hintText: ' Enter your 10 digit phone number',
                isEnabled: true,
                focusNode: model.mobileFocusNode,
                key: model.phoneFieldKey,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                maxLength: 10,
                prefixText: "+91 ",
                prefixTextStyle: TextStyles.sourceSans.body3,
                scrollPadding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom >
                            SizeConfig.screenHeight / 3
                        ? SizeConfig.screenHeight * 0.1
                        : 0),
                textStyle: TextStyles.sourceSans.body3,
                textEditingController: model.mobileController,
                onTap: model.showAvailablePhoneNumbers,
                validator: (value) => model.validateMobile(),
                margin: EdgeInsets.symmetric(
                    horizontal: SizeConfig.pageHorizontalMargins * 2),
              ),
            ),
            Spacer(),
            if (!isKeyboardOpen)
              Column(
                children: [
                  Text(
                    '100% Safe & Secure',
                    style:
                        TextStyles.sourceSans.body3.colour(Color(0xFFBDBDBE)),
                  ),
                  SizedBox(height: SizeConfig.padding16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BankingLogo(
                        asset: 'assets/images/augmont_logo.png',
                      ),
                      BankingLogo(
                        asset: 'assets/images/icici_logo.png',
                      ),
                      BankingLogo(
                        asset: 'assets/images/cbi_logo.png',
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 16, 10, 0),
                    child: RichText(
                      text: new TextSpan(
                        children: [
                          new TextSpan(
                            text: 'By continuing, you agree to our ',
                            style: TextStyles.sourceSans.body3
                                .colour(UiConstants.kTextColor2),
                          ),
                          new TextSpan(
                            text: 'Terms of Service',
                            style: TextStyles.sourceSans.body3.underline
                                .colour(UiConstants.kTextColor),
                            recognizer: new TapGestureRecognizer()
                              ..onTap = () {
                                model.onTermsAndConditionsClicked();
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

            SizedBox(
              height: SizeConfig.screenWidth * 0.1 +
                  MediaQuery.of(context).viewInsets.bottom,
            ),
          ],
        );
      },
    );
  }
}

class SignupHeroAsset extends StatelessWidget {
  final String asset;
  const SignupHeroAsset({Key key, @required this.asset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth * 0.54,
      height: SizeConfig.screenWidth * 0.54,
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
  final String asset;

  const BankingLogo({Key key, this.asset}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: SizeConfig.padding12),
      height: SizeConfig.screenWidth * 0.085,
      width: SizeConfig.screenWidth * 0.085,
      decoration: BoxDecoration(
        color: Color(0xFF39393C),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Image.asset(
          asset,
          height: SizeConfig.screenWidth * 0.053,
          width: SizeConfig.screenWidth * 0.053,
        ),
      ),
    );
  }
}
