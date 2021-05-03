import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';

class FieldContainer extends StatelessWidget {
  final Widget child;
  FieldContainer({this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 20,
        top: 5,
      ),
      padding: EdgeInsets.only(left: 5, right: 5),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: UiConstants.primaryColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}
