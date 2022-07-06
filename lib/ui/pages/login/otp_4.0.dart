import 'package:felloapp/ui/elements/pin_input_custom_text_field.dart';
import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OTP4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
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
              Text('Hey!', style: TextStyles.rajdhaniB.title2),
              SizedBox(height: SizeConfig.screenWidth * 0.018),
              Text(
                'Kindly enter the OTP shared with you',
                style: TextStyles.sourceSans.body3.colour(Color(0xFFBDBDBE)),
              ),
              SizedBox(height: SizeConfig.screenWidth * 0.098),
              //input
              Padding(
                padding: EdgeInsets.only(
                  left: SizeConfig.screenWidth*0.104,
                  right:  SizeConfig.screenWidth*0.136,
                ),
                child: PinInputTextField(
                  autoFocus: true,
                  pinLength: 5,
                  decoration: BoxLooseDecoration(
                    solidColor: Color(0xff6E6E7E).withOpacity(0.5),
                    strokeColor: Color(0xFFFFFFFF).withOpacity(0.5),
                    strokeWidth: 0,
                    textStyle: TextStyles.sourceSansSB.body1.colour(
                      Color(0xFFFFFFFF).withOpacity(0.5),
                    ),
                  ),
                  onChanged: (value) {
                    if (value.length == 5) {}
                  },
                ),
              ),
               SizedBox(height: SizeConfig.screenWidth * 0.050),
              RichText(
                text: TextSpan(
                  text: 'Didn\’t receive?',
                  style:
                      TextStyles.sourceSansSB.body3.colour(Color(0xFFBDBDBE)),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'RESEND',
                        style: TextStyles.sourceSans.body2
                            .colour(Color(0xFF34C3A7))),
                  ],
                ),
              ),
              SizedBox(height: SizeConfig.screenWidth * 0.736),
            ],
          ),
        ],
      ),
    );
  }
}
