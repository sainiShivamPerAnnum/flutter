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

// old text sizes
  static double smallTextSize;
  static double mediumTextSize;
  static double largeTextSize;
  static double cardTitleTextSize;

// ui size constants
  static double cardBorderRadius;
  static double globalMargin;
  static double scaffoldMargin;
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
    smallTextSize = blockSizeHorizontal * 2.4;
    mediumTextSize = blockSizeHorizontal * 3.2;
    largeTextSize = blockSizeHorizontal * 5;
    cardTitleTextSize = blockSizeHorizontal * 7;
    cardBorderRadius = 12;
    globalMargin = blockSizeHorizontal * 3;
    scaffoldMargin = blockSizeHorizontal * 5;
    isGamefirstTime = true;
    homeViewBorder = BorderRadius.only(
      bottomLeft: Radius.circular(SizeConfig.blockSizeHorizontal * 10),
      bottomRight: Radius.circular(SizeConfig.blockSizeHorizontal * 10),
    );
    print("Screen Height: $screenHeight");
    print("Screen Width: $screenWidth");
  }

  // TEXT SIZES
  static double get title1 => 36;
  static double get title2 => 32;
  static double get title3 => 28;
  static double get title4 => screenWidth * 0.058; //24
  static double get title5 => screenWidth * 0.048; //20
  static double get body1 => 18;
  static double get body2 => screenWidth * 0.038; // 16
  static double get body3 => screenWidth * 0.033; //14
  static double get body4 => screenWidth * 0.028; //12;

  // ICON SIZES
  static double get iconSize1 => screenWidth * 0.048; //16
  static double get iconSize2 => screenWidth * 0.033; //14
  static double get iconSize3 => screenWidth * 0.028; //12

  // PADDINGS
  static double get padding4 => screenWidth * 0.0096;
  static double get padding6 => screenWidth * 0.014;
  static double get padding8 => screenWidth * 0.019;
  static double get padding12 => screenWidth * 0.029;
  static double get padding16 => screenWidth * 0.038;
  static double get padding24 => screenWidth * 0.058;

  // MARGINS
  static double get pageHorizontalMargins => screenWidth * 0.0579;

  //BORDER RADIUS

  static double get roundness32 => screenWidth * 0.077; //32
  static double get roundness56 => screenWidth * 0.135; //56
  static double get roundness40 => screenWidth * 0.096; //40

  //SPECIFIC

  static double get navBarHeight => screenWidth * 0.212;
  static double get avatarRadius => screenWidth * 0.048;

  // static double get headline1 => 40;
  // static double get headline2 => 38;
  // static double get headline3 => 36;
  // static double get headline4 => 34;
  // static double get headline5 => 32;
  // static double get headline6 => 30;

  // static double get bodyText1 => 18;
  // static double get bodyText2 => 14;

  // static double get subtitle1 => 10;
  // static double get subtitle2 => 8;

  // static double get button => 16;
  // static double get caption => 12;
  // static double get overline => 16;
}
