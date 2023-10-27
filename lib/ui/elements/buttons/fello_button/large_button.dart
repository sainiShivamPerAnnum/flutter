import 'package:felloapp/ui/elements/buttons/fello_button/fello_button.dart';
import 'package:felloapp/util/localization/generated/l10n.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class FelloButtonLg extends StatelessWidget {
  final Widget? child;
  final Function? onPressed;
  final Color? color;
  final double? height;
  const FelloButtonLg({this.child, this.onPressed, this.color, this.height});
  @override
  Widget build(BuildContext context) {
    S locale = S.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(SizeConfig.roundness5),
      child: FelloButton(
        activeButtonUI: Container(
          width: SizeConfig.screenWidth,
          height: height ?? SizeConfig.screenWidth! * 0.14,
          decoration: BoxDecoration(
            gradient: UiConstants.kButtonGradient,
            borderRadius: BorderRadius.circular(SizeConfig.roundness5),
          ),
          child: Material(
            child: MaterialButton(
              child: child,
              onPressed: onPressed as void Function()?,
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
            color: Colors.blueGrey[700],
            borderRadius: BorderRadius.circular(SizeConfig.roundness16),
          ),
          alignment: Alignment.center,
          child: Text(
            locale.offline,
            style: TextStyles.body2.bold,
          ),
        ),
      ),
    );
  }
}
