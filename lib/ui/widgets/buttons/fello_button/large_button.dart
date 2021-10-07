import 'package:felloapp/ui/widgets/buttons/fello_button/fello_button.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class FelloButtonLg extends StatelessWidget {
  final Widget child;
  final Function onPressed;
  final Color color;
  FelloButtonLg({this.child, this.onPressed, this.color});
  @override
  Widget build(BuildContext context) {
    return FelloButton(
      activeButtonUI: Container(
        height: 50.0,
        decoration: BoxDecoration(
          color: color ?? UiConstants.primaryColor,
          borderRadius: new BorderRadius.circular(10.0),
        ),
        child: Material(
          child: MaterialButton(
            child: child,
            onPressed: onPressed,
            highlightColor: Colors.orange.withOpacity(0.5),
            splashColor: Colors.orange.withOpacity(0.5),
          ),
          color: Colors.transparent,
        ),
      ),
      offlineButtonUI: Container(
        height: 50.0,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: new BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
