import 'package:felloapp/ui/pages/login/login_components/fello_textfield.dart';
import 'package:felloapp/ui/pages/login/login_components/header_text.dart';
import 'package:felloapp/ui/pages/login/login_components/header_text2.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUp4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isKeyboardOpen =
        MediaQuery.of(context).viewInsets.bottom == SizeConfig.viewInsets.bottom
            ? false
            : true;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            NewSquareBackground(),
            Positioned(
              top: 0,
              child: Container(
                height: SizeConfig.screenHeight * 0.6,
                width: SizeConfig.screenWidth,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xff135756),
                      UiConstants.kBackgroundColor,
                    ],
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: SizeConfig.screenWidth * 0.186),
                SvgPicture.asset('assets/svg/flag_svg.svg'),
                SizedBox(height: SizeConfig.screenWidth * 0.028),
                HeaderText(
                  text: 'Hey!',
                ),
                SizedBox(height: SizeConfig.screenWidth * 0.018),
                HeaderText2(
                  text: 'Enter mobile number to sign up',
                ),
                SizedBox(height: SizeConfig.screenWidth * 0.098),
                //input
                FelloTextField(
                  hintText: '000000',
                  textInputType: TextInputType.number,
                ),
                SizedBox(height: SizeConfig.screenWidth * 0.736),
                Text(
                  '100% Safe & Secure',
                  style: TextStyles.sourceSans.body3.colour(Color(0xFFBDBDBE)),
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
                SizedBox(height: SizeConfig.padding16),
              ],
            ),
            if (isKeyboardOpen)
              Positioned(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                child: Container(
                  width: SizeConfig.screenWidth,
                  height: 50,
                  color: Colors.black54,
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.pageHorizontalMargins),
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Done",
                    style:
                        TextStyles.body2.bold.colour(UiConstants.primaryColor),
                  ),
                ),
              ),
          ],
        ),
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
      height: SizeConfig.screenWidth * 0.082,
      width: SizeConfig.screenWidth * 0.082,
      decoration: BoxDecoration(
        color: Color(0xFF39393C),
        shape: BoxShape.circle,
      ),
      child: Image.asset(
        asset,
        fit: BoxFit.cover,
        height: SizeConfig.screenWidth * 0.053,
        width: SizeConfig.screenWidth * 0.053,
      ),
    );
  }
}
