import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FelloTheme {
  Color textColor1 = Colors.black;
  Color textColor2 = Colors.black54;

  static ThemeData darkMode() {
    return ThemeData(
      textSelectionTheme:
          TextSelectionThemeData(cursorColor: UiConstants.primaryColor),
      primaryColor: Color(0xff34C3A7),
      primarySwatch: UiConstants.kPrimaryColor,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      colorScheme: ColorScheme.light(primary: UiConstants.primaryColor),
      textTheme: GoogleFonts.sourceSansProTextTheme(),
      chipTheme: ChipThemeData(
        backgroundColor: UiConstants.primaryLight.withOpacity(0.4),
      ),
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
