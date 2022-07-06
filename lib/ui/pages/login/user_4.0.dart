import 'package:felloapp/ui/pages/static/new_square_background.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class User4 extends StatelessWidget {
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
              Text('What do we call you?', style: TextStyles.rajdhaniB.title2),
              SizedBox(height: SizeConfig.screenWidth * 0.010),
              Text(
                'Come up with a unique name to get started on yoru fello journey',
                style: TextStyles.sourceSans.body3.colour(
                  Color(0xFFBDBDBE),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
              SizedBox(height: SizeConfig.screenWidth * 0.184),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: SizeConfig.screenWidth * 0.501,
                    height: SizeConfig.screenWidth * 0.501,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 0,
                      ),
                    ),
                  ),
                  Container(
                    width: SizeConfig.screenWidth * 0.424, // 142
                    height: SizeConfig.screenWidth * 0.424,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: UiConstants.kTextColor.withOpacity(0.2),
                        width: SizeConfig.border2,
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
                            color: Colors.white,
                            width: SizeConfig.border1,
                          ),
                        ),
                        padding: EdgeInsets.all(
                          SizeConfig.padding4,
                        ),
                        child:
                            SvgPicture.asset('assets/svg/user_avatar_svg.svg'),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.screenWidth * 0.101),
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
                    textAlign: TextAlign.center,
                    style: TextStyles.body2.colour(
                      Color(0xFFFFFFFF).withOpacity(0.5),
                    ),
                    cursorColor: Colors.grey,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(12.0),
                      hintText: 'Your username',
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
              SizedBox(height: SizeConfig.screenWidth * 0.530),
              Container(
                width: 71,
                height: 71,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF919193).withOpacity(0.10),
                ),
                child: Center(
                  child: Container(
                    width: 51,
                    height: 51,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF919193).withOpacity(0.20),
                    ),
                    child: Center(
                      child: SvgPicture.asset('assets/svg/arrow_svg.svg',
                      height: 25,
                      width: 26,
                      fit: BoxFit.cover,),
                    ),
                  ),
                ),
              ),
              SizedBox(height: SizeConfig.padding16),
            ],
          ),
        ],
      ),
    );
  }
}
