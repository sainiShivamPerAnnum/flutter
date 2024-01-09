import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FontSizes {
  //static double scale = SizeConfig.textScaleFactor;
  static double scale = 1;
  static double get body => 14 * scale;
  static double get bodySm => 12 * scale;

  static double get title => 16 * scale;
}

class TextStyles {
  static TextStyle get sourceSansT => GoogleFonts.sourceSansPro(
        fontWeight: FontWeight.w100,
        color: UiConstants.kTextColor,
      );
  static TextStyle get rajdhaniT => GoogleFonts.rajdhani(
        fontWeight: FontWeight.w100,
        color: UiConstants.kTextColor,
      );
  static TextStyle get sourceSansEL => GoogleFonts.sourceSansPro(
        fontWeight: FontWeight.w200,
        color: UiConstants.kTextColor,
      );
  static TextStyle get rajdhaniEL => GoogleFonts.rajdhani(
        fontWeight: FontWeight.w200,
        color: UiConstants.kTextColor,
      );
  static TextStyle get sourceSansL => GoogleFonts.sourceSansPro(
        fontWeight: FontWeight.w300,
        color: UiConstants.kTextColor,
      );
  static TextStyle get rajdhaniL => GoogleFonts.rajdhani(
        fontWeight: FontWeight.w300,
        color: UiConstants.kTextColor,
      );
  static TextStyle get sourceSans => GoogleFonts.sourceSansPro(
        fontWeight: FontWeight.w400,
        color: UiConstants.kTextColor,
      );
  static TextStyle get rajdhani => GoogleFonts.rajdhani(
        fontWeight: FontWeight.w400,
        color: UiConstants.kTextColor,
      );
  static TextStyle get sourceSansM => GoogleFonts.sourceSansPro(
        fontWeight: FontWeight.w500,
        color: UiConstants.kTextColor,
      );
  static TextStyle get rajdhaniM => GoogleFonts.rajdhani(
        fontWeight: FontWeight.w500,
        color: UiConstants.kTextColor,
      );
  static TextStyle get sourceSansSB => GoogleFonts.sourceSansPro(
        fontWeight: FontWeight.w600,
        color: UiConstants.kTextColor,
      );
  static TextStyle get rajdhaniSB => GoogleFonts.rajdhani(
        fontWeight: FontWeight.w600,
        color: UiConstants.kTextColor,
      );
  static TextStyle get sourceSansB => GoogleFonts.sourceSansPro(
        fontWeight: FontWeight.w700,
        color: UiConstants.kTextColor,
      );
  static TextStyle get rajdhaniB => GoogleFonts.rajdhani(
        fontWeight: FontWeight.w700,
        color: UiConstants.kTextColor,
      );
  static TextStyle get sourceSansEB => GoogleFonts.sourceSansPro(
        fontWeight: FontWeight.w800,
        color: UiConstants.kTextColor,
      );
  static TextStyle get rajdhaniEB => GoogleFonts.rajdhani(
        fontWeight: FontWeight.w800,
        color: UiConstants.kTextColor,
      );
  static TextStyle get sourceSansBL => GoogleFonts.sourceSansPro(
        fontWeight: FontWeight.w900,
        color: UiConstants.kTextColor,
      );
  static TextStyle get rajdhaniBL => GoogleFonts.rajdhani(
        fontWeight: FontWeight.w900,
        color: UiConstants.kTextColor,
      );

  // 3.0 Code START {Need to retire after 4.0 release}

  static TextStyle get bodyFont =>
      GoogleFonts.sourceSansPro(); //TextStyle(fontFamily: "Arctick");
  static TextStyle get titleFont =>
      GoogleFonts.sourceSansPro(); //TextStyle(fontFamily: "Arctick");

