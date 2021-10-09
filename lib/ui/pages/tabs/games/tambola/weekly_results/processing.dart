import 'package:felloapp/util/styles/size_config.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PrizeProcessing extends StatelessWidget {
  const PrizeProcessing({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5DFC3),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(
                flex: 1,
              ),
              Text(
                "Prize Day",
                style: TextStyle(
                    fontFamily: "Cucciolo",
                    color: Color(0xff272727),
                    fontSize: SizeConfig.cardTitleTextSize * 1.6,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                    shadows: [
                      BoxShadow(
                          color: Color(0xffFCB260).withOpacity(0.8),
                          offset: Offset(1, 1),
                          blurRadius: 5,
                          spreadRadius: 5)
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "It's Sunday, and we are processing your tickets to see if any of your tickets won or not ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: SizeConfig.mediumTextSize,
                      height: 1.5,
                      letterSpacing: 2),
                ),
              ),
              LottieBuilder.asset(
                "images/Tambola/process.json",
                width: SizeConfig.screenWidth * 0.5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "PROCESSING...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xffFCB260),
                      fontSize: SizeConfig.largeTextSize,
                      height: 1.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 5),
                ),
              ),
              Spacer(
                flex: 2,
              )
            ],
          ),
        ),
      ),
    );
  }
}
