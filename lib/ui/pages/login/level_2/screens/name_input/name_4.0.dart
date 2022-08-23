import 'package:felloapp/ui/pages/login/level_2/complete_profile_vm.dart';
import 'package:felloapp/ui/pages/login/login_components/login_textfield.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Name4 extends StatelessWidget {
  const Name4({Key key, @required this.model}) : super(key: key);
  final CompleteProfileViewModel model;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: SizeConfig.padding80),
        SvgPicture.asset('assets/svg/signUp_hi_svg.svg'),
        SizedBox(height: SizeConfig.padding24),
        Text(
          'What do people call you?',
          style: TextStyles.rajdhaniSB.title5,
        ),
        SizedBox(height: SizeConfig.padding4),
        Text(
          'Swipe to choose your avatar',
          style: TextStyles.sourceSans.body3.colour(Color(0xFFBDBDBE)),
        ),
        SizedBox(height: SizeConfig.padding64),
        //input
        Form(
          key: model.nameFormKey,
          child: LogInTextField(
            hintText: 'Your full name',
            controller: model.nameController,
            validator: (val) {
              if (val.isEmpty) {
                return 'Please enter your full name';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
