import 'package:felloapp/util/styles/palette.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final Widget child;

  InputField({this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 20,
        top: 5,
      ),
      padding: EdgeInsets.only(left: 15, bottom: 5, top: 5, right: 15),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: UiConstants.primaryColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}

InputDecoration inputFieldDecoration(String hintText) {
  return InputDecoration(
    border: InputBorder.none,
    focusedBorder: InputBorder.none,
    enabledBorder: InputBorder.none,
    disabledBorder: InputBorder.none,
    focusedErrorBorder: InputBorder.none,
    hintText: hintText,
  );
}

InputDecoration augmontFieldInputDecoration(String hintText, IconData icon) {
  if (icon != null)
    return InputDecoration(
      prefixIcon: Icon(icon),
      focusColor: FelloColorPalette.augmontFundPalette().primaryColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: FelloColorPalette.augmontFundPalette().secondaryColor,
        ),
      ),
      // labelStyle: GoogleFonts.montserrat(color:  FelloColorPalette.augmontFundPalette().primaryColor2),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: FelloColorPalette.augmontFundPalette().primaryColor,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: FelloColorPalette.augmontFundPalette().primaryColor,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
        ),
      ),
      labelText: hintText,
    );

  return InputDecoration(
    focusColor: FelloColorPalette.augmontFundPalette().primaryColor,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: FelloColorPalette.augmontFundPalette().secondaryColor,
      ),
    ),
    // labelStyle: GoogleFonts.montserrat(color:  FelloColorPalette.augmontFundPalette().primaryColor2),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: FelloColorPalette.augmontFundPalette().primaryColor,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: FelloColorPalette.augmontFundPalette().primaryColor,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.red,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.red,
      ),
    ),
    labelText: hintText,
  );
}
