import 'package:felloapp/ui/widgets/buttons/fello_button/fello_button.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class FelloButtonLg extends StatelessWidget {
  final Widget child;
  final Function onPressed;
  final Color color;
  final double height;
  FelloButtonLg({this.child, this.onPressed, this.color, this.height});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: new BorderRadius.circular(16.0),
      child: FelloButton(
        activeButtonUI: Container(
          width: SizeConfig.screenWidth,
          height: height ?? SizeConfig.screenWidth * 0.13,
          decoration: BoxDecoration(
            color: color ?? UiConstants.primaryColor,
            borderRadius: new BorderRadius.circular(16.0),
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
          width: SizeConfig.screenWidth,
          height: 60.0,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.5),
            borderRadius: new BorderRadius.circular(16.0),
          ),
          alignment: Alignment.center,
          child: Text(
            "Offline",
            style: TextStyles.body2.bold,
          ),
        ),
      ),
    );
  }
}
