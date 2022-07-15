import 'package:felloapp/ui/pages/login/login_components/fello_textfield.dart';
import 'package:felloapp/ui/pages/login/login_components/header_text.dart';
import 'package:felloapp/ui/pages/login/login_components/header_text2.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class User4 extends StatelessWidget {
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
                SizedBox(height: SizeConfig.screenWidth * 0.197),
                HeaderText(
                  text: 'What do we call you?',
                ),
                SizedBox(height: SizeConfig.screenWidth * 0.010),
                HeaderText2(
                  text:
                      'Come up with a unique name to get\nstarted on yoru fello journey',
                ),
                SizedBox(height: SizeConfig.screenWidth * 0.184),
                FelloUserAvatar(),
                SizedBox(height: SizeConfig.screenWidth * 0.101),
                //input
                FelloTextField(
                  hintText: 'Your username',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.screenWidth * 0.530),
                Container(
                  width: SizeConfig.screenWidth * 0.189,
                  height: SizeConfig.screenWidth * 0.189,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF919193).withOpacity(0.10),
                  ),
                  child: Center(
                    child: Container(
                      width: SizeConfig.screenWidth * 0.136,
                      height: SizeConfig.screenWidth * 0.136,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF919193).withOpacity(0.20),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/svg/arrow_svg.svg',
                          height: SizeConfig.screenWidth * 0.066,
                          width: SizeConfig.screenWidth * 0.069,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.screenWidth * 0.109),
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

class FelloUserAvatar extends StatelessWidget {
  const FelloUserAvatar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          child: Container(
            width: SizeConfig.screenWidth * 0.560,
            height: SizeConfig.screenWidth * 0.560,
            decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
              BoxShadow(
                color: Color(0xff135756).withOpacity(0.2),
                blurRadius: 6.0,
                spreadRadius: 0.0,
                offset: Offset(
                  0.0,
                  3.0,
                ),
              ),
            ]),
          ),
        ),
        Container(
          width: SizeConfig.screenWidth * 0.501,
          height: SizeConfig.screenWidth * 0.501,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Color(0xff737373).withOpacity(0.5),
              width: 1,
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
              width: 1,
            ),
          ),
        ),
        Positioned(
          bottom: SizeConfig.screenWidth * 0.3333, //120
          right: (SizeConfig.screenWidth * 0.0550), // 23
          child: Container(
            height: SizeConfig.padding6,
            width: SizeConfig.padding6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: UiConstants.kTextColor,
            ),
          ),
        ),
        Stack(
          alignment: Alignment.center,
          children: [
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
              padding: EdgeInsets.all(
                SizeConfig.padding4,
              ),
              child: SvgPicture.asset('assets/svg/user_avatar_svg.svg'),
            ),
          ],
        ),
      ],
    );
  }
}
