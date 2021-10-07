import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FelloTheme {
  Color textColor1 = Colors.black;
  Color textColor2 = Colors.black54;

  static ThemeData lightMode() {
    return ThemeData(
      primaryColor: UiConstants.primaryColor,
      primarySwatch: UiConstants.kPrimaryColor,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: TextTheme(
        //For titles and headings
        headline1: GoogleFonts.montserrat(
          color: UiConstants.primaryColor,
          fontWeight: FontWeight.w700,
          fontSize: SizeConfig.title1,
        ),
        headline2: GoogleFonts.montserrat(
          color: UiConstants.primaryColor,
          fontWeight: FontWeight.w700,
          fontSize: SizeConfig.title2,
        ),
        headline3: GoogleFonts.montserrat(
          color: UiConstants.primaryColor,
          fontWeight: FontWeight.w700,
          fontSize: SizeConfig.title3,
        ),
        // headline4: GoogleFonts.montserrat(
        //   color: UiConstants.primaryColor,
        //   fontWeight: FontWeight.w500,
        //   fontSize: SizeConfig.headline4,
        // ),
        // headline5: GoogleFonts.montserrat(
        //   color: UiConstants.primaryColor,
        //   fontWeight: FontWeight.w500,
        //   fontSize: SizeConfig.headline5,
        // ),
        // headline6: GoogleFonts.montserrat(
        //   color: UiConstants.primaryColor,
        //   fontWeight: FontWeight.w500,
        //   fontSize: SizeConfig.headline6,
        // ),

        // For body and overall content
        bodyText1: GoogleFonts.montserrat(
          color: Color(0xff333333),
          fontSize: SizeConfig.body1,
        ),
        bodyText2: GoogleFonts.montserrat(
          color: Color(0xff333333),
          fontSize: SizeConfig.body2,
        ),

        // For mini texts
        subtitle1: GoogleFonts.montserrat(
          color: Color(0xff333333),
          fontSize: SizeConfig.body3,
        ),
        // subtitle2: GoogleFonts.montserrat(
        //   color: Color(0xff333333),
        //   fontSize: SizeConfig.subtitle2,
        // ),

        // Area specific
        // button: GoogleFonts.montserrat(
        //   color: Color(0xff333333),
        //   fontSize: SizeConfig.button,
        // ),
        // overline: GoogleFonts.montserrat(
        //   color: Color(0xff333333),
        //   fontSize: SizeConfig.caption,
        // ),
        // caption: GoogleFonts.montserrat(
        //   color: Color(0xff333333),
        //   fontSize: SizeConfig.caption,
        // ),
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
