import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class LargeButton extends StatelessWidget {
  final Widget child;
  final Function onTap;

  const LargeButton({this.child, this.onTap});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      decoration: BoxDecoration(
        gradient: new LinearGradient(colors: [
          UiConstants.primaryColor,
          UiConstants.primaryColor.withBlue(190),
        ], begin: Alignment(0.5, -1.0), end: Alignment(0.5, 1.0)),
        borderRadius: new BorderRadius.circular(10.0),
      ),
      child: Material(
        child: MaterialButton(
          child: child,
          onPressed: onTap,
          highlightColor: Colors.orange.withOpacity(0.5),
          splashColor: Colors.orange.withOpacity(0.5),
        ),
        color: Colors.transparent,
        borderRadius: new BorderRadius.circular(20.0),
      ),
    );
  }
}
