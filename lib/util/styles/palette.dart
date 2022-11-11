import 'package:flutter/material.dart';

class FelloColorPalette {
  static FundPalette augmontFundPalette() {
    return FundPalette(
      primaryColor: Color(0xffFFB700),
      primaryColor2: Color(0xffFFC300),
      secondaryColor: Color(0xff203130),
    );
  }
}

// COLOR PALETTE MODELS

class FundPalette {
  final Color primaryColor;
  final Color primaryColor2;
  final Color secondaryColor;
  final Color tertiaryColor;

  const FundPalette(
      {this.primaryColor,
      this.primaryColor2,
      this.secondaryColor,
      this.tertiaryColor});
}
