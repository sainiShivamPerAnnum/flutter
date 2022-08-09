import 'package:felloapp/ui/pages/login/login_components/login_textfield.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:felloapp/ui/pages/login/level_2/level_2_vm.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Email4 extends StatelessWidget {
  const Email4({Key key, @required this.model}) : super(key: key);
  final Level2ViewModel model;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: SizeConfig.padding80),
        SvgPicture.asset('assets/svg/signUp_mail_svg.svg'),
        SizedBox(height: SizeConfig.padding24),
        Text(
          'Where do we reach you?',
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
          key: model.emailFormKey,
          child: LogInTextField(
            hintText: 'Your email ID',
            textInputType: TextInputType.emailAddress,
            controller: model.emailController,
            validator: (val) {
              if (val.isEmpty) {
                return 'Please enter your email ID';
              } else if (!RegExp(
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                  .hasMatch(val)) {
                return 'Please enter a valid email ID';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
