import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final Function action;
  final String title;
  final bool isDisabled;

  SubmitButton(
      {@required this.action, @required this.title, @required this.isDisabled});

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      height: 50,
      width: _width * 0.5,
      decoration: (!isDisabled)
          ? BoxDecoration(
              gradient: new LinearGradient(
                colors: [
                  UiConstants.primaryColor,
                  UiConstants.primaryColor.withGreen(150),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(80),
            )
          : BoxDecoration(
              gradient: new LinearGradient(
                colors: [
                  Colors.blueGrey,
                  Colors.blueGrey.withBlue(150),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(80),
            ),
      alignment: Alignment.center,
      child: TextButton(
        onPressed: action,
        child: Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
