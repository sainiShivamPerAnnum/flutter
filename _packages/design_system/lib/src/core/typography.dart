import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class TextStyleV2 {
  const TextStyleV2._();

  static final h1 = GoogleFonts.rajdhani(
    fontSize: 40.sp,
    fontWeight: FontWeight.bold,
    height: 1.275,
  );

  static final h2 = GoogleFonts.rajdhani(
    fontSize: 35.sp,
    fontWeight: FontWeight.w600,
    height: 1.35,
  );

  static final h3 = GoogleFonts.rajdhani(
    fontSize: 30.sp,
    fontWeight: FontWeight.bold,
    height: 1.25,
  );

  static final h4 = GoogleFonts.rajdhani(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static final h5 = GoogleFonts.rajdhani(
    fontSize: 22.sp,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  static final sub1 = GoogleFonts.sourceSansPro(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    height: 1.27,
  );

  static final sub2 = GoogleFonts.rajdhani(
    fontSize: 18.sp,
    fontWeight: FontWeight.w700,
    height: 1.27,
  );

  static final sub3 = GoogleFonts.rajdhani(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    height: 1.27,
  );

  static final sub4 = GoogleFonts.rajdhani(
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
    height: 1.25,
  );

  static final sub5 = GoogleFonts.rajdhani(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    height: 1.25,
  );

  static final caption1 = GoogleFonts.sourceSansPro(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    height: 1.25,
  );

  static final caption2 = GoogleFonts.sourceSansPro(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    height: 1.25,
  );

  static final body1 = GoogleFonts.sourceSansPro(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static final body2 = GoogleFonts.sourceSansPro(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    height: 1.25,
  );
}

class AppText extends StatelessWidget {
  const AppText(
    this.data, {
    super.key,
    this.letterSpacing,
    this.style,
    this.textAlign,
    this.height,
    this.fontSize,
    this.color = Colors.black,
    this.maxLines,
    this.textOverflow,
    this.textDecoration,
    this.weight,
    this.fontStyle = FontStyle.normal,
  });

  final String data;
  final TextStyle? style;
  final Color? color;
  final double? fontSize;
  final TextAlign? textAlign;
  final double? height;
  final double? letterSpacing;
  final int? maxLines;
  final TextOverflow? textOverflow;
  final TextDecoration? textDecoration;
  final FontStyle fontStyle;
  final FontWeight? weight;

  AppText.h1(
    this.data, {
    super.key,
    this.height,
    this.letterSpacing,
    this.textAlign,
    this.fontSize,
    this.color = Colors.black,
    this.maxLines,
    this.textOverflow,
    this.textDecoration,
    this.fontStyle = FontStyle.normal,
    this.weight,
  }) : style = TextStyleV2.h1;

  AppText.h2(
    this.data, {
    super.key,
    this.height,
    this.letterSpacing,
    this.textAlign,
    this.fontSize,
    this.color = Colors.black,
    this.maxLines,
    this.textOverflow,
    this.textDecoration,
    this.fontStyle = FontStyle.normal,
    this.weight,
  }) : style = TextStyleV2.h2;

  AppText.h3(
    this.data, {
    super.key,
    this.height,
    this.letterSpacing,
    this.textAlign,
    this.fontSize,
    this.color = Colors.black,
    this.maxLines,
    this.textOverflow,
    this.textDecoration,
    this.fontStyle = FontStyle.normal,
    this.weight,
  }) : style = TextStyleV2.h3;

  AppText.h4(
    this.data, {
    super.key,
    this.height,
    this.letterSpacing,
    this.textAlign,
    this.fontSize,
    this.color = Colors.black,
    this.maxLines,
    this.textOverflow,
    this.textDecoration,
    this.fontStyle = FontStyle.normal,
    this.weight,
  }) : style = TextStyleV2.h4;

  AppText.h5(
    this.data, {
    super.key,
    this.height,
    this.letterSpacing,
    this.textAlign,
    this.fontSize,
    this.color = Colors.black,
    this.maxLines,
    this.textOverflow,
    this.textDecoration,
    this.fontStyle = FontStyle.normal,
    this.weight,
  }) : style = TextStyleV2.h5;

  AppText.sub1(
    this.data, {
    super.key,
    this.height,
    this.letterSpacing,
    this.textAlign,
    this.fontSize,
    this.color = Colors.black,
    this.maxLines,
    this.textOverflow,
    this.textDecoration,
    this.fontStyle = FontStyle.normal,
    this.weight,
  }) : style = TextStyleV2.sub1;

  AppText.sub2(
    this.data, {
    super.key,
    this.height,
    this.letterSpacing,
    this.textAlign,
    this.fontSize,
    this.color = Colors.black,
    this.maxLines,
    this.textOverflow,
    this.textDecoration,
    this.fontStyle = FontStyle.normal,
    this.weight,
  }) : style = TextStyleV2.sub2;

  AppText.sub3(
    this.data, {
    super.key,
    this.height,
    this.letterSpacing,
    this.textAlign,
    this.fontSize,
    this.color = Colors.black,
    this.maxLines,
    this.textOverflow,
    this.textDecoration,
    this.fontStyle = FontStyle.normal,
    this.weight,
  }) : style = TextStyleV2.sub3;

  AppText.sub4(
    this.data, {
    super.key,
    this.height,
    this.letterSpacing,
    this.textAlign,
    this.fontSize,
    this.color = Colors.black,
    this.maxLines,
    this.textOverflow,
    this.textDecoration,
    this.fontStyle = FontStyle.normal,
    this.weight,
  }) : style = TextStyleV2.sub4;

  AppText.sub5(
    this.data, {
    super.key,
    this.height,
    this.letterSpacing,
    this.textAlign,
    this.fontSize,
    this.color = Colors.black,
    this.maxLines,
    this.textOverflow,
    this.textDecoration,
    this.fontStyle = FontStyle.normal,
    this.weight,
  }) : style = TextStyleV2.sub5;

  AppText.caption1(
    this.data, {
    super.key,
    this.height,
    this.letterSpacing,
    this.textAlign,
    this.fontSize,
    this.color = Colors.black,
    this.maxLines,
    this.textOverflow,
    this.textDecoration,
    this.fontStyle = FontStyle.normal,
    this.weight,
  }) : style = TextStyleV2.caption1;

  AppText.caption2(
    this.data, {
    super.key,
    this.height,
    this.letterSpacing,
    this.textAlign,
    this.fontSize,
    this.color = Colors.black,
    this.maxLines,
    this.textOverflow,
    this.textDecoration,
    this.fontStyle = FontStyle.normal,
    this.weight,
  }) : style = TextStyleV2.caption2;

  AppText.body1(
    this.data, {
    super.key,
    this.height,
    this.letterSpacing,
    this.textAlign,
    this.fontSize,
    this.color = Colors.black,
    this.maxLines,
    this.textOverflow,
    this.textDecoration,
    this.fontStyle = FontStyle.normal,
    this.weight,
  }) : style = TextStyleV2.body1;

  AppText.body2(
    this.data, {
    super.key,
    this.height,
    this.letterSpacing,
    this.textAlign,
    this.fontSize,
    this.color = Colors.black,
    this.maxLines,
    this.textOverflow,
    this.textDecoration,
    this.fontStyle = FontStyle.normal,
    this.weight,
  }) : style = TextStyleV2.body2;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      textAlign: textAlign,
      style: style?.copyWith(
        fontWeight: weight,
        fontStyle: fontStyle,
        height: height,
        fontSize: fontSize,
        color: color,
        letterSpacing: letterSpacing,
        decoration: textDecoration,
      ),
      maxLines: maxLines,
      overflow: textOverflow,
    );
  }
}
