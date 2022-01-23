import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeBackground extends StatelessWidget {
  final WhiteBackground whiteBackground;
  final Widget child;
  HomeBackground({this.whiteBackground, this.child});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: SizeConfig.screenWidth,
          height: SizeConfig.screenHeight / 2,
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
            color: UiConstants.primaryColor,
          ),
        ),
        Positioned(
          top: 0,
          child: Image.asset(
            Assets.splashBackground,
            width: SizeConfig.screenWidth,
            fit: BoxFit.fitWidth,
          ),
        ),
        // const RadialGradientLeft(),
        // const RadialGradientRight(),
        // const Thunderstorm(),
        if (whiteBackground != null) whiteBackground,
        child,
      ],
    );
  }
}

class WhiteBackground extends StatelessWidget {
  const WhiteBackground({this.height, this.color});
  final double height;
  final Color color;
  @override
  Widget build(BuildContext context) {
    var query = MediaQuery.of(context);
    return Positioned(
      bottom: 0,
      child: Container(
        width: SizeConfig.screenWidth,
        height: (SizeConfig.screenHeight - query.padding.top) - height,
        decoration: BoxDecoration(
          color: color ?? UiConstants.scaffoldColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(SizeConfig.roundness40),
            topRight: Radius.circular(SizeConfig.roundness40),
          ),
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
      child: SvgPicture.asset(
        "assets/vectors/home_bg_shape.svg",
        fit: BoxFit.cover,
      ),
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
