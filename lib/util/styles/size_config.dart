import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SizeConfig {
  const SizeConfig._();
  // reference
  static late MediaQueryData _mediaQueryData;

  // dimens
  static double? screenWidth;
  static double? screenHeight;
  static EdgeInsets? padding;
  static double? safeScreenHeight;

  static double? pixelRatio;
  static double? textScaleFactor;

  static late double blockSizeHorizontal;
  static double? blockSizeVertical;

// old text sizes
  static double? smallTextSize;
  static double? mediumTextSize;
  static double? largeTextSize;
  static late double cardTitleTextSize;

// ui size constants
  static late double cardBorderRadius;
  static late double globalMargin;
  static double? scaffoldMargin;
  static late EdgeInsets viewInsets;
  static EdgeInsets? viewPadding;
  static late double fToolBarHeight;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    safeScreenHeight = _mediaQueryData.size.height -
        _mediaQueryData.padding.top -
        _mediaQueryData.padding.bottom;
    pixelRatio = _mediaQueryData.devicePixelRatio;
    textScaleFactor = _mediaQueryData.textScaleFactor;
    viewInsets = _mediaQueryData.padding;
    blockSizeHorizontal = screenWidth! / 100;
    blockSizeVertical = screenHeight! / 100;
    smallTextSize = blockSizeHorizontal * 2.4;
    mediumTextSize = blockSizeHorizontal * 3.2;
    largeTextSize = blockSizeHorizontal * 5;
    cardTitleTextSize = blockSizeHorizontal * 7;
    cardBorderRadius = 12;
    globalMargin = blockSizeHorizontal * 3;
    scaffoldMargin = blockSizeHorizontal * 5;
    fToolBarHeight = viewInsets.top + kToolbarHeight;
    padding = _mediaQueryData.padding;
    viewPadding = _mediaQueryData.viewPadding;
  }

  static double get title98 => 98.sp; //98
  static double get title68 => 68.sp; //68
  static double get title50 => 50.sp; //50
  static double get title0 => 40.sp; //40
  static double get title1 => 35.sp; //35
  static double get title2 => 30.sp; //30
  static double get title3 => 25.sp; //25
  static double get title4 => 24.sp; //24
  static double get title5 => 22.sp; //22
  static double get body0 => 20.sp; //20
  static double get body1 => 18.sp; //18
  static double get body2 => 16.sp; //16
  static double get body3 => 14.sp; //14
  static double get body4 => 12.sp; //12;
  static double get body5 => 8.sp; //8;
  static double get body6 => 10.sp; //10;

  // ICON SIZES
  static double get iconSize0 => 20.r; //20
  static double get iconSize1 => 16.r; //16
  static double get iconSize2 => 14.r; //14
  static double get iconSize3 => 12.r; //12
  static double get iconSize4 => 8.r; //8
  static double get iconSize5 => 32.r; //32
  static double get iconSize6 => 50.r; //50
  static double get iconSize7 => 70.r; //70
  static double get iconSize8 => 28.r; //28

  // PADDINGS
  static double get padding1 => 1.w;
  static double get padding2 => 2.w;
  static double get padding3 => 3.w;
  static double get padding4 => 4.w;
  static double get padding6 => 6.w;

  static double get padding8 => 8.w;

  static double get padding10 => 10.w;

  static double get padding12 => 12.w;

  static double get padding14 => 14.w;

  static double get padding16 => 16.w;

  static double get padding18 => 18.w;

  static double get padding20 => 20.w;

  static double get padding22 => 22.w;

  static double get padding24 => 24.w;

  static double get padding25 => 25.w;

  static double get padding26 => 26.w;

  static double get padding28 => 28.w;

  static double get padding30 => 30.w;

  static double get padding32 => 32.w;

  static double get padding33 => 33.w;
  static double get padding34 => 34.w;
  static double get padding35 => 35.w;
  static double get padding36 => 36.w;
  static double get padding38 => 38.w;
  static double get padding40 => 40.w;
  static double get padding42 => 42.w;
  static double get padding44 => 44.w;
  static double get padding46 => 46.w;
  static double get padding48 => 48.w;
  static double get padding50 => 50.w;
  static double get padding52 => 52.w;
  static double get padding54 => 54.w;
  static double get padding56 => 56.w;
  static double get padding58 => 58.w;
  static double get padding60 => 60.w;
  static double get padding62 => 62.w;
  static double get padding64 => 64.w;
  static double get padding66 => 66.w;
  static double get padding68 => 68.w;
  static double get padding70 => 70.w;
  static double get padding72 => 72.w;
  static double get padding74 => 74.w;
  static double get padding76 => 76.w;
  static double get padding78 => 78.w;
  static double get padding80 => 80.w;
  static double get padding82 => 82.w;
  static double get padding84 => 84.w;
  static double get padding86 => 86.w;
  static double get padding88 => 88.w;
  static double get padding90 => 90.w;
  static double get padding100 => 100.w;
  static double get padding104 => 104.w;
  static double get padding108 => 108.w;
  static double get padding112 => 112.w;
  static double get padding116 => 116.w;
  static double get padding120 => 120.w;
  static double get padding124 => 124.w;
  static double get padding128 => 128.w;
  static double get padding132 => 132.w;
  static double get padding136 => 136.w;
  static double get padding140 => 140.w;
  static double get padding144 => 144.w;
  static double get padding148 => 148.w;
  static double get padding152 => 152.w;
  static double get padding156 => 156.w;
  static double get padding160 => 160.w;
  static double get padding164 => 164.w;
  static double get padding168 => 168.w;
  static double get padding172 => 172.w;
  static double get padding175 => 175.w;
  static double get padding176 => 176.w;
  static double get padding180 => 180.w;
  static double get padding184 => 184.w;
  static double get padding188 => 188.w;
  static double get padding192 => 192.w;
  static double get padding196 => 196.w;
  static double get padding200 => 200.w;
  static double get padding232 => 232.w;
  static double get padding252 => 252.w;
  static double get padding275 => 275.w;
  static double get padding300 => 300.w;
  static double get padding325 => 325.w;
  static double get padding350 => 350.w;
  static double get padding436 => 436.w;

  // MARGINS
  static double get pageHorizontalMargins => screenWidth! * 0.0579; //

  //BORDER RADIUS
  static double get roundness2 => 2.r;
  static double get roundness8 => 8.r; //8
  static double get roundness5 => 5.r; //5
  static double get roundness12 => 12.r; //12
  static double get roundness16 => 16.r; //12
  static double get roundness24 => 24.r; //24
  static double get roundness32 => 32.r; //32
  static double get roundness40 => 40.r; //40
  static double get roundness56 => 56.r; //56
  static double get roundness112 => 112.r; //56

  //Navbar
  static double get navBarWidth =>
      SizeConfig.screenWidth! - (SizeConfig.pageHorizontalMargins * 2);
  static double get navBarHeight =>
      kBottomNavigationBarHeight +
      math.max(SizeConfig.viewPadding!.bottom, 8.h);

  //Avatar
  static double get avatarRadius => screenWidth! * 0.048;
  static double get notificationAvatarRadius => screenWidth! * 0.06;
  //BORDER SIZES
  static double get border0 => 0.5.w; // 0.5
  static double get border1 => 1.w; // 1
  static double get border2 => 1.5.w; // 1.5
  static double get border3 => 2.w; // 2
  static double get border4 => 2.5.w; // 2.5

  // Button Border Radius
  static double get buttonBorderRadius => screenWidth! * 0.0139; // 5
}
