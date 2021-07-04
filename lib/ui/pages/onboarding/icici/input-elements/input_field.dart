import 'package:felloapp/util/ui_constants.dart';
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
    hintText: hintText,
  );
}
