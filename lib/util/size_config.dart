import 'package:flutter/material.dart';

class SizeConfig {
  // reference
  static MediaQueryData _mediaQueryData;

  // dimens
  static double screenWidth;
  static double screenHeight;

  static double pixelRatio;
  static double textScaleFactor;

  static double blockSizeHorizontal;
  static double blockSizeVertical;

  // text sizes
  static double headline1;
  static double headline2;
  static double headline3;
  static double headline4;
  static double headline5;
  static double headline6;

  static double bodyText1;
  static double bodyText2;

  static double subtitle1;
  static double subtitle2;

  static double button;
  static double caption;
  static double overline;

// old text sizes
  static double smallTextSize;
  static double mediumTextSize;
  static double largeTextSize;
  static double cardTitleTextSize;

// ui size constants
  static double cardBorderRadius;
  static double globalMargin;
  static BorderRadius homeViewBorder;
  static bool isGamefirstTime;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    pixelRatio = _mediaQueryData.devicePixelRatio;
    textScaleFactor = _mediaQueryData.textScaleFactor;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    headline1 = 40;
    headline2 = 38;
    headline3 = 36;
    headline4 = 34;
    headline5 = 32;
    headline6 = 30;

    bodyText1 = 16;
    bodyText2 = 12;

    subtitle1 = 10;
    subtitle2 = 8;

    smallTextSize = blockSizeHorizontal * 2.4;
    mediumTextSize = blockSizeHorizontal * 3.2;
    largeTextSize = blockSizeHorizontal * 5;
    cardTitleTextSize = blockSizeHorizontal * 7;
    cardBorderRadius = 12;
    globalMargin = blockSizeHorizontal * 3;
    isGamefirstTime = true;
    homeViewBorder = BorderRadius.only(
      bottomLeft: Radius.circular(SizeConfig.blockSizeHorizontal * 10),
      bottomRight: Radius.circular(SizeConfig.blockSizeHorizontal * 10),
    );
  }
}
