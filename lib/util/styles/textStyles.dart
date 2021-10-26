import 'package:felloapp/util/styles/size_config.dart';
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
  static TextStyle get bodyFont => GoogleFonts.sourceSansPro();//TextStyle(fontFamily: "Arctick");
  static TextStyle get titleFont => GoogleFonts.sourceSansPro();//TextStyle(fontFamily: "Arctick");

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

  static TextStyle get body1 => bodyFont.copyWith(fontSize: SizeConfig.body1);
  static TextStyle get body2 => bodyFont.copyWith(fontSize: SizeConfig.body2);
  static TextStyle get body3 => bodyFont.copyWith(fontSize: SizeConfig.body3);
  static TextStyle get body4 => bodyFont.copyWith(fontSize: SizeConfig.body4);
}

extension TextStyleHelpers on TextStyle {
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);
  TextStyle get light => copyWith(fontWeight: FontWeight.w300);
  TextStyle get underline => copyWith(decoration: TextDecoration.underline);
  TextStyle get overline => copyWith(decoration: TextDecoration.overline);
  TextStyle get lineThrough => copyWith(decoration: TextDecoration.lineThrough);
  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);
  TextStyle letterSpace(double value) => copyWith(letterSpacing: value);
  TextStyle weight(FontWeight weight) => copyWith(fontWeight: weight);
  TextStyle colour(Color color) => copyWith(color: color);
}
