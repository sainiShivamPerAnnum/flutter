import 'dart:ui';

import 'package:felloapp/ui/pages/login/login_components/button_4.0.dart';
import 'package:felloapp/ui/pages/login/login_components/fello_textfield.dart';
import 'package:felloapp/ui/pages/login/login_components/header_text.dart';
import 'package:felloapp/ui/pages/login/login_components/header_text2.dart';
import 'package:felloapp/ui/pages/login/user_4.0.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChooseAvatar4 extends StatelessWidget {
  const ChooseAvatar4({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        NewSquareBackground(),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: SizeConfig.screenWidth * 0.570),
            HeaderText(
              text: 'What avatar suits you the best?',
            ),
            SizedBox(height: SizeConfig.screenWidth * 0.018),
            HeaderText2(
              text: 'Swipe to choose your avatar',
            ),
            SizedBox(height: SizeConfig.screenWidth * 0.133),
            Container(
              width: SizeConfig.screenWidth,
              height: SizeConfig.screenWidth * 0.68,
              child: PageView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: 5,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (ctx, idx) {
                    return Container(
                      width: SizeConfig.screenWidth * 0.576,
                      height: SizeConfig.screenWidth * 0.576,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset('assets/svg/user_avatar_svg.svg'),
                    );
                  }),
            ),
            SizedBox(height: SizeConfig.screenWidth * 0.354),
            Center(
              child: Container(
                width: SizeConfig.screenWidth * 0.136,
                height: SizeConfig.screenWidth * 0.136,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF01656B),
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
            SizedBox(height: SizeConfig.padding16),
          ],
        ),
      ],
    );
  }
}
