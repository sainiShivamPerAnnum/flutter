import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FelloTheme {
  Color textColor1 = Colors.black;
  Color textColor2 = Colors.black54;

  static ThemeData darkMode() {
    return ThemeData(
      textSelectionTheme:
          const TextSelectionThemeData(cursorColor: UiConstants.primaryColor),
      primaryColor: const Color(0xff34C3A7),
      primarySwatch: UiConstants.kPrimaryColor,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      colorScheme: const ColorScheme.light(primary: UiConstants.primaryColor),
      textTheme: GoogleFonts.sourceSansProTextTheme(),
      chipTheme: ChipThemeData(
        backgroundColor: UiConstants.primaryLight.withOpacity(0.4),
      ),
      listTileTheme:
          const ListTileThemeData().copyWith(iconColor: Colors.white),
      unselectedWidgetColor: Colors.white,
      expansionTileTheme: const ExpansionTileThemeData()
          .copyWith(iconColor: Colors.white, collapsedIconColor: Colors.white),
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
          borderSide: const BorderSide(
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
