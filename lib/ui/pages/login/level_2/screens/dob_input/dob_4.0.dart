import 'package:felloapp/ui/pages/login/login_components/login_textfield.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DOB4 extends StatelessWidget {
  const DOB4({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: SizeConfig.padding80),
        SvgPicture.asset('assets/svg/signUp_gift_svg.svg'),
        SizedBox(height: SizeConfig.padding24),
        Text(
          'When did you arrive in this\nworld?',
          style: TextStyles.rajdhaniSB.title5,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: SizeConfig.padding4),
        Text(
          'Swipe to choose your avatar',
          style: TextStyles.sourceSans.body3.colour(Color(0xFFBDBDBE)),
        ),
        SizedBox(height: SizeConfig.padding64),
        //input
        LogInTextField(
          hintText: 'Your date of birth',
          textInputType: TextInputType.number,
          controller: null,
        ),
      ],
    );
  }
}
