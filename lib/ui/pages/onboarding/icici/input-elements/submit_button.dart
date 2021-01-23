import 'package:felloapp/util/ui_constants.dart';
import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final Function action;
  final String title;

  SubmitButton({@required this.action, @required this.title});
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      height: 50,
      width: _width * 0.5,
      decoration: BoxDecoration(
        gradient: new LinearGradient(
          colors: [
            UiConstants.primaryColor,
            UiConstants.primaryColor.withGreen(150),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(100),
      ),
      alignment: Alignment.center,
      child: FlatButton(
        onPressed: action,
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
