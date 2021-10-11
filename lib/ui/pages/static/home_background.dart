import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const RadialGradientLeft(),
        const RadialGradientRight(),
        const Thunderstorm(),
        const WhiteBackground(),
      ],
    );
  }
}

class WhiteBackground extends StatelessWidget {
  const WhiteBackground({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Container(
        width: SizeConfig.screenWidth,
        height: AppState.getCurrentTabIndex == 0
            ? SizeConfig.screenHeight * 0.72
            : SizeConfig.screenHeight * 0.82,
        decoration: BoxDecoration(
          color: Color(0xffF1F6FF),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
      ),
    );
  }
}

class Thunderstorm extends StatelessWidget {
  const Thunderstorm({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -20,
      height: SizeConfig.screenHeight * 0.3,
      width: SizeConfig.screenWidth,
      child: SvgPicture.asset("assets/vectors/home_bg_shape.svg"),
    );
  }
}

class RadialGradientRight extends StatelessWidget {
  const RadialGradientRight({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -SizeConfig.screenWidth / 3,
      right: -SizeConfig.screenWidth / 3,
      child: Container(
        width: SizeConfig.screenWidth / 1.2,
        height: SizeConfig.screenWidth / 1.2,
        decoration: BoxDecoration(
          //color: Color(0xffFFF5E6),
          gradient: RadialGradient(
            colors: [
              Color(0xffFED69A).withOpacity(0.8),
              UiConstants.primaryColor
              // UiConstants.primaryColor
            ],
          ),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class RadialGradientLeft extends StatelessWidget {
  const RadialGradientLeft({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -SizeConfig.screenWidth / 6,
      left: -SizeConfig.screenWidth / 3,
      child: Container(
        width: SizeConfig.screenWidth / 1.4,
        height: SizeConfig.screenWidth / 1.4,
        decoration: BoxDecoration(
          //color: Color(0xffFFF5E6),
          gradient: RadialGradient(
            colors: [
              Color(0xffFFF5E6).withOpacity(0.5),
              UiConstants.primaryColor
              // UiConstants.primaryColor
            ],
          ),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