  static TextStyle get title0 =>
      titleFont.copyWith(fontSize: SizeConfig.title0);
  static TextStyle get title1 =>
      titleFont.copyWith(fontSize: SizeConfig.title1);
  static TextStyle get title2 =>
      titleFont.copyWith(fontSize: SizeConfig.title2);
  static TextStyle get title3 =>
      titleFont.copyWith(fontSize: SizeConfig.title3);
  static TextStyle get title4 =>
      titleFont.copyWith(fontSize: SizeConfig.title4);
  static TextStyle get title5 =>
      titleFont.copyWith(fontSize: SizeConfig.title5);

  static TextStyle get body0 => bodyFont.copyWith(fontSize: SizeConfig.body0);
  static TextStyle get body1 => bodyFont.copyWith(fontSize: SizeConfig.body1);
  static TextStyle get body2 => bodyFont.copyWith(fontSize: SizeConfig.body2);
  static TextStyle get body3 => bodyFont.copyWith(fontSize: SizeConfig.body3);
  static TextStyle get body4 => bodyFont.copyWith(fontSize: SizeConfig.body4);

  // 3.0 Code END {Need to retire after 4.0 release}
}

extension TextStyleHelpers on TextStyle {
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);
  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);
  TextStyle get extraBold => copyWith(fontWeight: FontWeight.w900);
  TextStyle get light => copyWith(fontWeight: FontWeight.w300);
  TextStyle get underline => copyWith(decoration: TextDecoration.underline);
  TextStyle get overline => copyWith(decoration: TextDecoration.overline);
  TextStyle get lineThrough => copyWith(decoration: TextDecoration.lineThrough);
  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);
  TextStyle letterSpace(double value) => copyWith(letterSpacing: value);
  TextStyle weight(FontWeight weight) => copyWith(fontWeight: weight);
  TextStyle colour(Color? color) => copyWith(color: color);
  TextStyle size(double size) => copyWith(fontSize: size);
  TextStyle setHeight(double height) => copyWith(height: height);
  TextStyle setOpacity(double opacity) =>
      copyWith(color: color!.withOpacity(opacity));
}

// class SansPro {
//   static TextStyle get style => GoogleFonts.sourceSansPro(color: Colors.white);
// }

// class Rajdhani {
//   static TextStyle get style => GoogleFonts.rajdhani(color: Colors.white);
// }

extension FontSize on TextStyle {
  /// Title 68 Size == 98
  TextStyle get title98 => copyWith(fontSize: SizeConfig.title98);
  /// Title 68 Size == 68
  TextStyle get title68 => copyWith(fontSize: SizeConfig.title68);

  TextStyle get title50 => copyWith(fontSize: SizeConfig.title50);

  /// Title 0 Size == 40
  TextStyle get title0 => copyWith(fontSize: SizeConfig.title0);

  /// Title 1 Size == 34
  TextStyle get title1 => copyWith(fontSize: SizeConfig.title1);

  /// Title 2 Size == 32
  TextStyle get title2 => copyWith(fontSize: SizeConfig.title2);

  /// Title 3 Size == 26
  TextStyle get title3 => copyWith(fontSize: SizeConfig.title3);

  /// Title 4 Size == 24
  TextStyle get title4 => copyWith(fontSize: SizeConfig.title4);

  /// Title 5 Size == 22
  TextStyle get title5 => copyWith(fontSize: SizeConfig.title5);

  /// Body 0 Size == 20
  TextStyle get body0 => copyWith(fontSize: SizeConfig.body0);

  /// Body 1 Size == 18
  TextStyle get body1 => copyWith(fontSize: SizeConfig.body1);

  /// Body 2 Size == 16
  TextStyle get body2 => copyWith(fontSize: SizeConfig.body2);

  /// Body 3 Size == 14
  TextStyle get body3 => copyWith(fontSize: SizeConfig.body3);

  /// Body 4 Size == 12
  TextStyle get body4 => copyWith(fontSize: SizeConfig.body4);

  /// Body 4 Size == 8
  TextStyle get body5 => copyWith(fontSize: SizeConfig.body5);
}
