import 'package:flutter/material.dart';

class FelloColorPalette {
  static FundPalette augmontFundPalette() {
    return FundPalette(
      primaryColor: Color(0xffFFB700),
      primaryColor2: Color(0xffFFC300),
      secondaryColor: Color(0xff203130),
    );
  }

  static List<TambolaTicketColorPalette> tambolaTicketColorPalettes() {
    return [
      TambolaTicketColorPalette(
        boardColor: Color(0xffD6C481),
        itemColorEven: Color(0xffC7B36C),
        itemColorMarked: Color(0xffE76F51),
        itemColorOdd: Colors.white,
      ),
      TambolaTicketColorPalette(
        boardColor: Color(0xff445C3C),
        itemColorEven: Color(0xffC9D99E),
        itemColorMarked: Color(0xffFDA77F),
        itemColorOdd: Color(0xffFAE8C8),
      ),
      TambolaTicketColorPalette(
        boardColor: Color(0xffEA907A),
        itemColorEven: Color(0xffC56E58),
        itemColorMarked: Color(0xffFFD56B),
        itemColorOdd: Colors.white,
      ),
      TambolaTicketColorPalette(
        boardColor: Color(0xff0C9463),
        itemColorEven: Color(0xff09744D),
        itemColorMarked: Color(0xffFFD56B),
        itemColorOdd: Colors.white,
      ),
      TambolaTicketColorPalette(
        boardColor: Color(0xffD4A5A5),
        itemColorEven: Color(0xffC59B9B),
        itemColorMarked: Color(0xffFFD56B),
        itemColorOdd: Colors.white,
      ),
      TambolaTicketColorPalette(
        boardColor: Color(0xff086972),
        itemColorEven: Color(0xff118792),
        itemColorMarked: Color(0xffFFD56B),
        itemColorOdd: Colors.white,
      ),
      TambolaTicketColorPalette(
        boardColor: Color(0xff9E7777),
        itemColorEven: Color(0xffDEBA9D),
        itemColorMarked: Color(0xffCD113B),
        itemColorOdd: Color(0xffF5E8C7),
      ),
    ];
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

class TambolaTicketColorPalette {
  Color boardColor;
  Color itemColorEven;
  Color itemColorOdd;
  Color itemColorMarked;

  TambolaTicketColorPalette(
      {@required this.boardColor,
      @required this.itemColorEven,
      @required this.itemColorMarked,
      @required this.itemColorOdd});
}
