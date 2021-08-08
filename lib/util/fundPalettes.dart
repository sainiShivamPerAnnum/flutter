import 'package:flutter/material.dart';

class FundPalettes {
  final Color primaryColor;
  final Color primaryColor2;
  final Color secondaryColor;

  const FundPalettes(
      {this.primaryColor, this.primaryColor2, this.secondaryColor});
}

const FundPalettes augmontGoldPalette = FundPalettes(
  primaryColor: Color(0xffFFB700),
  primaryColor2: Color(0xffFFC300),
  secondaryColor: Color(0xff203130),
);
