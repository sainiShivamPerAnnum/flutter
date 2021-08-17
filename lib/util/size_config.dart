import 'package:flutter/material.dart';

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double blockSizeHorizontal;
  static double blockSizeVertical;
  static double smallTextSize;
  static double mediumTextSize;
  static double largeTextSize;
  static double cardTitleTextSize;
  static double cardBorderRadius;
  static double globalMargin;
  static BorderRadius homeViewBorder;
  static bool isGamefirstTime;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
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
