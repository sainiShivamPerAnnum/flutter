import 'package:flutter/material.dart';

class UiConstants {
  UiConstants._();

  static final Color primaryColor = const Color(0xff2EB19F);
  static final Color accentColor = const Color(0xff333333);
  static final Color darkPrimaryColor = const Color.fromARGB(255, 58, 120, 255);
  static final Color secondaryColor = const Color.fromARGB(255, 241, 227, 243);
  // static final Color chipColor = const Color.fromARGB(255, 241, 227, 243);
  static final Color chipColor = Colors.grey[200];
  static final Color positiveAlertColor = Colors.blueAccent[400];
  static final Color negativeAlertColor = Colors.blueGrey;
//  static final Color secondaryColor = Colors.greenAccent;
  static final Color spinnerColor = Colors.grey[400];
  static final Color spinnerColor2 = Colors.grey[200];
  //dimens
// MODES
// Dark Mode
//   static final Color backgroundColor = Colors.black;
//   static final Color bottomNavBarColor = Color(0xff232931);
//   static final Color titleTextColor = Color(0xff393e46);
//   static final Color textColor = Colors.white;
  //Color(0xff393e46);
// Light Mode
  static final Color backgroundColor = Color(0xfff1f1f1);
  static final Color bottomNavBarColor = Colors.white;
  static final Color titleTextColor = Colors.white;
  static final Color textColor = Colors.black87;

  static final double dialogRadius = 20.0;
  static const double padding = 16.0;
  static const double avatarRadius = 96.0;

  static List<Color> boardColors = [Colors.greenAccent];

  static const MaterialColor kPrimaryColor = MaterialColor(
    0xff2EB19F,
    const <int, Color>{
      50: const Color(0xff2EB19F),
      100: const Color(0xff2EB19F),
      200: const Color(0xff2EB19F),
      300: const Color(0xff2EB19F),
      400: const Color(0xff2EB19F),
      500: const Color(0xff2EB19F),
      600: const Color(0xff2EB19F),
      700: const Color(0xff2EB19F),
      800: const Color(0xff2EB19F),
      900: const Color(0xff2EB19F),
    },
  );
}
