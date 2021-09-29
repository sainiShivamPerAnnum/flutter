import 'package:felloapp/util/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Widgets {
  getTitle(String text, Color color) => Text(
        text,
        style: TextStyle(
            fontWeight: FontWeight.w700,
            color: color,
            fontSize: SizeConfig.cardTitleTextSize),
      );

  getHeadlineLight(String text, Color color) => Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: SizeConfig.largeTextSize,
        ),
      );

  getHeadlineBold({String text, Color color = Colors.black}) => Text(
        text,
        style: GoogleFonts.montserrat(
            color: color,
            fontWeight: FontWeight.w500,
            fontSize: SizeConfig.largeTextSize),
      );
  getBodyLight(String text, Color color) => Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: SizeConfig.mediumTextSize,
        ),
      );

  getBodyBold(String text, Color color) => Text(
        text,
        style: TextStyle(
            color: color,
            fontWeight: FontWeight.w500,
            fontSize: SizeConfig.mediumTextSize),
      );

  getButton(String text, Function onPressed, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(primary: color),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.black,
          fontSize: SizeConfig.mediumTextSize,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
