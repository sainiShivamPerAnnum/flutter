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
                'Enter mobile number to sign up',
                style: TextStyles.sourceSans.body3.colour(Color(0xFFBDBDBE)),
              ),
              SizedBox(height: SizeConfig.screenWidth * 0.098),
              //input
              Padding(
                padding: EdgeInsets.only(left: 39, right: 41),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF161617),
                        Colors.transparent,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.0, 0.3],
                      // tileMode: TileMode.repeated,
                    ),
                    borderRadius: BorderRadius.circular(SizeConfig.roundness5),
                    // color: UiConstants.kPrimaryColor,
                  ),
                  child: TextField(
                    style: TextStyles.body2.colour(
                      Color(0xFFFFFFFF).withOpacity(0.5),
                    ),
                    cursorColor: Colors.grey,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(12.0),
                      hintText: '000000',
                      hintStyle: TextStyles.body2
                          .colour(Color(0xFFFFFFFF).withOpacity(0.5)),
                      filled: true,
                      fillColor: Color(0xff6E6E7E).withOpacity(0.5),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFFFFFFF).withOpacity(0.5),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFFFFFFF).withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: SizeConfig.screenWidth * 0.736),
              Text(
                '100% Safe & Secure',
                style: TextStyles.sourceSans.body3.colour(Color(0xFFBDBDBE)),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BankingLogo(
                    asset: Assets.ludoGameAsset,
                  ),
                  BankingLogo(
                    asset: Assets.ludoGameAsset,
                  ),
                  BankingLogo(
                    asset: Assets.ludoGameAsset,
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
                  style: TextStyles.body2.bold.colour(UiConstants.primaryColor),
                ),
              ),
            ),
        ],
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
      height: 31,
      width: 31,
      decoration: BoxDecoration(
        color: Color(0xFF39393C),
        shape: BoxShape.circle,
      ),
      child: SvgPicture.asset(
        asset,
        fit: BoxFit.cover,
        height: 20,
        width: 20,
      ),
    );
  }
}
