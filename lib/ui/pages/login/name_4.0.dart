import 'package:felloapp/ui/pages/login/login_components/button_4.0.dart';
import 'package:felloapp/ui/pages/login/login_components/fello_textfield.dart';
import 'package:felloapp/ui/pages/login/login_components/header_text.dart';
import 'package:felloapp/ui/pages/login/login_components/header_text2.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Name4 extends StatelessWidget {
  const Name4({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
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
            SvgPicture.asset('assets/svg/signUp_hi_svg.svg'),
            SizedBox(height: SizeConfig.screenWidth * 0.028),
            HeaderText(
              text: 'What do people call you?',
            ),
            SizedBox(height: SizeConfig.screenWidth * 0.018),
            HeaderText2(
              text: 'Swipe to choose your avatar',
            ),
            SizedBox(height: SizeConfig.screenWidth * 0.098),
            //input
            FelloTextField(
              hintText: 'Your full name',
              textInputType: TextInputType.number,
            ),
            SizedBox(height: SizeConfig.screenWidth * 0.824),

            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.screenWidth * 0.093),
              child: AppPositiveBtn(
                btnText: 'Next',
                onPressed: () {},
                width: SizeConfig.screenWidth,
              ),
            ),
            SizedBox(height: SizeConfig.padding16),
          ],
        ),
      ],
    );
  }
}
