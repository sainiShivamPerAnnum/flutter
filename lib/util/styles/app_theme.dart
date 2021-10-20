import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FelloTheme {
  Color textColor1 = Colors.black;
  Color textColor2 = Colors.black54;

  static ThemeData lightMode() {
    return ThemeData(
      primaryColor: Color(0xff34C3A7),
      primarySwatch: UiConstants.kPrimaryColor,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      colorScheme: ColorScheme.fromSwatch(accentColor: Colors.white),
      textTheme: GoogleFonts.montserratTextTheme(),
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: UiConstants.primaryColor.withOpacity(0.3), width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.3), width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: UiConstants.primaryColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red.withOpacity(0.3),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red.withOpacity(0.3),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      // elevatedButtonTheme: ElevatedButtonThemeData(
      //   style: ElevatedButton.styleFrom(
      //     primary: UiConstants.primaryColor,
      //     minimumSize: Size(double.infinity, 50),
      //     textStyle:
      //         TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      //     padding: EdgeInsets.all(4),
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(8),
      //     ),
      //   ),
      // ),
      // textButtonTheme: TextButtonThemeData(
      //   style: TextButton.styleFrom(
      //     textStyle: TextStyle(
      //       color: Colors.black,
      //       fontWeight: FontWeight.w500,
      //     ),
      //     primary: UiConstants.primaryColor,
      //     shadowColor: UiConstants.primaryLight,
      //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      //   ),
      // ),
    );
  }
}

extension TextStyleHelpers on TextStyle {
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);
  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);
  TextStyle letterSpace(double value) => copyWith(letterSpacing: value);
  TextStyle weight(FontWeight weight) => copyWith(fontWeight: weight);
  TextStyle colour(Color color) => copyWith(color: color);
}
