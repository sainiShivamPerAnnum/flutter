import "dart:math" as math;

import 'package:felloapp/navigator/app_state.dart';
import 'package:felloapp/util/assets.dart';
import 'package:felloapp/util/styles/size_config.dart';
import 'package:felloapp/util/styles/textStyles.dart';
import 'package:felloapp/util/styles/ui_constants.dart';
import 'package:flutter/material.dart';

class LendboxAppBar extends StatelessWidget {
  final bool isEnabled;
  const LendboxAppBar({@required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: SizeConfig.screenWidth * 0.168,
        height: SizeConfig.screenWidth * 0.168,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              UiConstants.primaryColor.withOpacity(0.4),
              UiConstants.primaryColor.withOpacity(0.2),
              UiConstants.primaryColor.withOpacity(0.04),
              Colors.transparent,
            ],
          ),
        ),
        alignment: Alignment.center,
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(math.pi),
          child: Image.asset(
            Assets.felloFlo,
            width: SizeConfig.screenWidth * 0.27,
            height: SizeConfig.screenWidth * 0.27,
          ),
        ),
      ),
      title: Text('Fello Flo', style: TextStyles.rajdhaniSB.body2),
      subtitle: Text(
        "10% returns on investment",
        style: TextStyles.sourceSans.body4.colour(UiConstants.kTextColor3),
      ),
      trailing: !isEnabled
          ? SizedBox()
          : IconButton(
              icon: Icon(Icons.close, color: Colors.white),
              onPressed: () {
                AppState.backButtonDispatcher.didPopRoute();
              },
            ),
    );
  }
}
